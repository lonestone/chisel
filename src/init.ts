// `chisel init` — pose the socle and every adapter in a target repo, and
// leave everything the repo already had exactly as it was.

import { basename, join } from "@std/path";
import {
  copyManagedFiles,
  ensureProjectManagementSkeleton,
  initWrites,
  linkClaudeSkills,
  managedSocleFiles,
  refuseLinkedPaths,
  warnForeignSkills,
  writeAgentsMd,
  writeClaudeMd,
} from "./install.ts";
import { fullRecord, today } from "./intentions.ts";
import { type Manifest, readManifest, writeManifest } from "./manifest.ts";
import {
  ensureProjectMd,
  pointNewGlueAtExistingJournal,
  tickAdapterInventory,
} from "./project-md.ts";
import { type Found, takeInventory } from "./inventory.ts";
import { AGENT_WORK_EXIT, ChiselError, reportLine } from "./report.ts";
import { isDirectory, pathExists } from "./target.ts";
import {
  REFERENCE_DIR,
  SESSION_FILE,
  SETUP_SKILL,
  stageInstall,
  WORKSPACE_DIR,
} from "./workspace.ts";

export interface InitOptions {
  /**
   * The setup skill has placed what a first `init` found: install without
   * taking the inventory again. Linked paths are still refused.
   */
  readonly arranged?: boolean;
}

export async function init(
  targetDir: string,
  options: InitOptions = {},
): Promise<number> {
  if (!(await isDirectory(targetDir))) {
    throw new ChiselError(`target dir does not exist: ${targetDir}`);
  }
  const projectTitle = basename(await Deno.realPath(targetDir));
  if (await pathExists(join(targetDir, WORKSPACE_DIR))) {
    throw new ChiselError(
      `${targetDir}/${WORKSPACE_DIR} exists: a chisel session is in progress. ` +
        `Finish it (${SESSION_FILE} says how), or delete the directory to start ` +
        `again. Nothing was written.`,
    );
  }

  // What an earlier run installed here, read before this one writes: a skill
  // that manifest tracked is chisel's own, whatever the socle ships today, and
  // the intentions it recorded are the repo's history, kept as they are.
  const previous = await readManifest(targetDir);

  // A repo chisel never installed may already have a method of its own.
  // Installing beside it would leave two voices; the setup skill places each
  // thing with the human first, then runs `init --arranged`. A repo with a
  // manifest is one chisel installed: what it holds is chisel's own layout.
  if (previous === null && !options.arranged) {
    const found = await takeInventory(targetDir);
    if (found.length > 0) return await stageFirstInstall(targetDir, found);
  }

  await refuseLinkedPaths(targetDir, initWrites());
  await poseSocle(targetDir, projectTitle, previous);

  console.log(
    `chisel init: ${targetDir} ready (.agents/, AGENTS.md, CLAUDE.md, .claude/skills, ` +
      `project-management/, scripts/task-id.sh)`,
  );
  return 0;
}

/** Stages the install session, names what was found, and hands over. */
async function stageFirstInstall(
  targetDir: string,
  found: readonly Found[],
): Promise<number> {
  await stageInstall(targetDir, found);
  console.log(
    `chisel init: ${targetDir} already has a method of its own — staged ` +
      `${WORKSPACE_DIR}/, nothing else written`,
  );
  for (const item of found) reportLine(`found: ${item.kind} — ${item.path}`);
  reportLine(`session: ${SESSION_FILE}`);
  reportLine(
    `next: ask your agent to follow ${REFERENCE_DIR}/${SETUP_SKILL}, ` +
      `which places each one with you before anything is installed`,
  );
  return AGENT_WORK_EXIT;
}

/**
 * Every write of `init`, once its pre-flight has passed: the socle, the glue,
 * the adapters, the task workspace and the manifest. Also how a staged update
 * lays its reference tree, in an empty directory.
 *
 * The intentions record: a first install has applied everything it ships —
 * it starts from this release. A repo that already has a manifest keeps its
 * record as it is: what was pending stays pending, for `update` to stage.
 */
export async function poseSocle(
  targetDir: string,
  projectTitle: string,
  previous: Manifest | null,
): Promise<void> {
  await copyManagedFiles(targetDir);
  await warnForeignSkills(targetDir, Object.keys(previous?.managed ?? {}));
  // The glue is written before the adapters so the inventory below can report
  // what this run actually put in place — and only on a glue this run created.
  const glueCreated = await ensureProjectMd(targetDir);
  await writeAgentsMd(targetDir, projectTitle);
  await writeClaudeMd(targetDir);
  await linkClaudeSkills(targetDir);
  if (glueCreated) await tickAdapterInventory(targetDir);
  await ensureProjectManagementSkeleton(targetDir);
  if (glueCreated) await pointNewGlueAtExistingJournal(targetDir);
  await writeManifest(
    targetDir,
    managedSocleFiles(),
    previous?.intentions ?? fullRecord(today()),
  );
}
