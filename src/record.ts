// `chisel record` — write what a repo did with one intention into its
// manifest: applied, or skipped with the reason. The update skill runs it
// after each intention of a staged session; it also ticks the session's line.

import { join } from "@std/path";
import { type IntentionResult, shippedIntention, today } from "./intentions.ts";
import { MANIFEST_FILE, readManifest, recordIntention } from "./manifest.ts";
import { packageVersion } from "./paths.ts";
import { ChiselError, UsageError } from "./report.ts";
import { isDirectory, linkedPaths } from "./target.ts";
import { tickSession } from "./workspace.ts";

interface RecordRequest {
  readonly id: string;
  readonly targetDir: string;
  readonly result: IntentionResult;
}

/** `<id> (--applied | --skipped "<reason>") [target-dir]`, in any order. */
function parseRecordArgs(args: readonly string[]): RecordRequest {
  const positional: string[] = [];
  let result: IntentionResult | null = null;
  for (let index = 0; index < args.length; index++) {
    const arg = args[index];
    if (arg === "--applied" || arg === "--skipped") {
      if (result !== null) {
        throw new UsageError("record takes one of --applied or --skipped");
      }
      if (arg === "--applied") {
        result = { result: "applied", date: today() };
        continue;
      }
      const reason = args[index + 1]?.trim() ?? "";
      if (reason === "" || reason.startsWith("--")) {
        throw new UsageError(
          '--skipped needs its reason: --skipped "<reason>"',
        );
      }
      result = { result: "skipped", date: today(), reason };
      index += 1;
    } else if (arg.startsWith("--")) {
      throw new UsageError(`unknown option: ${arg}`);
    } else {
      positional.push(arg);
    }
  }
  if (positional.length === 0) {
    throw new UsageError("record needs the id of an intention");
  }
  if (positional.length > 2) {
    throw new UsageError(`unexpected extra argument: ${positional[2]}`);
  }
  if (result === null) {
    throw new UsageError("record needs --applied or --skipped");
  }
  return { id: positional[0], targetDir: positional[1] ?? ".", result };
}

export async function record(args: readonly string[]): Promise<number> {
  const { id, targetDir, result } = parseRecordArgs(args);
  if (!(await isDirectory(targetDir))) {
    throw new ChiselError(`target dir does not exist: ${targetDir}`);
  }
  if (shippedIntention(id) === null) {
    throw new ChiselError(
      `chisel ${await packageVersion()} ships no intention ${id} — ` +
        `the ids are in the session's checklist`,
    );
  }
  if ((await linkedPaths(targetDir, [MANIFEST_FILE])).length > 0) {
    throw new ChiselError(
      `${
        join(targetDir, MANIFEST_FILE)
      } is, or sits under, a symbolic link — ` +
        `nothing was written`,
    );
  }
  if ((await readManifest(targetDir)) === null) {
    throw new ChiselError(
      `no manifest at ${join(targetDir, MANIFEST_FILE)}: the session's first ` +
        `intention creates it — nothing was written`,
    );
  }
  await recordIntention(targetDir, id, result);
  await tickSession(targetDir, id);
  console.log(
    `chisel record: ${id} ${result.result}` +
      (result.reason ? ` — ${result.reason}` : ""),
  );
  return 0;
}
