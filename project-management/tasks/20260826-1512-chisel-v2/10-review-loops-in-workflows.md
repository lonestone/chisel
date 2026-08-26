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

**D1 — two steps; each new body is ONE string, byte-identical in the 3 files.**
`spec` → **`spec-review`** → `plan` → **`design-check`** → `type`; rewire
`needs` only, ids 7 → 9. No mode-specific paragraph: escalation says "the owner
of the spec / of the plan" — right in all 3 modes (🧑 = zone owner).
- `spec-review` (`needs=["spec"]`; `plan` needs it) — *a SECOND Architect
  (frontier), FRESH session, never the author of {{spec}}. Reads TWO things and
  nothing else, the Brief and {{spec}}: a spec needing more context is itself a
  finding. Verdict GO, or blocking findings in the Notes of {{spec}}. Loop with
  the author, TWO rounds MAX; still blocked after the second → escalate to the
  OWNER of the spec, never a third round.*
- `design-check` (`needs=["plan"]`; `type` needs it) — *the Mason (cheap) posts
  its PROGRAM DESIGN, 40 lines MAX, into the Design section of {{spec}}: files,
  seam signatures, TDD order — no code typed here. The Architect who owns the
  plan reads the slice and that design only, answers VALIDATED or corrections.
  TWO rounds MAX, then back to the plan's owner as a finding AGAINST THE PLAN,
  never against the Mason. Typing needs VALIDATED.*

**D2 — gates stay 3/1/0, exactly one MOVES.** Both gated presets keep "spec
approved" on `plan`, now after the loop — the human approves a spec two
Architects already agree on. In `chisel-controlled` "plan approved + typist
chosen" moves `type` → `design-check`: the gate belongs to the step that waits,
no Mason designs before the plan is approved.

**D3 — profiles.** `architect.md`, new `## Reviewer duties` after `## Tier`:
spec-review of a PEER's spec (2 rounds → the spec's owner), design-check of a
Mason's ≤40-line design (2 rounds → a finding against the plan), + prohibition
"never reviews a spec it authored". `mason.md`, new `## Speed contract` before
`## Prohibitions`: types from a VALIDATED design, ZERO open question while
typing (an open question is a report through the proposal door), **commits at
every green step**, worklog ≤40 / journal ≤8 lines, Mason ≥ half the slice
spend, mutation testing only on a reviewer's named doubt.

**D4 — memory ban + close.** `discipline.md` rule 8: "**The repo is the only
memory.** Never store project knowledge in a harness memory (auto-memory or any
equivalent outside the repo); it goes in the repo's files, visible to review and
git. Lessons about the way of working go through `to-lessons` at close." The 3
`close` bodies gain ONE identical sentence, same anchor (after evergreen
promotion): run `to-lessons`, sort by gravity, PROPOSE to each touched zone's
owner; accepted ones are written in.

**D5 — `to-lessons`** (`socle/agents/skills/to-lessons/SKILL.md`). KEEP from
upstream `retro`: the 7 categories (navigation, automated checks, coding
standards, AGENTS.md hygiene, tool economy, no-ops, information access) and "in
order of severity". ADAPT: drop the `writing-for-agents` call (not vendored →
`writing-great-skills`); sources are repo artifacts, never harness session logs
(D4); targets resolve via `.agents/project.md`. ADD: each proposal names target
file + zone owner, **nothing is auto-applied**, deferred ones get a dated line;
drop `disable-model-invocation`. `x-upstream` = repo
`mattpocock/skills`, path `skills/in-progress/retro`, sha
`6654f6b60cd9d5be8b54c6fafe44346dabeb3b76` (NOT the set's `2ab9580` — retro 404s
there), same triple in `upstream.lock.json`.

**D6 — order, one commit per green step.** (1) rule 8. (2) formulas ×3 **and**
`test/installer.sh` in the SAME commit — two EXISTING values updated, `7`→`9`
and `"chisel-controlled": ["plan","design-check","close"]` (else the parse test
is red). (3) profiles + regenerate renders. (4) `to-lessons` + lock entry.
Budget: 0 new assertions in 1–3, ≤2 in 4, no grep-on-prose. **Interdits:**
nothing beyond that test budget, no prose-pin; do NOT rewrite `methodology.md` nor
rename the formulas (slice 07); do NOT touch `inspector.md`; never a third round
nor a mode-specific paragraph in the two new bodies.

---

> 🤖 **AGENT ZONE**

## Notes

_Worklog ≤ 40 lines._
