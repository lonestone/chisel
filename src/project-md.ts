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
  hasGeneratedDefinitions,
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
    // Ticked when chisel actually RENDERED something there, not merely when
    // the directory exists: a directory holding only the user's own
    // definitions is not an adapter chisel installed.
    ".claude/agents": await hasGeneratedDefinitions(
      join(targetDir, ".claude", "agents"),
    ),
    ".codex/agents": await hasGeneratedDefinitions(
      join(targetDir, ".codex", "agents"),
    ),
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

/**
 * The heading of a subsection the socle retired and nothing reads any more,
 * when a glue still carries it. Reported, never edited: the glue belongs to
 * the project, and deleting a paragraph out of someone's document is not an
 * installer's business.
 */
export async function staleGlueSubsection(
  targetDir: string,
): Promise<string | null> {
  const text = await readTextIfPresent(gluePath(targetDir));
  if (text === null) return null;
  const retired = glueSubsection(parseGlue(text), "B", "B3");
  if (!retired || retired.title !== "Autonomous runs") return null;
  return `${retired.id} · ${retired.title}`;
}

/** The line `update` and `check` print about a residue they will not touch. */
export function staleGlueReport(heading: string): string {
  return `stale: .agents/project.md still carries "${heading}", which nothing in the socle ` +
    `reads any more — safe to delete by hand (chisel never edits this file)`;
}
