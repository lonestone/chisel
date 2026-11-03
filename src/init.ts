// `chisel init` — pose the socle and every adapter in a target repo, and
// leave everything the repo already had exactly as it was.

import { basename } from "@std/path";
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
import { ChiselError } from "./report.ts";
import { isDirectory } from "./target.ts";

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
  await refuseLinkedPaths(targetDir, initWrites());

  // What an earlier run installed here, read before this one writes: a skill
  // that manifest tracked is chisel's own, whatever the socle ships today, and
  // the intentions it recorded are the repo's history, kept as they are.
  const previous = await readManifest(targetDir);
  await poseSocle(targetDir, projectTitle, previous);

  console.log(
    `chisel init: ${targetDir} ready (.agents/, AGENTS.md, CLAUDE.md, .claude/skills, ` +
      `project-management/, scripts/task-id.sh)`,
  );
  return 0;
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
