// Everything `init` and `update` write into a target repo, and the two
// stances that govern it: a managed file is re-installed without asking, a
// file the project owns is never touched. Each step is idempotent — running
// it twice with unchanged inputs leaves byte-identical output.

import { dirname, join } from "@std/path";
import { BLOCK_BEGIN, BLOCK_END, CLAUDE_IMPORT_LINE } from "./markers.ts";
import {
  readPackageFile,
  readPackageText,
  SOCLE,
  SOCLE_ROOT,
} from "./paths.ts";
import { SOCLE_FILES } from "./socle-files.ts";
import { ChiselError, warn } from "./report.ts";
import {
  hasManagedBlockMarkers,
  isDirectory,
  isFile,
  pathExists,
  readTextIfPresent,
  SKILLS_LINK_VALUE,
  skillsLinkValue,
} from "./target.ts";
import { JOURNAL_NAME, LEGACY_JOURNAL_NAME } from "./project-md.ts";

/** The socle directories copied whole into `.agents/`. */
const COPIED_TREES = [
  "agents/skills/",
  "agents/formulas/",
  "agents/profiles/",
] as const;

/** Socle file → path inside the target, for the files copied one by one. */
const COPIED_FILES: ReadonlyArray<readonly [string, string]> = [
  [SOCLE.discipline, ".agents/discipline.md"],
  [SOCLE.methodology, ".agents/methodology.md"],
  [SOCLE.reference, ".agents/reference.md"],
  // The TEMPLATE of the personal file, not the personal file itself: it is
  // socle text, committed like the rest, and it is what lets any dev — the
  // first one or the fifth — pose their own `.agents/user.md` with a copy, no
  // package and no network. `init` never writes `.agents/user.md`: a shared
  // installer has no business creating a personal, gitignored file.
  [SOCLE.userMdTemplate, ".agents/user.md.tpl"],
  [SOCLE.specTemplate, "project-management/000-template.spec.md"],
  [SOCLE.workTemplate, "project-management/000-template.work.md"],
];

const EXECUTABLE_MODE = 0o755;

async function writePackaged(
  socleRelative: string,
  destination: string,
  mode?: number,
): Promise<void> {
  await Deno.mkdir(dirname(destination), { recursive: true });
  await Deno.writeFile(destination, await readPackageFile(socleRelative));
  if (mode !== undefined) await Deno.chmod(destination, mode);
}

/** The socle files a target gets, as paths relative to the target. */
export function managedSocleFiles(): string[] {
  const managed: string[] = [];
  for (const socleFile of SOCLE_FILES) {
    const tree = COPIED_TREES.find((prefix) => socleFile.startsWith(prefix));
    if (tree) managed.push(`.agents/${socleFile.slice("agents/".length)}`);
  }
  return managed.sort();
}

export async function copyManagedFiles(targetDir: string): Promise<void> {
  for (const socleFile of SOCLE_FILES) {
    if (!COPIED_TREES.some((prefix) => socleFile.startsWith(prefix))) continue;
    const relative = `.agents/${socleFile.slice("agents/".length)}`;
    await writePackaged(`${SOCLE_ROOT}${socleFile}`, join(targetDir, relative));
  }
  for (const [socleFile, relative] of COPIED_FILES) {
    await writePackaged(socleFile, join(targetDir, relative));
  }
  await writePackaged(
    SOCLE.taskIdScript,
    join(targetDir, "scripts", "task-id.sh"),
    EXECUTABLE_MODE,
  );
}

const SKILLS_PREFIX = ".agents/skills/";

