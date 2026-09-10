// chisel — install, update, and check the Lonestone dev-workflow socle (the
// `socle/` shipped inside this package) in a target repo.
//
// The entry does three things and no more: it reads the arguments, it maps a
// command to its module, and it turns an error into an exit code. Everything
// a command decides belongs to that command's own module.

import { check } from "./check.ts";
import { init } from "./init.ts";
import { packageVersion } from "./paths.ts";
import { ChiselError, UsageError } from "./report.ts";
import { update } from "./update.ts";

export function usage(): string {
  return [
    "chisel — install, update, and check the Lonestone dev-workflow socle",
    "",
    "Usage:",
    "  chisel init [target-dir]    copy the socle + adapters (default target-dir: .)",
    "  chisel update [target-dir]  re-render managed files + AGENTS.md block (default: .)",
    "  chisel check [target-dir]   report version + local divergences, zero writes (default: .)",
    "  chisel --version            print the installed chisel version",
    "  chisel --help               show this message",
    "",
    "Exit codes:",
    "  0  the command did what it says",
    "  1  a refusal, a missing precondition, or a divergence found by check",
    "  2  a usage error: an unknown command, or an argument too many",
    "",
    "Requires Deno 2.6 or later. Permissions: read and write inside the target",
    "directory, and read of chisel's own packaged files — `-A` grants them all",
    "at once, and running without it answers one prompt per kind of access.",
  ].join("\n");
}

function targetOf(rest: string[]): string {
  if (rest.length > 1) {
    throw new UsageError(`unexpected extra argument: ${rest[1]}`);
  }
  return rest[0] ?? ".";
}

export async function run(args: string[]): Promise<number> {
  const [command, ...rest] = args;
  switch (command) {
    case "init":
      return await init(targetOf(rest));
    case "update":
      return await update(targetOf(rest));
    case "check":
      return await check(targetOf(rest));
    case "--version":
    case "version":
      if (rest.length > 0) {
        throw new UsageError(`unexpected extra argument: ${rest[0]}`);
      }
      console.log(await packageVersion());
      return 0;
    case undefined:
    case "":
    case "-h":
    case "--help":
    case "help":
      console.log(usage());
      return 0;
    default:
      throw new UsageError(`unknown command: ${command}`);
  }
}

export async function main(args: string[]): Promise<number> {
  try {
    return await run(args);
  } catch (error) {
    if (error instanceof UsageError) {
      console.error(`chisel: ${error.message}`);
      console.error(usage());
      return 2;
    }
    const message = error instanceof ChiselError || error instanceof Error
      ? error.message
      : String(error);
    console.error(`chisel: ${message}`);
    return 1;
  }
}

if (import.meta.main) {
  Deno.exit(await main(Deno.args));
}
