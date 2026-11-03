// The conventional-commit checks of chisel's own repo: one message (the
// commit-msg hook), every commit of a pull request, and a pull request's
// title and description, which become the squash commit on main.

import { assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import {
  installHook,
  lintMessage,
  lintPullRequest,
  lintRange,
} from "../scripts/commit-lint.ts";
import { commitAll, gitIn, withRepo } from "./helpers.ts";

const BODY = "Why it changes, in prose.";

Deno.test("commit-lint message: a conventional header with a known scope passes", () => {
  assertEquals(lintMessage("feat(release): add the gate\n\nWhy.\n"), []);
  assertEquals(lintMessage("fix(cli)!: refuse a link\n"), []);
});

Deno.test("commit-lint message: a plain sentence fails, naming the form", () => {
  const problems = lintMessage("Spec and plan: chisel releases\n");
  assertEquals(problems.length > 0, true);
  assertStringIncludes(problems.join("\n"), "type(scope): description");
});

Deno.test("commit-lint message: an unknown type, a missing or unknown scope fail", () => {
  assertStringIncludes(lintMessage("feature(cli): x\n").join(), "type");
  assertStringIncludes(lintMessage("feat: add x\n").join(), "scope");
  assertStringIncludes(lintMessage("feat(api): add x\n").join(), "api");
});

Deno.test("commit-lint message: a capitalised or dotted description, a long header, a body without a blank line fail", () => {
  assertEquals(lintMessage("feat(cli): Add x\n").length, 1);
  assertEquals(lintMessage("feat(cli): add x.\n").length, 1);
  assertEquals(lintMessage(`feat(cli): ${"a".repeat(100)}\n`).length, 1);
  assertEquals(lintMessage("feat(cli): add x\nno blank line\n").length, 1);
});

Deno.test("commit-lint message: git's comments and merge commits are not linted", () => {
  assertEquals(
    lintMessage("feat(cli): add x\n\n# Please enter the commit message\n"),
    [],
  );
  assertEquals(lintMessage("Merge branch 'main' into v2\n"), []);
  assertEquals(lintMessage("fixup! feat(cli): add x\n"), []);
});

Deno.test("commit-lint pr: a conventional title and a prose body pass", () => {
  assertEquals(
    lintPullRequest({ title: "feat(release): x", body: BODY, draft: false }),
    [],
  );
});

Deno.test("commit-lint pr: a non-draft PR needs a description, a draft does not", () => {
  const title = "feat(release): x";
  assertEquals(lintPullRequest({ title, body: null, draft: false }).length, 1);
  assertEquals(lintPullRequest({ title, body: "", draft: true }), []);
});

Deno.test("commit-lint pr: a WIP title, an image, a task list and BREAKING-CHANGE fail", () => {
  const ok = { title: "feat(release): x", body: BODY, draft: false };
  assertStringIncludes(
    lintPullRequest({ ...ok, title: "feat(release): wip gate" }).join(),
    "wip",
  );
  assertEquals(
    lintPullRequest({ ...ok, body: "See ![shot](a.png)" }).length,
    1,
  );
  assertEquals(lintPullRequest({ ...ok, body: "- [ ] test it" }).length, 1);
  assertEquals(
    lintPullRequest({ ...ok, body: "BREAKING-CHANGE: gone" }).length,
    1,
  );
  assertEquals(
    lintPullRequest({ ...ok, body: "BREAKING CHANGE: gone" }).length,
    1,
  );
});

Deno.test("commit-lint pr: a description that opens with lint or temp is not WIP", () => {
  const body = BODY;
  const draft = false;
  assertEquals(
    lintPullRequest({ title: "feat(tooling): lint markdown", body, draft }),
    [],
  );
  assertEquals(
    lintPullRequest({ title: "fix(cli): temp files leak", body, draft }),
    [],
  );
  assertEquals(
    lintPullRequest({ title: "fix(cli): typo", body, draft }).length,
    1,
  );
});

Deno.test("commit-lint pr: a conventional paragraph in the description is linted as a header", () => {
  const problems = lintPullRequest({
    title: "feat(release): x",
    body: `${BODY}\n\nfix(nope): a second entry`,
    draft: false,
  });
  assertStringIncludes(problems.join("\n"), "nope");
});

Deno.test("commit-lint range: every commit after the base is linted, the exempt history is not", async () => {
  await withRepo(async (workspace) => {
    const root = await workspace.dir("repo");
    await gitIn(root, "init", "-q", "-b", "main");
    await Deno.writeTextFile(join(root, "a"), "1");
    await commitAll(root, "Initial commit");
    await gitIn(root, "checkout", "-q", "-b", "work");
    await Deno.writeTextFile(join(root, "a"), "2");
    const exempt = await commitAll(root, "An old plain sentence");
    await Deno.writeTextFile(join(root, "a"), "3");
    await commitAll(root, "feat(cli): a good one");

    assertEquals(await lintRange(root, "main", exempt), []);

    await Deno.writeTextFile(join(root, "a"), "4");
    await commitAll(root, "A new plain sentence");
    const problems = await lintRange(root, "main", exempt);
    assertEquals(problems.length, 1, problems.join("\n"));
    assertStringIncludes(problems[0], "A new plain sentence");
  });
});

Deno.test("commit-lint range: an exempt commit the clone does not know exempts nothing", async () => {
  await withRepo(async (workspace) => {
    const root = await workspace.dir("repo");
    await gitIn(root, "init", "-q", "-b", "main");
    await Deno.writeTextFile(join(root, "a"), "1");
    await commitAll(root, "Initial commit");
    await gitIn(root, "checkout", "-q", "-b", "work");
    await Deno.writeTextFile(join(root, "a"), "2");
    await commitAll(root, "A plain sentence");

    const problems = await lintRange(root, "main", "0".repeat(40));
    assertEquals(problems.length, 1);
  });
});

Deno.test("commit-lint install-hook: writes an executable commit-msg hook, and refuses another one", async () => {
  await withRepo(async (workspace) => {
    const root = await workspace.dir("repo");
    await gitIn(root, "init", "-q", "-b", "main");

    const path = await installHook(root);
    const hook = await Deno.readTextFile(path);
    assertStringIncludes(hook, "scripts/commit-lint.ts message");
    assertEquals(((await Deno.stat(path)).mode ?? 0) & 0o111, 0o111);
    assertEquals(await installHook(root), path, "rewriting its own is fine");

    await Deno.writeTextFile(path, "#!/bin/sh\necho mine\n");
    let refused = "";
    try {
      await installHook(root);
    } catch (error) {
      refused = (error as Error).message;
    }
    assertStringIncludes(refused, "commit-msg");
    assertEquals(await Deno.readTextFile(path), "#!/bin/sh\necho mine\n");
  });
});
