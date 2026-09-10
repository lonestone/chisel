// Helpers only: no test body lives here. Every test builds a throwaway repo
// from a fixture, runs the CLI on it as a real process, and reads the file
// tree that comes out — no mocks, no in-process shortcut.
//
// The fixtures under `test/fixtures/` are the oracle and are never mutated:
// every use goes through a copy under a temp root.

import { fromFileUrl, join } from "@std/path";

export const REPO_ROOT: string = fromFileUrl(new URL("../", import.meta.url));
export const ENTRY: string = join(REPO_ROOT, "src", "main.ts");
export const FIXTURES: string = join(REPO_ROOT, "test", "fixtures");
export const SOCLE: string = join(REPO_ROOT, "socle");

export interface CliResult {
  readonly code: number;
  readonly stdout: string;
  readonly stderr: string;
  /** Both streams together, the way a terminal shows them. */
  readonly output: string;
}

/**
 * Runs the CLI the way a user does: a separate process, through the real
 * entry module. Exit code, stdout and stderr are the ones that ship.
 */
export async function runChisel(
  args: string[],
  entry: string = ENTRY,
): Promise<CliResult> {
  const { code, stdout, stderr } = await new Deno.Command(Deno.execPath(), {
    args: ["run", "-A", entry, ...args],
    stdout: "piped",
    stderr: "piped",
  }).output();
  const decoder = new TextDecoder();
  const out = decoder.decode(stdout);
  const err = decoder.decode(stderr);
  return { code, stdout: out, stderr: err, output: out + err };
}

export interface Workspace {
  /** The temp root every repo of this test is built under. */
  readonly root: string;
  /** A raw copy of a fixture, untouched by chisel. */
  copy(fixture: string): Promise<string>;
  /** A copy of a fixture with `chisel init` already run on it. */
  install(fixture: string): Promise<string>;
  /** An empty directory under the root, for a scratch file or a symlink. */
  dir(name: string): Promise<string>;
}

class TempWorkspace implements Workspace {
  #counter = 0;

  constructor(readonly root: string) {}

  async #freshPath(name: string): Promise<string> {
    this.#counter += 1;
    const path = join(this.root, `${this.#counter}-${name}`);
    await Deno.mkdir(path, { recursive: true });
    return path;
  }

  async copy(fixture: string): Promise<string> {
    const destination = await this.#freshPath(fixture);
    await copyTree(join(FIXTURES, fixture), destination);
    return destination;
  }

  async install(fixture: string): Promise<string> {
    const target = await this.copy(fixture);
    const result = await runChisel(["init", target]);
    if (result.code !== 0) {
      throw new Error(
        `priming \`chisel init\` failed for ${fixture}:\n${result.output}`,
      );
    }
    return target;
  }

  dir(name: string): Promise<string> {
    return this.#freshPath(name);
  }
}

/**
 * Gives a test its own temp root and takes it away again — unless the test
 * failed, in which case the repo is kept and its path printed, because a
 * failure whose evidence has been deleted costs an hour to reproduce.
 */
export async function withRepo(
  body: (workspace: Workspace) => Promise<void>,
): Promise<void> {
  const root = await Deno.makeTempDir({ prefix: "chisel-test-" });
  try {
    await body(new TempWorkspace(root));
  } catch (error) {
    console.error(`chisel test: kept the repo of this failing test at ${root}`);
    throw error;
  }
  await Deno.remove(root, { recursive: true });
}

export async function copyTree(
  source: string,
  destination: string,
): Promise<void> {
  await Deno.mkdir(destination, { recursive: true });
  for await (const entry of Deno.readDir(source)) {
    const from = join(source, entry.name);
    const to = join(destination, entry.name);
    if (entry.isDirectory) {
      await copyTree(from, to);
    } else if (entry.isSymlink) {
      await Deno.symlink(await Deno.readLink(from), to);
    } else {
      await Deno.copyFile(from, to);
    }
  }
}

const INSTALLED_ROOTS = [
  ".agents",
  ".claude",
  ".codex",
  "scripts",
  "project-management",
] as const;

/**
 * The installed layout, path by path — the tree chisel is responsible for,
 * root files left out. An exact comparison also catches an extra file, which
 * a list of existence assertions never does. Symlinks are listed and never
 * followed.
 */
export async function installedTree(targetDir: string): Promise<string[]> {
  const paths: string[] = [];
  async function walk(relative: string): Promise<void> {
    let info: Deno.FileInfo;
    try {
      info = await Deno.lstat(join(targetDir, relative));
    } catch {
      return;
    }
    paths.push(relative);
    if (!info.isDirectory) return;
    for await (const entry of Deno.readDir(join(targetDir, relative))) {
      await walk(`${relative}/${entry.name}`);
    }
  }
  for (const root of INSTALLED_ROOTS) await walk(root);
  return paths.sort();
}

export type SnapshotEntry = string;

/**
 * Every path under a directory with what it holds — a content hash for a
 * file, its own value for a symlink. Two snapshots comparing equal is the
 * assertion "nothing at all moved".
 */
export async function snapshot(
  directory: string,
): Promise<Record<string, SnapshotEntry>> {
  const entries: Record<string, SnapshotEntry> = {};
  async function walk(relative: string): Promise<void> {
    const absolute = relative === "" ? directory : join(directory, relative);
    for await (const entry of Deno.readDir(absolute)) {
      const child = relative === "" ? entry.name : `${relative}/${entry.name}`;
      if (entry.isSymlink) {
        entries[child] = `link:${await Deno.readLink(
          join(absolute, entry.name),
        )}`;
      } else if (entry.isDirectory) {
        entries[child] = "dir";
        await walk(child);
      } else {
        entries[child] = `file:${await hashOf(join(absolute, entry.name))}`;
      }
    }
  }
  await walk("");
  return entries;
}

async function hashOf(path: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    await Deno.readFile(path) as BufferSource,
  );
  return Array.from(new Uint8Array(digest)).map((byte) =>
    byte.toString(16).padStart(2, "0")
  ).join(
    "",
  );
}

/**
 * The frontmatter and body of a markdown file with a `---` head, split here
 * rather than borrowed from the CLI: an oracle that reuses the code under
 * test proves only that the code agrees with itself.
 */
export function splitFrontmatter(
  text: string,
): { head: Map<string, string>; body: string } {
  const lines = text.split("\n");
  if (lines.at(-1) === "") lines.pop();
  const head = new Map<string, string>();
  let index = 0;
  if (lines[0] === "---") {
    index = 1;
    while (index < lines.length && lines[index] !== "---") {
      const separator = lines[index].indexOf(": ");
      if (separator > 0) {
        head.set(
          lines[index].slice(0, separator),
          lines[index].slice(separator + 2),
        );
      }
      index += 1;
    }
    index += 1;
  }
  while (index < lines.length && lines[index] === "") index += 1;
  const body = lines.slice(index);
  return { head, body: body.length === 0 ? "" : `${body.join("\n")}\n` };
}

/** Everything after a generated definition's provenance comment, blanks trimmed. */
export function bodyAfterProvenance(text: string): string {
  const lines = text.split("\n");
  if (lines.at(-1) === "") lines.pop();
  const start = lines.findIndex((line) => line.includes("chisel:generated"));
  if (start === -1) return "";
  let index = start + 1;
  while (index < lines.length && lines[index] === "") index += 1;
  const body = lines.slice(index);
  return body.length === 0 ? "" : `${body.join("\n")}\n`;
}

export async function appendTo(path: string, text: string): Promise<void> {
  await Deno.writeTextFile(path, text, { append: true });
}
