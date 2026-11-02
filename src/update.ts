// `chisel update` — bring every managed file back to the shipped socle, say
// what moved, and clean up after a file that left the managed set.

import { join } from "@std/path";
import {
  copyManagedFiles,
  refuseV1Layout,
  removeEmptyParents,
  upgradeRecipePointer,
  warnForeignSkills,
  writeAgentsMd,
} from "./install.ts";
import {
  manifestPath,
  orphansOf,
  readManifest,
  writeManifest,
} from "./manifest.ts";
import { reportStaleGlue } from "./project-md.ts";
import { ChiselError, reportLine, warn } from "./report.ts";
import { isDirectory, isFile } from "./target.ts";

export async function update(targetDir: string): Promise<number> {
  if (!(await isDirectory(targetDir))) {
    throw new ChiselError(`target dir does not exist: ${targetDir}`);
  }
  if (!(await isDirectory(join(targetDir, ".agents")))) {
    throw new ChiselError(
      `${targetDir}/.agents not found — run 'chisel init' first`,
    );
  }
  await refuseV1Layout(targetDir);

  // Read before writing: the comparison this command reports on is between
  // what the last run installed and what this one does. Without a manifest
  // there is no last run to compare with — chisel did not install this repo,
  // or installed it before it kept one — and a layout it does not recognise
  // is the recipe's business, not a script's.
  const previous = await readManifest(targetDir);
  if (previous === null) {
    throw new ChiselError(
      `${targetDir} has .agents/ but no ${
        manifestPath(targetDir)
      }: chisel did not ` +
        `install this repo, or installed it before the manifest existed, and it does not ` +
        `guess at a layout it does not recognise. ${await upgradeRecipePointer()}`,
    );
  }

  await copyManagedFiles(targetDir);
  if (await isFile(join(targetDir, "AGENTS.md"))) {
    await writeAgentsMd(targetDir, "");
  } else {
    console.error(
      `chisel update: warning: ${targetDir}/AGENTS.md not found — skipping (run chisel init first)`,
    );
  }
  const current = await writeManifest(targetDir);

  console.log(`chisel update: ${targetDir}`);
  let reported = false;
  for (const name of Object.keys(current.managed).sort()) {
    if (previous.managed[name] !== current.managed[name]) {
      reportLine(`changed: ${name}`);
      reported = true;
    }
  }
  for (const orphan of await orphansOf(targetDir, previous, current)) {
    if (orphan.verdict === "removed") {
      await Deno.remove(join(targetDir, orphan.name));
      await removeEmptyParents(targetDir, orphan.name);
      reportLine(`removed: ${orphan.name}`);
      reported = true;
    } else if (orphan.verdict === "orphaned") {
      reportLine(`orphaned: ${orphan.name}`);
      warn(
        `${orphan.name} left the managed set but has local changes — leaving it alone; ` +
          `delete it by hand once you are done with it`,
      );
      reported = true;
    }
  }
  // Last, because the orphan pass has just taken the retired files and their
  // emptied directories away: whatever is still sitting in `.agents/skills/`
  // that neither this socle ships nor the last manifest claimed really is
  // someone else's.
  await warnForeignSkills(targetDir, Object.keys(previous.managed));
  if (!reported) reportLine("(no managed files changed)");

  await reportStaleGlue(targetDir);
  return 0;
}
