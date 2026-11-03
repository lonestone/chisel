// A first `init` on a repo that already has a method of its own: it names
// what it found, stages a workspace for the setup skill, and writes nothing
// in the project. A repo with nothing to arrange installs as before.

import { assert, assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import {
  installedTree,
  outsideWorkspace,
  REPO_ROOT,
  runChisel,
  snapshot,
  withRepo,
  WORKSPACE,
  type Workspace,
} from "./helpers.ts";

const SETUP_SKILL =
  `${WORKSPACE}/reference/.agents/skills/chisel-setup/SKILL.md`;

async function goldenTree(): Promise<string[]> {
  const text = await Deno.readTextFile(
    join(REPO_ROOT, "test", "fixtures", "golden-tree.txt"),
  );
  return text.split("\n").filter((line) => line !== "");
}

async function exists(path: string): Promise<boolean> {
  return await Deno.lstat(path).then(() => true).catch(() => false);
}

/** A directory holding exactly these files, built in the test. */
async function repoWith(
  workspace: Workspace,
  name: string,
  files: Record<string, string>,
): Promise<string> {
  const target = await workspace.dir(name);
  for (const [relative, content] of Object.entries(files)) {
    if (relative.endsWith("/")) {
      await Deno.mkdir(join(target, relative), { recursive: true });
      continue;
    }
    await Deno.mkdir(join(target, relative, ".."), { recursive: true });
    await Deno.writeTextFile(join(target, relative), content);
  }
  return target;
}

Deno.test("arrange: init on a repo with nothing to arrange installs and exits 0", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.dir("empty");

    const result = await runChisel(["init", target]);
    assertEquals(result.code, 0, result.output);
    assertEquals(await installedTree(target), await goldenTree());
    assert(!(await exists(join(target, WORKSPACE))), "no workspace staged");
  });
});

Deno.test("arrange: init on a repo with its own instructions stages and writes nothing", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.copy("brownfield");
    const before = await snapshot(target);

    const staged = await runChisel(["init", target]);
    assertEquals(staged.code, 3, `an agent has work to do\n${staged.output}`);
    assertEquals(
      outsideWorkspace(await snapshot(target)),
      before,
      "nothing outside the workspace moved",
    );
    assert(
      !(await exists(join(target, ".agents", ".chisel.json"))),
      "no manifest written",
    );
    assertStringIncludes(staged.stdout, "AGENTS.md");
    assertStringIncludes(staged.stdout, "CLAUDE.md");
    assertStringIncludes(staged.stdout, SETUP_SKILL, "it names the skill");
    assert(await exists(join(target, SETUP_SKILL)), "the skill is staged");

    const session = await Deno.readTextFile(
      join(target, WORKSPACE, "session.md"),
    );
    assertStringIncludes(session, "AGENTS.md");
    assertStringIncludes(session, "CLAUDE.md");
    assertEquals(
      await Deno.readTextFile(join(target, WORKSPACE, ".gitignore")),
      "*\n",
      "the workspace ignores itself",
    );
  });
});

/** Each signal, the files that make it, and the path init must name. */
const SIGNALS: ReadonlyArray<
  { kind: string; files: Record<string, string>; names: string }
> = [
  {
    kind: "OpenSpec",
    files: { "openspec/specs/auth/spec.md": "# Auth\n" },
    names: "openspec/",
  },
  {
    kind: "Spec Kit",
    files: { ".specify/memory/constitution.md": "# Constitution\n" },
    names: ".specify/",
  },
  {
    kind: "Spec Kit",
    files: {
      "specs/001-login/spec.md": "# Login\n",
      "specs/001-login/plan.md": "# Plan\n",
    },
    names: "specs/001-login/",
  },
  {
    kind: "task folder",
    files: { "project-management/tasks/a-task.md": "# A task\n" },
    names: "project-management/",
  },
  {
    kind: "task folder",
    files: { "doc/project-management/CHANGELOG.md": "# Changelog\n" },
    names: "doc/project-management/",
  },
  {
    kind: "task folder",
    files: { "tasks/todo.md": "# Todo\n" },
    names: "tasks/",
  },
  {
    kind: "decision records",
    files: { "docs/adr/0001-use-deno.md": "# Use Deno\n" },
    names: "docs/adr/",
  },
  {
    kind: "decision records",
    files: { "decisions/": "" },
    names: "decisions/",
  },
  {
    kind: "glossary",
    files: { "CONTEXT.md": "# Context\n" },
    names: "CONTEXT.md",
  },
  {
    kind: "other agent's rules",
    files: { ".cursor/rules/style.mdc": "Use tabs.\n" },
    names: ".cursor/rules/",
  },
  {
    kind: "other agent's rules",
    files: { ".windsurf/rules.md": "Use tabs.\n" },
    names: ".windsurf/",
  },
  {
    kind: "other agent's rules",
    files: { ".github/copilot-instructions.md": "Use tabs.\n" },
    names: ".github/copilot-instructions.md",
  },
  {
    kind: "instructions file",
    files: { "AGENTS.md": "# Repo\n\nRun `make test` first.\n" },
    names: "AGENTS.md",
  },
  {
    kind: "instructions file",
    files: { "CLAUDE.md": "Use pnpm.\n" },
    names: "CLAUDE.md",
  },
  {
    kind: "beads",
    files: { ".beads/issues.jsonl": "" },
    names: ".beads/",
  },
  {
    kind: "first chisel version",
    files: { ".agents/workflows.md": "# Workflows\n" },
    names: ".agents/workflows.md",
  },
];

