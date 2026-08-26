# 08 — Post-audit hardening: installer guards, test legibility, supervised preset, proposal door

**Status:** 🔴 Not Started
**Blocked by:** None (01–04 delivered) — **runs BEFORE 05 and 06** (it
reorganizes the test suite they will grow)

**What to build:** The corrective slice from the adversarial audit
(`../factory-bench/research/audit-fable-v2.md`) plus the Owner's round of
decisions (parent Notes, "Audit round"). Four bundles:

1. **Installer guards** (both bugs proven live by the audit): `chisel update`
   on a v1 layout (a repo that still has `.agents/rules/` or
   `.agents/workflows.md`) REFUSES with a clear message pointing to
   `upgrade-v2` — it must never leave two normative discourses side by side.
   And a file chisel did not write in `.agents/skills/` is NEVER adopted as
   managed by `update` (warn, leave alone) — the same discipline
   `.claude/agents/` already applies via its marker; the bd-init case (a
   foreign `beads/` skill dir) is the fixture.
2. **Test suite legibility** (the Owner's explicit complaint + audit finding
   5): every group opens with a `PROTECTS:` line printed at run time; the
   final summary counts SCENARIOS (groups) alongside assertions; tautological
   asserts (copied-file-exists ×2 fixtures) pruned or folded; the three
   neutrality scans unified on the one shared regex; a `test/TESTS.md`
   one-pager (group → what it protects → what a failure means) — THAT is the
   Owner's review surface, not the sh. Plus the missing test the audit
   proved: **referential integrity** — every internal pointer in the
   installed socle resolves to an existing file (would have caught the
   dangling `rules/` pointers).
3. **The `chisel-supervised` formula** (Owner decision, human-ON-the-loop):
   third preset, same steps byte-identical to the other two, exactly ONE
   human gate — spec approval, sitting on the `plan` step — plan approval
   and review arbitration handled as in auto (Architect persists, Inspector
   arbitrates). Works degraded without beads: stop at the gate, status
   `awaiting approval`, fresh session resumes after the human edits.
   Invariant tests become three-way (same step ids, bodies identical,
   gate-set is the only diff: default = 3, supervised = 1, auto = 0).
4. **The proposal door in the profiles** (Cursor-article insight, Owner
   decision): `mason.md` — when the work reveals a needed change beyond the
   persisted plan (touching core code, structure), PROPOSE it upward to the
   Architect; never silently do it, never silently drop it. `architect.md` —
   rule on Mason proposals; when the magnitude exceeds what you authored
   (contests the spec's owner's zones), escalate to that owner. Without an
   explicit door, agents never propose large improvements and quality decays.

Also, one wording defer (Owner decision Q-b): the B1 questionnaire's option 3
(shared background service) is marked **deferred** — shown as "not supported
yet, ask when you need it", not offered as a pickable option.

## Acceptance criteria

- [ ] `chisel update` on a v1-layout fixture exits non-zero with a message
      naming `upgrade-v2`; on a v2 layout it behaves as before (tested)
- [ ] A foreign file/dir planted in `.agents/skills/` survives `update`
      untouched and un-adopted, with a warning; `check` does not flag it
      (tested with a `beads/`-like fixture)
- [ ] Referential integrity: a suite-wide test walks every internal socle
      pointer (installed tree) and fails on any target that does not exist —
      it FAILS on a fixture with a planted dangling pointer (mutation-tested)
- [ ] `bash test/run.sh` prints one `PROTECTS:` line per group and a final
      `N scenarios, M assertions` summary; `test/TESTS.md` exists, one page,
      current; the suite stays green throughout
- [ ] `socle/agents/formulas/chisel-supervised.formula.toml` ships and is
      installed by `init`; three-way invariants green; a no-bd walkthrough
      stops exactly once (spec gate) and runs through the rest
- [ ] `mason.md` and `architect.md` carry the proposal door (proposal upward,
      ruling, escalation to the zone's owner); renders re-generated; wording
      ledger- and vendor-neutral
- [ ] B1 option 3 displayed as deferred; questionnaire tests updated

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

_To be filled by the implementing session when its plan is approved._

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_Filled during implementation. Sources: the audit report
(`../factory-bench/research/audit-fable-v2.md`), the Owner's audit-round
decisions in the parent's Notes. Out of scope here: beads enforcement
(hooks anti---mirror, post-claim verify, push verification, exit plan) →
slice 05 ; digest/escalation/ownership WORDING in discipline & docs →
slice 07._
