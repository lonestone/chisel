# 02 — Install arranges what it finds — work

Created by the Crewmate at the plan step, 2026-11-03. Spec:
`project-management/tasks/20261102-1543-updates-read-intentions/02-install-arranges-what-it-finds.spec.md`.

**Plan:** waiting for the Architect's reading.

## Program Design

### When `init` looks

`init` looks for what the repo already has **only when the repo has no
manifest**. A repo with a manifest is one chisel installed: its `AGENTS.md`
carries the markers, its `project-management/` holds the skeleton chisel wrote,
and looking there would stage every re-run of `init`. A re-run keeps today's
behaviour, exit 0.

### What `init` looks for

A new module `src/inventory.ts` exports
`takeInventory(targetDir): Promise<Found[]>`, where a `Found` is
`{ kind, path }`. It reads only, it is cheap (a few `stat`s and two file reads),
and it never judges: it names. Kinds, in the order printed:

| Kind                 | Found when                                                                                                                     |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| OpenSpec             | `openspec/` is a directory                                                                                                     |
| Spec Kit             | `.specify/` is a directory, or some `specs/<name>/spec.md` sits beside a `plan.md` or a `tasks.md`                             |
| task folder          | `project-management/`, `doc/project-management/`, `docs/project-management/` or `tasks/` holds at least one file, at any depth |
| decision records     | `docs/adr/`, `doc/adr/`, `adr/` or `decisions/` is a directory                                                                 |
| glossary             | `CONTEXT.md` is a file                                                                                                         |
| other agent's rules  | `.cursor/rules/` or `.windsurf/` is a directory, or `.github/copilot-instructions.md` is a file                                |
| instructions file    | `AGENTS.md` holds text outside chisel's markers besides its title; `CLAUDE.md` holds anything but blank lines and `@AGENTS.md` |
| beads                | `.beads/` is a directory                                                                                                       |
| first chisel version | `.agents/rules/` or `.agents/workflows.md` (the existing `v1LayoutFound`)                                                      |
| linked path          | a path `init` would write is a symlink (the existing `linkedPaths`)                                                            |

Two rows go beyond the spec's list, both on purpose:

- **The first chisel version.** Today `init` on such a repo copies the current
  socle beside the old one, which is exactly what `update` refuses to do. It is
  a method the repo already has; placement is where it is sorted.
- **A linked path.** Slice 01 kept `init`'s link refusal at exit 1 "until slice
  02". It becomes a staging signal, as it already is for `update`: the agent can
  resolve where the link points with the human.

### What `init` does on a signal

It writes nothing outside the workspace and exits 3, as `update` does:

```
chisel init: <target> already has a method of its own — staged .chisel-workspace/
found: OpenSpec — openspec/
found: task folder — project-management/
found: instructions file — AGENTS.md
next: run the setup skill, reference/.agents/skills/chisel-setup/SKILL.md, from .chisel-workspace/
```

The workspace is the one of slice 01, built whole or not at all by
`stageWorkspace`, now taking a session kind:

- `.gitignore` (`*`), `reference/` (the socle posed in an empty directory), no
  `intentions/` (a first install records everything, nothing is pending).
- `session.md` titled `# Chisel install session`, with `## What init found` (one
  checklist line per item: kind, path) and `## Next` naming the setup skill's
  placement step.

An existing workspace makes `init` refuse, exit 1, as it makes `update` refuse:
a staged session is never overwritten.

### How the agent finishes the install

`chisel init --arranged <target>` skips the inventory and installs as today. It
still refuses a linked path (exit 1): after placement a link left in place is a
mistake. The setup skill runs it once the human has ruled, and nobody else needs
it; the usage line names it.

A flag is the narrowest seam I see. The alternatives — reading the session's
rulings back, or the skill moving the files away before a plain `init` — either
make `init` parse the agent's prose or force a move the human may have refused
("keep in place").

### The setup skill gains a placement step

`chisel-setup` gets a **Step 0 — Placement**, run when there is no manifest and
`.chisel-workspace/session.md` is an install session (the current Step 0
precondition otherwise stands):

