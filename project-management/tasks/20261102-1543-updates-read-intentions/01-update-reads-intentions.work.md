# 01 — Update reads intentions — work

Created by the Crewmate at the plan step, 2026-11-02. Spec:
`project-management/tasks/20261102-1543-updates-read-intentions/01-update-reads-intentions.spec.md`.

**Plan:** approved by the Architect, 2026-11-02. Rulings: an edited
managed file keeps the fast path (option a) and is overwritten as today, but
`update` names it on an `overwritten:` line when its hash on disk differs
from the last manifest's, so a local edit never vanishes silently; `init` on
an existing manifest keeps its record and adds nothing (option a).

## Program Design

### What a release ships

Intentions live under `socle/intentions/` and ship through
`src/socle-files.ts` like every other socle file: a published package is
read over HTTP, where a directory cannot be listed, so the list is how the
CLI finds them. They are never installed in the target: the CLI reads them
from the package and copies the pending ones into the workspace.

```
socle/intentions/
  TEMPLATE.md                          the format and the promotion rule, for whoever writes one
  unreleased/<slug>.md                 written with the change, no number
  <version>/NN-<slug>.md               promoted at release; NN is the order inside the release
```

`<version>` is bare (`0.2.5`), as the manifest writes it. Each intention
starts with a frontmatter block, then the nine sections of the current
`chisel-upgrade` intentions (Goal, Why, Applies When, Do Not Apply When,
Observable Gaps, Out of Scope, Reference Paths, Validation, Record Result):

```
---
id: unreleased/manifest-records-intentions
classification: automatic
---
```

- The id is `<folder>/<slug>`, the slug being the file name without its
  `NN-` prefix and `.md`. The CLI derives it from the path; the frontmatter
  repeats it because the spec asks each intention to carry it, and the
  integrity test holds the two equal. Slugs are unique across releases.
- `classification` is one of `automatic`, `migration`, `breaking-manual`,
  `informational`. Anything else, or no frontmatter, is an error naming the
  file.
- **Promotion**, written in `TEMPLATE.md`: at release time,
  `git mv unreleased/<slug>.md <version>/NN-<slug>.md` and rewrite the id.
  A record under `unreleased/<slug>` counts for `<version>/<slug>`, so a
  repo equipped from a checkout before the release does not see the
  promoted intention pending again.
- **Order**: releases by version, `unreleased` last; inside a release, by
  file name.

**The one intention of this slice** is not a placeholder but the real change
of this release: `unreleased/manifest-records-intentions`, `automatic` — the
manifest gains its record of intentions, and the fast-path update closes it
by writing that record. Every existing repo gets it on its next `update`,
through the fast path, with no judgement asked.

### The manifest

```json
{
  "intentions": {
    "unreleased/manifest-records-intentions": { "date": "2026-11-02", "result": "applied" },
    "0.3.0/some-slug": { "date": "2026-11-05", "reason": "the project keeps no journal", "result": "skipped" }
  },
  "managed": { "...": "..." },
  "version": "0.2.4"
}
```

Keys sorted at every level, as `serializeManifest` does today. `reason` only
on a skip.

- **A manifest without `intentions`** (every manifest written before this
  release) is read with an implicit baseline: every shipped intention whose
  release folder is a version less than or equal to the manifest's version
  counts as applied; `unreleased` never does. The next write materialises
  it. This is what lets slice 03's 0.1.1 replay get exactly 0.2.0 onward.
- **Pending** = shipped intentions with no record (applied or skipped).
- **Judgement** = `migration` or `breaking-manual`. `automatic` and
  `informational` need none.

### The commands

**`chisel update [target-dir]`**, in order:

1. target exists; `.agents/` exists — else exit 1, as today.
2. `.chisel-workspace` exists (or is a link) — refuse, exit 1: a session is
   in progress; finish it with the update skill, or delete the directory.
   This holds for the fast path too, so a half-applied session is never
   overwritten by a copy.
3. Collect the **reasons to stage**, writing nothing:
   - the first version's layer (`.agents/rules/`, `.agents/workflows.md`);
   - no manifest;
   - symbolic links on the paths the update would write (the 0.2.4
     pre-flight set, unchanged);
   - pending intentions classified `migration` or `breaking-manual`.
   Without a manifest, every shipped intention is pending.
