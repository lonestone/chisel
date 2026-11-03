// The maintainer's promotion at a release, run on a temporary copy of
// chisel's own intentions and shipped list: what moves, how it is numbered,
// and what it refuses.

import { assert, assertEquals, assertRejects } from "@std/assert";
import { join } from "@std/path";
import {
  promoteIntentions,
  PromotionRefused,
} from "../scripts/promote-intentions.ts";
import { copyTree, snapshot, withRepo } from "./helpers.ts";

const REPO = new URL("..", import.meta.url).pathname;

async function gitIn(root: string, ...args: string[]): Promise<string> {
  const result = await new Deno.Command("git", { args, cwd: root }).output();
  assert(result.success, new TextDecoder().decode(result.stderr));
  return new TextDecoder().decode(result.stdout);
}

/** A git repo holding a copy of the intentions, the shipped list and a deno.json. */
async function copyOfRepo(root: string, version: string): Promise<string> {
  await copyTree(
    join(REPO, "socle", "intentions"),
    join(root, "socle", "intentions"),
  );
  await Deno.mkdir(join(root, "src"));
  await Deno.copyFile(
    join(REPO, "src", "socle-files.ts"),
    join(root, "src", "socle-files.ts"),
  );
  await Deno.writeTextFile(
    join(root, "deno.json"),
    JSON.stringify({ version }),
  );
  await gitIn(root, "init", "-q");
  await gitIn(root, "add", ".");
  await gitIn(
    root,
    "-c",
    "user.name=test",
    "-c",
    "user.email=test@example.invalid",
    "commit",
    "-qm",
    "copy",
  );
  return root;
}

async function unreleasedSlugs(root: string): Promise<string[]> {
  const slugs: string[] = [];
  for await (
    const entry of Deno.readDir(join(root, "socle/intentions/unreleased"))
  ) {
    slugs.push(entry.name.slice(0, -".md".length));
  }
  return slugs.sort();
}

Deno.test("promote-intentions: unreleased moves to the release, numbered after what is there", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.2.4");
    const slugs = await unreleasedSlugs(root);
    assert(slugs.length > 0, "the copy has something to promote");

    const promotions = await promoteIntentions(root, "0.2.4");

    // 0.2.4 already holds 01 and 02: the promoted ones follow.
    assertEquals(
      promotions.map((promotion) => promotion.to),
      slugs.map((slug, index) =>
        `socle/intentions/0.2.4/${`${index + 3}`.padStart(2, "0")}-${slug}.md`
      ),
    );
    assertEquals(await unreleasedSlugs(root), [], "unreleased/ is empty");
    for (const [index, slug] of slugs.entries()) {
      const text = await Deno.readTextFile(join(root, promotions[index].to));
      assert(text.includes(`\nid: 0.2.4/${slug}\n`), "the id is rewritten");
      assert(!text.includes("id: unreleased/"), "no unreleased id is left");
    }

    const status = await gitIn(root, "status", "--porcelain");
    for (const { from, to } of promotions) {
      assert(
        new RegExp(`^RM? ${from} -> ${to}$`, "m").test(status),
        `git sees ${from} moved`,
      );
    }

    const list = await Deno.readTextFile(join(root, "src/socle-files.ts"));
    const files = [...list.matchAll(/^ {2}"([^"]+)",$/gm)].map((m) => m[1]);
    assertEquals(files, [...files].sort(), "the shipped list stays sorted");
    for (const { from, to } of promotions) {
      assert(files.includes(to.slice("socle/".length)), `${to} ships`);
      assert(!files.includes(from.slice("socle/".length)), `${from} is gone`);
    }
  });
});

Deno.test("promote-intentions: a version deno.json does not declare moves nothing", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.2.4");
    const before = await snapshot(root);
    await assertRejects(
      () => promoteIntentions(root, "0.3.0"),
      PromotionRefused,
      "deno.json declares 0.2.4",
    );
    assertEquals(await snapshot(root), before, "nothing moved");
  });
});

Deno.test("promote-intentions: an empty unreleased folder moves nothing", async () => {
  await withRepo(async (workspace) => {
    const root = await copyOfRepo(await workspace.dir("repo"), "0.3.0");
    for (const slug of await unreleasedSlugs(root)) {
      await Deno.remove(
        join(root, "socle/intentions/unreleased", `${slug}.md`),
      );
    }
    const before = await snapshot(root);
    await assertRejects(
      () => promoteIntentions(root, "0.3.0"),
      PromotionRefused,
      "is empty",
    );
    assertEquals(await snapshot(root), before, "nothing moved");
  });
});
