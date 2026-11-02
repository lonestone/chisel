// The intentions a release ships: one per change a repo must act on, written
// for an agent, under `socle/intentions/<release>/`. What the CLI knows of
// them, and what it records of them in a repo's manifest.
//
// The path alone gives an intention's id and its place in the order, so the
// shipped list costs no read; the classification needs the file.

import { readPackageText, SOCLE_ROOT } from "./paths.ts";
import { ChiselError } from "./report.ts";
import { SOCLE_FILES } from "./socle-files.ts";

export const CLASSIFICATIONS = [
  "automatic",
  "migration",
  "breaking-manual",
  "informational",
] as const;

/**
 * How much judgement an intention needs: `automatic`, the fast-path copy
 * closes it; `migration`, an agent applies it; `breaking-manual`, a human
 * decides before anything moves; `informational`, read, nothing to do.
 */
export type Classification = typeof CLASSIFICATIONS[number];

/** The folder of the intentions written before their release. */
export const UNRELEASED = "unreleased";

const INTENTIONS_DIR = "intentions/";
const NUMBER_PREFIX = /^\d+-/;

/** A shipped intention, known from its path alone. */
export interface ShippedIntention {
  /** `<release>/<slug>`, as the manifest records it. */
  readonly id: string;
  /** A version (`0.2.5`) or `unreleased`. */
  readonly release: string;
  readonly slug: string;
  /** Relative to the package root. */
  readonly source: string;
}

export interface Intention extends ShippedIntention {
  readonly classification: Classification;
  /** The first `# ` heading. */
  readonly title: string;
}

/** What a repo did with one intention. */
export interface IntentionResult {
  readonly result: "applied" | "skipped";
  readonly date: string;
  readonly reason?: string;
}

/** Intention id → what the repo did with it. */
export type IntentionRecord = Record<string, IntentionResult>;

function versionParts(release: string): number[] {
  return release.split(".").map((part) => Number.parseInt(part, 10) || 0);
}

/** Orders two releases: by version, `unreleased` after every version. */
export function compareReleases(a: string, b: string): number {
  if (a === b) return 0;
  if (a === UNRELEASED) return 1;
  if (b === UNRELEASED) return -1;
  const left = versionParts(a);
  const right = versionParts(b);
  for (let index = 0; index < Math.max(left.length, right.length); index++) {
    const difference = (left[index] ?? 0) - (right[index] ?? 0);
    if (difference !== 0) return Math.sign(difference);
  }
  return 0;
}

/** Every intention the package ships, in the order they apply. */
export function shippedIntentions(): ShippedIntention[] {
  const shipped: ShippedIntention[] = [];
  for (const file of SOCLE_FILES) {
    if (!file.startsWith(INTENTIONS_DIR)) continue;
    const parts = file.slice(INTENTIONS_DIR.length).split("/");
    // The template and any other page at the top are not intentions.
    if (parts.length !== 2 || !parts[1].endsWith(".md")) continue;
    const [release, name] = parts;
    const slug = name.slice(0, -".md".length).replace(NUMBER_PREFIX, "");
    shipped.push({
      id: `${release}/${slug}`,
      release,
      slug,
      source: `${SOCLE_ROOT}${file}`,
    });
  }
  return shipped.sort((a, b) =>
    compareReleases(a.release, b.release) ||
    (a.source < b.source ? -1 : a.source > b.source ? 1 : 0)
  );
}

/** The shipped intention of that id, or null. */
export function shippedIntention(id: string): ShippedIntention | null {
  return shippedIntentions().find((intention) => intention.id === id) ?? null;
}

function frontmatterOf(text: string): Map<string, string> | null {
  const lines = text.split("\n");
  if (lines[0] !== "---") return null;
  const fields = new Map<string, string>();
  for (const line of lines.slice(1)) {
    if (line === "---") return fields;
    const colon = line.indexOf(":");
    if (colon > 0) {
      fields.set(line.slice(0, colon).trim(), line.slice(colon + 1).trim());
    }
  }
  return null;
}

/**
 * Reads the frontmatter of an intention: its id must be the one its path
 * gives, its classification one of the four. Anything else is an error that
 * names the file — a release with a broken intention must not ship.
 */
export function parseIntention(
  shipped: ShippedIntention,
  text: string,
): Intention {
  const fields = frontmatterOf(text);
  if (fields === null) {
    throw new ChiselError(
      `${shipped.source} has no frontmatter block on its first line`,
    );
  }
  if (fields.get("id") !== shipped.id) {
    throw new ChiselError(
      `${shipped.source} declares id ${fields.get("id") ?? "(none)"}, ` +
        `its path gives ${shipped.id}`,
    );
  }
  const classification = fields.get("classification") ?? "";
  if (!(CLASSIFICATIONS as readonly string[]).includes(classification)) {
    throw new ChiselError(
      `${shipped.source} has classification "${classification}", ` +
        `not one of ${CLASSIFICATIONS.join(", ")}`,
    );
  }
  const heading = text.split("\n").find((line) => line.startsWith("# "));
  return {
    ...shipped,
    classification: classification as Classification,
    title: heading?.slice(2).trim() ?? shipped.slug,
  };
}

export async function readIntention(
  shipped: ShippedIntention,
): Promise<Intention> {
  return parseIntention(shipped, await readPackageText(shipped.source));
}

/**
 * The record of a manifest written before intentions were recorded: every
 * intention of a release up to the manifest's version counts as applied, so
 * only what came later is pending. An unreleased one never counts: a
 * manifest without a record was written before any intention shipped, so
 * nothing unreleased can have been part of its install. A first install, by
 * contrast, records everything its own package ships (`fullRecord`).
 */
export function baselineRecord(version: string, date: string): IntentionRecord {
  const record: IntentionRecord = {};
  for (const intention of shippedIntentions()) {
    if (
      intention.release !== UNRELEASED &&
      compareReleases(intention.release, version) <= 0
    ) {
      record[intention.id] = { result: "applied", date };
    }
  }
  return record;
}

/** Every shipped intention recorded applied today: the record of a first install. */
export function fullRecord(date: string): IntentionRecord {
  const record: IntentionRecord = {};
  for (const intention of shippedIntentions()) {
    record[intention.id] = { result: "applied", date };
  }
  return record;
}

/**
 * Whether the record resolves the intention: by its id, or, for one promoted
 * from `unreleased/` since, by the id it had before its release.
 */
function resolves(record: IntentionRecord, intention: ShippedIntention) {
  return intention.id in record ||
    `${UNRELEASED}/${intention.slug}` in record;
}

/** The shipped intentions the record resolves neither way, in order. */
export function pendingIntentions(
  record: IntentionRecord | null,
): ShippedIntention[] {
  const shipped = shippedIntentions();
  if (record === null) return shipped;
  return shipped.filter((intention) => !resolves(record, intention));
}

/** `migration` and `breaking-manual` need an agent, or a human. */
export function needsJudgement(classification: Classification): boolean {
  return classification === "migration" ||
    classification === "breaking-manual";
}

export function today(): string {
  const now = new Date();
  const month = `${now.getMonth() + 1}`.padStart(2, "0");
  const day = `${now.getDate()}`.padStart(2, "0");
  return `${now.getFullYear()}-${month}-${day}`;
}