Deno.test("arrange: init names each kind of method it finds", async () => {
  await withRepo(async (workspace) => {
    for (const signal of SIGNALS) {
      const target = await repoWith(workspace, "signal", signal.files);
      const before = await snapshot(target);

      const staged = await runChisel(["init", target]);
      const label = `${signal.kind} at ${signal.names}`;
      assertEquals(staged.code, 3, `${label} stages\n${staged.output}`);
      assertStringIncludes(staged.stdout, signal.kind, label);
      assertStringIncludes(staged.stdout, signal.names, label);
      assertEquals(
        outsideWorkspace(await snapshot(target)),
        before,
        `${label}: nothing outside the workspace moved`,
      );
    }
  });
});

Deno.test("arrange: what is not a method of its own installs", async () => {
  await withRepo(async (workspace) => {
    const cases: ReadonlyArray<Record<string, string>> = [
      { "tasks/": "" },
      { "CLAUDE.md": "@AGENTS.md\n" },
      { "AGENTS.md": "# My repo\n" },
      { "specs/001-login/spec.md": "# Login\n" },
      { "README.md": "# A readme\n", "docs/guide.md": "# Guide\n" },
    ];
    for (const files of cases) {
      const target = await repoWith(workspace, "quiet", files);
      const result = await runChisel(["init", target]);
      assertEquals(
        result.code,
        0,
        `${Object.keys(files).join(", ")} installs\n${result.output}`,
      );
    }
  });
});

Deno.test("arrange: init on a repo chisel installed does not look again", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const again = await runChisel(["init", target]);
    assertEquals(again.code, 0, again.output);
    assert(!(await exists(join(target, WORKSPACE))), "no workspace staged");
  });
});

Deno.test("arrange: init refuses while a workspace is staged", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.copy("brownfield");
    assertEquals((await runChisel(["init", target])).code, 3);
    const staged = await snapshot(target);

    for (const args of [["init", target], ["init", "--arranged", target]]) {
      const refused = await runChisel(args);
      assertEquals(refused.code, 1, `${args.join(" ")}\n${refused.output}`);
      assertStringIncludes(refused.stderr, WORKSPACE);
      assertEquals(await snapshot(target), staged, "nothing moved");
    }
  });
});

Deno.test("arrange: init stages a linked path, and --arranged still refuses it", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.dir("linked");
    const elsewhere = await workspace.dir("elsewhere");
    await Deno.writeTextFile(join(elsewhere, "claude.md"), "@AGENTS.md\n");
    await Deno.symlink(join(elsewhere, "claude.md"), join(target, "CLAUDE.md"));
    const before = await snapshot(target);

    const staged = await runChisel(["init", target]);
    assertEquals(staged.code, 3, staged.output);
    assertStringIncludes(staged.stdout, "linked path");
    assertStringIncludes(staged.stdout, "CLAUDE.md");
    assertEquals(outsideWorkspace(await snapshot(target)), before);
    await Deno.remove(join(target, WORKSPACE), { recursive: true });

    const refused = await runChisel(["init", "--arranged", target]);
    assertEquals(refused.code, 1, refused.output);
    assertEquals(await snapshot(target), before, "nothing written");
  });
});