1. Read the session. For each found item, read enough of it to recommend.
2. Put the items to the user **one at a time**, each with one recommended
   placement among three, said in the user's words:
   - **keep in place** and point chisel's project file at it (§A for a task
     folder, §G for decisions and a glossary, §C for the rest);
   - **migrate** it into chisel's format (tasks into
     `project-management/tasks/`, an instructions file through Step 7);
   - **leave it alongside**, untouched and unreferenced. A recommendation table
     per kind tells the agent where to start (OpenSpec and Spec Kit: keep in
     place; a task folder already named `project-management/`: keep in place; an
     instructions file: keep, sorted by Step 7; a linked path: resolve with the
     user before anything else).
3. Delete the workspace, run `chisel init --arranged .`, then write **only what
   was accepted**: the pointers into `project.md` are the §A/§C/§G writes of
   Step 4; a migration moves files with `git mv`. Nothing is written for "leave
   alongside".
4. Continue with Step 1, the rulings already standing as facts.

The skill's description says it now also arranges what a fresh install finds.

### What the tests become

The `brownfield` fixture carries a hand-written `AGENTS.md` and `CLAUDE.md`, so
`init` on it now stages. The tests that use it mean "a repo chisel installed",
not "a repo with a method": `workspace.install` runs `init --arranged`, and the
`init` tests on `brownfield` (golden tree, idempotence, journal, intentions
baseline) run `init --arranged` too. The behaviour they pin does not change.

New tests, in `test/arrange.test.ts`, red first, in this order:

1. **fast-install** — `init` on an empty directory exits 0 and leaves the golden
   tree minus the root files (the existing boilerplate fixture has no signal
   either).
2. **stage-not-write** — `init` on `brownfield` exits 3, nothing outside the
   workspace moved, no manifest, `session.md` names `AGENTS.md` and `CLAUDE.md`,
   stdout names the setup skill's path.
3. **signals-detected** — one table-driven test: a directory per row of the
   table above (built in the test, a few files each), `init` exits 3 and names
   that kind and that path. Plus the counter-cases: an empty `tasks/`, a
   `CLAUDE.md` that is only `@AGENTS.md`, a `specs/x/spec.md` alone.
4. **re-run** — `init` on an installed repo (manifest present) exits 0.
5. **workspace kept** — `init` with a workspace present exits 1.
6. **arranged** — `init --arranged` on `brownfield` installs; on a linked path
   it still exits 1.

The moved guard tests ("init refuses a linked skill / a linked CLAUDE.md / a
relocated layout") become exit 3 with nothing written. **placement-proposed** is
prose in a skill: no test pins it (the suite tests behaviour, never prose); the
dogfood exercises it.

### The dogfood

On the chisel repo, from this branch: `deno run -A src/main.ts init .` must
stage, naming `project-management/` and `AGENTS.md`. I then run the placement
step as the skill says, **asking you the rulings** (they are Pierrick's: this is
his repo's method), run `init --arranged`, apply them, commit `.agents/`,
`.claude/skills` and the glue (the Owner's 2026-08-26 ruling), and run
`chisel check`. Known collisions to put to you then:

- `project-management/000-template.{spec,work}.md` differ from the socle's only
  by their links (`../socle/agents/X.md` against `/.agents/X.md`); `init`
  overwrites them with the socle's, whose links now resolve.
- `scripts/task-id.sh` is overwritten by the socle's copy (the same script, to
  be diffed).
- `AGENTS.md` gains the block; Step 7 sorts the hand-written bullets.

The old task `20260826-2302-chisel-dogfoods-itself` is then marked cancelled
with a pointer to this slice.

### Documents

README (init's exit 3 and `--arranged`), `test/TESTS.md` (the new group), the
usage text in `src/main.ts`.

## Worklog

## Implementation Checkboxes

- [ ] Plan approved
- [ ] Helpers and existing tests move to `init --arranged`, suite green
- [ ] fast-install and stage-not-write, red then green
- [ ] signals-detected table and counter-cases, red then green
- [ ] re-run, workspace kept, arranged, moved guard tests
- [ ] Setup skill placement step, README, usage, TESTS.md
- [ ] Dogfood on the chisel repo, old dogfood task cancelled
- [ ] code-review, findings answered
- [ ] Close: criteria, archive, journal, retro

## Notes & Snippets

## Diff-Review Findings
