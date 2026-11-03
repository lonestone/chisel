// `deno task promote-intentions <version>`: at a release, moves every
// intention written since the last one from `socle/intentions/unreleased/` to
// the release's folder, numbered after the files already there, rewrites its
// id, and keeps `src/socle-files.ts` in step. A maintainer's script, run on
// chisel's own repo: it is not part of the CLI, because a repo equipped with
// chisel never promotes anything.

import { join } from "@std/path";

const INTENTIONS = "socle/intentions";
const UNRELEASED = "unreleased";
const SOCLE_FILES = "src/socle-files.ts";
const NUMBERED = /^(\d+)-/;
const VERSION = /^\d+\.\d+\.\d+$/;

/** One intention moved: its paths relative to the repo root. */
export interface Promotion {
  readonly from: string;
  readonly to: string;
}

/** Thrown before anything moved: the reason is the whole message. */
export class PromotionRefused extends Error {}

async function git(root: string, args: string[]): Promise<void> {
  const result = await new Deno.Command("git", {
    args,
    cwd: root,
    stdout: "null",
    stderr: "piped",
  }).output();
  if (!result.success) {
    throw new Error(
      `git ${args.join(" ")} failed: ${
        new TextDecoder().decode(result.stderr)
      }`,
    );
  }
}

async function markdownIn(directory: string): Promise<string[]> {
  const names: string[] = [];
  try {
    for await (const entry of Deno.readDir(directory)) {
      if (entry.isFile && entry.name.endsWith(".md")) names.push(entry.name);
    }
  } catch (error) {
    if (!(error instanceof Deno.errors.NotFound)) throw error;
  }
  return names.sort();
}

/**
 * Promotes `unreleased/` to `<version>/` in the repo at `root`. Refuses, with
 * nothing moved, when the version is not the one `deno.json` declares — the
 * folder names the release the files ship in — or when `unreleased/` is
 * empty.
 */
export async function promoteIntentions(
  root: string,
  version: string,
): Promise<Promotion[]> {
  if (!VERSION.test(version)) {
    throw new PromotionRefused(
      `"${version}" is not a release version (X.Y.Z)`,
    );
  }
  const declared = JSON.parse(
    await Deno.readTextFile(join(root, "deno.json")),
  ).version;
  if (declared !== version) {
    throw new PromotionRefused(
      `deno.json declares ${declared}, not ${version}: bump it first, ` +
        `so the folder names the release these files ship in`,
    );
  }
  const unreleased = await markdownIn(join(root, INTENTIONS, UNRELEASED));
  if (unreleased.length === 0) {
    throw new PromotionRefused(
      `${INTENTIONS}/${UNRELEASED}/ is empty: nothing to promote`,
    );
  }

  const target = join(root, INTENTIONS, version);
  let last = 0;
  for (const name of await markdownIn(target)) {
    const number = NUMBERED.exec(name);
    if (number) last = Math.max(last, Number.parseInt(number[1], 10));
  }
  await Deno.mkdir(target, { recursive: true });

  const promotions: Promotion[] = [];
  for (const name of unreleased) {
    const slug = name.slice(0, -".md".length);
    const number = `${++last}`.padStart(2, "0");
    const from = `${INTENTIONS}/${UNRELEASED}/${name}`;
    const to = `${INTENTIONS}/${version}/${number}-${name}`;
    await git(root, ["mv", from, to]);
    const text = await Deno.readTextFile(join(root, to));
    await Deno.writeTextFile(
      join(root, to),
      text.replace(
        new RegExp(`^id: ${UNRELEASED}/${slug}$`, "m"),
        `id: ${version}/${slug}`,
      ),
    );
    promotions.push({ from, to });
  }
  await rewriteSocleFiles(root, promotions);
  return promotions;
}

/** Renames the promoted entries of the shipped list and keeps it sorted. */
async function rewriteSocleFiles(
  root: string,
  promotions: readonly Promotion[],
): Promise<void> {
  const path = join(root, SOCLE_FILES);
  const text = await Deno.readTextFile(path);
  const entry = /^ {2}"([^"]+)",$/;
  const lines = text.split("\n");
  const first = lines.findIndex((line) => entry.test(line));
  let end = first;
  while (end < lines.length && entry.test(lines[end])) end++;
  const renamed = new Map(
    promotions.map(({ from, to }) => [
      from.slice("socle/".length),
      to.slice("socle/".length),
    ]),
  );
  const files = lines.slice(first, end).map((line) => {
    const file = entry.exec(line)![1];
    return renamed.get(file) ?? file;
  }).sort();
  lines.splice(first, end - first, ...files.map((file) => `  "${file}",`));
  await Deno.writeTextFile(path, lines.join("\n"));
}

if (import.meta.main) {
  const [version] = Deno.args;
  if (!version) {
    console.error("usage: deno task promote-intentions <version>");
    Deno.exit(2);
  }
  try {
    for (const { from, to } of await promoteIntentions(Deno.cwd(), version)) {
      console.log(`promoted: ${from} -> ${to}`);
    }
  } catch (error) {
    if (!(error instanceof PromotionRefused)) throw error;
    console.error(`promote-intentions: ${error.message}. Nothing moved.`);
    Deno.exit(1);
  }
}
