// The workspace a staged update or a staged first install leaves for an
// agent: the pending intentions, the reference tree, and the session the
// update skill — or the setup skill, for an install — works through. It
// sits at the target's root, never under `.agents/` — a linked `.agents` is
// one of the cases that stages — and it ignores itself, so staging writes
// nothing in the project's own files.

import { join } from "@std/path";
import { poseSocle } from "./init.ts";
import type { Intention } from "./intentions.ts";
import type { Found } from "./inventory.ts";
import { today } from "./intentions.ts";
import { packageVersion, readPackageFile, SOCLE_ROOT } from "./paths.ts";
import { readTextIfPresent } from "./target.ts";

export const WORKSPACE_DIR = ".chisel-workspace";
export const SESSION_FILE = `${WORKSPACE_DIR}/session.md`;
export const REFERENCE_DIR = `${WORKSPACE_DIR}/reference`;
export const UPDATE_SKILL = ".agents/skills/chisel-update/SKILL.md";
export const SETUP_SKILL = ".agents/skills/chisel-setup/SKILL.md";

/** What a staged update hands over. */
export interface Staging {
  /** The manifest's version, or null when there is no manifest. */
  readonly from: string | null;
  /** Why the update did not take the fast path, one sentence each. */
  readonly reasons: readonly string[];
  readonly pending: readonly Intention[];
}

/** Where an intention is staged, inside the workspace: its path in the socle. */
function relativeSource(intention: Intention): string {
  return intention.source.slice(SOCLE_ROOT.length);
}

/** One checklist line: what `record` ticks, matched by the id in backticks. */
function checklistLine(intention: Intention): string {
  const stop = intention.classification === "breaking-manual"
    ? " — the human decides before anything moves"
    : "";
  return `- [ ] \`${intention.id}\` (${intention.classification}) — ` +
    `\`${relativeSource(intention)}\`${stop}`;
}

/**
 * Builds the workspace whole, or not at all: a step that throws takes the
 * directory away again. Fails when the directory already exists — a session
 * in progress is never overwritten. Writes the intentions given, the
 * reference tree, and the session text.
 */
async function buildWorkspace(
  targetDir: string,
  pending: readonly Intention[],
  session: string,
): Promise<void> {
  const root = join(targetDir, WORKSPACE_DIR);
  await Deno.mkdir(root);
  try {
    // Git ignores everything in the directory, this file included.
    await Deno.writeTextFile(join(root, ".gitignore"), "*\n");
    for (const intention of pending) {
      const destination = join(root, relativeSource(intention));
      await Deno.mkdir(join(destination, ".."), { recursive: true });
      await Deno.writeFile(
        destination,
        await readPackageFile(intention.source),
      );
    }
    const reference = join(targetDir, REFERENCE_DIR);
    await Deno.mkdir(reference);
    await poseSocle(reference, "reference", null);
    await Deno.writeTextFile(join(targetDir, SESSION_FILE), session);
  } catch (error) {
    await Deno.remove(root, { recursive: true });
    throw error;
  }
}

/** Stages an update session. Returns the checklist lines. */
export async function stageWorkspace(
  targetDir: string,
  staging: Staging,
): Promise<string[]> {
  const version = await packageVersion();
  const lines = staging.pending.map(checklistLine);
  await buildWorkspace(
    targetDir,
    staging.pending,
    [
      "# Chisel update session",
      "",
      `From ${staging.from ?? "no manifest"} to ${version}, staged ${today()}.`,
      `Run chisel as \`deno x jsr:@lonestone/chisel@${version}\`.`,
      `Follow \`${REFERENCE_DIR}/${UPDATE_SKILL}\`.`,
      "",
      "## Why update stopped",
      "",
      ...staging.reasons.map((reason) => `- ${reason}`),
      "",
      "## Intentions",
      "",
      ...(lines.length > 0 ? lines : ["None pending."]),
      "",
    ].join("\n"),
  );
  return lines;
}

/** One line of what a first `init` found. */
function foundLine(found: Found): string {
  return `- [ ] ${found.kind} — \`${found.path}\``;
}

/**
 * Stages an install session: what `init` found, for the setup skill to
 * place with the human before anything is installed. No intention is
 * staged: a first install starts from this release.
 */
export async function stageInstall(
  targetDir: string,
  found: readonly Found[],
): Promise<void> {
  const version = await packageVersion();
  await buildWorkspace(
    targetDir,
    [],
    [
      "# Chisel install session",
      "",
      `Chisel ${version}, staged ${today()}.`,
      `Run chisel as \`deno x jsr:@lonestone/chisel@${version}\`.`,
      `Follow Step 0 of \`${REFERENCE_DIR}/${SETUP_SKILL}\`.`,
      "",
      "## What init found",
      "",
      ...found.map(foundLine),
      "",
      "## Next",
      "",
      "Place each item with the human, one at a time. Then delete this",
      `directory and run \`chisel init --arranged .\`.`,
      "",
    ].join("\n"),
  );
}

/** Ticks the checklist line of `id`, when a session is in progress. */
export async function tickSession(
  targetDir: string,
  id: string,
): Promise<void> {
  const path = join(targetDir, SESSION_FILE);
  const text = await readTextIfPresent(path);
  if (text === null) return;
  const ticked = text.split("\n").map((line) =>
    line.startsWith("- [ ] ") && line.includes(`\`${id}\``)
      ? `- [x] ${line.slice("- [ ] ".length)}`
      : line
  ).join("\n");
  if (ticked !== text) await Deno.writeTextFile(path, ticked);
}
