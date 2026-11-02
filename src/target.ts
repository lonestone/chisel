// Questions asked of a target repo. Every one of them is a read: nothing in
// this module writes, so a command can decide what to do before it does it.

import { join } from "@std/path";
import { BLOCK_BEGIN, BLOCK_END, CLAUDE_IMPORT_LINE } from "./markers.ts";

export const SKILLS_LINK_VALUE = "../.agents/skills";

export async function pathExists(path: string): Promise<boolean> {
  try {
    await Deno.lstat(path);
    return true;
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return false;
    throw error;
  }
}

export async function isFile(path: string): Promise<boolean> {
  try {
    return (await Deno.stat(path)).isFile;
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return false;
    throw error;
  }
}

export async function isDirectory(path: string): Promise<boolean> {
  try {
    return (await Deno.stat(path)).isDirectory;
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return false;
    throw error;
  }
}

export async function readTextIfPresent(path: string): Promise<string | null> {
  try {
    return await Deno.readTextFile(path);
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return null;
    throw error;
  }
}

export function hasManagedBlockMarkers(agentsMd: string): boolean {
  const lines = agentsMd.split("\n");
  return lines.includes(BLOCK_BEGIN) && lines.includes(BLOCK_END);
}

export async function agentsMdHasBlockMarkers(
  targetDir: string,
): Promise<boolean> {
  const text = await readTextIfPresent(join(targetDir, "AGENTS.md"));
  return text !== null && hasManagedBlockMarkers(text);
}

export async function claudeMdImportsAgents(
  targetDir: string,
): Promise<boolean> {
  const text = await readTextIfPresent(join(targetDir, "CLAUDE.md"));
  return text !== null && text.split("\n").includes(CLAUDE_IMPORT_LINE);
}

/** The link's own value, unresolved — `null` when the path is not a symlink. */
export async function skillsLinkValue(
  targetDir: string,
): Promise<string | null> {
  const link = join(targetDir, ".claude", "skills");
  try {
    return await Deno.readLink(link);
  } catch {
    return null;
  }
}

/**
 * Each path among `relatives`, or directory above one inside the target, that
 * is a symbolic link: relative to the target, sorted, once each. Each path is
 * walked from the top and the walk stops at the first link on it, so a linked
 * directory is named once, not once per file below it. The target directory
 * itself is not asked about: only what lies inside it.
 */
export async function linkedPaths(
  targetDir: string,
  relatives: Iterable<string>,
): Promise<string[]> {
  const linked = new Set<string>();
  const asked = new Map<string, boolean>();
  for (const relative of relatives) {
    const segments = relative.split("/");
    for (let depth = 1; depth <= segments.length; depth++) {
      const prefix = segments.slice(0, depth).join("/");
      let isLink = asked.get(prefix);
      if (isLink === undefined) {
        try {
          isLink = (await Deno.lstat(join(targetDir, prefix))).isSymlink;
        } catch (error) {
          if (!(error instanceof Deno.errors.NotFound)) throw error;
          isLink = false;
        }
        asked.set(prefix, isLink);
      }
      if (isLink) {
        linked.add(prefix);
        break;
      }
    }
  }
  return [...linked].sort();
}
