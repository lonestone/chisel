// `deno task release-check <gate|promoted|publish|notes> …`: the checks of
// chisel's own release, one decision per subcommand, so the workflows under
// `.github/workflows/` only call them.
//
// - `gate <base>`: a pull request that changes `socle/` adds an intention.
// - `promoted <base>`: the Release PR carries the promotion of every
//   intention `<base>` held under `unreleased/`.
// - `publish <tag>`: the tag is deno.json's version, and nothing is left
//   unreleased.
// - `notes <version>`: the release's intentions, for the GitHub Release.
//
// A maintainer's script, like `promote-intentions.ts`: a repo equipped with
// chisel never releases chisel.

import { join } from "@std/path";
import { parseIntention, UNRELEASED } from "../src/intentions.ts";

const SOCLE = "socle/";
const INTENTIONS = "socle/intentions";
const UNRELEASED_DIR = `${INTENTIONS}/${UNRELEASED}`;
const NUMBERED = /^\d+-/;

/** What a check found: `ok` maps to the exit code, `message` is printed. */
export interface CheckResult {
  readonly ok: boolean;
  readonly message: string;
}

async function git(root: string, args: string[]): Promise<string> {
  const result = await new Deno.Command("git", {
    args,
    cwd: root,
    stdout: "piped",
    stderr: "piped",
  }).output();
  const decoder = new TextDecoder();
  if (!result.success) {
    throw new Error(
      `git ${args.join(" ")} failed: ${decoder.decode(result.stderr)}`,
    );
  }
  return decoder.decode(result.stdout);
}

async function declaredVersion(root: string): Promise<string> {
  return JSON.parse(await Deno.readTextFile(join(root, "deno.json"))).version;
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

function isUnreleasedIntention(path: string): boolean {
  return path.startsWith(`${UNRELEASED_DIR}/`) && path.endsWith(".md") &&
    !path.slice(UNRELEASED_DIR.length + 1).includes("/");
}

/**
 * A change under `socle/`, outside `socle/intentions/`, needs an intention
 * added under `unreleased/`. A change to the CLI alone does not: it is not
 * something an equipped repo acts on.
 */
export async function gate(root: string, base: string): Promise<CheckResult> {
  const diff = await git(root, ["diff", "--name-status", `${base}...HEAD`]);
  const needing: string[] = [];
  let added = false;
  for (const line of diff.split("\n").filter(Boolean)) {
    const [status, ...paths] = line.split("\t");
    for (const path of paths) {
      if (path.startsWith(SOCLE) && !path.startsWith(`${INTENTIONS}/`)) {
        needing.push(path);
      }
    }
    const last = paths[paths.length - 1];
    if (/^[AR]/.test(status) && isUnreleasedIntention(last)) added = true;
  }
  if (needing.length === 0) {
    return { ok: true, message: "No socle change: no intention needed." };
  }
  if (added) {
    return { ok: true, message: "The socle change adds an intention." };
  }
  return {
    ok: false,
    message: [
      `This change touches the socle without adding an intention:`,
      ...[...new Set(needing)].map((path) => `  ${path}`),
      `Either add one under ${UNRELEASED_DIR}/ (CONTRIBUTING.md, ` +
      `"Intentions"), or, when a repo truly has nothing to act on, apply ` +
      `the label no-intention and say why in the description ` +
      `("No intention: <why>").`,
    ].join("\n"),
  };
}

/**
 * On the Release PR: `unreleased/` is empty, and every intention `<base>`
 * held there sits in the release's folder under its rewritten id.
 */
export async function promoted(
  root: string,
  base: string,
): Promise<CheckResult> {
  const version = await declaredVersion(root);
  const left = await markdownIn(join(root, UNRELEASED_DIR));
  const onBase = (await git(root, [
    "ls-tree",
    "--name-only",
    base,
    `${UNRELEASED_DIR}/`,
  ])).split("\n").filter(isUnreleasedIntention);
  const released = await markdownIn(join(root, INTENTIONS, version));

  const missing: string[] = [];
  for (const path of onBase) {
    const slug = path.slice(UNRELEASED_DIR.length + 1, -".md".length);
    const name = released.find((file) =>
      NUMBERED.test(file) && file.replace(NUMBERED, "") === `${slug}.md`
    );
    const text = name === undefined
      ? ""
      : await Deno.readTextFile(join(root, INTENTIONS, version, name));
    if (!new RegExp(`^id: ${version}/${slug}$`, "m").test(text)) {
      missing.push(`${INTENTIONS}/${version}/NN-${slug}.md`);
    }
  }
  if (left.length === 0 && missing.length === 0) {
    return {
      ok: true,
      message: `Every intention is promoted to ${version}.`,
    };
  }
  return {
    ok: false,
    message: [
      `The Release PR for ${version} does not carry the promotion. Run ` +
      `\`deno task promote-intentions ${version}\` on its branch, then push.`,
      ...left.map((name) => `  still unreleased: ${UNRELEASED_DIR}/${name}`),
      ...missing.map((path) => `  missing, with id ${version}/<slug>: ${path}`),
    ].join("\n"),
  };
}

/** Before `deno publish`: the tag names deno.json's version, and nothing is left unreleased. */
export async function publish(root: string, tag: string): Promise<CheckResult> {
  const version = await declaredVersion(root);
  const problems: string[] = [];
  if (tag !== `v${version}`) {
    problems.push(`the tag ${tag} is not v${version}, deno.json's version`);
  }
  for (const name of await markdownIn(join(root, UNRELEASED_DIR))) {
    problems.push(`${UNRELEASED_DIR}/${name} was never promoted`);
  }
  if (problems.length === 0) {
    return { ok: true, message: `Ready to publish ${version}.` };
  }
  return {
    ok: false,
    message: [`Refusing to publish ${tag}:`, ...problems.map((p) => `  ${p}`)]
      .join("\n"),
  };
}

/** The release's intentions, as a Markdown section for its GitHub Release. */
export async function notes(
  root: string,
  version: string,
): Promise<CheckResult> {
  const heading = "## Intentions of this release";
  const folder = `${INTENTIONS}/${version}`;
  const names = await markdownIn(join(root, folder));
  if (names.length === 0) {
    return {
      ok: true,
      message: `${heading}\n\nThis release ships no intention.`,
    };
  }
  const items: string[] = [];
  for (const name of names) {
    const slug = name.slice(0, -".md".length).replace(NUMBERED, "");
    const source = `${folder}/${name}`;
    const intention = parseIntention(
      { id: `${version}/${slug}`, release: version, slug, source },
      await Deno.readTextFile(join(root, source)),
    );
    items.push(
      `- \`${intention.id}\` (${intention.classification}): ${intention.title}`,
    );
  }
  return { ok: true, message: `${heading}\n\n${items.join("\n")}` };
}

const USAGE = "usage: deno task release-check " +
  "<gate <base> | promoted <base> | publish <tag> | notes <version>>";

if (import.meta.main) {
  const [command, argument] = Deno.args;
  const checks: Record<
    string,
    (root: string, argument: string) => Promise<CheckResult>
  > = { gate, promoted, publish, notes };
  const check = checks[command];
  if (check === undefined || !argument) {
    console.error(USAGE);
    Deno.exit(2);
  }
  const result = await check(Deno.cwd(), argument);
  if (result.ok) {
    console.log(result.message);
  } else {
    console.error(`release-check ${command}: ${result.message}`);
    Deno.exit(1);
  }
}