// Say out loud that a skill chisel did not install is not chisel's. It is
// left strictly alone — not copied over, not managed, not reported by
// `check` — and the warning is what keeps "untouched" from looking like
// "adopted". The case that motivates it is real: another tool plants its own
// skill directory in `.agents/skills/`.
//
// Only `.agents/skills/`: `.agents/profiles/` is a documented extension point
// (drop a profile in, chisel renders its definitions), and a warning there
// would be noise about a file the project meant to add.
//
// The shipped socle alone cannot answer the question the warning asks. A skill
// retired upstream is absent from it and present on disk, and calling that
// directory a stranger's would be a lie chisel can disprove from its own
// records — so the previous manifest is consulted too: whatever it tracked,
// chisel installed.
export async function warnForeignSkills(
  targetDir: string,
  previouslyManaged: Iterable<string>,
): Promise<void> {
  const skillsDir = join(targetDir, ".agents", "skills");
  if (!(await isDirectory(skillsDir))) return;
  const chisels = new Set(
    SOCLE_FILES.filter((file) => file.startsWith("agents/skills/")).map((
      file,
    ) => file.slice("agents/skills/".length).split("/")[0]),
  );
  for (const name of previouslyManaged) {
    if (!name.startsWith(SKILLS_PREFIX)) continue;
    chisels.add(name.slice(SKILLS_PREFIX.length).split("/")[0]);
  }
  const present: string[] = [];
  for await (const entry of Deno.readDir(skillsDir)) present.push(entry.name);
  for (const name of present.sort()) {
    if (chisels.has(name)) continue;
    warn(
      `.agents/skills/${name} was not installed by chisel — leaving it alone ` +
        `(chisel neither updates nor manages it)`,
    );
  }
}

// Directories chisel creates in a target and keeps: an update that emptied one
// has retired a file, not un-installed the socle, and a skeleton with a hole in
// it would be the next surprise. Everything below them is fair game once empty.
const MANAGED_ROOTS: ReadonlySet<string> = new Set([
  ".agents",
  ".agents/skills",
  ".agents/formulas",
  ".agents/profiles",
  ".claude/agents",
  ".codex/agents",
  "project-management",
  "scripts",
]);

/**
 * Take the directories a removed file leaves behind with it, walking up and
 * stopping at the first one chisel owns. Emptiness is the whole licence: a
 * directory still holding anything — a file of the project's, a dotfile —
 * stays, and so does everything above it.
 */
export async function removeEmptyParents(
  targetDir: string,
  relative: string,
): Promise<void> {
  let current = dirname(relative);
  while (current !== "." && current !== "" && !MANAGED_ROOTS.has(current)) {
    try {
      await Deno.remove(join(targetDir, current));
    } catch {
      // Not empty, or already gone: nothing above it can be empty either.
      return;
    }
    current = dirname(current);
  }
}

/** Poses `.claude/skills` → `../.agents/skills`, or says why it did not. */
export async function linkClaudeSkills(targetDir: string): Promise<void> {
  const link = join(targetDir, ".claude", "skills");
  await Deno.mkdir(join(targetDir, ".claude"), { recursive: true });
  const current = await skillsLinkValue(targetDir);
  if (current !== null) {
    if (current !== SKILLS_LINK_VALUE) {
      warn(
        `${link} is a symlink to ${current}, not ${SKILLS_LINK_VALUE} — leaving it alone`,
      );
    }
    return;
  }
  if (await pathExists(link)) {
    warn(`${link} exists and is not a symlink — leaving it alone`);
    return;
  }
  await Deno.symlink(SKILLS_LINK_VALUE, link);
}

function blockLines(block: string): string[] {
  const lines = block.split("\n");
  if (lines.at(-1) === "") lines.pop();
  return lines;
}

/**
 * Create-or-update the `AGENTS.md` managed block. The title is only used when
 * the file does not exist yet. A file that has no markers gets the block
 * appended, separated from what was already there.
 */
export function agentsMdWithBlock(
  existing: string | null,
  projectTitle: string,
  block: string,
): string {
  const opened = `${BLOCK_BEGIN}\n${block}${BLOCK_END}\n`;
  if (existing === null) {
    return `# ${projectTitle} — agent instructions\n\n${opened}`;
  }
  if (!hasManagedBlockMarkers(existing)) {
    return `${existing}\n${opened}`;
  }
  const lines = existing.split("\n");
  if (lines.at(-1) === "") lines.pop();
  const rebuilt: string[] = [];
  let inside = false;
  for (const line of lines) {
    if (line === BLOCK_BEGIN) {
      rebuilt.push(BLOCK_BEGIN, ...blockLines(block));
      inside = true;
      continue;
    }
    if (line === BLOCK_END) {
      rebuilt.push(BLOCK_END);
      inside = false;
      continue;
    }
    if (!inside) rebuilt.push(line);
  }
  return `${rebuilt.join("\n")}\n`;
}

export async function writeAgentsMd(
  targetDir: string,
  projectTitle: string,
): Promise<void> {
  const path = join(targetDir, "AGENTS.md");
  const block = await readPackageText(SOCLE.agentsBlock);
  const existing = await readTextIfPresent(path);
  // Written by truncating in place, never by moving a temp file over it: a
  // fresh file would carry the temp file's private mode instead of the
  // target's own.
  await Deno.writeTextFile(
    path,
    agentsMdWithBlock(existing, projectTitle, block),
  );
}

