# Make update refuse what it does not recognise, and migrate by recipe

**Status:** in-progress

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

On 2026-11-02 Apollon ran `chisel update` 0.2.3 on a repo whose method
predates the CLI: the doctrine lives in `doc/agents/`, the task workspace in
`doc/project-management/`, and the entries of `.agents/skills/` are
symbolic links into `doc/agents/skills/`. The repo had no
`.agents/.chisel.json`. The update did three wrong things:

- **It ran instead of refusing.** The guard against the first version only
  looks for `.agents/rules/` and `.agents/workflows.md`, and this repo keeps
  its first-version method elsewhere.
- **It wrote through the links.** The installer writes each skill with a
  plain file write, which follows a symbolic link, so it rewrote 15 of the
  project's own skills in `doc/agents/skills/`. It also rewrote `AGENTS.md`
  and `scripts/task-id.sh`.
- **It created a second tree.** The templates went to a root
  `project-management/`, beside the workspace the repo already has.

Nothing was committed: Apollon parked the changes on a local branch.

The Owner's ruling: a script cannot handle every layout. The CLI does the
case it recognises and refuses the rest. Everything that needs judgement is
a recipe the agent applies, in the shape of the boilerplate's migration
intentions (`.boilerstone/migration-intentions/TEMPLATE.md` in the
Lonestone boilerplate): a goal, when it applies and when it does not,
observable gaps each with a signal, a reference with a copy-or-adapt
policy and a "done when", what is out of scope, and how to validate.

## Scope

**Included:**
- `chisel update` refuses, writing nothing, a repo it did not install (no
  manifest), and names the recipe.
- `chisel update` and `chisel init` refuse, writing nothing, when any path
  they would write is a symbolic link or sits under one, and name each
  such path.
- `chisel update` creates no file outside `.agents/` that the previous
  manifest did not list.
- The `chisel-upgrade` skill rewritten as migration intentions, one per
  starting point, that work whatever the layout.
- Tests for all of the above, on a fixture shaped like Apollon's repo.
- A dated journal entry.

**Not Included:**
- Publishing a new version: the release is the Owner's word.
- Applying the migration to Apollon's repo: that is the next step, run by
  Apollon with the new recipe.
- A CLI command to stage reference files: the recipe gets the reference
  tree with `chisel init` into a scratch directory outside the repo.
- The JSR score work (module docs, provenance): a later task.

## Acceptance Criteria

- [ ] **refuse-without-manifest** — `update` on a target with `.agents/`
  but no `.agents/.chisel.json` exits non-zero, prints a message naming
  the `chisel-upgrade` skill, and leaves the target byte-identical (tree
  snapshot equal before and after).
- [ ] **refuse-through-links** — `update` on an installed target where one
  managed path, or a directory above it inside the target, is a symbolic
  link exits non-zero, names that path, and leaves the target and the
  link's destination byte-identical.
- [ ] **init-refuses-through-links** — `init` on a target whose
  `.agents/skills/<name>` is a symbolic link exits non-zero, names it, and
  writes nothing.
- [ ] **no-new-tree** — `update` on an installed target whose last manifest
  lists no `project-management/` template does not create
  `project-management/` or anything in it.
- [ ] **relocated-layout-fixture** — a test fixture reproduces Apollon's
  shape (doctrine in `doc/agents/`, workspace in `doc/project-management/`,
  `.agents/skills/` entries linked into `doc/agents/skills/`, no manifest),
  and `update` on it refuses with the target unchanged.
- [ ] **recipe-shape** — `chisel-upgrade` holds one intention per starting
  point (a repo chisel did not install or installed with the first
  version; a 0.1.x install), each with the sections Goal, Why, Applies
  When, Do Not Apply When, Observable Gaps, Out of Scope, Reference Paths,
  Validation and Record Result.
