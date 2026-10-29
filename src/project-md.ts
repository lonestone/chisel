// The three things chisel is allowed to do to a project's glue, and nothing
// else. `init` writes the file once from the template and may fill in what it
// just observed; `update` and `check` only ever read it. A value a human
// answered is never rewritten by an installer.

import { join } from "@std/path";
import {
  glueItem,
  glueSection,
  glueSubsection,
  parseGlue,
  serializeGlue,
} from "./glue.ts";
import { readPackageFile, SOCLE } from "./paths.ts";
import {
  agentsMdHasBlockMarkers,
  claudeMdImportsAgents,
  isFile,
  readTextIfPresent,
  SKILLS_LINK_VALUE,
  skillsLinkValue,
} from "./target.ts";

export const JOURNAL_NAME = "LOG.md";
export const LEGACY_JOURNAL_NAME = "CHANGELOG.md";
const TASKS_ROOT = "/project-management/";
const JOURNAL_LABEL = "Changelog";

function gluePath(targetDir: string): string {
  return join(targetDir, ".agents", "project.md");
}

/** Writes the glue from the template if it is missing. True when this run wrote it. */
export async function ensureProjectMd(targetDir: string): Promise<boolean> {
  const path = gluePath(targetDir);
  if (await isFile(path)) return false;
  await Deno.writeFile(path, await readPackageFile(SOCLE.projectMdTemplate));
  return true;
}

/**
 * Ticks each §E adapter line whose adapter is actually in place. Called only
 * on a glue this `init` run created: a line a human unticked deliberately
 * stays unticked on every later run.
 */
export async function tickAdapterInventory(targetDir: string): Promise<void> {
  const path = gluePath(targetDir);
  const text = await readTextIfPresent(path);
  if (text === null) return;

  const inPlace: Record<string, boolean> = {
    "AGENTS.md": await agentsMdHasBlockMarkers(targetDir),
    "CLAUDE.md": await claudeMdImportsAgents(targetDir),
    ".claude/skills": (await skillsLinkValue(targetDir)) === SKILLS_LINK_VALUE,
  };

  const document = parseGlue(text);
  const adapters = glueSection(document, "E");
  if (!adapters) return;
  let touched = false;
  for (const item of adapters.items) {
    if (item.checkbox !== "unchecked" || !inPlace[item.label]) continue;
    document.lines[item.line] = item.raw.replace("- [ ]", "- [x]");
    touched = true;
  }
  if (touched) await Deno.writeTextFile(path, serializeGlue(document));
}

/**
 * When the journal guard declined to create `LOG.md` because the repo already
 * has its own journal, a glue this run created still points §A at a file that
 * does not exist. Point it at the one that does — and only while that line
 * still holds the template's default.
 */
export async function pointNewGlueAtExistingJournal(
  targetDir: string,
): Promise<void> {
  const path = gluePath(targetDir);
  const text = await readTextIfPresent(path);
  if (text === null) return;
  const pmRoot = join(targetDir, "project-management");
  if (!(await isFile(join(pmRoot, LEGACY_JOURNAL_NAME)))) return;
  if (await isFile(join(pmRoot, JOURNAL_NAME))) return;

  const document = parseGlue(text);
  const item = glueItem(glueSection(document, "A"), JOURNAL_LABEL);
  if (!item) return;
  const templateDefault = `\`${TASKS_ROOT}${JOURNAL_NAME}\``;
  if (item.value !== templateDefault) return;
  document.lines[item.line] =
    `- **${JOURNAL_LABEL}:** \`${TASKS_ROOT}${LEGACY_JOURNAL_NAME}\``;
  await Deno.writeTextFile(path, serializeGlue(document));
}

// The §E adapter lines an older socle wrote for the agent definitions it
// rendered. Nothing renders them any more, so a ticked line is a false fact.
const RETIRED_ADAPTERS = [".claude/agents", ".codex/agents"] as const;

/**
 * What a glue still carries that the socle retired and nothing reads any
 * more: a retired subsection, or an adapter line for a retired adapter. Each
 * entry says what it is, in words. Reported, never edited: the glue belongs
 * to the project, and deleting a paragraph out of someone's document is not
 * an installer's business.
 */
export async function staleGlueResidues(targetDir: string): Promise<string[]> {
  const text = await readTextIfPresent(gluePath(targetDir));
  if (text === null) return [];
  const document = parseGlue(text);
  const residues: string[] = [];
  const retired = glueSubsection(document, "B", "B3");
  if (retired && retired.title === "Autonomous runs") {
    residues.push(`"${retired.id} · ${retired.title}"`);
  }
  const adapters = glueSection(document, "E");
  for (const label of RETIRED_ADAPTERS) {
    if (glueItem(adapters, label)) {
      residues.push(`the adapter line \`${label}\` in "E · Adapters"`);
    }
  }
  return residues;
}

/** The line `update` and `check` print about a residue they will not touch. */
export function staleGlueReport(residue: string): string {
  return `stale: .agents/project.md still carries ${residue}, which nothing in the socle ` +
    `reads any more — safe to delete by hand (chisel never edits this file)`;
}
