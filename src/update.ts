// `chisel update` — bring every managed file back to the shipped socle, say
// what moved, and clean up after a file that left the managed set.

import { join } from "@std/path";
import {
  copyManagedFiles,
  managedSocleFiles,
  removeEmptyParents,
  v1LayoutFound,
  warnForeignSkills,
  writeAgentsMd,
} from "./install.ts";
import {
  BLOCK_KEY,
  type Manifest,
  MANIFEST_FILE,
  orphansOf,
  readManifest,
  writeManifest,
} from "./manifest.ts";
import {
  BASELINE,
  type Intention,
  type IntentionRecord,
  needsJudgement,
  pendingIntentions,
  readIntention,
  type ShippedIntention,
  today,
} from "./intentions.ts";
import { sha256File } from "./hash.ts";
import { reportStaleGlue } from "./project-md.ts";
import { AGENT_WORK_EXIT, ChiselError, reportLine, warn } from "./report.ts";
import { isDirectory, isFile, linkedPaths, pathExists } from "./target.ts";
import {
  REFERENCE_DIR,
  SESSION_FILE,
  stageWorkspace,
  type Staging,
  UPDATE_SKILL,
  WORKSPACE_DIR,
} from "./workspace.ts";

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
  if (await pathExists(join(targetDir, WORKSPACE_DIR))) {
    throw new ChiselError(
      `${targetDir}/${WORKSPACE_DIR} exists: an update session is in progress. ` +
        `Finish it with the chisel-update skill (${SESSION_FILE} says how), or delete the ` +
        `directory to start again. Nothing was written.`,
    );
  }

  // Read before writing: the comparison this command reports on is between
  // what the last run installed and what this one does. Without a manifest
  // there is no last run to compare with, and a layout chisel does not
  // recognise is an agent's business, not a script's.
  const previous = await readManifest(targetDir);
  const writes = await updateWrites(targetDir, previous ?? EMPTY_MANIFEST);
  const firstVersion = await v1LayoutFound(targetDir);
  const pending: Intention[] = [];
  for (const shipped of intentionsToRead(previous, firstVersion)) {
    pending.push(await readIntention(shipped));
  }

  const reasons = await reasonsToStage(
    targetDir,
    previous,
    firstVersion,
    writes,
    pending,
  );
  // A missing manifest is always among the reasons; the test on it is what
  // tells the type checker the fast path has one.
  if (reasons.length > 0 || previous === null) {
    return await stage(targetDir, {
      from: previous?.version ?? null,
      reasons,
      pending,
    });
  }
  return await fastPath(targetDir, previous, writes, pending);
}

const EMPTY_MANIFEST: Manifest = { version: "", managed: {}, intentions: {} };

/**
 * What the session lists. A repo without a manifest has no release history
 * to replay: the baseline alone takes it to the current layout. The first
 * version's layer beside a manifest is closed by the baseline first, then by
 * whatever its record still has pending.
 */
function intentionsToRead(
  previous: Manifest | null,
  firstVersion: readonly string[],
): ShippedIntention[] {
  if (previous === null) return [BASELINE];
  const pending = pendingIntentions(previous.intentions);
  return firstVersion.length > 0 ? [BASELINE, ...pending] : pending;
}

/**
 * Every reason this update cannot be a copy, as a sentence for the session:
 * the first version's layer, no manifest, a symbolic link on a path it would
 * write, and the pending intentions that need judgement. Reads only.
 */
async function reasonsToStage(
  targetDir: string,
  previous: Manifest | null,
  firstVersion: readonly string[],
  writes: readonly string[],
  pending: readonly Intention[],
): Promise<string[]> {
  const reasons: string[] = [];
  if (firstVersion.length > 0) {
    reasons.push(
      `The first version's layer is still here (${
        firstVersion.join(", ")
      }): copying the ` +
        `current socle beside it would leave two methods in one repo. Its intention is ` +
        `${BASELINE.id}.`,
    );
  }
  if (previous === null) {
    reasons.push(
      `No manifest (${MANIFEST_FILE}): chisel did not install this repo, or installed it ` +
        `before the manifest existed. Its intention is ${BASELINE.id}.`,
    );
  }
  const linked = await linkedPaths(targetDir, [
    ...writes,
    "AGENTS.md",
    MANIFEST_FILE,
    // The orphan pass may remove any of them, and a removal under a linked
    // directory would reach the link's destination too.
    ...Object.keys(previous?.managed ?? {}).filter((name) =>
      name !== BLOCK_KEY
    ),
  ]);
  if (linked.length > 0) {
    reasons.push(
      `Symbolic links on paths chisel writes, and writing them would change the files ` +
        `they point at: ${
          linked.join(", ")
        }. Step 3 of the update skill (${REFERENCE_DIR}/${UPDATE_SKILL}) ` +
        `closes them with the human.`,
    );
  }
  const judged = pending.filter((intention) =>
    needsJudgement(intention.classification)
  );
  if (judged.length > 0) {
    reasons.push(
      `Pending intentions need judgement: ${
        judged.map((intention) =>
          `${intention.id} (${intention.classification})`
        ).join(", ")
      }.`,
    );
  }
  return reasons;
}

/** Stages the workspace, says why and what is in it, and hands over. */
async function stage(targetDir: string, staging: Staging): Promise<number> {
  const checklist = await stageWorkspace(targetDir, staging);
  console.log(
    `chisel update: ${targetDir} — staged ${WORKSPACE_DIR}/, nothing else written`,
  );
  for (const reason of staging.reasons) reportLine(`why: ${reason}`);
  for (const line of checklist) reportLine(line);
  reportLine(`checklist: ${SESSION_FILE}`);
  reportLine(
    `next: ask your agent to follow ${REFERENCE_DIR}/${UPDATE_SKILL}`,
  );
  return AGENT_WORK_EXIT;
}

/** Today's update: refresh, report, clean up — then record what it closed. */
async function fastPath(
  targetDir: string,
  previous: Manifest,
  writes: string[],
  pending: readonly Intention[],
): Promise<number> {
  const overwritten = await locallyEdited(targetDir, writes, previous);

  await copyManagedFiles(targetDir, new Set(writes));
  if (await isFile(join(targetDir, "AGENTS.md"))) {
    await writeAgentsMd(targetDir, "");
  } else {
    console.error(
      `chisel update: warning: ${targetDir}/AGENTS.md not found — skipping (run chisel init first)`,
    );
  }
  const intentions: IntentionRecord = { ...previous.intentions };
  for (const intention of pending) {
    intentions[intention.id] = { result: "applied", date: today() };
  }
  const current = await writeManifest(targetDir, writes, intentions);

  console.log(`chisel update: ${targetDir}`);
  let reported = false;
  for (const name of overwritten) {
    reportLine(`overwritten: ${name}`);
    reported = true;
  }
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
  for (const intention of pending) {
    reportLine(`recorded: ${intention.id} (${intention.classification})`);
    if (intention.classification === "informational") {
      reportLine(`  read: ${intention.title}`);
    }
  }
  return 0;
}

/**
 * The managed files about to be written whose content is no longer what the
 * last run installed: someone edited them. The fast path still replaces
 * them — they are chisel's — but says so first, so an edit never vanishes
 * without a line naming it.
 */
async function locallyEdited(
  targetDir: string,
  writes: readonly string[],
  previous: Manifest,
): Promise<string[]> {
  const edited: string[] = [];
  for (const name of writes) {
    const installed = previous.managed[name];
    const path = join(targetDir, name);
    if (installed === undefined || !(await isFile(path))) continue;
    if ((await sha256File(path)) !== installed) edited.push(name);
  }
  return edited.sort();
}
