# Migrate the two pilots to the installed socle, and read the parity back

**Status:** deferred (2026-09-15) — the Owner is not yet sure of what chisel v2 delivered and will not migrate a pilot before that is settled; nothing depends on this task

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before any code.

## Context

Two earlier slices asked for the same act and both waited on it: slice 06 of
the chisel v1 task ("Pilot migration + Cursor reliability test") and the two
human criteria of slice 06 of the chisel v2 task ("upgrade-v2 skill +
LOG.md, pilot migration = parity check", its Notes carry the handoff to the
Owner). Both parents were otherwise finished; on 2026-09-15 they were
closed and this standalone task took over what only the Owner can do: it
needs the Owner's real repos and a real human validating a real diff. This
task is the Owner's.

## Scope

**Included:**
- The two pilots, `music-downloader` and `evea-ai`, equipped through the
  published package (`deno x jsr:@lonestone/chisel`, then the `chisel-setup`
  questionnaire in a session) — a v1-equipped one through the `upgrade-v2`
  skill — with the old socle copies (`doc/agents/`, `.cursor/rules`)
  removed and the existing tasks, changelog and archive left byte-intact.
- A parity session on a migrated pilot, logged against the parity checklist
  of the upgrade-v2 skill: no missing step, no missing gate, artifacts that
  conform, the sliced case exercised.
- The routing test in fresh sessions, Claude Code and Cursor: ambient →
  propose a task → create → work, from `AGENTS.md` alone. If Cursor proves
  unreliable, the documented fallback (thin `.mdc` shims posed by `init`)
  is activated, and the verdict lands in this repo's README.

**Not Included:**
- Any change to the socle beyond the Cursor verdict line in the README and
  whatever the parity session reveals, which becomes its own task.

## Acceptance Criteria

- [ ] **pilots-equipped** — both pilots carry `.agents/` and `chisel check`
      is clean in each; the old socle copies are gone; `git log` on their
      task workspaces shows no rewrite of existing files.
- [ ] **parity-logged** — one parity session on a migrated pilot is logged
      in that pilot's journal against the checklist, with every step and
      gate accounted for.
- [ ] **routing-verified** — the fresh-session routing test passes on each
      pilot in Claude Code and in Cursor, or the shim fallback is enabled
      and the README says so.

## Seams

- Seam 1: the published package and the pilot's repo — the installed tree
  matches the golden tree and `check` is clean.

## Architecture

**System design:** nothing new; this task runs what the socle ships, on the
repos it was made for, and reads the result back.

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Notes

Carried over from the two slices it supersedes, both archived with their
parents on 2026-09-15: the v1 slice's three criteria (rewritten above for
the Deno invocation, `npx` being gone), and the v2 slice's AC3 and AC4 with
the "Handoff to the Owner" section of its Notes, which stays readable in the
archive.