- [ ] **gaps-are-layout-free** — no observable gap assumes where the
  project's method lives: each finds it through the glue, `AGENTS.md`, or
  symbolic links, and the two-trees case ends with the human choosing which
  tree to keep.
- [ ] **reference-tree** — the recipe obtains the reference socle with
  `chisel init` into a scratch directory outside the repo, and says to
  delete it afterwards.
- [ ] **socle-list-matches** — `src/socle-files.ts`, the golden tree and the
  integrity test agree with the files under `socle/`.
- [ ] **doctrine-budget** — the four doctrine pages stay at 600 lines or
  fewer in total.
- [ ] **suite-green** — `deno task test` and `deno task check` pass.

## Seams

- **`chisel update <target>`** — on an unrecognised install or a linked
  path: non-zero exit, a message naming the cause and the skill, zero
  writes. On a recognised install: as today, minus any new file outside
  `.agents/`.
- **`chisel init <target>`** — on a linked path it would write: non-zero
  exit, zero writes.
- **The `chisel-upgrade` skill** — read by an agent; its contract is the
  intention sections above.

## Architecture

**System design:** a pre-flight runs before the first write of `init` and
`update`: it computes every path the command would write, checks each one
and each of its parents inside the target with `lstat`, and refuses with
the full list when any is a link. `update` first requires a manifest, and
computes its write set from the shipped list intersected with what stays
inside `.agents/` or what the previous manifest listed. The recipe lives in
the skill directory: `SKILL.md` routes, and each intention is its own file
beside it.

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Implementation Decisions

- **Refuse rather than repair.** When the CLI does not recognise what it
  sees, it stops before writing anything. Partial writes are worse than
  none.
- **The adapter link `.claude/skills` is chisel's own.** The pre-flight
  checks the paths chisel writes, under `.agents/`, `project-management/`,
  `scripts/` and `AGENTS.md`, not the adapter link, which points into
  `.agents/skills/` and is never written through.
- **The first-version guard stays** as it is; the manifest rule catches
  the relocated case without enumerating layouts.
- **Messages name the recipe by its path**,
  `.agents/skills/chisel-upgrade/SKILL.md`, and, for a repo without
  `.agents/skills/` yet, the command that fetches the reference tree.
- **Writing rules of `discipline.md`** apply to the recipe: named things,
  no section codes in prose, one fact in one place.

## Testing Strategy

- Tree snapshots before and after each refusal, including the
  destinations of the links.
- One fixture for the relocated layout, built in the test from plain
  files and `Deno.symlink`, not committed links.
- The recipe is prose: its shape is checked by reading, at the review, not
  by a test that pins its wording (rule 1 of `test/TESTS.md`).

## Slices & Dependencies

- **Slices:** one pass.

## Deliverables

- [ ] The pre-flight and the manifest rule in `src/`.
- [ ] The tests and the fixture.
- [ ] `chisel-upgrade` as intentions.
- [ ] The journal entry.

## References

- `src/install.ts`, `writePackaged` and `refuseV1Layout`: the plain write
  and the guard that missed the case.
- `src/update.ts`: where the manifest is read with an empty fallback.
- Lonestone boilerplate, `.boilerstone/migration-intentions/TEMPLATE.md`
  and `v1.1.0/00-adopt-conventional-commits.md`: the intention format and
  a worked example.
- `socle/agents/skills/chisel-upgrade/SKILL.md`: the recipe to rewrite.
- `project-management/JOURNAL.md`, entries 37 to 43: what 0.2.x changed.

## Notes

Apollon's report, 2026-11-02 (Architect's summary): the update created
`.agents/{discipline,methodology,workflow,reference}.md`, a root
`project-management/` with the two templates, `.agents/.chisel.json` and a
`deno.lock`; rewrote 15 skills through the links, `AGENTS.md` and
`scripts/task-id.sh`; left 8 skills it never installed alone
(`review-videos`, `project-release`, `finalize-pr`, `triage` among them).

## Retrospective

Added at the close.
