// The command line itself: what `--help` promises, what `--version` prints,
// and what a mistake costs.

import { assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import { REPO_ROOT, runChisel } from "./helpers.ts";

Deno.test("usage: --help names the commands, the exit codes and the prerequisite", async () => {
  const result = await runChisel(["--help"]);
  assertEquals(result.code, 0);
  for (
    const expected of [
      "init",
      "update",
      "check",
      "--version",
      "--help",
      "Deno",
      "Exit codes",
    ]
  ) {
    assertStringIncludes(result.stdout, expected);
  }
});

Deno.test("usage: an unknown command and an argument too many exit 2, naming the offender", async () => {
  const unknown = await runChisel(["frob"]);
  assertEquals(unknown.code, 2, "an unknown command is a usage error");
  assertStringIncludes(unknown.stderr, "frob");

  const extra = await runChisel(["init", "a", "b"]);
  assertEquals(extra.code, 2, "an extra positional argument is a usage error");
  assertStringIncludes(extra.stderr, "b");
});

Deno.test("usage: --version prints the version the package declares", async () => {
  const declared = JSON.parse(
    await Deno.readTextFile(join(REPO_ROOT, "deno.json")),
  ) as {
    version: string;
  };
  const result = await runChisel(["--version"]);
  assertEquals(result.code, 0);
  assertEquals(result.stdout, `${declared.version}\n`);
});
