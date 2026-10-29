---
name: chisel-upgrade
description: Move a repo equipped with an older chisel to the current layout — from the first version's layout (`.agents/rules/`, `workflows.md`) or from a 0.1.x install (formulas, presets, role profiles, rendered agent definitions, thirteen statuses). One step at a time, the human validating each one; the archive is never touched.
disable-model-invocation: true
---

# Upgrade to the current layout

The current socle has one prose workflow (`.agents/workflow.md`), four
roles (Architect, Crewmate, an optional Typist, the reviewers of
`code-review`), seven statuses, and one tracker section in the glue. A repo
equipped with an older chisel carries pieces that are gone. This skill moves
it, from either of two starting points:

- **The first version's layout** — three rule files (`.agents/rules/task-*.md`)
  and a visual guide (`.agents/workflows.md`). `chisel update` REFUSES such a
  repo: updating it would leave two normative discourses side by side.
- **A 0.1.x install** — the formulas and their five presets
  (`.agents/formulas/`), the role profiles (`.agents/profiles/`: Foreman,
  Architect, Checker, Mason, Inspector), the agent definitions rendered from
  them in `.claude/agents/` and `.codex/agents/`, the thirteen-status ladder,
  and a glue with §B1 and §B2. `chisel update` accepts it and removes the
  retired files it installed unchanged; what it cannot touch — the glue, the
  task statuses, the project's own text — is this skill's.

It is a migration, not a command: **you move one thing at a time and the
human validates each move**. Run it from the repo being migrated.

## What is never touched

Say this out loud at the start, and hold to it:

- **The archive.** Every archived task keeps its bytes.
- **The content of open task files.** Only their `**Status:**` line may
  change, by the migration tables below, after the human's yes.
- **The project's own glue values.** §A's paths, the reading list, the gate
  commands stay answered. The migration rewrites §B into the tracker section,
  drops retired §E lines, and changes the journal's name on the first-version
  path.
- **Anything outside `.agents/`, the glue, the task workspace and
  `AGENTS.md`.** Source code, CI, git history: out of scope.

## Step 0 — Preconditions

1. **Find the starting point.** The first version, if `.agents/rules/` or
   `.agents/workflows.md` exists. A 0.1.x install, if `.agents/.chisel.json`
   names a version starting with `0.1.`, or `.agents/formulas/` or
   `.agents/profiles/` exists, or the glue has a `### B1 ·` heading. Neither:
   the repo is current — stop, say so, and run
   `deno x jsr:@lonestone/chisel update` instead.
2. **Require a clean working tree** (`git status --porcelain` empty), so the
   human can read one diff and revert it in one command.
3. **Say what is about to happen**, in three lines, then wait.

## Step 1 — Inventory, stated as facts

Gather it all, then state it as a short table:

- which retired files are present (rules, `workflows.md`, formulas, profiles,
  definitions in `.claude/agents/` and `.codex/agents/`);
- what §A of `.agents/project.md` declares, and the journal's path;
- which glue sections exist (§B1, §B2, §B3, §E's adapter lines, §H);
- the open task files and their status values, and the number of archived
  files (checked again at the end);
- whether `.beads/` exists, and whether `.beads/formulas` is a symlink;
- what `AGENTS.md` says outside the `chisel:begin` / `chisel:end` markers.

Facts are stated; only genuine decisions are asked.

## Path A — from the first version

1. **Retire the layer.** List the exact files found, wait for the yes, then
   `git rm .agents/rules/task-*.md .agents/workflows.md` (only what exists).
   The rules directory must not survive: a rule someone added locally is the
   project's — name it and ask where it should move (usually a project
   instruction outside the managed block of `AGENTS.md`).
2. **Rename the journal.** The current default is `LOG.md`; the first
   version called it `CHANGELOG.md`, which collides with a release changelog.
   `git mv` it, point §A's changelog line at the new name, and leave its
   content alone. No journal yet: point §A at `LOG.md` and let the installer
   create it.
3. **Install the current layer:** `deno x jsr:@lonestone/chisel init .`. It
   poses the socle, rewrites the managed block of `AGENTS.md`, and leaves the
   glue as it is. If the task workspace is not `project-management/`, delete
   the `project-management/LOG.md` the installer seeded there — two journals
   is what this step exists to prevent — and say so.
