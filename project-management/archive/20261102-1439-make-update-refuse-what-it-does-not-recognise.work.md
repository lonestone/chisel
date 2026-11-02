# Make update refuse what it does not recognise, and migrate by recipe — work

Created by the Crewmate at the plan step, 2026-11-02. Spec:
`project-management/archive/20261102-1439-make-update-refuse-what-it-does-not-recognise.spec.md`.

**Plan:** approved by the Architect, 2026-11-02. Rulings: the listed file
the project deleted takes option (b), written outside `.agents/` only when
listed and still on disk; a linked `AGENTS.md` is refused by both commands,
and the links gap of the recipe covers it.

## Program Design

### The order of a command, before and after

`update` today: target exists, `.agents/` exists, first-version guard, read
the manifest with an empty fallback, write. After this task:

1. target exists, `.agents/` exists (unchanged);
2. the first-version guard, unchanged and still first, so the first-version
   fixture keeps its own message;
3. **the manifest rule**: no `.agents/.chisel.json` → refuse;
4. compute the write set from the previous manifest;
5. **the pre-flight**: any path of the write set, or any directory above
   one inside the target, that is a symbolic link → refuse, naming each;
6. write, exactly as today.

`init` today writes at once. After: target exists, compute its write set,
**the pre-flight**, then write as today. No manifest rule for `init`.

Every refusal is a `ChiselError` thrown before the first write, so the
existing mapping in `src/main.ts` gives exit 1 and the message on stderr.

### Seam signatures

`src/target.ts` (the module of read-only questions):

```ts
/**
 * Each path among `relatives`, or directory above one inside the target,
 * that is a symbolic link: relative to the target, sorted, once each.
 * Walks each path from the top and stops at the first link on it. Reads only.
 */
export async function linkedPaths(
  targetDir: string,
  relatives: Iterable<string>,
): Promise<string[]>;
```

`src/install.ts`:

```ts
/** One file the installer copies from the socle: source, destination, mode. */
interface ManagedCopy { source: string; relative: string; mode?: number }

/** The single list both `managedSocleFiles` and `copyManagedFiles` read. */
function managedCopies(): ManagedCopy[];

export function managedSocleFiles(): string[];            // unchanged contract

/** Copies the managed files named in `only`; all of them when omitted. */
export async function copyManagedFiles(
  targetDir: string,
  only?: ReadonlySet<string>,
): Promise<void>;

/** Every path `init` may write, before it writes any (the adapter link excepted). */
export function initWrites(): string[];
// = managedSocleFiles() + .agents/project.md, .agents/.chisel.json,
//   AGENTS.md, project-management/{tasks,archive,JOURNAL.md}

/** Throws, naming each linked path and the recipe, when `linkedPaths` finds any. */
export async function refuseLinkedPaths(
  targetDir: string,
  relatives: Iterable<string>,
): Promise<void>;

/** The sentence every new refusal ends with: where the recipe is, and how to get it. */
export async function upgradeRecipePointer(): Promise<string>;
```

`src/manifest.ts`:

```ts
/** Records the files of `tracked` that exist; every managed file when omitted. */
export async function writeManifest(
  targetDir: string,
  tracked: readonly string[] = managedSocleFiles(),
): Promise<Manifest>;
```

