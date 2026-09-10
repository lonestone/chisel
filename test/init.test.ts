// `init` and its neighbours: the full layout, a repo that predates chisel,
// a repo with nothing at all, running it twice, and the journal.

import {
  assert,
  assertEquals,
  assertNotEquals,
  assertStringIncludes,
} from "@std/assert";
import { join } from "@std/path";
import {
  installedTree,
  REPO_ROOT,
  runChisel,
  snapshot,
  withRepo,
} from "./helpers.ts";

const BLOCK_BEGIN = "<!-- chisel:begin -->";
const BLOCK_END = "<!-- chisel:end -->";

async function goldenTree(): Promise<string[]> {
  const text = await Deno.readTextFile(
    join(REPO_ROOT, "test", "fixtures", "golden-tree.txt"),
  );
  return text.split("\n").filter((line) => line !== "");
}

function managedBlockOf(agentsMd: string): string {
  const lines = agentsMd.split("\n");
  const begin = lines.indexOf(BLOCK_BEGIN);
  const end = lines.indexOf(BLOCK_END);
  return lines.slice(begin + 1, end).map((line) => `${line}\n`).join("");
}

function today(): string {
  const now = new Date();
  return [
    now.getFullYear(),
    `${now.getMonth() + 1}`.padStart(2, "0"),
    `${now.getDate()}`.padStart(2, "0"),
  ].join("-");
}

Deno.test("init: full layout and content preservation", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.copy("brownfield");

    const result = await runChisel(["init", target]);
    assertEquals(result.code, 0, `init exits 0\n${result.output}`);

    const tree = await installedTree(target);
    assert(
      tree.length > 40,
      `the compared tree is a real install, not an empty listing: ${tree.length}`,
    );
    assertEquals(
      tree,
      await goldenTree(),
      "the installed tree matches the golden layout",
    );

    assertEquals(
      await Deno.readLink(join(target, ".claude", "skills")),
      "../.agents/skills",
    );
    assert(
      (await Deno.stat(join(target, ".claude", "skills"))).isDirectory,
      "the link resolves",
    );
    const mode =
      (await Deno.stat(join(target, "scripts", "task-id.sh"))).mode ?? 0;
    assert((mode & 0o111) !== 0, "scripts/task-id.sh is executable");

    const claudeMd = await Deno.readTextFile(join(target, "CLAUDE.md"));
    const agentsMd = await Deno.readTextFile(join(target, "AGENTS.md"));
    assert(
      claudeMd.split("\n").includes("@AGENTS.md"),
      "CLAUDE.md imports AGENTS.md",
    );
    assertStringIncludes(agentsMd, BLOCK_BEGIN);
    assertStringIncludes(agentsMd, BLOCK_END);

    assertStringIncludes(agentsMd, "# Acme Bookkeeper — agent instructions");
    assertStringIncludes(
      agentsMd,
      "Do not touch `legacy/` without asking Jane first.",
    );
    assertStringIncludes(claudeMd, "this project uses Ruby 3.2 and Sidekiq");
    assertStringIncludes(
      await Deno.readTextFile(join(target, "README.md")),
      "Internal payroll tool.",
    );

    assertEquals(
      managedBlockOf(agentsMd),
      await Deno.readTextFile(
        join(REPO_ROOT, "socle", "templates", "AGENTS-block.md"),
      ),
      "the rendered block matches the block template",
    );
    assertStringIncludes(agentsMd, ".agents/discipline.md");
    assertStringIncludes(
      agentsMd,
      ".agents/formulas/chisel-default.formula.toml",
    );
    assert(
      !agentsMd.includes(".agents/rules/"),
      "the block no longer routes to the retired rules",
    );
  });
});

Deno.test("init: a CLAUDE.md whose last line has no newline keeps the import on its own line", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.copy("brownfield");
    const claudeMd = join(target, "CLAUDE.md");
    const lastLine = "the last line of this file has no trailing newline";
    await Deno.writeTextFile(claudeMd, `# Notes\n\n${lastLine}`);

    const result = await runChisel(["init", target]);
    assertEquals(result.code, 0, result.output);

    const lines = (await Deno.readTextFile(claudeMd)).split("\n");
    assert(lines.includes(lastLine), "the original last line survives whole");
    assert(lines.includes("@AGENTS.md"), "the import is a line of its own");
  });
});