/**
 * Ensure `CLAUDE.md` carries the import line, and touch nothing else. A file
 * whose last line has no newline of its own gets one first — otherwise the
 * import would land on the end of someone's sentence.
 */
export function claudeMdWithImport(existing: string | null): string {
  if (existing === null) return `${CLAUDE_IMPORT_LINE}\n`;
  if (existing.split("\n").includes(CLAUDE_IMPORT_LINE)) return existing;
  const separator = existing.endsWith("\n") || existing === "" ? "" : "\n";
  return `${existing}${separator}${CLAUDE_IMPORT_LINE}\n`;
}

export async function writeClaudeMd(targetDir: string): Promise<void> {
  const path = join(targetDir, "CLAUDE.md");
  const existing = await readTextIfPresent(path);
  const next = claudeMdWithImport(existing);
  if (next !== existing) await Deno.writeTextFile(path, next);
}

function today(): string {
  const now = new Date();
  const month = `${now.getMonth() + 1}`.padStart(2, "0");
  const day = `${now.getDate()}`.padStart(2, "0");
  return `${now.getFullYear()}-${month}-${day}`;
}

// Project-owned: tasks and archive created if missing; the journal written
// once, never again.
//
// Why the journal is called `LOG.md`, why it is handwritten, and why §A of the
// glue — not this function — is where its path is declared: the glue template,
// section A. The rule is written there once and not re-argued here.
//
// What this function adds is a guard: a journal already sitting in the
// skeleton under its older name stops it. Two journals in one workspace is the
// incoherence the rename exists to prevent, and an installer has no business
// renaming a project's own file. It says so and names the skill that migrates
// properly. The guard is skeleton-local: it looks in `project-management/`,
// because that is the only place this function writes. A repo whose workspace
// lives elsewhere is the migration skill's business.
export async function ensureProjectManagementSkeleton(
  targetDir: string,
): Promise<void> {
  const pmRoot = join(targetDir, "project-management");
  await Deno.mkdir(join(pmRoot, "tasks"), { recursive: true });
  await Deno.mkdir(join(pmRoot, "archive"), { recursive: true });
  const journal = join(pmRoot, JOURNAL_NAME);
  if (await isFile(journal)) return;
  if (await isFile(join(pmRoot, LEGACY_JOURNAL_NAME))) {
    warn(
      `${targetDir}/project-management/${LEGACY_JOURNAL_NAME} is the journal this repo ` +
        `already has, and v2 names it ${JOURNAL_NAME} — leaving it alone rather than ` +
        `creating a second journal beside it. The upgrade-v2 skill renames it properly ` +
        `and updates the project glue.`,
    );
    return;
  }
  await Deno.writeTextFile(
    journal,
    [
      "# Log",
      "",
      "Project history, newest first. Written by hand, one dated entry per",
      "task — never generated.",
      "",
      `## ${today()}`,
      "",
      "- chisel init: installed the dev-workflow socle.",
      "",
    ].join("\n"),
  );
}

// Refuse to update a repo still carrying the v1 layer. `.agents/rules/` and
// `.agents/workflows.md` were retired: copying the current socle in beside
// them leaves TWO normative discourses in one repo, with the old one still
// cited by whatever pointed at it — and `check` stays silent, because chisel
// never managed those files. Migrating has a tool; this closes the silent
// bypass around it. Called before anything is written, so a refused update
// writes nothing at all.
export async function refuseV1Layout(targetDir: string): Promise<void> {
  const found: string[] = [];
  if (await isDirectory(join(targetDir, ".agents", "rules"))) {
    found.push(".agents/rules/");
  }
  if (await isFile(join(targetDir, ".agents", "workflows.md"))) {
    found.push(".agents/workflows.md");
  }
  if (found.length === 0) return;
  throw new ChiselError(
    `${targetDir} still carries the v1 layout (${
      found.join(" ")
    }) — updating it here ` +
      `would leave two normative discourses side by side, and 'chisel check' would report ` +
      `neither. Run the 'upgrade-v2' skill first: it retires the v1 rules and workflows.md ` +
      `file by file, with a human validating; 'chisel update' is safe again the moment they ` +
      `are gone.`,
  );
}
