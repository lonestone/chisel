// `chisel init` — pose the socle and every adapter in a target repo, and
// leave everything the repo already had exactly as it was.

import { basename } from "@std/path";
import {
  copyManagedFiles,
  ensureProjectManagementSkeleton,
  linkClaudeSkills,
  writeAgentsMd,
  writeClaudeMd,
} from "./install.ts";
import { writeManifest } from "./manifest.ts";
import {
  ensureProjectMd,
  pointNewGlueAtExistingJournal,
  tickAdapterInventory,
} from "./project-md.ts";
import { renderAgentDefinitions } from "./render.ts";
import { ChiselError } from "./report.ts";
import { isDirectory } from "./target.ts";

export async function init(targetDir: string): Promise<number> {
  if (!(await isDirectory(targetDir))) {
    throw new ChiselError(`target dir does not exist: ${targetDir}`);
  }
  const projectTitle = basename(await Deno.realPath(targetDir));

  await copyManagedFiles(targetDir);
  await renderAgentDefinitions(targetDir);
  // The glue is written before the adapters so the inventory below can report
  // what this run actually put in place — and only on a glue this run created.
  const glueCreated = await ensureProjectMd(targetDir);
  await writeAgentsMd(targetDir, projectTitle);
  await writeClaudeMd(targetDir);
  await linkClaudeSkills(targetDir);
  if (glueCreated) await tickAdapterInventory(targetDir);
  await ensureProjectManagementSkeleton(targetDir);
  if (glueCreated) await pointNewGlueAtExistingJournal(targetDir);
  await writeManifest(targetDir);

  console.log(
    `chisel init: ${targetDir} ready (.agents/, AGENTS.md, CLAUDE.md, .claude/skills, ` +
      `.claude/agents, .codex/agents, project-management/, scripts/task-id.sh)`,
  );
  return 0;
}
