# 11 — Owner review of slice 10: five corrections

**Status:** 🔴 Not Started
**Blocked by:** 10 (delivered)

**What to build:** The Owner reviewed slice 10's output and ruled five
corrections (2026-08-26 evening). This slice applies them. The reference for
artifact content and form is the ORIGINAL task template
(`socle/templates/000-task-file-template.md`) — nothing else.

1. **Rename the skill `to-lessons` → `retro`.** The upstream name is kept
   (Owner: "on doit utiliser retro comme base, pas un nouveau truc").
   Directory, lock entry key, the `close` step sentence in the 3 formulas,
   `discipline.md` rule 8, and the golden-tree fixture all follow.
2. **Strip every invented numeric limit.** Six occurrences, inventoried:
   `mason.md` (worklog/journal length targets; the "Mason work is at least
   half of the slice's total spend" bullet — DELETED entirely),
   `architect.md` (design ~40 lines), the `design-check` body in the 3
   formulas (~40 lines). No line counts, no spend ratios anywhere in the
   socle. Where a sentence loses its object, the correct wording points at
   the task template instead of a number.
3. **De-duplicate the review knowledge** (one source per concept): the
   reviewer duties live ONCE, in the profiles. The `spec-review` and
   `design-check` step bodies keep only the sequencing — who acts, in what
   order, two rounds then escalate to the zone's owner — and POINT to the
   profile for the how. Byte-identity of step bodies across the 3 presets
   is preserved.
4. **New profile `checker.md`** — the spec reviewer becomes a role (Owner
   decision): frontier tier; NEVER the author of the spec under review;
   inputs: the Brief, the spec, THE CODEBASE, and the repo's rules
   (resolved via the glue's reading list and doc reference); duties: verify
   the design fits the existing code, verify the repo rules are followed,
   PROPOSE alternative designs when it sees them (via the `codebase-design`
   skill and its design-it-twice practice) and discuss them with the
   author; verdict GO or blocking findings in the spec's Notes; two rounds
   then escalate to the spec's owner. The `spec-review` step points to this
   profile (not to a second architect). Rendered per-tool like the others.
5. The Owner's ruling from the same review, already noted: `retro` runs at
   close; the repo is the only memory — unchanged, just renamed with (1).

## Acceptance criteria

- [ ] `grep -r "to-lessons" socle/ upstream.lock.json` returns nothing;
      the skill lives at `socle/agents/skills/retro/` with its x-upstream
      intact
- [ ] `grep -rE "40 lines|8 lines|half of the slice|half the spend|target ~"
      socle/` returns nothing; no numeric length/spend rule anywhere in the
      socle (the task template is the only reference for artifact form)
- [ ] The `spec-review` and `design-check` bodies contain sequencing and a
      profile pointer only — no duty text duplicated from the profiles;
      bodies stay byte-identical across the 3 presets; gate sets unchanged
      (3/1/0)
- [ ] `socle/agents/profiles/checker.md` ships with the five duties above;
      renders regenerate; golden-tree updated; `spec-review` names the
      Checker in all 3 formulas
- [ ] Suite green; net new assertions ≤ 2

---

> 🧑 **REVIEW IF RELEVANT** — design.

## Design — persisted at plan time

_To be filled at the plan gate._

---

> 🤖 **AGENT ZONE**

## Notes

_Worklog per the task template._
