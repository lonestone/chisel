// `deno task commit-lint <message|range|pr> …`: every commit of chisel is
// conventional, `type(scope): description`, after the Lonestone boilerplate's
// commitlint config, in Deno. release-please reads the commits on `main` to
// pick the next version and write the changelog.
//
// - `message <file>`: one message; the commit-msg hook `deno task hooks`
//   writes into the clone.
// - `range <base>`: every commit of a pull request, in CI.
// - `pr [event.json]`: a pull request's title and description, which a squash
//   merge turns into the commit on `main`; the event defaults to
//   `$GITHUB_EVENT_PATH`.
//
// This file is the single source of the types and the scopes: name them
// nowhere else.

import { join } from "@std/path";

/** Conventional Commits 1.0.0 types. */
export const TYPES = [
  "feat",
  "fix",
  "docs",
  "style",
  "refactor",
  "perf",
  "test",
  "build",
  "ci",
  "chore",
  "revert",
] as const;

/** What a change touches in chisel. Every header names one. */
export const SCOPES = [
  "cli", // src/: the commands and what they write
  "socle", // socle/: the doctrine, skills and templates chisel ships
  "skills", // a skill, shipped or chisel's own
  "intentions", // socle/intentions/ and the code that reads them
  "release", // the release machinery: scripts, workflows, release-please
  "tasks", // project-management/: specs, work docs, journal
  "tooling", // tests, deno.json, hooks, repo settings
] as const;

/**
 * The commits written before this rule, on the branch that introduced it:
 * `b7f121c` and its ancestors are not linted. Nothing pushed is rewritten.
 */
export const HISTORY_BEFORE_THE_RULE =
  "b7f121c7f9559d92f3155efb58d5b1a74f22f386";

/**
 * Words that mean a pull request was not finalized, checked on its title and
 * on the conventional paragraphs of its description: they would land in the
 * changelog.
 */
export const WIP_WORDS = [
  "wip",
  "fixup",
  "squash",
  "tmp",
  "temp",
  "oops",
  "typo",
  "fmt",
  "lint",
  "do not merge",
  "wtf",
] as const;

const WIP_TRAILING = [/\s+2$/, /\s+again$/i];
const MAX_LINE = 100;
const FORM = "write it as `type(scope): description`, with a type of " +
  `${TYPES.join(", ")} and a scope of ${SCOPES.join(", ")} ` +
  "(scripts/commit-lint.ts, CONTRIBUTING.md)";
const HEADER =
  /^(?<type>[a-z]+)(?:\((?<scope>[^)]*)\))?(?<breaking>!)?: (?<description>.*)$/;
const CONVENTIONAL_START = new RegExp(
  `^(?:${TYPES.join("|")})(?:\\([^)]*\\))?!?: `,
);
/** Messages git writes itself, which commitlint ignores too. */
const IGNORED = [
  /^Merge /,
  /^Revert "/,
  /^(?:fixup|squash|amend)! /,
];
const BREAKING_TOKEN = "BREAKING-CHANGE:";
const IMAGE = /!\[[^\]]*\]\([^)]+\)|<img[\s>]/i;
const TASK_LIST = /^\s*[-*+]\s+\[[ xX]\]/m;
const HOOK_MARK = "Written by `deno task hooks`";

/** The problems of one header; empty when it is conventional. */
export function lintHeader(header: string): string[] {
  const match = HEADER.exec(header);
  if (match === null) return [`"${header}" is not conventional: ${FORM}`];
  const { type, scope, description } = match.groups!;
  const problems: string[] = [];
  if (!(TYPES as readonly string[]).includes(type)) {
    problems.push(`"${type}" is not a type: ${FORM}`);
  }
  if (scope === undefined || scope === "") {
    problems.push(`"${header}" names no scope: ${FORM}`);
  } else if (!(SCOPES as readonly string[]).includes(scope)) {
    problems.push(`"${scope}" is not a scope: ${FORM}`);
  }
  if (description.trim() === "") {
    problems.push(`"${header}" has no description`);
  } else if (/^[A-Z]/.test(description)) {
    problems.push(`"${header}": start the description in lower case`);
  } else if (description.endsWith(".")) {
    problems.push(`"${header}": end the description without a full stop`);
  }
  if (header.length > MAX_LINE) {
    problems.push(`"${header}" is longer than ${MAX_LINE} characters`);
  }
  return problems;
}

/** A message as git stores it: comment lines and the scissors part gone. */
function cleaned(message: string): string[] {
  const lines: string[] = [];
  for (const line of message.split("\n")) {
    if (line.startsWith("# ------------------------ >8")) break;
    if (!line.startsWith("#")) lines.push(line);
  }
  while (lines.length > 0 && lines[lines.length - 1].trim() === "") {
    lines.pop();
  }
  return lines;
}

