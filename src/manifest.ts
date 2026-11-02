// `.agents/.chisel.json`: what chisel installed, and the hash each file had
// when it did. It is the whole basis of `check` (has anything drifted?) and
// of `update`'s report (what moved, what left the managed set).

import { join } from "@std/path";
import { agentsBlockHash, sha256File } from "./hash.ts";
import { packageVersion } from "./paths.ts";
import {
  baselineRecord,
  type IntentionRecord,
  type IntentionResult,
  today,
} from "./intentions.ts";
import { ChiselError } from "./report.ts";
import { isFile, readTextIfPresent } from "./target.ts";

/** Not a file: the hash of the managed block inside `AGENTS.md`. */
export const BLOCK_KEY = "AGENTS.md#block";

export interface Manifest {
  readonly version: string;
  readonly managed: Record<string, string>;
  /** What the repo did with each intention it has met. */
  readonly intentions: IntentionRecord;
}

/** Where the manifest sits, relative to the target. */
export const MANIFEST_FILE = ".agents/.chisel.json";

export function manifestPath(targetDir: string): string {
  return join(targetDir, MANIFEST_FILE);
}

export async function readManifest(
  targetDir: string,
): Promise<Manifest | null> {
  const text = await readTextIfPresent(manifestPath(targetDir));
  if (text === null) return null;
  const parsed = JSON.parse(text) as Partial<Manifest>;
  const version = parsed.version ?? "";
  return {
    version,
    managed: parsed.managed ?? {},
    // A manifest written before intentions were recorded: what its version
    // shipped counts as applied, and the next write makes it explicit.
    intentions: parsed.intentions ?? baselineRecord(version, today()),
  };
}

function sortedKeys<T>(record: Record<string, T>): Record<string, T> {
  const sorted: Record<string, T> = {};
  for (const key of Object.keys(record).sort()) sorted[key] = record[key];
  return sorted;
}

/** Keys sorted, two-space indent, one trailing newline — stable across runs. */
export function serializeManifest(manifest: Manifest): string {
  const intentions: Record<string, IntentionResult> = {};
  for (
    const [id, { date, reason, result }] of Object.entries(
      sortedKeys(manifest.intentions),
    )
  ) {
    intentions[id] = reason === undefined
      ? { date, result }
      : { date, reason, result };
  }
  const ordered = {
    intentions,
    managed: sortedKeys(manifest.managed),
    version: manifest.version,
  };
  return `${JSON.stringify(ordered, null, 2)}\n`;
}

// The files the manifest tracks (the managed block excepted, which is not a
// file) are exactly the ones `managedSocleFiles` names.
//
// The `.agents/` entries come from the socle that shipped, NOT from a walk of
// the target: chisel manages exactly the files it copies, and nothing else.
// Scanning the target instead would adopt whatever a third party dropped in
// `.agents/skills/` — silently tracked, then reported DIVERGED the day its
// owner edits their own file. It also means a file retired upstream stops
// being tracked instead of being tracked forever — which is how `update`
// cleans an install from an older socle: the pages it retired and the agent
// definitions it rendered into `.claude/agents/` and `.codex/agents/` sit in
// its last manifest and in no list here, so they come out as orphans.

/**
 * Rewrites the manifest from the current state of the target, and returns it.
 * It records the files of `tracked` that exist, so a command that did not
 * write a path never adopts it, and the intentions record it is given.
 */
export async function writeManifest(
  targetDir: string,
  tracked: readonly string[],
  intentions: IntentionRecord,
): Promise<Manifest> {
  const managed: Record<string, string> = {};
  for (const relative of tracked) {
    const path = join(targetDir, relative);
    if (await isFile(path)) managed[relative] = await sha256File(path);
  }
  const agentsMd = await readTextIfPresent(join(targetDir, "AGENTS.md"));
  if (agentsMd !== null) managed[BLOCK_KEY] = await agentsBlockHash(agentsMd);

  const manifest: Manifest = {
    version: await packageVersion(),
    managed,
    intentions,
  };
  await Deno.writeTextFile(
    manifestPath(targetDir),
    serializeManifest(manifest),
  );
  return manifest;
}

/**
 * Writes one intention's result into the manifest, and nothing else: the
 * managed hashes and the version stay what the last install wrote.
 */
export async function recordIntention(
  targetDir: string,
  id: string,
  result: IntentionResult,
): Promise<void> {
  const manifest = await readManifest(targetDir);
  if (manifest === null) {
    throw new ChiselError(`no manifest at ${manifestPath(targetDir)}`);
  }
  await Deno.writeTextFile(
    manifestPath(targetDir),
    serializeManifest({
      ...manifest,
      intentions: { ...manifest.intentions, [id]: result },
    }),
  );
}

export type OrphanVerdict = "removed" | "orphaned" | "gone";

export interface Orphan {
  readonly name: string;
  readonly verdict: OrphanVerdict;
}

/**
 * What became of the files that left the managed set between two manifests.
 *
 * A file whose content still matches the hash the old manifest recorded holds
 * nothing of the project's — chisel installed it and chisel retired it, so it
 * is deleted. One whose content changed may carry someone's edit: it stays,
 * and it is named. One already absent needs neither.
 */
export async function orphansOf(
  targetDir: string,
  previous: Manifest,
  current: Manifest,
): Promise<Orphan[]> {
  const orphans: Orphan[] = [];
  for (const name of Object.keys(previous.managed).sort()) {
    if (name === BLOCK_KEY || name in current.managed) continue;
    const path = join(targetDir, name);
    if (!(await isFile(path))) {
      orphans.push({ name, verdict: "gone" });
      continue;
    }
    const stillAsInstalled =
      (await sha256File(path)) === previous.managed[name];
    orphans.push({ name, verdict: stillAsInstalled ? "removed" : "orphaned" });
  }
  return orphans;
}
