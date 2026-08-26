# 10 — The review loops live in the workflows, not in anyone's memory

**Status:** 🔴 Not Started
**Blocked by:** 09 (so formula edits are no longer pinned by prose tests)

**What to build:** The Owner's ruling (audit round, 2026-08-26): the
knowledge of WHO reviews WHAT, and the improvement loops, must be carried by
the chisel workflows themselves — formulas and profiles — not by an
orchestrator's session memory. Source: the target pipeline in
`../factory-bench/research/audit-process-dur.md` (§3) and the Owner's own
words: the Architect's spec is reviewed by ANOTHER Architect until it is
good; the Mason's program design is validated by the Architect before
implementation; a Mason is FAST and does not ask itself fifty questions.

Changes:

1. **Formulas — two loop steps added to all three presets:**
   - `spec-review` (after `spec`, before the spec gate where one exists): a
     SECOND Architect, fresh session, reads the Brief and the spec only,
     reviews it; loop with the authoring Architect, maximum 2 rounds, then
     the disagreement escalates to the spec's owner. In `chisel-default`
     the human gate follows the loop (the human approves a spec that two
     Architects already agree on).
   - `design-check` (inside the `type` flow, before typing): the Mason
     posts its program design — 40 lines maximum — into the slice file; the
     plan's owner (the Architect) validates or corrects, maximum 2 rounds,
     then escalate. Only then does typing start.
2. **Profiles updated:**
   - `architect.md`: gains the two reviewer duties (spec-review of a peer's
     spec; design-check of a Mason's program design) with the 2-round rule.
   - `mason.md`: gains the speed contract — types from a validated design,
     zero open questions during typing (an open question = a report, per
     the proposal door), **commits at every green step** (never
     all-or-nothing), worklog ≤ 40 lines.
3. **Budgets written into the profiles** (proportional protocol, from the
   process audit): per-slice targets — Mason work ≥ half of the total spend,
   journal entry ≤ 8 lines, no systematic mutation testing (a mutation test
   is ordered by a reviewer for a specific doubt, not a default).
4. **Harness memory is banned; lessons persist in the repo** (Owner ruling,
   2026-08-26): a rule in `discipline.md` (rendered into the AGENTS block) —
   an agent NEVER stores project knowledge in a harness memory (Claude
   auto-memory or equivalent); the repo's files are the only memory. In its
   place, a new socle skill **`to-lessons`** — forked/adapted from
   `mattpocock/skills` `in-progress/retro` (vendor it with `x-upstream`
   frontmatter + lock entry, per the D3 discipline): at the END of a
   workflow it evaluates the session and proposes improvements to the
   WORKING RULES (not the code) — navigation, automated checks, standards,
   AGENTS.md hygiene, tool economy, dead instructions, missing information —
   sorted by gravity, and persists the accepted ones into the repo's rules/
   docs. The formulas' `close` step invokes it (propose, human or zone
   owner accepts).

## Acceptance criteria

- [ ] The three formulas carry `spec-review` and `design-check` with the
      2-rounds-then-escalate rule; step bodies stay byte-identical across
      presets (gates aside); TOML parses, gate counts unchanged (3/1/0)
- [ ] `architect.md` and `mason.md` carry the duties above; renders
      re-generated
- [ ] No prose-pin test added (slice 09's standing rules apply)
- [ ] A no-tooling walkthrough of `chisel-default` shows the two loops in
      the right places (trace in Notes)
- [ ] `discipline.md` carries the harness-memory ban (repo files are the
      only memory); `to-lessons` ships as a vendored skill (x-upstream +
      lock entry) and the `close` step of all three formulas invokes it

---

> 🧑 **REVIEW IF RELEVANT** — design.

## Design — persisted at plan time

_To be filled at the plan gate._

---

> 🤖 **AGENT ZONE**

## Notes

_Worklog ≤ 40 lines._
