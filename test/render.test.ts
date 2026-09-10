// The renders: what a profile becomes in each tool's format, and what the
// installed formulas are supposed to say.
//
// The oracle for the render is a committed pair of files nobody generated —
// a profile and the two renders expected of it — compared byte for byte. The
// loop over the installed profiles is driven by the tree, not by a list, so
// a role added upstream is covered the day it lands.

import { assert, assertEquals, assertStringIncludes } from "@std/assert";
import { parse as parseToml } from "@std/toml";
import { join } from "@std/path";
import {
  bodyAfterProvenance,
  FIXTURES,
  runChisel,
  splitFrontmatter,
  withRepo,
} from "./helpers.ts";

interface FormulaExpectation {
  readonly steps: number;
  readonly gates: string[];
}

const EXPECTED_FORMULAS: Record<string, FormulaExpectation> = {
  "chisel-default": { steps: 9, gates: ["plan", "type", "close"] },
  "chisel-light": { steps: 7, gates: ["plan", "diff-review"] },
  "chisel-supervised": { steps: 9, gates: ["plan"] },
  "chisel-auto": { steps: 9, gates: [] },
  "chisel-auto-light": { steps: 6, gates: [] },
};

interface Formula {
  version: unknown;
  formula: string;
  steps: Array<{ id: string; gate?: { type?: string } }>;
}

Deno.test("render: every installed profile carries its body into both formats", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const profilesDir = join(target, ".agents", "profiles");

    let covered = 0;
    for await (const entry of Deno.readDir(profilesDir)) {
      if (!entry.isFile || !entry.name.endsWith(".md")) continue;
      const profile = splitFrontmatter(
        await Deno.readTextFile(join(profilesDir, entry.name)),
      );
      const role = profile.head.get("name");
      // A page with no `name` — the profiles README — is not a role, and the
      // renderer is supposed to ignore it.
      if (role === undefined) continue;
      covered += 1;

      const claude = await Deno.readTextFile(
        join(target, ".claude", "agents", `${role}.md`),
      );
      const codex = await Deno.readTextFile(
        join(target, ".codex", "agents", `${role}.toml`),
      );
      assertEquals(
        bodyAfterProvenance(claude),
        profile.body,
        `the claude definition of ${role} carries the profile body verbatim`,
      );
      assertStringIncludes(claude, `name: "${role}"`);
      assertStringIncludes(codex, `name = "${role}"`);
      assertStringIncludes(claude, `from .agents/profiles/${entry.name}`);
      assertStringIncludes(codex, `from .agents/profiles/${entry.name}`);
      assertEquals(
        (parseToml(codex) as unknown as { developer_instructions: string })
          .developer_instructions,
        profile.body,
        `the codex definition of ${role} parses back to the profile body`,
      );
    }
    assert(
      covered >= 5,
      `the loop covered every role, not a hand-written few: ${covered}`,
    );
    assert(
      (await Deno.stat(join(target, ".claude", "agents", "checker.md"))).isFile,
      "the checker is rendered like any other role",
    );
  });
});

Deno.test("render: a committed profile renders to its two committed goldens", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const goldenDir = join(FIXTURES, "render-golden");
    await Deno.copyFile(
      join(goldenDir, "profile.md"),
      join(target, ".agents", "profiles", "render-probe.md"),
    );

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);

    assertEquals(
      await Deno.readTextFile(
        join(target, ".claude", "agents", "render-probe.md"),
      ),
      await Deno.readTextFile(join(goldenDir, "expected.claude.md")),
      "the claude render matches its golden byte for byte",
    );
    assertEquals(
      await Deno.readTextFile(
        join(target, ".codex", "agents", "render-probe.toml"),
      ),
      await Deno.readTextFile(join(goldenDir, "expected.codex.toml")),
      "the codex render matches its golden byte for byte",
    );
  });
});

Deno.test("render: the five formula presets parse with their steps and their gates", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const formulasDir = join(target, ".agents", "formulas");

    const seen = new Set<string>();
    for await (const entry of Deno.readDir(formulasDir)) {
      if (!entry.isFile || !entry.name.endsWith(".formula.toml")) continue;
      const formula = parseToml(
        await Deno.readTextFile(join(formulasDir, entry.name)),
      ) as unknown as Formula;
      assert(
        Number.isInteger(formula.version),
        `${entry.name}: the version is an integer`,
      );
      const expected = EXPECTED_FORMULAS[formula.formula];
      assert(
        expected !== undefined,
        `${entry.name}: an unexpected preset, ${formula.formula}`,
      );
      seen.add(formula.formula);
      const ids = formula.steps.map((step) => step.id);
      assertEquals(
        new Set(ids).size,
        ids.length,
        `${entry.name}: the step ids are unique`,
      );
      assertEquals(ids.length, expected.steps, `${entry.name}: the step count`);
      assertEquals(
        formula.steps.filter((step) => step.gate?.type === "human").map((
          step,
        ) => step.id),
        expected.gates,
        `${entry.name}: the human gates, in order`,
      );
    }
    assertEquals(
      [...seen].sort(),
      Object.keys(EXPECTED_FORMULAS).sort(),
      "every preset the socle ships was parsed",
    );
  });
});

Deno.test("render: the installed tree carries no retired name and no invented limit", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const invented =
      /40 lines|8 lines|half of the slice|half the spend|target ~/;

    for await (const path of walkFiles(join(target, ".agents"))) {
      const text = await Deno.readTextFile(path);
      const relative = path.slice(target.length + 1);
      assert(
        !text.includes("to-lessons"),
        `${relative} still says to-lessons (renamed to retro)`,
      );
      assert(
        !invented.test(text),
        `${relative} carries an invented numeric limit`,
      );
    }
  });
});

async function* walkFiles(directory: string): AsyncGenerator<string> {
  for await (const entry of Deno.readDir(directory)) {
    const path = join(directory, entry.name);
    if (entry.isDirectory) {
      yield* walkFiles(path);
    } else if (entry.isFile) {
      yield path;
    }
  }
}
