// `check`: the exit codes, the files it names, and the two things it looks
// at beyond a hash — the link's target and a residue in the glue.

import { assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import { appendTo, runChisel, withRepo } from "./helpers.ts";

Deno.test("check: exit codes on a clean install and on drift", async () => {
  await withRepo(async (workspace) => {
    const clean = await workspace.install("brownfield");
    const first = await runChisel(["check", clean]);
    assertEquals(
      first.code,
      0,
      `clean immediately after init\n${first.output}`,
    );
    assertStringIncludes(first.stdout, "clean — no divergence");

    await appendTo(
      join(clean, ".agents", "skills", "code-review", "SKILL.md"),
      "\n<!-- diverged -->\n",
    );
    const drifted = await runChisel(["check", clean]);
    assertEquals(drifted.code, 1, "a hand-edited managed skill is drift");
    assertStringIncludes(drifted.stdout, ".agents/skills/code-review/SKILL.md");

    // The recomposed normative layer is managed too.
    const normative = await workspace.install("brownfield");
    await appendTo(
      join(normative, ".agents", "discipline.md"),
      "\n<!-- diverged -->\n",
    );
    const normativeDrift = await runChisel(["check", normative]);
    assertEquals(
      normativeDrift.code,
      1,
      "a hand-edited discipline.md is drift",
    );
    assertStringIncludes(normativeDrift.stdout, ".agents/discipline.md");

    // So are the rendered agent definitions, in both formats.
    const rendered = await workspace.install("brownfield");
    await appendTo(
      join(rendered, ".claude", "agents", "architect.md"),
      "\n<!-- diverged -->\n",
    );
    await appendTo(
      join(rendered, ".codex", "agents", "mason.toml"),
      "\n# diverged\n",
    );
    const renderDrift = await runChisel(["check", rendered]);
    assertEquals(
      renderDrift.code,
      1,
      "a hand-edited generated definition is drift",
    );
    assertStringIncludes(renderDrift.stdout, ".claude/agents/architect.md");
    assertStringIncludes(renderDrift.stdout, ".codex/agents/mason.toml");
  });
});

Deno.test("check: a skills link pointing elsewhere is a missing adapter", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const elsewhere = await workspace.dir("someone-elses-skills");
    const link = join(target, ".claude", "skills");

    await Deno.remove(link);
    await Deno.symlink(elsewhere, link);

    const result = await runChisel(["check", target]);
    assertEquals(
      result.code,
      1,
      "a link that resolves but points elsewhere is not the adapter",
    );
    assertStringIncludes(result.stdout, ".claude/skills");
  });
});

Deno.test("check: a retired glue subsection is reported and the glue left byte-identical", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const glue = join(target, ".agents", "project.md");
    const withResidue = (await Deno.readTextFile(glue)).replace(
      "## C · Reading list",
      "### B3 · Autonomous runs\n\nA subsection an older socle read and nothing reads now.\n\n## C · Reading list",
    );
    await Deno.writeTextFile(glue, withResidue);

    const result = await runChisel(["check", target]);
    assertStringIncludes(result.stdout, "stale:");
    assertStringIncludes(result.stdout, "B3 · Autonomous runs");
    assertEquals(
      await Deno.readTextFile(glue),
      withResidue,
      "check writes nothing at all",
    );
  });
});
