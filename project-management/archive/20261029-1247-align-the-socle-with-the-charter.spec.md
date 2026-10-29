# Align the socle with the charter

**Status:** done
**Created:** 2026-10-29 by the Architect, on the Owner's "Je te laisse faire ça"
**Governing page:** `CHARTER.md` (it wins over anything below that disagrees)

## Context

On 2026-10-29 the Owner recentred chisel (`CHARTER.md`, decisions record
Addenda 15 and 16): chisel processes one task, from plan to commit, with
the tracker update and the pull request in scope; it does not orchestrate.
The workflow is prose. Roles are Architect, Crewmate, an optional Typist,
and the reviewers inside `code-review`. The Foreman, the formulas and their
five presets, the role profiles (with the Checker and the Inspector), the
thirteen-status ladder and beads as a coordination layer go away.

The socle on branch `v2` still ships all of that. JSR serves 0.1.1, the
socle of 2026-09-10, and at least one repo (idbyrivoli) installed it. So
the next version must also clean a 0.1.1 install through `chisel update`.

## Scope

In:

- The socle under `socle/`: doctrine files, templates, the glue template,
  the managed `AGENTS.md` block, every skill that names a retired piece.
- The CLI under `src/` and its tests: stop copying formulas and profiles,
  stop rendering agent definitions, clean them out of a 0.1.1 install.
- `README.md`, `PHILOSOPHY.md`, this repo's `AGENTS.md`, the changelog.

Out:

- Publishing, and merging into `main`: the Owner's acts.
- A docs axis in `code-review` (note of 2026-10-12): separate task.
- A skill for Plane: Plane is reached through its MCP, named in the glue.
- The dogfooding task and the deferred pilot migration.

## Decisions already taken (by the Architect, within the charter)

1. **One prose page for the workflow: `.agents/workflow.md`.** It says the
   steps of a task from intent to commit and pull request, who does each,
   where the Crewmate stops for the Architect, where the Architect stops
   for the human, and where the tracker is read and updated. It holds the
   Crewmate brief and the Typist brief, a few lines each, and the rule for
   launching a sub-agent (charter objective 3). `methodology.md` keeps only
   the *why* sections that still hold. Whether `reference.md` survives or
   folds into the two is the Crewmate's call.
2. **Doctrine budget: 600 lines.** `discipline.md`, `workflow.md`,
   `methodology.md` and `reference.md` (if kept) together. Today the
   equivalent is about 2,600 lines with formulas and profiles. The first
   version ran on about 670.
3. **Seven statuses** for a task file: `draft`, `ready`, `in-progress`,
   `done`, `blocked`, `deferred`, `cancelled`. Plan approval happens inside
   `in-progress` and shows in the work document. A migration table maps the
   thirteen old values: `creating`, `waiting-business-approval`,
   `waiting-design-approval` → `draft`; `planning`, `waiting-plan-approval`,
   `waiting-diff-approval` → `in-progress`; `stalled` → `blocked`; the
   rest keep their name.
4. **Typist replaces Mason everywhere.** No file says Mason, Foreman,
   Checker, Inspector, formula or preset afterwards.
5. **The tracker is one section of the glue.** `.agents/project.md` says
   where tasks live (files, beads, Plane, other) and which skill or tool
   reads and updates them. `chisel-beads` shrinks to that adapter role for
   beads: read a task, set its status, comment, link. Its status mapping
   uses the seven values.
6. **The migration skill becomes `chisel-upgrade`.** It moves a repo to the
   current layout from either the first version's layout (`rules/`,
   `workflows.md`) or a 0.1.x install. The CLI's refusal message names it.
7. **Two rules move to `discipline.md`**, since their home `foreman.md`
   goes: merging and publishing wait for the human's explicit word on that
   very action; `seam` and the glossary's words are never translated.
8. **`deno.json` stays at 0.2.0.** Nothing was published under it.

## Acceptance Criteria

- [x] **Retired words are gone.** A case-insensitive search for `foreman`,
      `mason`, `formula`, `preset`, `inspector` and the role `checker`
      across `socle/`, `src/`, `test/` (fixtures included), `README.md` and
      `PHILOSOPHY.md` finds nothing but deliberate mentions in the
      migration skill and its migration table.
- [x] **Retired files are gone.** `socle/agents/formulas/`,
      `socle/agents/profiles/` and `src/render.ts` no longer exist. No code
      writes `.claude/agents/` or `.codex/agents/`.
- [x] **The workflow page exists and matches the charter**, per decision 1.
- [x] **The doctrine fits the budget** of decision 2, counted with `wc -l`.
- [x] **Seven statuses**, per decision 3, used consistently in templates,
      glue, skills and the migration table.
- [x] **The glue has one tracker section** and `chisel-beads` is at most
      120 lines across its files, per decision 5.
- [x] **A 0.1.1 install is cleaned by `chisel update`.** A test poses the
      0.1.1 shape (formulas, profiles, generated definitions in
      `.claude/agents/` and `.codex/agents/`, manifest listing them), runs
      update, and sees each unchanged file reported `removed:` and gone.
- [x] **`chisel-upgrade`** exists per decision 6; `upgrade-v2` does not.
- [x] **`README.md` and `PHILOSOPHY.md` say what the charter says.** The
      README also shows how to pin a version, for example
      `deno x jsr:@lonestone/chisel@0.1.1 init`.
- [x] **Green.** `deno task test` and `deno task check` pass;
      `deno publish --dry-run --allow-dirty` succeeds; the golden tree is
      regenerated and matches.
- [x] **Recorded.** Changelog entry 37 says what 0.2.0 now contains and
      how a 0.1.1 repo moves to it. This repo's `AGENTS.md` names Crewmate
      and Typist, not Mason.
- [x] **Reviewed.** `code-review` has run on the full diff with fresh
      reviewers, and its findings are fixed or answered in the work
      document.

## Seams

- `chisel update` on a 0.1.1-shaped target: the files it reports and the
  tree it leaves. That is the only behaviour change a user sees from the
  CLI.
- `chisel init` on an empty target: the golden tree.

## Notes

- The work document beside this file holds the plan, then the worklog.
- Commit on `v2` with explicit paths. Never `git add -A`. Do not push: the
  Architect pushes after reading.

## Retrospective

Closed by the Crewmate, 2026-10-29. Criteria checked against `HEAD`:
23 tests green, `deno task check` clean, `deno publish --dry-run
--allow-dirty` succeeds, doctrine 533 lines, `chisel-beads` 114 lines.
The retired-words search finds, outside `chisel-upgrade`, only deliberate
mentions: the 0.1.1 cleanup test and its `test/TESTS.md` row (they must
name the 0.1.1 shape), the integrity waivers for the paths
`chisel-upgrade` cites, and the vendored GLOSSARY sentence the Architect
accepted. No evergreen material to promote: this repo has no living docs
outside the socle, which is itself the deliverable.

Proposals for the Architect (from `retro`):

- **The integrity test only checks paths, not glue section names.** Two
  skills kept pointing at glue sections that were gone, and only the Spec
  reviewer caught it. Proposal: a test that every `§X · Title` cited in the
  installed socle exists as a heading in the glue template (a structural
  check, not a wording check).
- **The retired-name test breaks rule 1 of `test/TESTS.md`.** It predates
  this task. Proposal: decide whether to keep it as a named exception in
  `TESTS.md` or remove it.
- **The plan step and the approval corrections.** The plan body kept the
  superseded design next to the corrections, which a reviewer flagged.
  Proposal: when the Architect corrects a plan, the Crewmate revises the
  design in place rather than only prepending the corrections.