4. **No reason → the fast path**, exactly today's update (copy, orphan
   pass, stale glue, foreign skills), then every pending intention is
   recorded `applied` with today's date, one `recorded: <id>
   (<classification>)` line each; an `informational` one also prints its
   title. Exit 0.
5. **Any reason → stage** the workspace (below), print the reasons, the
   checklist lines and the skill's path. Exit **3**.

**`chisel record <id> (--applied | --skipped "<reason>") [target-dir]`**:
writes one result into the manifest's `intentions`, today's date, leaving
`managed` and `version` as they are; ticks the matching line of
`.chisel-workspace/session.md` when there is one. Exit 1: an id this
package does not ship, no manifest, the manifest path linked. Exit 2: no
id, neither or both flags, an empty reason, an extra argument. Recording an
id again replaces its result.

**`chisel check [target-dir]`**: one `pending: <id> (<classification>)` line
per pending intention; any pending intention makes the exit 1, as a version
mismatch does.

**`chisel init [target-dir]`**: on a repo without a manifest, records every
shipped intention `applied`, today's date (the baseline). On a repo whose
manifest exists, keeps its record — materialised from its version when it
has none — and adds nothing: see the question below.

**Exit codes** (`--help` names them): 0 done; 1 a refusal, a missing
precondition, a divergence or a pending intention found by `check`; 2 a
usage error; **3 an agent has work to do: a workspace was staged**.

### The workspace

```
.chisel-workspace/
  .gitignore           one line, "*": git ignores the directory, this file included
  session.md           the checklist
  intentions/<release>/<file>.md   each pending intention, as shipped
  reference/           the tree `chisel init` lays in an empty repo, at this version
```

- **Ignored by git without touching the project**: the `.gitignore` inside
  the workspace ignores everything in it, itself included. No write to the
  project's own `.gitignore`.
- **At the root of the target**, never under `.agents/`: a linked `.agents`
  is one of the cases that stages, and the workspace must not be written
  through it.
- **Built whole or not at all**: written into `.chisel-workspace`, removed
  again if any step throws, so a failed staging leaves nothing.
- **The reference** is laid by the same function `init` uses for its
  writes, extracted from `init` as `poseSocle`; it carries the update skill
  and `chisel-upgrade`, so a repo that has neither installed yet still has
  both to read.

`session.md`, written by the CLI (CLI output, not socle prose):

```
# Chisel update session

From <manifest version, or "no manifest"> to <package version>, staged <date>.
Run chisel as `deno x jsr:@lonestone/chisel@<package version>`.
Follow `.chisel-workspace/reference/.agents/skills/chisel-update/SKILL.md`.

## Why update stopped

- <one line per reason; a refusal names the chisel-upgrade intention, at its reference path>

## Intentions

- [ ] `<id>` (<classification>) — `intentions/<release>/<file>`
```

### The update skill

`socle/agents/skills/chisel-update/SKILL.md`, `disable-model-invocation:
true` like `chisel-upgrade`. Its steps, in the boilerplate runbook's shape:

1. Require a clean working tree; read `.chisel-workspace/session.md`.
2. Close the reasons first: a refusal reason is closed by the
   `chisel-upgrade` intention it names (until slice 03 replaces it).
3. **Propose before any edit**: read every pending intention, inspect the
   repo, present an apply / skip / ask table, one observable signal per
   line. Finding the old state is a reason to apply, never to skip. Wait
   for the human.
4. One intention at a time: re-check Applies When and Do Not Apply When;
   on `breaking-manual`, stop and get the human's decision before anything
   moves; **find where the project keeps its method** (the glue, `AGENTS.md`,
   `CLAUDE.md`, symbolic links) and close the gaps there, never by assuming
   chisel's paths; show each move before making it; follow each reference
   path's copy or adapt policy against `reference/`; validate; `chisel
   record`. `automatic` ones are left to the closing update; `informational`
   ones are read to the human.
5. Stop on failing validation or unsafe ambiguity, recording nothing.
6. The close: delete `.chisel-workspace/`, run `chisel update` (the fast
   path now: it refreshes the managed files and records the `automatic` and
   `informational` ones), `chisel check` clean, the human reads the full
   diff, a dated journal entry, one commit on exact paths.

`chisel-upgrade` keeps its intentions; two sentences of its `SKILL.md`
change: `update` now stages instead of refusing, and the reference tree is
the workspace's `reference/` when there is one (the scratch `init` stays
for a repo without `.agents/`).

### Seam signatures

`src/intentions.ts` (new):

```ts
export type Classification =
  | "automatic" | "migration" | "breaking-manual" | "informational";

/** A shipped intention, known from its path alone. */
export interface ShippedIntention {
  readonly id: string;       // "<release>/<slug>"
  readonly release: string;  // "0.2.5" | "unreleased"
  readonly slug: string;
  readonly source: string;   // relative to the package root
}
export interface Intention extends ShippedIntention {
  readonly classification: Classification;
  readonly title: string;    // the first "# " heading
}

