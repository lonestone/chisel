// The two refusals: a repo still carrying the retired layout, and a file
// chisel did not install.

import { assert, assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import { appendTo, runChisel, withRepo } from "./helpers.ts";

async function absent(path: string): Promise<boolean> {
  return await Deno.lstat(path).then(() => false).catch(() => true);
}

Deno.test("guards: update refuses a repo still carrying the v1 layout", async () => {
  await withRepo(async (workspace) => {
    const legacy = await workspace.copy("brownfield-v1");
    const workflowsBefore = await Deno.readTextFile(
      join(legacy, ".agents", "workflows.md"),
    );

    const refused = await runChisel(["update", legacy]);
    assertEquals(refused.code, 1, "the refusal exits 1");
    assertStringIncludes(
      refused.stderr,
      "upgrade-v2",
      "it names the migration skill",
    );
    assertStringIncludes(
      refused.stderr,
      ".agents/rules/",
      "it names what it found",
    );
    assert(
      await absent(join(legacy, ".agents", "discipline.md")),
      "no discipline.md installed",
    );
    assert(
      await absent(join(legacy, ".agents", "formulas")),
      "no formulas installed",
    );
    assert(
      await absent(join(legacy, ".agents", ".chisel.json")),
      "no manifest written",
    );
    assertEquals(
      await Deno.readTextFile(join(legacy, ".agents", "workflows.md")),
      workflowsBefore,
      "the v1 files are byte-intact",
    );

    // The guard refuses a situation, not a command: the same command on a v2
    // layout still works.
    const current = await workspace.install("brownfield");
    assertEquals(
      (await runChisel(["update", current])).code,
      0,
      "a v2 layout still updates",
    );
  });
});

Deno.test("guards: a skill chisel did not install is never adopted or overwritten", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const foreignDir = join(target, ".agents", "skills", "beads");
    const foreign = join(foreignDir, "SKILL.md");
    await Deno.mkdir(foreignDir, { recursive: true });
    await Deno.writeTextFile(
      foreign,
      "# A skill installed by another tool, not by chisel.\n",
    );
    const before = await Deno.readTextFile(foreign);

    const updated = await runChisel(["update", target]);
    assertEquals(updated.code, 0, updated.output);
    assertEquals(
      await Deno.readTextFile(foreign),
      before,
      "it survives update byte-intact",
    );
    assertStringIncludes(
      updated.stderr,
      "was not installed by chisel",
      "update says out loud that it does not manage it",
    );
    assert(
      !(await Deno.readTextFile(join(target, ".agents", ".chisel.json")))
        .includes("skills/beads"),
      "never adopted into the manifest",
    );

    // The point of not adopting it: its owner edits their own file and chisel
    // stays quiet.
    await appendTo(foreign, "\n<!-- edited by its owner, not by chisel -->\n");
    assertEquals(
      (await runChisel(["check", target])).code,
      0,
      "check stays clean after its owner edits it",
    );

    // A socle skill in the same tree is still managed: the guard narrows the
    // claim, not the coverage.
    await appendTo(
      join(target, ".agents", "skills", "tdd", "SKILL.md"),
      "\n<!-- diverged -->\n",
    );
    assertEquals(
      (await runChisel(["check", target])).code,
      1,
      "a socle skill next to it is still checked",
    );
  });
});