4. **Complete the glue** with `.agents/skills/chisel-setup/SKILL.md`: its §B,
   §H and personal-file steps, one question per message, written back one
   section at a time. Add §E with each adapter ticked from what is in place.
5. **Move the statuses** of open task files by the first-version table below.

## Path B — from a 0.1.x install

1. **Run `deno x jsr:@lonestone/chisel update`.** It removes every retired
   file it installed unchanged — formulas, profiles, rendered definitions —
   with a `removed:` line each, and rewrites the managed block. An
   `orphaned:` line is a retired file someone edited: show it, and ask
   whether its content moves into a project instruction or goes. A `stale:`
   line names a glue residue step 2 takes care of.
2. **Rewrite the glue's §B into the tracker section.** Replace §B1, §B2 and
   any §B3 with one `## B · Tracker` section, using chisel-setup's §B screen
   with the old answers as the recommendation: statuses in the task files →
   the default; a committed database → beads; an external tracker named in
   §B2 → that tracker and its connector. Drop the `.claude/agents` and
   `.codex/agents` lines from §E. Every byte outside those spans stays.
3. **Move the statuses** of open task files by the 0.1.x table below — a list
   of old → new for the human first, then the edit. With beads, also:
   re-declare `bd config set status.custom "draft:active,done:done,cancelled:done"`,
   move each open bead off a retired value with `bd update <id> --status`,
   and remove the `.beads/formulas` symlink (`git rm .beads/formulas`).
4. **A profile the project wrote itself** in `.agents/profiles/` was never
   installed by chisel, so `update` left it. Its content is a project
   instruction: propose moving it into `AGENTS.md`, outside the markers, then
   remove the directory.
5. **The project's own words.** List every line outside the managed block of
   `AGENTS.md`, and in the README or CI, that names a retired piece — the
   Foreman, a formula or preset, a profile, the Checker, the Mason, the
   Inspector — with its replacement: the Architect, `.agents/workflow.md`,
   the Crewmate or the Typist, the reviewers of `code-review`. Fixing them is
   the human's decision, line by line.

## The migration tables

**From a 0.1.x install** (thirteen statuses → seven):

| Old | New |
|---|---|
| `creating`, `waiting-business-approval`, `waiting-design-approval` | `draft` |
| `ready` | `ready` |
| `planning`, `waiting-plan-approval`, `in-progress`, `waiting-diff-approval` | `in-progress` |
| `done` | `done` |
| `blocked`, `stalled` | `blocked` |
| `deferred` | `deferred` |
| `cancelled` | `cancelled` |

A task moved from `waiting-plan-approval` keeps its plan unapproved: say so
on its work document's `**Plan:**` line.

**From the first version** (a coloured circle before one of six words; the
free text after the word is kept):

| Old | New |
|---|---|
| Not Started | `draft` or `ready`, by the real state of the spec — `blocked` when a named dependency holds it, `in-progress` for a parent whose slices are partly done |
| In Progress | `in-progress` |
| Blocked | `blocked` |
| Complete / Done / Delivered | `done` |
| Deferred | `deferred` |
| Cancelled | `cancelled` |

## Verify

Run, and show the results:

1. `deno x jsr:@lonestone/chisel check` — clean.
2. `deno x jsr:@lonestone/chisel update` — accepted, with no `removed:`,
   `orphaned:` or `stale:` line left to act on.
3. `git diff --stat` on the archive — empty. A changed archived file is a
   failed migration: revert it.
4. A search of the repo's own text for the retired names and paths — what is
   left is listed for the human.

## Hand over

1. Show the human the full diff; their reading of it is the validation of
   the whole migration.
2. Once accepted, add one dated entry to the journal: what was retired, what
   is now in place.
3. Commit it as one commit, on exact paths — never `git add -A`.

Then say what changed for whoever works here next, in three lines: the
ambient core applies to every session; real scoped work follows
`.agents/workflow.md`, with the Architect as the default role; the tracker
section of `.agents/project.md` says where tasks live.
