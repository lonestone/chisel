// Every file the installed socle points a reader at must exist in the
// installed tree.
//
// What counts as a pointer — also written in TESTS.md: (1) any `.agents/…`
// path in the text; (2) a markdown link to a SIBLING file. Deliberately NOT
// pointers: deep relative links, illustrative paths inside another project's
// tree, placeholders.

import { assert, assertEquals } from "@std/assert";
import { join } from "@std/path";
import { REPO_ROOT, withRepo } from "./helpers.ts";
import { SOCLE_FILES } from "../src/socle-files.ts";

const AGENTS_PATH = /\.agents\/[A-Za-z0-9._*\/-]+/g;
const SIBLING_LINK = /\]\((?:\.\/)?([A-Za-z0-9._-]+\.(?:md|toml|sh|tpl))\)/g;
const READABLE = /\.(md|toml|tpl)$/;

/**
 * A waiver with teeth on both sides: a new dangling pointer that is not
 * listed fails the test, and a listed one that has started resolving fails it
 * too — so a fixed pointer cannot leave a line behind to hide the next hole.
 */
const WAIVED = new Map<string, string>([
  [
    ".agents/user.md",
    "BY DESIGN — personal file, deliberately never installed (the template is)",
  ],
  [
    ".agents/rules/task-*.md",
    "BY DESIGN (upgrade-v2 must name the layer it retires)",
  ],
  [
    ".agents/workflows.md",
    "BY DESIGN (upgrade-v2 must name the layer it retires)",
  ],
]);

const RETIRED_LAYER = [".agents/rules/task-*.md", ".agents/workflows.md"];

interface Dangling {
  readonly pointer: string;
  readonly source: string;
}

async function sourceFiles(target: string): Promise<string[]> {
  const sources: string[] = [];
  async function walk(relative: string): Promise<void> {
    let info: Deno.FileInfo;
    try {
      info = await Deno.lstat(join(target, relative));
    } catch {
      return;
    }
    if (info.isSymlink) return;
    if (info.isFile) {
      if (READABLE.test(relative)) sources.push(relative);
      return;
    }
    if (!info.isDirectory) return;
    for await (const entry of Deno.readDir(join(target, relative))) {
      await walk(`${relative}/${entry.name}`);
    }
  }
  for (
    const root of ["AGENTS.md", ".agents", ".claude/agents", ".codex/agents"]
  ) {
    await walk(root);
  }
  return sources.sort();
}

function pointersOf(source: string, text: string): string[] {
  const directory = source.includes("/")
    ? source.slice(0, source.lastIndexOf("/"))
    : "";
  const raw: string[] = [];
  for (const match of text.matchAll(AGENTS_PATH)) raw.push(match[0]);
  for (const match of text.matchAll(SIBLING_LINK)) {
    raw.push(directory === "" ? match[1] : `${directory}/${match[1]}`);
  }
  const trimmed = raw.map((pointer) =>
    pointer.replace(/[.,;:)`]*$/, "").replace(/\/$/, "")
  );
  return [...new Set(trimmed)].sort();
}

async function danglingPointers(target: string): Promise<Dangling[]> {
  const dangling: Dangling[] = [];
  for (const source of await sourceFiles(target)) {
    const text = await Deno.readTextFile(join(target, source));
    for (const pointer of pointersOf(source, text)) {
      const resolves = await Deno.lstat(join(target, pointer)).then(() => true)
        .catch(() => false);
      if (!resolves) dangling.push({ pointer, source });
    }
  }
  return dangling;
}

Deno.test("integrity: every pointer of the installed socle resolves", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const dangling = await danglingPointers(target);
    const found = new Set(dangling.map((entry) => entry.pointer));

    const unwaived = dangling.filter((entry) => !WAIVED.has(entry.pointer));
    assertEquals(
      unwaived.map((entry) => `${entry.pointer} (in ${entry.source})`),
      [],
      "no pointer sends a reader to a file that is not there",
    );

    const staleWaivers = [...WAIVED.keys()].filter((pointer) =>
      !found.has(pointer)
    );
    assertEquals(
      staleWaivers,
      [],
      "the waiver has no stale line: a fixed pointer must leave it",
    );

    // ...and WHO is allowed to name the retired layer today.
    const citers = dangling
      .filter((entry) => RETIRED_LAYER.includes(entry.pointer))
      .map((entry) => entry.source);
    assertEquals(
      [...new Set(citers)].sort(),
      [".agents/skills/upgrade-v2/SKILL.md"],
      "only the migration skill names the layer it retires",
    );

    // Mutation test: plant one broken pointer of each shape, demand both are
    // caught — a checker nobody checks is a decoration.
    const mutant = await workspace.install("brownfield");
    await Deno.writeTextFile(
      join(mutant, ".agents", "discipline.md"),
      "\nSee `.agents/nope/missing-page.md` for the rest.\nAnd [the other half](./missing-sibling.md) of it.\n",
      { append: true },
    );
    const planted = (await danglingPointers(mutant)).map((entry) =>
      entry.pointer
    );
    assert(
      planted.includes(".agents/nope/missing-page.md"),
      "a planted .agents/ pointer is caught",
    );
    assert(
      planted.includes(".agents/missing-sibling.md"),
      "a planted sibling link is caught too",
    );
  });
});

Deno.test("integrity: the shipped socle list matches the socle tree", async () => {
  const socleRoot = join(REPO_ROOT, "socle");
  const walked: string[] = [];
  async function walk(directory: string): Promise<void> {
    for await (const entry of Deno.readDir(directory)) {
      const path = join(directory, entry.name);
      if (entry.isDirectory) {
        await walk(path);
      } else if (entry.isFile && entry.name !== ".DS_Store") {
        walked.push(path.slice(socleRoot.length + 1));
      }
    }
  }
  await walk(socleRoot);
  assertEquals(
    [...SOCLE_FILES].sort(),
    walked.sort(),
    "the list the package ships names exactly the files that are there",
  );
});