Deno.test("idempotence: init twice changes nothing", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.copy("brownfield");
    assertEquals(
      (await runChisel(["init", target])).code,
      0,
      "first init exits 0",
    );
    const afterFirst = await snapshot(target);

    assertEquals(
      (await runChisel(["init", target])).code,
      0,
      "second init exits 0",
    );
    assertEquals(
      await snapshot(target),
      afterFirst,
      "init twice leaves the repo untouched",
    );

    const agentsMd = await Deno.readTextFile(join(target, "AGENTS.md"));
    assertEquals(
      agentsMd.split("\n").filter((line) => line === BLOCK_BEGIN).length,
      1,
      "a single managed block after two inits",
    );

    // A §E line a human deliberately unticked must not come back ticked.
    const gluePath = join(target, ".agents", "project.md");
    const unticked = (await Deno.readTextFile(gluePath)).replace(
      "- [x] `.claude/skills`",
      "- [ ] `.claude/skills`",
    );
    await Deno.writeTextFile(gluePath, unticked);

    assertEquals(
      (await runChisel(["init", target])).code,
      0,
      "third init exits 0",
    );
    assertStringIncludes(
      await Deno.readTextFile(gluePath),
      "- [ ] `.claude/skills`",
      "the hand-unticked line survives re-init",
    );
  });
});

Deno.test("boilerplate: the same installed tree whatever the repo was", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.copy("boilerplate");

    const result = await runChisel(["init", target]);
    assertEquals(result.code, 0, result.output);

    const tree = await installedTree(target);
    assert(
      tree.length > 40,
      `the compared tree is a real install: ${tree.length}`,
    );
    assertEquals(
      tree,
      await goldenTree(),
      "the same golden tree as a brownfield repo",
    );
    assertStringIncludes(
      await Deno.readTextFile(join(target, "AGENTS.md")),
      "agent instructions",
      "AGENTS.md created with the project title",
    );
    assert(
      await Deno.stat(join(target, "apps", "documentation", "README.md")).then(
        () => true,
      ),
      "apps/documentation untouched",
    );
    assertStringIncludes(
      await Deno.readTextFile(join(target, "package.json")),
      '"lint"',
    );
  });
});

Deno.test("journal: written once, and never beside a journal the repo already has", async () => {
  await withRepo(async (workspace) => {
    // (a) A repo with no journal gets one, dated today, with one entry.
    const fresh = await workspace.copy("brownfield");
    assertEquals((await runChisel(["init", fresh])).code, 0);
    const journal = await Deno.readTextFile(
      join(fresh, "project-management", "LOG.md"),
    );
    assertStringIncludes(journal, `## ${today()}`);
    assertEquals(
      journal.split("\n").filter((line) => line.startsWith("- ")).length,
      1,
      "one entry, not a generated list",
    );

    // (b) A repo that already has its own journal keeps it, is warned, and
    // gets its brand-new glue pointed at the file that exists.
    const legacy = await workspace.dir("repo-with-changelog");
    await Deno.mkdir(join(legacy, "project-management"));
    await Deno.writeTextFile(
      join(legacy, "project-management", "CHANGELOG.md"),
      "# Changelog\n\n## 2026-01-01\n\n- the journal this repo already had\n",
    );
    const warned = await runChisel(["init", legacy]);
    assertEquals(warned.code, 0, warned.output);
    assertStringIncludes(warned.stderr, "project-management/CHANGELOG.md");
    assertStringIncludes(warned.stderr, "upgrade-v2");
    assertEquals(
      await Deno.stat(join(legacy, "project-management", "LOG.md")).then(() =>
        true
      ).catch(() => false),
      false,
      "no second journal was created",
    );
    assertStringIncludes(
      await Deno.readTextFile(join(legacy, ".agents", "project.md")),
      "- **Changelog:** `/project-management/CHANGELOG.md`",
      "§A points at the journal the repo has",
    );

    // (c) A journal that exists is never rewritten.
    const handWritten = `${await Deno.readTextFile(
      join(fresh, "project-management", "LOG.md"),
    )}\n## 2099-01-01\n\n- written by hand, must survive\n`;
    await Deno.writeTextFile(
      join(fresh, "project-management", "LOG.md"),
      handWritten,
    );
    assertEquals((await runChisel(["init", fresh])).code, 0);
    assertEquals(
      await Deno.readTextFile(join(fresh, "project-management", "LOG.md")),
      handWritten,
      "a pre-existing journal is left byte for byte",
    );
    assertNotEquals(handWritten, journal);
  });
});
