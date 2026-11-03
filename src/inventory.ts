// What a repo already has, read before a first `init` writes anything: a
// method of its own — specs, tasks, decisions, another agent's rules, its own
// instructions — that installing beside it would leave as a second voice.
// Naming is scripted and cheap; deciding where each one goes is the setup
// skill's job, with the human. Reads only.

import { join } from "@std/path";
import { initWrites, v1LayoutFound } from "./install.ts";
import { BLOCK_BEGIN, BLOCK_END, CLAUDE_IMPORT_LINE } from "./markers.ts";
import {
  isDirectory,
  isFile,
  linkedPaths,
  readTextIfPresent,
} from "./target.ts";

/** One thing found: what it is, and where, relative to the target. */
export interface Found {
  readonly kind: string;
  readonly path: string;
}

const TASK_FOLDERS = [
  "project-management/",
  "doc/project-management/",
  "docs/project-management/",
  "tasks/",
] as const;

const DECISION_FOLDERS = [
  "docs/adr/",
  "doc/adr/",
  "adr/",
  "decisions/",
] as const;

const OTHER_AGENTS: ReadonlyArray<readonly [string, "dir" | "file"]> = [
  [".cursor/rules/", "dir"],
  [".windsurf/", "dir"],
  [".github/copilot-instructions.md", "file"],
];

/** Everything the repo already has that a first install must not talk over. */
export async function takeInventory(targetDir: string): Promise<Found[]> {
  const found: Found[] = [];
  const at = (relative: string) => join(targetDir, relative);

  if (await isDirectory(at("openspec"))) {
    found.push({ kind: "OpenSpec", path: "openspec/" });
  }
  if (await isDirectory(at(".specify"))) {
    found.push({ kind: "Spec Kit", path: ".specify/" });
  } else {
    for (const feature of await specKitFeatures(targetDir)) {
      found.push({ kind: "Spec Kit", path: feature });
    }
  }
  for (const folder of TASK_FOLDERS) {
    if (await holdsAFile(at(folder))) {
      found.push({ kind: "task folder", path: folder });
    }
  }
  for (const folder of DECISION_FOLDERS) {
    if (await isDirectory(at(folder))) {
      found.push({ kind: "decision records", path: folder });
    }
  }
  if (await isFile(at("CONTEXT.md"))) {
    found.push({ kind: "glossary", path: "CONTEXT.md" });
  }
  for (const [path, type] of OTHER_AGENTS) {
    const present = type === "dir"
      ? await isDirectory(at(path))
      : await isFile(at(path));
    if (present) found.push({ kind: "other agent's rules", path });
  }
  const linked = new Set(await linkedPaths(targetDir, initWrites()));
  if (
    !linked.has("AGENTS.md") && ownAgentsText(await readFile(at("AGENTS.md")))
  ) {
    found.push({ kind: "instructions file", path: "AGENTS.md" });
  }
  if (
    !linked.has("CLAUDE.md") && ownClaudeText(await readFile(at("CLAUDE.md")))
  ) {
    found.push({ kind: "instructions file", path: "CLAUDE.md" });
  }
  if (await isDirectory(at(".beads"))) {
    found.push({ kind: "beads", path: ".beads/" });
  }
  for (const path of await v1LayoutFound(targetDir)) {
    found.push({ kind: "first chisel version", path });
  }
  for (const path of linked) {
    found.push({ kind: "linked path", path });
  }
  return found;
}

async function readFile(path: string): Promise<string | null> {
  return await isFile(path) ? await readTextIfPresent(path) : null;
}

/** Spec Kit's feature folders: `specs/<name>/spec.md` beside a plan or tasks. */
async function specKitFeatures(targetDir: string): Promise<string[]> {
  const specs = join(targetDir, "specs");
  if (!(await isDirectory(specs))) return [];
  const features: string[] = [];
  for await (const entry of Deno.readDir(specs)) {
    if (!entry.isDirectory) continue;
    const feature = join(specs, entry.name);
    if (
      await isFile(join(feature, "spec.md")) &&
      (await isFile(join(feature, "plan.md")) ||
        await isFile(join(feature, "tasks.md")))
    ) {
      features.push(`specs/${entry.name}/`);
    }
  }
  return features.sort();
}

/** True when the directory holds a file, at any depth. Links are not followed. */
async function holdsAFile(directory: string): Promise<boolean> {
  if (!(await isDirectory(directory))) return false;
  for await (const entry of Deno.readDir(directory)) {
    if (entry.isFile || entry.isSymlink) return true;
    if (entry.isDirectory && await holdsAFile(join(directory, entry.name))) {
      return true;
    }
  }
  return false;
}

/**
 * An `AGENTS.md` speaks for the project when something stands outside
 * chisel's block besides its title: the first heading line.
 */
function ownAgentsText(text: string | null): boolean {
  if (text === null) return false;
  const lines = text.split("\n");
  const begin = lines.indexOf(BLOCK_BEGIN);
  const end = lines.indexOf(BLOCK_END);
  const outside = begin !== -1 && end > begin
    ? [...lines.slice(0, begin), ...lines.slice(end + 1)]
    : lines;
  const meaningful = outside.filter((line) => line.trim() !== "");
  if (meaningful.length > 0 && meaningful[0].startsWith("# ")) {
    meaningful.shift();
  }
  return meaningful.length > 0;
}

/** A `CLAUDE.md` speaks for the project when it holds more than the import. */
function ownClaudeText(text: string | null): boolean {
  if (text === null) return false;
  return text.split("\n").some((line) =>
    line.trim() !== "" && line.trim() !== CLAUDE_IMPORT_LINE
  );
}