`update` passes its write set, so a file outside `.agents/` that `update`
did not write is never adopted into the manifest (a project file sitting at
`scripts/task-id.sh` on a repo whose manifest never listed it stays the
project's).

`src/update.ts`:

```ts
/** The managed files this update writes: the shipped list, inside `.agents/` or listed before. */
async function updateWrites(targetDir: string, previous: Manifest): Promise<string[]>;
```

The pre-flight set of `update` is its write set, plus `AGENTS.md`,
`.agents/.chisel.json`, and every file key of the previous manifest (the
orphan pass may remove one, and a removal under a linked directory would
reach the link's destination).

### The messages

Both new refusals end with `upgradeRecipePointer()`: follow the
`chisel-upgrade` skill, `.agents/skills/chisel-upgrade/SKILL.md`; a repo
without it gets the reference tree with `deno x
jsr:@lonestone/chisel@<this version> init <a scratch directory outside the
repo>`. The version is pinned to the running CLI's, so the recipe read
matches the CLI that refused. Each also says that nothing was written. The
links refusal lists one path per line. The first-version message is left as
it is (spec, "The first-version guard stays").

### The recipe

`socle/agents/skills/chisel-upgrade/` becomes three files:

- `SKILL.md` — the router: what an intention is and how to apply one (gaps
  independent, a closed gap skipped, the human validates each move); what
  is never touched; the starting points with their signals and the file
  each one goes to; how to get the reference tree (`chisel init` into a
  scratch directory outside the repo, deleted at the end); the hand-over.
- `from-first-version.md` — a repo chisel did not install, or installed
  with the first version. Gaps, each found through `AGENTS.md`, the glue,
  or `find … -type l`, never through an assumed path: the method's
  location and the two trees (ends with the human choosing which tree to
  keep, and the task workspace section of `.agents/project.md` naming it); links where chisel writes; the retired layer
  (rule files and the visual guide, wherever they live); the current layer
  and its manifest (`chisel init .` once the links are gone, then what it
  seeded in a tree the human did not keep is removed, then `chisel update`);
  the glue and the journal; the statuses, with the first-version table.
- `from-0.1.x.md` — a 0.1.x install. Gaps: the retired files (`chisel
  update`, its `removed:`, `orphaned:` and `stale:` lines); the glue's
  tracker section, retired adapter lines and "I · Merge and publish"; the
  statuses with the thirteen-to-seven table, and beads; the project's own
  profiles and words; the journal's name. A linked path that `update` names
  sends the reader to the links gap of the other intention, not a copy of it.

Each intention has the nine sections of the spec, in its order: Goal, Why,
Applies When, Do Not Apply When, Observable Gaps, Out of Scope, Reference
Paths (each **copy** or **adapt**), Validation, Record Result. No
frontmatter on the intentions: nothing parses it here. The content of
today's paths A and B moves into them; nothing is said twice.

### Question for the Architect: a listed file the project deleted

**Fact.** The spec's write set outside `.agents/` is "what the previous
manifest listed". **Problem.** In the relocated case, the recipe runs
`chisel init .` to get a manifest; `init` seeds `project-management/` with
the two templates, and the manifest lists them. When the human keeps
`doc/project-management/` and the seeded tree is removed, the next `update`
recreates the templates, because the manifest still lists them: the second
tree comes back on every update, and the intention cannot close its
two-trees gap. **Options.**

- (a) As the spec says: listed → written, even when absent. The recipe
  then has to edit `.agents/.chisel.json` by hand, which no recipe should.
- (b) **Recommended.** Outside `.agents/`, write a file only when the
  previous manifest listed it **and** it is still on disk. A deleted
  template stays deleted; `update` drops it from the manifest (it is not in
  the write set), `check` reports it MISSING only until that update. Inside
  `.agents/`, a deleted file still comes back, as today. One condition in
  `updateWrites`.

### Consequences of the write-set rule, said out loud

- A file a future socle adds outside `.agents/` reaches existing installs
  through `chisel init` only, never through `update`. Every manifest since
  0.1.1 lists the two templates and the task id script, so nothing shipped
  today is lost.
- The pre-flight checks `AGENTS.md` (spec, "The adapter link"): a repo whose
  `AGENTS.md` is a link to `CLAUDE.md` is refused by both commands.

### Test order

Each test red first, then the code that turns it green, then a commit.

1. `guards`: `update` on an installed brownfield whose manifest was deleted
   exits 1, names `chisel-upgrade`, and the target snapshot is unchanged.
   Code: the manifest rule and `upgradeRecipePointer`.
2. `guards`: `update` on an installed brownfield where (a)
   `.agents/workflow.md` is a link to a file outside the target, (b)
   `.agents/skills/tdd` is a link to a directory outside it, exits 1, names
   the path, and both the target and the destination snapshots are
   unchanged. Positive control in the same test: a foreign skill linked
   outside (`.agents/skills/review-videos`) does not stop `update`. Code:
   `linkedPaths`, `refuseLinkedPaths`, `updateWrites`, the pre-flight.
3. `guards`: `init` on a brownfield copy whose `.agents/skills/tdd` is a
   link exits 1, names it, and writes nothing. Code: `initWrites`, the
   pre-flight in `init`.
4. `guards`: the relocated layout, built in the test from plain files and
   `Deno.symlink` (doctrine and skills in `doc/agents/`, workspace with a
   `CHANGELOG.md` in `doc/project-management/`, `.agents/skills/tdd` and
   `.agents/skills/review-videos` linked into `doc/agents/skills/`, an
   `AGENTS.md` pointing at `doc/agents/`, no manifest): `update` and `init`
   both exit 1 and the snapshot is unchanged. No new code expected.
5. `update`: an installed brownfield whose manifest no longer lists the two
   templates and the task id script, with `project-management/` and
   `scripts/` removed: `update` exits 0 and creates neither. Code:
   `writeManifest(tracked)`. If the Architect approves the question below,
   the same test also covers a template the manifest lists but the project
   deleted.
6. The recipe: the three files, `src/socle-files.ts`,
   `test/fixtures/golden-tree.txt`, and the integrity test's "only the
   migration skill names the pieces it retires", which moves from one file
   to the skill's directory. The waived pointers stay found.
7. `test/TESTS.md` (`guards` and `update` rows), and the README's "Keeping
   it up to date", which today says the first version is the only refusal.

### Decisions the spec left to the implementation

- The pre-flight's write sets are computed from the same lists the
  installer copies from (`managedCopies`), so they cannot drift.
- The links refusal names each path once, at the highest link on it: a
  linked `.agents/skills` is one line, not one per skill.
- The target directory itself is not checked: the spec says "inside the
  target", and temp directories on macOS sit under a link.
- `CLAUDE.md` and the adapter link are not in the pre-flight (spec).

## Worklog

**2026-11-02, code (Crewmate).** Five green steps, each test red first
except the relocated layout, which the two earlier rules already refused
(expected in the plan). The manifest rule; the pre-flight for `update`,
with `linkedPaths` in `src/target.ts`, `managedCopies` as the one list in
`src/install.ts`, and `writeManifest` taking the paths it tracks; the
pre-flight for `init`; the relocated-layout test; the write-set rule with
the Architect's ruling (b), listed and still on disk. The no-new-tree test
also checks that a managed page deleted inside `.agents/` still comes back,
and that `check` is clean after the update that dropped the deleted
templates.

**2026-11-02, recipe and docs (Crewmate).** `chisel-upgrade` is now a
router (`SKILL.md`) and two intentions, `from-first-version.md` and
`from-0.1.x.md`, with the nine sections each; the content of the former
paths A and B moved into them. Per the Architect's ruling, the links gap of
`from-first-version.md` names a linked `AGENTS.md` and a linked skill, the
human choosing which content stays, and comes before the gap that runs
`chisel init .`. The integrity test's citer rule now accepts any file of
the skill's directory, and asserts that the skill still names what it
retires. `test/TESTS.md` and the README's "Keeping it up to date" follow.
28 tests green, `deno task check` clean.

**2026-11-02, review and close (Crewmate).** Two fresh reviewers; their
findings and answers are below. Gap citations by title, one name for the
manifest path, the CLAUDE.md warning in the recipe. Criteria ticked, spec
and work documents archived, journal entry 44, `retro` run.

## Implementation Checkboxes

- [x] Manifest rule and its `guards` test
- [x] Pre-flight for `update` and its `guards` test
- [x] Pre-flight for `init` and its `guards` test
- [x] Relocated-layout test
- [x] Write-set rule and its `update` test
- [x] Recipe as intentions; socle list, golden tree, integrity test
- [x] `test/TESTS.md` and README
- [x] Gates green
- [x] `code-review`, findings answered
- [x] Close

## Notes & Snippets

## Diff-Review Findings

`code-review` on `git diff ff222af...HEAD`, two fresh reviewers, 2026-11-02.

### Standards

- **Gaps cited by number in the recipe** (rule 10 of `.agents/discipline.md`,
  "name things by their meaning"): "gap 2", "gap 4" and the like in both
  intentions. **Fixed:** each gap is cited by its title.
- **A bare "§A" in this document.** **Fixed:** named as the task workspace
  section of `.agents/project.md`.
- **Hand-kept names in the write sets** (duplicated code, judgement call):
  the manifest path and the journal name were repeated as strings.
  **Fixed:** `MANIFEST_FILE` is exported by `src/manifest.ts` and used by
  `manifestPath`, `initWrites` and the pre-flight of `update`; the journal
  path uses `JOURNAL_NAME`. `updateWrites` stays in `src/update.ts`: it
  depends on the previous manifest, which only `update` reads.
- **`upgradeRecipePointer`'s comment claimed every refusal**, and the
  first-version refusal keeps its own wording (the spec keeps that guard as
  it is). **Fixed:** the comment names the two refusals that use it.
- **The no-manifest message printed the target twice.** **Fixed:** it names
  `.agents/.chisel.json`.
- **Refusal text lives in `src/install.ts`, not `src/report.ts`.**
  **Answered:** it follows `refuseV1Layout`, the precedent;
  `src/report.ts` holds the printing primitives, not every message.
- **A manifest type cast repeated in `test/update.test.ts`.** **Answered:**
  the same inline shape is already used by the file's other tests; left as
  the file's style.

### Spec

- **The journal entry is missing.** **Answered:** written at the close,
  entry 44.
- **Ruling (b) changes a recognised install** (a listed template the project
  deleted is no longer restored) and the spec's system design still says
  "what the previous manifest listed". **Answered:** the Architect's ruling,
  on the `**Plan:**` line; recorded in the spec's Notes, signed, without
  touching the spec's decision zones.
- **The pre-flight of `update` also checks the previous manifest's paths.**
  **Answered:** approved in the program design; the orphan pass removes
  them, and a removal under a linked directory reaches its destination.
- **`init` writes through a linked `CLAUDE.md`.** Reproduced by the
  reviewer: with `CLAUDE.md` linked into `doc/`, `init` appends its import
  line to the destination. The spec's scope says "any path they would
  write"; its "adapter link" decision lists four places without
  `CLAUDE.md`; the approved plan left `CLAUDE.md` out. **Partly fixed,
  partly reported:** the recipe's links gap now names a linked `CLAUDE.md`
  and says to replace it before `init`. Whether the CLI should refuse it
  too departs from the approved plan, so it goes to the Architect (close
  report), recommended: refuse, like a linked `AGENTS.md`.
