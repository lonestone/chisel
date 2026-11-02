// `chisel update` — bring every managed file back to the shipped socle, say
// what moved, and clean up after a file that left the managed set.

import { join } from "@std/path";
import {
  copyManagedFiles,
  managedSocleFiles,
  refuseLinkedPaths,
  refuseV1Layout,
  removeEmptyParents,
  upgradeRecipePointer,
  warnForeignSkills,
  writeAgentsMd,
} from "./install.ts";
import {
  BLOCK_KEY,
  type Manifest,
  manifestPath,
  orphansOf,
  readManifest,
  writeManifest,
} from "./manifest.ts";
import { reportStaleGlue } from "./project-md.ts";
import { ChiselError, reportLine, warn } from "./report.ts";
import { isDirectory, isFile } from "./target.ts";

/**
 * The managed files this update writes: everything the socle ships inside
 * `.agents/`, and outside it only what the last run installed and the project
 * still has. A repo whose manifest never listed a template or the task id
 * script keeps its workspace where it chose, and one that deleted them has
 * them deleted for good: no second tree grows beside the one it kept.
 */
async function updateWrites(
  targetDir: string,
  previous: Manifest,
): Promise<string[]> {
  const writes: string[] = [];
  for (const relative of managedSocleFiles()) {
    if (
      relative.startsWith(".agents/") ||
      (relative in previous.managed &&
        await isFile(join(targetDir, relative)))
    ) {
      writes.push(relative);
    }
  }
  return writes;
}

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

  const writes = await updateWrites(targetDir, previous);
  await refuseLinkedPaths(targetDir, [
    ...writes,
    "AGENTS.md",
    ".agents/.chisel.json",
    // The orphan pass may remove any of them, and a removal under a linked
    // directory would reach the link's destination too.
    ...Object.keys(previous.managed).filter((name) => name !== BLOCK_KEY),
  ]);

  await copyManagedFiles(targetDir, new Set(writes));
  if (await isFile(join(targetDir, "AGENTS.md"))) {
    await writeAgentsMd(targetDir, "");
  } else {
    console.error(
      `chisel update: warning: ${targetDir}/AGENTS.md not found — skipping (run chisel init first)`,
    );
  }
  const current = await writeManifest(targetDir, writes);

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
