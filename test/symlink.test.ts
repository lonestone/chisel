// Package-root resolution: chisel must find its own socle when it is reached
// through a symlink, which is what an installed package looks like.

import { assert, assertEquals } from "@std/assert";
import { join } from "@std/path";
import { REPO_ROOT, runChisel, withRepo } from "./helpers.ts";

Deno.test("symlink: reached through a symlinked package directory, chisel finds its socle", async () => {
  await withRepo(async (workspace) => {
    const linkHome = await workspace.dir("bin");
    const linkedPackage = join(linkHome, "chisel-package");
    await Deno.symlink(REPO_ROOT, linkedPackage);
    const target = await workspace.copy("brownfield");

    const result = await runChisel(
      ["init", target],
      join(linkedPackage, "src", "main.ts"),
    );
    assertEquals(
      result.code,
      0,
      `init through the link exits 0\n${result.output}`,
    );
    assert(
      (await Deno.stat(join(target, ".agents", "skills", "tdd", "SKILL.md")))
        .isFile,
      "the resolved socle content was copied",
    );
  });
});
