// The maintainer's release checks, run on a temporary git repo holding a copy
// of chisel's intentions: the intention gate of a pull request, the promotion
// a Release PR must carry, the guard before publishing, and the release
// note's list of intentions.

import { assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import { gate, notes, promoted, publish } from "../scripts/release-check.ts";
import { promoteIntentions } from "../scripts/promote-intentions.ts";
import {
  commitAll,
  copyOfRepo,
  gitIn,
  withRepo,
  type Workspace,
} from "./helpers.ts";

const UNRELEASED = "socle/intentions/unreleased";

async function unreleasedFiles(root: string): Promise<string[]> {
  const names: string[] = [];
  for await (const entry of Deno.readDir(join(root, UNRELEASED))) {
    names.push(entry.name);
  }
  return names.sort();
}

async function emptyUnreleased(root: string): Promise<void> {
  for (const name of await unreleasedFiles(root)) {
    await Deno.remove(join(root, UNRELEASED, name));
  }
}

/** An intention under `unreleased/`, so no case leans on the repo's own. */
async function writeUnreleased(root: string, slug: string): Promise<void> {
  await Deno.writeTextFile(
    join(root, UNRELEASED, `${slug}.md`),
    `---\nid: unreleased/${slug}\nclassification: informational\n---\n\n# ${slug}\n`,
  );
}

async function setVersion(root: string, version: string): Promise<void> {
  await Deno.writeTextFile(
    join(root, "deno.json"),
    JSON.stringify({ version }),
  );
}

/** A repo on `main`, then a branch `work` for the change under test. */
async function repoWithBranch(
  workspace: Workspace,
  version = "0.2.4",
): Promise<string> {
  const root = await copyOfRepo(await workspace.dir("repo"), version);
  await Deno.mkdir(join(root, "socle", "agents"), { recursive: true });
  await Deno.writeTextFile(join(root, "socle/agents/workflow.md"), "# W\n");
  await writeUnreleased(root, "fixture-change");
  await commitAll(root, "chore(socle): a page");
  await gitIn(root, "checkout", "-q", "-b", "work");
  return root;
}

Deno.test("release-check gate: a socle change without an intention fails, naming both ways out", async () => {
  await withRepo(async (workspace) => {
    const root = await repoWithBranch(workspace);
    await Deno.writeTextFile(join(root, "socle/agents/workflow.md"), "# W2\n");
    await commitAll(root, "feat(socle): change the workflow");

    const result = await gate(root, "main");

    assertEquals(result.ok, false);
    assertStringIncludes(result.message, "socle/agents/workflow.md");
    assertStringIncludes(result.message, UNRELEASED);
    assertStringIncludes(result.message, "no-intention");
  });
});

Deno.test("release-check gate: a socle change that adds an unreleased intention passes", async () => {
  await withRepo(async (workspace) => {
    const root = await repoWithBranch(workspace);
    await Deno.writeTextFile(join(root, "socle/agents/workflow.md"), "# W2\n");
    await writeUnreleased(root, "workflow-changes");
    await commitAll(root, "feat(socle): change the workflow");

    assertEquals((await gate(root, "main")).ok, true);
  });
});

Deno.test("release-check gate: a change outside socle needs no intention", async () => {
  await withRepo(async (workspace) => {
    const root = await repoWithBranch(workspace);
    await Deno.writeTextFile(join(root, "src/new.ts"), "export {};\n");
    await Deno.writeTextFile(
      join(
        root,
        "socle/intentions/0.2.4/01-update-writes-only-what-it-installed.md",
      ),
      "edited\n",
    );
    await commitAll(root, "fix(cli): a fix");

    assertEquals((await gate(root, "main")).ok, true);
  });
});

Deno.test("release-check promoted: a Release PR with unreleased intentions left fails with the command", async () => {
  await withRepo(async (workspace) => {
    const root = await repoWithBranch(workspace);
    await setVersion(root, "0.3.0");
    await commitAll(root, "chore(release): release 0.3.0");

    const result = await promoted(root, "main");

    assertEquals(result.ok, false);
    assertStringIncludes(result.message, "deno task promote-intentions 0.3.0");
  });
});

Deno.test("release-check promoted: intentions moved by promote-intentions pass", async () => {
  await withRepo(async (workspace) => {
    const root = await repoWithBranch(workspace);
    await setVersion(root, "0.3.0");
    await commitAll(root, "chore(release): release 0.3.0");
    await promoteIntentions(root, "0.3.0");
    await commitAll(root, "chore(release): promote the intentions");

    const result = await promoted(root, "main");

    assertEquals(result.ok, true, result.message);
  });
});

Deno.test("release-check promoted: intentions deleted instead of promoted fail, naming each", async () => {
  await withRepo(async (workspace) => {
    const root = await repoWithBranch(workspace);
    const slugs = (await unreleasedFiles(root)).map((name) =>
      name.slice(0, -".md".length)
    );
    await setVersion(root, "0.3.0");
    await emptyUnreleased(root);
    await commitAll(root, "chore(release): release 0.3.0");

    const result = await promoted(root, "main");

    assertEquals(result.ok, false);
    for (const slug of slugs) {
      assertStringIncludes(result.message, `0.3.0/NN-${slug}.md`);
    }
  });
});

Deno.test("release-check publish: the tag of deno.json's version, nothing unreleased, passes", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.3.0");
    await emptyUnreleased(root);

    assertEquals((await publish(root, "v0.3.0")).ok, true);
  });
});

Deno.test("release-check publish: a tag deno.json does not declare fails", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.3.0");
    await emptyUnreleased(root);

    const result = await publish(root, "v0.3.1");

    assertEquals(result.ok, false);
    assertStringIncludes(result.message, "0.3.0");
  });
});

Deno.test("release-check publish: an intention left in unreleased fails, naming it", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.3.0");
    await emptyUnreleased(root);
    await writeUnreleased(root, "left-behind");
    const left = "left-behind.md";

    const result = await publish(root, "v0.3.0");

    assertEquals(result.ok, false);
    assertStringIncludes(result.message, left);
  });
});

Deno.test("release-check notes: lists each intention of the version with its classification and title", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.2.4");

    const result = await notes(root, "0.2.4");

    assertEquals(result.ok, true);
    const items = result.message.split("\n").filter((line) =>
      line.startsWith("- ")
    );
    assertEquals(items.length, 2, result.message);
    assertStringIncludes(
      items[0],
      "`0.2.4/update-writes-only-what-it-installed`",
    );
    assertStringIncludes(items[0], "informational");
  });
});

Deno.test("release-check notes: a version with no intention says so", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.2.2");

    const result = await notes(root, "0.2.2");

    assertEquals(result.ok, true);
    assertEquals(result.message.includes("\n- "), false);
    assertStringIncludes(result.message, "no intention");
  });
});
