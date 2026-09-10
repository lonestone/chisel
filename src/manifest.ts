// `.agents/.chisel.json`: what chisel installed, and the hash each file had
// when it did. It is the whole basis of `check` (has anything drifted?) and
// of `update`'s report (what moved, what left the managed set).

import { join } from "@std/path";
import { agentsBlockHash, sha256File } from "./hash.ts";
import { GEN_MARKER } from "./markers.ts";
import { packageVersion } from "./paths.ts";
import { managedSocleFiles } from "./install.ts";
import { isFile, listFilesRecursive, readTextIfPresent } from "./target.ts";

/** Not a file: the hash of the managed block inside `AGENTS.md`. */
export const BLOCK_KEY = "AGENTS.md#block";

export interface Manifest {
  readonly version: string;
  readonly managed: Record<string, string>;
}

export function manifestPath(targetDir: string): string {
  return join(targetDir, ".agents", ".chisel.json");
}

export async function readManifest(
  targetDir: string,
): Promise<Manifest | null> {
  const text = await readTextIfPresent(manifestPath(targetDir));
  if (text === null) return null;
  const parsed = JSON.parse(text) as Partial<Manifest>;
  return { version: parsed.version ?? "", managed: parsed.managed ?? {} };
}

/** Keys sorted, two-space indent, one trailing newline — stable across runs. */
export function serializeManifest(manifest: Manifest): string {
  const managed: Record<string, string> = {};
  for (const name of Object.keys(manifest.managed).sort()) {
    managed[name] = manifest.managed[name];
  }
  return `${JSON.stringify({ managed, version: manifest.version }, null, 2)}\n`;
}

// Relative-to-target paths of every file the manifest tracks (the managed
// block excepted, which is not a file).
//
// The `.agents/` entries come from the socle that shipped, NOT from a walk of
// the target: chisel manages exactly the files it copies, and nothing else.
// Scanning the target instead would adopt whatever a third party dropped in
// `.agents/skills/` — silently tracked, then reported DIVERGED the day its
// owner edits their own file. It also means a file retired upstream stops
// being tracked instead of being tracked forever.
//
// The rendered agent definitions live in directories chisel shares with the
// user (`.claude/agents/`, `.codex/agents/`), so only the files carrying the
// generated marker are claimed — a definition of the user's own is neither
// re-rendered nor reported as drift. Same discipline, reached by the road each
// directory offers: an exact source list here, a marker there.
export async function managedRelativeFiles(
  targetDir: string,
): Promise<string[]> {
  const managed = managedSocleFiles();
  for (const definitionDir of [".claude/agents", ".codex/agents"]) {
    for (
      const relative of await listFilesRecursive(join(targetDir, definitionDir))
    ) {
      const path = join(targetDir, definitionDir, relative);
      const text = await readTextIfPresent(path);
      if (text !== null && text.includes(GEN_MARKER)) {
        managed.push(`${definitionDir}/${relative}`);
      }
    }
  }
  managed.push(
    ".agents/discipline.md",
    ".agents/methodology.md",
    ".agents/reference.md",
    ".agents/user.md.tpl",
    "scripts/task-id.sh",
    "project-management/000-template.spec.md",
    "project-management/000-template.work.md",
  );
  return managed;
}

/** Rewrites the manifest from the current state of the target, and returns it. */
export async function writeManifest(targetDir: string): Promise<Manifest> {
  const managed: Record<string, string> = {};
  for (const relative of await managedRelativeFiles(targetDir)) {
    const path = join(targetDir, relative);
    if (await isFile(path)) managed[relative] = await sha256File(path);
  }
  const agentsMd = await readTextIfPresent(join(targetDir, "AGENTS.md"));
  if (agentsMd !== null) managed[BLOCK_KEY] = await agentsBlockHash(agentsMd);

  const manifest: Manifest = { version: await packageVersion(), managed };
  await Deno.writeTextFile(
    manifestPath(targetDir),
    serializeManifest(manifest),
  );
  return manifest;
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