/** Every intention the package ships, in execution order. From SOCLE_FILES, no read. */
export function shippedIntentions(): ShippedIntention[];
/** Parses the frontmatter; throws a ChiselError naming the file when it is wrong. */
export function parseIntention(shipped: ShippedIntention, text: string): Intention;
export async function readIntention(shipped: ShippedIntention): Promise<Intention>;
/** -1, 0, 1; "unreleased" after every version. */
export function compareReleases(a: string, b: string): number;
/** The implicit record of a manifest written before intentions were recorded. */
export function baselineRecord(version: string, date: string): IntentionRecord;
/** Shipped intentions the record resolves neither by id nor by an unreleased slug. */
export function pendingIntentions(record: IntentionRecord): ShippedIntention[];
export function needsJudgement(classification: Classification): boolean;
```

`src/manifest.ts`:

```ts
export interface IntentionResult {
  readonly result: "applied" | "skipped";
  readonly date: string;
  readonly reason?: string;
}
export type IntentionRecord = Record<string, IntentionResult>;
export interface Manifest { version; managed; intentions: IntentionRecord }

// readManifest: a missing "intentions" field reads as baselineRecord(version).
export async function writeManifest(
  targetDir: string,
  tracked: readonly string[],
  intentions: IntentionRecord,
): Promise<Manifest>;
/** Rewrites only the intentions field. */
export async function recordIntention(
  targetDir: string, id: string, result: IntentionResult,
): Promise<void>;
```

`src/workspace.ts` (new):

```ts
export const WORKSPACE_DIR = ".chisel-workspace";
export const SESSION_FILE = ".chisel-workspace/session.md";
export const UPDATE_SKILL = ".agents/skills/chisel-update/SKILL.md";

