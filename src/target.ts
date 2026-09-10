// Questions asked of a target repo. Every one of them is a read: nothing in
// this module writes, so a command can decide what to do before it does it.

import { join } from "@std/path";
import {
  BLOCK_BEGIN,
  BLOCK_END,
  CLAUDE_IMPORT_LINE,
  GEN_MARKER,
} from "./markers.ts";

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
 * True when a directory holds at least one definition chisel rendered. The
 * directory existing proves nothing — it is shared with the user's own
 * sub-agents, and they may own everything in it.
 */
export async function hasGeneratedDefinitions(
  directory: string,
): Promise<boolean> {
  for (const file of await listFiles(directory)) {
    const text = await readTextIfPresent(join(directory, file));
    if (text !== null && text.includes(GEN_MARKER)) return true;
  }
  return false;
}

/** File names directly inside a directory, sorted; empty when it is absent. */
export async function listFiles(directory: string): Promise<string[]> {
  const names: string[] = [];
  try {
    for await (const entry of Deno.readDir(directory)) {
      if (entry.isFile) names.push(entry.name);
    }
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return [];
    throw error;
  }
  return names.sort();
}

/**
 * Every file under a directory, as paths relative to it, sorted. Symlinks are
 * listed and never descended into: the tree chisel walks is the one it wrote.
 */
export async function listFilesRecursive(directory: string): Promise<string[]> {
  const found: string[] = [];
  async function walk(current: string, prefix: string): Promise<void> {
    let entries: Deno.DirEntry[];
    try {
      entries = [];
      for await (const entry of Deno.readDir(current)) entries.push(entry);
    } catch (error) {
      if (error instanceof Deno.errors.NotFound) return;
      throw error;
    }
    for (const entry of entries.sort((a, b) => (a.name < b.name ? -1 : 1))) {
      const relative = prefix ? `${prefix}/${entry.name}` : entry.name;
      if (entry.isDirectory) {
        await walk(join(current, entry.name), relative);
      } else if (entry.isFile) {
        found.push(relative);
      }
    }
  }
  await walk(directory, "");
  return found.sort();
}
