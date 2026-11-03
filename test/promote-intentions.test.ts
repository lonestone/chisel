// The maintainer's promotion at a release, run on a throwaway repo of test
// intentions, never chisel's own (they move at every release): what moves,
// how it is numbered, and what it refuses.

import { assert, assertEquals, assertRejects } from "@std/assert";
import { join } from "@std/path";
import {
  promoteIntentions,
  PromotionRefused,
} from "../scripts/promote-intentions.ts";
import { gitIn, intentionsRepo, snapshot, withRepo } from "./helpers.ts";

async function unreleasedSlugs(root: string): Promise<string[]> {
  const slugs: string[] = [];
  try {
    for await (
      const entry of Deno.readDir(join(root, "socle/intentions/unreleased"))
    ) {
      slugs.push(entry.name.slice(0, -".md".length));
    }
  } catch (error) {
    if (!(error instanceof Deno.errors.NotFound)) throw error;
  }
  return slugs.sort();
}

Deno.test("promote-intentions: unreleased moves to the release, numbered after what is there", async () => {
  await withRepo(async (workspace) => {
    const root = await intentionsRepo(await workspace.dir("repo"), "0.2.4");
    const slugs = await unreleasedSlugs(root);
    assertEquals(slugs, ["a-move", "b-notice"]);

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
    const root = await intentionsRepo(await workspace.dir("repo"), "0.2.4");
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
    const root = await intentionsRepo(await workspace.dir("repo"), "0.3.0");
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
