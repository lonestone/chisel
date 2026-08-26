# 09 — Test suite rebuild: behavior only, three files, hard cap

**Status:** 🔴 Not Started
**Blocked by:** None (06 merged). Runs before 05-redo and 07.

**What to build:** The test suite shrinks to what tests BEHAVIOR, split at
the real seam. Spec approved by the Owner (audit decision round,
2026-08-26): *« Supprime la prose, check des magic strings c'est merdique »*.
Sources (the plan already exists — follow it, do not re-plan):
`../factory-bench/research/audit-tests-dur.md` (what to delete, the 5-step
migration plan) and `../factory-bench/research/architecture-report-chisel.html`
(the 3-file structure, the pristine-install fixture).

Target structure:

- `test/lib.sh` — helpers only (assert_*, run_chisel, fresh_install: one
  cached pristine install + `cp -R` per group, so groups are
  order-independent, no shared mutable fixture).
- `test/installer.sh` — the behavioral groups: current 1-6 (init layouts,
  idempotence, update, check, npx), 11 (guards), 12 (referential integrity,
  waiver table kept until slice 07), plus the few structural checks that
  test chisel.sh behavior: formulas parse as TOML with the right gate count
  per preset (3/1/0, by PARSING, never by grep), renders carry the profile
  body verbatim (byte comparison), `update` leaves a hand-written
  `.agents/user.md` intact.
- `test/run.sh` — a runner of ~60 lines: runs everything by default, one
  group by name on demand (`bash test/run.sh guards`), prints PROTECTS
  lines and the `N scenarios, M assertions` summary, and FAILS if the
  suite's total line count exceeds 600.

DELETED, permanently: group 10 (setup questionnaire prose), group 13
(neutrality greps), every prose/magic-string assertion in groups 7-9 (word
pins, wording checks, W-label greps). An AC written as a grep is verified
once at review time and never committed as a test.

`test/TESTS.md` rewritten: the group table, plus the three standing rules —
behavior only (CLI seam or parsed structure); net +10 assertions max per
slice, no new group without a deletion; 600-line cap enforced by the runner.

## Acceptance criteria

- [ ] Three files as above; `bash test/run.sh` green; `bash test/run.sh
      <group>` runs exactly one group
- [ ] Total assertions ≤ 120; total test lines ≤ 600 (runner-enforced,
      proven by a temporary +lines probe)
- [ ] Zero grep-on-prose assertion left (no needle that pins a sentence of a
      markdown file; parsed-structure checks are fine)
- [ ] Groups pass in any order (shuffle two groups manually once)
- [ ] TESTS.md current: table + the three standing rules
- [ ] Every deleted assertion is listed in this slice's Notes with one
      reason each (bulk reasons allowed per family)

---

> 🧑 **REVIEW IF RELEVANT** — design.

## Design — persisted at plan time

The plan IS the two audit documents (migration plan §6 of audit-tests-dur +
target structure of the architecture report). Owner-approved 2026-08-26.
The Mason executes; deviations require escalation, not improvisation.

Execution order (commit at EACH green step — never all-or-nothing):
1. `lib.sh` extracted + runner skeleton, old groups still wired → green → commit.
2. Behavioral groups migrated into `installer.sh` → green → commit.
3. Deletions (10, 13, prose of 7-9) → green → commit.
4. Cap + selective run + TESTS.md → green → commit.

---

> 🤖 **AGENT ZONE**

## Notes

_Deleted-assertion ledger and worklog go here. Keep the worklog under 40
lines._
