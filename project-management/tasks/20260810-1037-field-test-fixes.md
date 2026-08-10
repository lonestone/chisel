# Field-test fixes — gcs-monorepo dry-run findings

**Status:** 🟢 Complete
**Effort:** S (one-shot)

---

> 🧑 **REVIEW CAREFULLY** — short, decision-rich.

## Context

First real-world dry-run of the full install flow (2026-08-10, on
`gcs-monorepo`, a pnpm monorepo with no prior agent setup): `init`, `check`
and the `chisel-setup` questionnaire all worked end-to-end, and surfaced
four findings. Two are chisel defects fixed by this task; one is a D5
decision to reopen (tracked below, NOT fixed here); one belongs to the
target repo's team.

## Scope

**Included**
1. `socle/templates/AGENTS-block.md`: the opening self-doc comment is copied
   verbatim into equipped projects' AGENTS.md, where it reads as nonsense
   ("this file is the source text… copied into your AGENTS.md" — read from
   inside that very AGENTS.md). Reword it context-neutral: keep the
   ownership contract (edit outside the markers), point to the socle file
   as the place to change the block for everyone.
2. `bin/chisel.sh init`: §E (Adapters) of the `project.md` it poses stays
   `- [ ]` — init never fills the inventory it claims to write (slice 03's
   Design said "written by init"). Fix: when init CREATES `project.md`,
   tick each adapter line that is actually in place. A pre-existing
   `project.md` is project-owned and stays untouched.

**Not included**
- GitLab Issues as a wired tracker option (§B offers local | GitHub |
  Plane; gcs is GitLab-hosted) — reopens decision D5-B, awaiting Pierrick's
  call.
- gcs-monorepo repo fixes (malformed typecheck script, api-only test gate)
  — their team's code.

## Acceptance criteria

- [x] A fresh `init` produces an AGENTS.md whose block comment reads
      correctly in the equipped project (no "source text" meta talk)
- [x] A fresh `init` produces a `project.md` §E with `- [x]` on every
      adapter actually posed; a pre-existing `project.md` is not touched
- [x] `test/run.sh` asserts both and passes

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

Typed directly by the planner (S one-shot, no typist delegation).

### Worklog (2026-08-10)

- `socle/templates/AGENTS-block.md`: comment rewritten context-neutral —
  ownership contract first, "edit outside the markers for this project /
  edit the socle file for every project". Reads correctly both in the socle
  and inside an equipped AGENTS.md. Body: "This file only routes" → "This
  block only routes" (same context fix).
- `bin/chisel.sh`: `ensure_project_md` now prints `created` when it writes
  the file; `cmd_init` calls the new `tick_adapter_inventory` ONLY in that
  case — a pre-existing `project.md` is project-owned and never touched.
  The tick checks each adapter's real state (markers present, `@AGENTS.md`
  line, symlink target) and flips only the matching `- [ ]` lines inside §E.
- `test/run.sh`: 8 new asserts — §E ticked in `assert_full_layout` (both
  fixtures), plus a re-init scenario proving a hand-unticked §E line
  survives (ownership). 79/79 pass.
- Bonus defect found while verifying: `assert_file_contains`/`_not_contains`
  called `grep -qF "$needle"` without `--` — any needle starting with `-`
  (like `- [x] ...`) was parsed as a grep OPTION. The 7 initial "failures"
  of the new asserts were this test-harness bug, not the feature. Fixed
  with `grep -qF --`.
- Field-validation on gcs-monorepo (working tree only, no commit there):
  `chisel update` refreshes the managed block to the new wording and leaves
  `project.md` (filled by the questionnaire) untouched.
