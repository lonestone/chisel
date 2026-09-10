// Hashing, in the one form the manifest records: lowercase hex SHA-256, the
// digest `sha256sum` prints, so a manifest written by an earlier version is
// still readable and a hash can be checked by hand.

import { encodeHex } from "@std/encoding/hex";
import { BLOCK_BEGIN, BLOCK_END } from "./markers.ts";

export async function sha256Bytes(bytes: Uint8Array): Promise<string> {
  const digest = await crypto.subtle.digest("SHA-256", bytes as BufferSource);
  return encodeHex(new Uint8Array(digest));
}

export async function sha256Text(text: string): Promise<string> {
  return await sha256Bytes(new TextEncoder().encode(text));
}

export async function sha256File(path: string): Promise<string> {
  return await sha256Bytes(await Deno.readFile(path));
}

/**
 * The hash of an `AGENTS.md`'s managed block: the lines strictly between the
 * markers, each newline-terminated. A file with no markers hashes as empty,
 * which is what a repo whose block was deleted by hand looks like.
 */
export async function agentsBlockHash(text: string): Promise<string> {
  const lines = text.split("\n");
  // A file ending in a newline splits with a trailing empty element that is
  // not a line of the file: dropping it is what keeps an unterminated block
  // from hashing one phantom newline more than it holds.
  if (lines.at(-1) === "") lines.pop();
  const kept: string[] = [];
  let inside = false;
  for (const line of lines) {
    if (line === BLOCK_BEGIN) {
      inside = true;
      continue;
    }
    if (line === BLOCK_END) {
      inside = false;
      continue;
    }
    if (inside) kept.push(line);
  }
  return await sha256Text(kept.map((line) => `${line}\n`).join(""));
}