/** The problems of one commit message; empty when it is conventional. */
export function lintMessage(message: string): string[] {
  const [header = "", ...body] = cleaned(message);
  if (IGNORED.some((pattern) => pattern.test(header))) return [];
  const problems = lintHeader(header);
  if (body.length > 0 && body[0].trim() !== "") {
    problems.push(`"${header}": leave a blank line after the header`);
  }
  for (const line of body) {
    if (line.length > MAX_LINE && !/https?:\/\//.test(line)) {
      problems.push(
        `"${header}": a body line is longer than ${MAX_LINE} characters`,
      );
      break;
    }
  }
  return problems;
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

async function knows(root: string, commit: string): Promise<boolean> {
  const result = await new Deno.Command("git", {
    args: ["cat-file", "-e", `${commit}^{commit}`],
    cwd: root,
    stdout: "null",
    stderr: "null",
  }).output();
  return result.success;
}

/**
 * The problems of every commit after `base`, merges aside, except `exempt`
 * and its ancestors. An exempt commit the clone does not know exempts
 * nothing.
 */
export async function lintRange(
  root: string,
  base: string,
  exempt: string = HISTORY_BEFORE_THE_RULE,
): Promise<string[]> {
  const args = ["rev-list", "--no-merges", `${base}..HEAD`];
  if (await knows(root, exempt)) args.push(`^${exempt}`);
  const commits = (await git(root, args)).split("\n").filter(Boolean);
  const problems: string[] = [];
  for (const commit of commits) {
    const message = await git(root, ["log", "-1", "--format=%B", commit]);
    for (const problem of lintMessage(message)) {
      problems.push(`${commit.slice(0, 7)}: ${problem}`);
    }
  }
  return problems;
}

export interface PullRequest {
  readonly title: string;
  readonly body: string | null;
  readonly draft: boolean;
}

function wipHits(header: string): string[] {
  const description = header.replace(/^[a-z]+(?:\([^)]*\))?!?:\s*/, "")
    .trim().toLowerCase();
  const first = description.split(/\s+/)[0] ?? "";
  const hits: string[] = WIP_WORDS.filter((word) =>
    word.includes(" ")
      ? new RegExp(`\\b${word}\\b`).test(description)
      : description === word || first === word
  );
  if (WIP_TRAILING.some((pattern) => pattern.test(description))) {
    hits.push(description.split(/\s+/).pop()!);
  }
  return hits;
}

/**
 * The problems of a pull request's title and description: the title becomes
 * the squash commit's header and the description its body.
 */
export function lintPullRequest(pull: PullRequest): string[] {
  const title = pull.title ?? "";
  const body = pull.body ?? "";
  const problems = lintHeader(title).map((problem) => `title: ${problem}`);
  if (title.includes(BREAKING_TOKEN) || body.includes(BREAKING_TOKEN)) {
    problems.push(
      `found ${BREAKING_TOKEN}: mark a breaking change with ` +
        "`type(scope)!: description` in the title instead",
    );
  }
  if (body.trim() === "") {
    if (!pull.draft) {
      problems.push(
        "the description is empty: it becomes the commit body, say why",
      );
    }
  }
  if (IMAGE.test(body)) {
    problems.push(
      "the description holds an image: it becomes the commit body, " +
        "move it to a comment",
    );
  }
  if (TASK_LIST.test(body)) {
    problems.push(
      "the description holds a task list: it becomes the commit body, " +
        "move it to a comment",
    );
  }
  const paragraphs = body.split(/\n\s*\n/).map((part) => part.trim())
    .map((part) => part.split("\n")[0])
    .filter((first) => CONVENTIONAL_START.test(first));
  for (const header of paragraphs) {
    for (const problem of lintHeader(header)) {
      problems.push(`description: ${problem}`);
    }
  }
  if (!pull.draft) {
    for (const header of [title, ...paragraphs]) {
      for (const word of wipHits(header)) {
        problems.push(
          `"${header}": "${word}" would land in the changelog, ` +
            "describe the result instead",
        );
      }
    }
  }
  return problems;
}

/**
 * Writes the commit-msg hook into the clone at `root` and returns its path.
 * Refuses to replace a hook it did not write.
 */
export async function installHook(root: string): Promise<string> {
  const hooks = (await git(root, ["rev-parse", "--git-path", "hooks"])).trim();
  const directory = hooks.startsWith("/") ? hooks : join(root, hooks);
  const path = join(directory, "commit-msg");
  try {
    const existing = await Deno.readTextFile(path);
    if (!existing.includes(HOOK_MARK)) {
      throw new Error(
        `${path} already holds a commit-msg hook chisel did not write: ` +
          "merge it by hand with scripts/commit-lint.ts, nothing written",
      );
    }
  } catch (error) {
    if (!(error instanceof Deno.errors.NotFound)) throw error;
  }
  await Deno.mkdir(directory, { recursive: true });
  await Deno.writeTextFile(
    path,
    [
      "#!/bin/sh",
      `# ${HOOK_MARK}: every commit message is conventional.`,
      'exec deno run --allow-read --allow-run=git scripts/commit-lint.ts message "$1"',
      "",
    ].join("\n"),
  );
  await Deno.chmod(path, 0o755);
  return path;
}

const USAGE = "usage: deno task commit-lint " +
  "<message <file> | range <base> | pr [event.json] | install-hook>";

async function run(command: string, argument: string | undefined) {
  const root = Deno.cwd();
  switch (command) {
    case "message":
      if (!argument) return null;
      return lintMessage(await Deno.readTextFile(argument));
    case "range":
      if (!argument) return null;
      return await lintRange(root, argument);
    case "pr": {
      const path = argument ?? Deno.env.get("GITHUB_EVENT_PATH");
      if (!path) return null;
      const event = JSON.parse(await Deno.readTextFile(path));
      return lintPullRequest(event.pull_request);
    }
    case "install-hook":
      console.log(`commit-msg hook: ${await installHook(root)}`);
      return [];
    default:
      return null;
  }
}

if (import.meta.main) {
  const [command, argument] = Deno.args;
  const problems = await run(command, argument);
  if (problems === null) {
    console.error(USAGE);
    Deno.exit(2);
  }
  if (problems.length > 0) {
    console.error(`commit-lint ${command}:`);
    for (const problem of problems) console.error(`  ${problem}`);
    Deno.exit(1);
  }
}