export interface Staging {
  readonly from: string | null;        // the manifest's version, null without one
  readonly reasons: readonly string[];
  readonly pending: readonly Intention[];
}
/** Builds the workspace whole, or removes it. Returns the checklist lines. */
export async function stageWorkspace(targetDir: string, staging: Staging): Promise<string[]>;
/** Ticks the session line of `id`, when a session exists. */
export async function tickSession(targetDir: string, id: string): Promise<void>;
```

`src/init.ts`: `poseSocle(targetDir, projectTitle, previous)` — every write
of `init` after its pre-flight, without the summary line; `init` calls it,
and so does `stageWorkspace` for `reference/`.

`src/install.ts`: `refuseV1Layout` becomes `v1LayoutFound(targetDir):
Promise<string[]>`; the message moves to the staging reason.
`refuseLinkedPaths` stays for `init` (slice 02 changes `init`).

`src/record.ts` (new): `record(args: string[]): Promise<number>`.
`src/report.ts`: `AGENT_WORK_EXIT = 3`. `src/main.ts`: the `record`
command and the help.

### Test order

Each test red first, then the code that turns it green, then a commit. The
new tests form a group `intentions`, in `test/intentions.test.ts`.

**A test package.** `test/helpers.ts` gains `packageWith(workspace,
extras)`: copies `src/`, `socle/` and `deno.json` into the temp root, writes
each extra intention (release, slug, classification; body generated in the
test) under `socle/intentions/`, and rewrites the copy's
`src/socle-files.ts` as the real list plus the extras. It returns the copy's
entry for `runChisel`. Checked: a copied package runs from any working
directory. This is how a `migration` intention is made pending without
shipping one.

1. **integrity**: every shipped intention parses, its frontmatter id equals
   its path id, slugs are unique; the socle list and the golden tree carry
   `socle/intentions/` and the update skill. Code: `src/intentions.ts`,
   `TEMPLATE.md`, the intention, the skill's first version.
2. **baseline-recorded**: `init` records every shipped id `applied`; a
   second `init` leaves the manifest byte-identical (the idempotence test
   already checks every hash). Code: the manifest shape, `init`'s record.
3. **fast-path**: on an install, a test package adding an `automatic`
   intention: `update` exits 0, a locally edited managed page is restored,
   both intentions are recorded, `check` is clean. A manifest at `0.2.0`
   without `intentions`, a test package with `0.1.9/x` and `0.2.1/y`, both
   `automatic`: only `0.2.1/y` and the unreleased one print `recorded:`.
   The existing "0.1.1 install is cleaned" test stays green unchanged.
   Code: the fast path, the implicit baseline.
4. **stage-otherwise**: a test package adding a `migration` intention, and
   one adding a `breaking-manual`: exit 3, the target snapshot equal to the
   one before except `.chisel-workspace/`, the session listing the id
   unticked with its classification, `reference/` holding the update
   skill, stdout naming the skill's path. Then the 0.2.4 refusals: the
   four `guards` tests (first-version layout, no manifest, linked paths,
   relocated layout) move from exit 1 to exit 3 with the same assertions
   on the target and the link's destination, the workspace excepted.
   Code: `stageWorkspace`, the reasons, `poseSocle`.
5. **workspace-kept**: a second `update` exits 1 and leaves the workspace
   byte-identical; in a `git init` target, `git status --porcelain
   --untracked-files=all` lists nothing under `.chisel-workspace/`. Code:
   the refusal, the `.gitignore`.
6. **record**: `--applied` and `--skipped "<reason>"` land in the manifest
   and tick the session; an unknown id exits 1 and changes nothing; a
   missing reason exits 2. Then the close of a session, by hand: delete
   the workspace, `update` exits 0 by the fast path, `check` is clean.
   Code: `src/record.ts`, `main.ts`, help.
7. **check-knows**: a manifest with the shipped intention's record removed:
   `check` prints `pending:` with its id and exits 1. Code: `check`.
8. The update skill in full, `chisel-upgrade`'s two sentences,
   `test/TESTS.md` (groups `intentions`, `guards`, `update`, `check`,
   `usage`), the README's "Keeping it up to date", the `--help` test's exit
   code 3.

### Decisions the slice left to the implementation

- Intentions under `socle/intentions/`, shipped by `src/socle-files.ts`,
  never installed in the target.
- The workspace is `.chisel-workspace/` at the target's root, self-ignored
  by its own `.gitignore`.
- Exit code 3 for "an agent has work to do".
- Any `update` refuses while a workspace exists, the fast path included.
- The 0.2.4 refusals of `update` become reasons to stage; `init`'s link
  refusal stays an exit 1 until slice 02.
- Without a manifest every shipped intention is listed pending; `record`
  refuses there, so the refusal's intention (today `chisel-upgrade`, slice
  03's baseline intention tomorrow) is what creates the manifest.
- A record under `unreleased/<slug>` resolves the promoted
  `<version>/<slug>`.
- `informational` takes the fast path, printed and recorded `applied`.
- `check` counts a pending intention as a divergence (exit 1).
- The slice's intention is a real one, `automatic`; no placeholder ships.

### Questions for the Architect

**A managed file the project edited.** *Fact:* today `update` overwrites a
managed file whose content diverged from the manifest, and a test pins it
("managed refresh"). The slice lists what stages: a pending `migration` or
`breaking-manual`, or a 0.2.4 refusal. The parent spec says the fast path
needs "the repo is exactly what chisel installed". *Problem:* read
literally, a divergence would stage, and an edit someone made to a chisel
page would go through an agent instead of being lost. *Options:*
(a) **recommended** — keep overwriting on the fast path, as the slice's
criteria list the triggers; `check` already reports the divergence before
anyone updates; (b) a diverged managed file is a reason to stage, and the
skill asks whether the edit moves to a project file — changes a tested
behaviour and every repo with a stray edit stops on update.

**`init` on a repo that already has a manifest.** *Fact:* the criterion says
`init` records every shipped intention up to its version as applied.
*Problem:* `init` re-run on an older install would mark a pending
`migration` applied without anyone applying it. *Options:*
(a) **recommended** — a first `init` records the baseline; an `init` on an
existing manifest keeps its record (materialised) and adds nothing, so the
pending ones stay for `update` and `check` reports them; (b) the literal
reading, every run of `init` records everything.

## Worklog

## Implementation Checkboxes

- [ ] Intentions shipped and parsed; integrity test
- [ ] `init` records the baseline
- [ ] The fast path records; the implicit baseline
- [ ] Staging: the workspace, the reasons, the 0.2.4 refusals moved to it
- [ ] The workspace refused when present, and ignored by git
- [ ] `chisel record`
- [ ] `check` reports pending intentions
- [ ] The update skill, `chisel-upgrade`, README, `test/TESTS.md`
- [ ] Gates green
- [ ] `code-review`, findings answered
- [ ] Close

## Notes & Snippets

The reference model read at the plan step: the boilerplate's
`.boilerstone/docs/how-it-works.md` ("The commands, in the order you meet
them"), `upgrade-runbook.md` ("Applying intentions", "When to stop"),
`migration-intentions/TEMPLATE.md`, the `boilerstone-upgrade` skill, and
`cli/boilerplate.ts` (`syncUpgradeSessionProgress`, `cmdUpgradeRecord`,
`generateSessionPrompt`). Borrowed: frontmatter id and classification,
`unreleased/` then numbered release folders, the propose-first table, the
stop on `breaking-manual`, the session checklist ticked by `record`, the
refusal to overwrite a workspace. Left out, per the parent spec: domains,
git refs, a branch per upgrade, `upgrade finish` (the closing fast-path
`update` writes the version).

## Diff-Review Findings
