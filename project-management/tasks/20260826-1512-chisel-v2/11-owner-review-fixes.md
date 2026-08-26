# 11 — Owner review of slice 10: five corrections

**Status:** 🟢 Complete
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

- [x] `grep -r "to-lessons" socle/ upstream.lock.json` returns nothing;
      the skill lives at `socle/agents/skills/retro/` with its x-upstream
      intact
- [x] `grep -rE "40 lines|8 lines|half of the slice|half the spend|target ~"
      socle/` returns nothing; no numeric length/spend rule anywhere in the
      socle (the task template is the only reference for artifact form)
- [x] The `spec-review` and `design-check` bodies contain sequencing and a
      profile pointer only — no duty text duplicated from the profiles;
      bodies stay byte-identical across the 3 presets; gate sets unchanged
      (3/1/0)
- [x] `socle/agents/profiles/checker.md` ships with the five duties above;
      renders regenerate; golden-tree updated; `spec-review` names the
      Checker in all 3 formulas
- [x] Suite green; net new assertions ≤ 2

---

> 🧑 **REVIEW IF RELEVANT** — design.

## Design — persisted at plan time

### 1. The rename `to-lessons` → `retro`

The upstream skill is already called `retro` (`skills/in-progress/retro`);
only our local key was invented. So the rename is a pure alignment, and
nothing about the skill's body changes.

Seven edits, mechanical:

1. `git mv socle/agents/skills/to-lessons socle/agents/skills/retro` — the
   directory name IS the skill id everywhere downstream, so this is the one
   move that drives all the others.
2. `socle/agents/skills/retro/SKILL.md` frontmatter: `name: to-lessons` →
   `name: retro`. The `x-upstream` block (repo, path, sha, `changes`) is
   untouched — its `path` already reads `skills/in-progress/retro`, which is
   why the acceptance criterion says the provenance stays intact.
3. `upstream.lock.json`: rename the key `"to-lessons"` → `"retro"` and move
   the entry so the file stays alphabetical — it lands between `"research"`
   and `"slice-task"`. Value unchanged (`mattpocock/skills`,
   `skills/in-progress/retro`, sha `6654f6b6`). The lock maps *local skill
   directory* → upstream source; the directory moved, so the key must move
   with it or `sync-upstream` looks up a directory that no longer exists.
4. `socle/agents/discipline.md` rule 8, last sentence: "go through
   `to-lessons` at close" → "go through `retro` at close". Rule 8's substance
   (the repo is the only memory) is the Owner's ruling (5) and does not move.
5–7. The `close` step body in the three formulas, one identical line each
   (`chisel-auto` L210, `chisel-controlled` L202, `chisel-supervised` L228):
   "Run `to-lessons`, sort its proposals by gravity" → "Run `retro`, …". The
   three close bodies are not byte-identical to each other (each carries its
   own mode paragraph), but this sentence is shared and must change in all
   three or a preset invokes a skill that is not installed.

`test/fixtures/golden-tree.txt`: the two lines `.agents/skills/to-lessons`
and `.agents/skills/to-lessons/SKILL.md` are **relocated**, not edited in
place — the fixture is a sorted tree, so `retro` moves up next to
`.agents/skills/research`, ahead of `slice-task`. Renaming in place would
leave the fixture unsorted and the tree assertion red.

What this changes in the renders: nothing but the file's path. The installer
copies `socle/agents/skills/*` verbatim into `.agents/skills/` and symlinks
`.claude/skills`; there is no per-skill registry to update. `check` compares
installed files against the socle, so a fresh `chisel update` on an existing
target will report the old `.agents/skills/to-lessons/` as a foreign
directory it did not install — expected, and the same situation any skill
removal creates; it is not a bug to work around in this slice.

### 2. The six numeric limits, and what replaces each

The rule behind every replacement: **the task template
(`socle/templates/000-task-file-template.md`) is the only reference for
artifact form.** When a sentence loses its number it either points there or
disappears — it never gets a softer number.

| # | Site | Now | After |
|---|------|-----|-------|
| 1 | `mason.md` L50–53 | "target ~40 lines for the worklog, ~8 for the journal entry" | **Keep it short — the task template declares the shape of the worklog and the journal entry.** NEVER spend a round compressing an artifact to fit: if it runs long, leave it and note it; a reviewer asks for cuts, the author never loops on length. |
| 2 | `mason.md` L54–56 | "Mason work is at least half of the slice's total spend" bullet | **Deleted entirely**, bullet and its two follow-up sentences. Nothing replaces it: a spend ratio is not a rule the socle can hold, and the finding it wanted ("the plan was too heavy for its Mason") is already covered by the escalation section and by the design-check verdict below. |
| 3 | `architect.md` L53–55 | "(target ~40 lines — a design that cannot fit is a finding about the plan's size, never a reason to make the Mason compress it)" | "(in the shape the task template declares — a design that will not fit that shape is a finding about the plan's size, never a reason to make the Mason compress it)". The *judgement* survives, only the number goes. |
| 4–6 | `design-check` body, 3 formulas | "Target ~40 lines; if it cannot fit, that is a finding about the plan's size, not a compression exercise." | Removed from the step body altogether — under (3) below this sentence is duty text, and duty text now lives once, in `architect.md`. |

Rationale for keeping the *judgement* in 1 and 3 while deleting it in 2: 1
and 3 protect the author from a review loop about length, which is a real
failure mode with or without a number; 2 asserted a fact about cost split
that no artifact in the repo can measure.

Post-check: `grep -rE "40 lines|8 lines|half of the slice|half the spend|
target ~" socle/` must be silent, and no replacement wording may introduce a
new count, ratio, page budget or time box anywhere in the socle.

### 3. The dedup: sequencing in the formula, duties in the profile

Today the `spec-review` body restates the Checker's duties and the
`design-check` body restates the Architect's — the same sentences that are
(or will be) in the profiles. Two copies of one rule is two rules as soon as
one is edited. The split, applied to both steps:

**Stays in the step body** (it is orchestration, and the formula is what
sequences): the role name and its tier; that it runs in a FRESH session; that
it is never the author of the artifact under review; what it reads *from the
workspace* — `{{spec}}` and the Brief; the verdict vocabulary the next step
branches on (GO / VALIDATED, or blocking findings written into the Notes of
`{{spec}}`); TWO rounds MAX then escalate to the owner of the spec (for
`spec-review`) or as a finding AGAINST THE PLAN (for `design-check`); and a
closing pointer — "duties: `.agents/profiles/<role>.md`".

**Moves to / stays in the profile** (it is the *how* of the role): why the
reading list is closed and what it means when a spec needs more than it; how
findings are phrased and where they attach; the discussion posture with the
author; the shape of an alternative proposal; everything the reviewer decides
rather than everything the pipeline schedules.

Concretely: `spec-review`'s "Reads TWO things and nothing else … a spec
needing more context than that is itself a finding" moves into `checker.md`;
`design-check`'s design-shape sentence is deleted per (2)/(4–6) and its
substance is already in `architect.md` § Reviewer duties. `architect.md` §
Reviewer duties loses its "Spec review" bullet entirely — that duty belongs
to the Checker now — and keeps only "Design check".

**Byte-identity.** The `description` string of `spec-review` and of
`design-check` must be identical across the three presets, as it is today.
The mode differences live OUTSIDE the description: `chisel-controlled` hangs
a `[steps.gate] type = "human"` block off `design-check`, and that block is
untouched. Gate sets stay `chisel-controlled` = `[plan, design-check, close]`,
`chisel-supervised` = `[plan]`, `chisel-auto` = `[]` — the 3/1/0 the render
group parses. Step ids and their count stay as they are; the `needs` graph is
untouched.

### 4. `socle/agents/profiles/checker.md`

New file, same skeleton and voice as `architect.md` / `mason.md` /
`inspector.md`: YAML frontmatter (`name: checker`, one-sentence
`description`, `tier: frontier`), then `## Mission`, `## Tier`,
`## Prohibitions`, `## Escalation`, `## Inputs — what this role receives`.
No new section type, so the renderer and the render assertions see nothing
unusual. `inspector.md` is not touched by this slice.

Mission carries the five duties of the Owner's ruling, in this order:

1. **Fit with the existing code.** The Checker reads THE CODEBASE, not only
   the spec — the one input that separates it from a second Architect. A
   design that is coherent on paper and foreign to the code it lands in is a
   blocking finding.
2. **The repo's own rules.** Resolved through the glue, never assumed: the
   reading list of `.agents/project.md` §C and the living docs declared in §D,
   plus `.agents/discipline.md`. A finding cites the rule it rests on.
3. **Alternative designs, when it sees them.** Via the `codebase-design`
   skill and its `DESIGN-IT-TWICE.md` practice — the first design is unlikely
   to be the best. Proposing is a duty, not a courtesy.
4. **Discussion with the author.** An alternative is put to the author and
   argued, not filed as a verdict. The Checker persuades or drops it.
5. **Verdict.** GO, or blocking findings written into the Notes of the spec.
   Loop with the author, TWO rounds MAX, then escalate to the spec's owner —
   never a third round.

Prohibitions, in the house style: **never the author of the spec under
review** (the separation of powers `inspector.md` states for diffs, stated
here for specs); never rewrites the spec itself — it writes findings, the
author edits; never decides a 🧑 zone; never turns a preference into a
blocking finding without citing the rule or the code it rests on; never
opens a third round.

Escalation: unresolved after the second round → the spec's owner. A finding
that touches scope or a 🧑 zone → the Owner. Nothing to review against →
say so rather than invent the missing requirement.

Inputs: the Brief; the spec (by path); the codebase; the repo's rules
resolved via §C and §D; and explicitly **not** the conversation that produced
the spec.

`spec-review` in the three formulas opens with the Checker, not a second
Architect: `Role: Checker (frontier tier), in a FRESH session — never the
author of {{spec}}.` plus the pointer of (3). Rendering is automatic: the
renderer loops over `.agents/profiles/*.md` and keys off the frontmatter, so
`checker.md` produces `.claude/agents/checker.md` and
`.codex/agents/checker.toml` with no code change in `bin/chisel.sh`. Check
the body for `'''` before committing — the TOML render dies on it.

`test/fixtures/golden-tree.txt` gains exactly three sorted lines:
`.agents/profiles/checker.md` (after `architect.md`),
`.claude/agents/checker.md` (after `architect.md`),
`.codex/agents/checker.toml` (after `architect.toml`).

### 5. Mason execution order, and the test impact

Six steps, each ending green and committed — a red step never travels to the
next:

1. **Rename** (§1): `git mv`, SKILL.md `name`, lock key + reposition,
   discipline rule 8, the three `close` lines, golden-tree relocation. Run
   the suite: the tree assertion is the proof. Commit.
2. **Strip the numbers** (§2): `mason.md` ×2, `architect.md` ×1. The three
   formula occurrences are NOT done here — they disappear in step 3 as part
   of the dedup, and doing them twice invites a merge of two half-edits.
   Verify with the criterion's own grep. Commit.
3. **Dedup the two step bodies** (§3), all three presets in one edit, then
   diff the two descriptions across the presets to prove byte-identity before
   running anything. Commit.
4. **Write `checker.md`** (§4) and repoint `spec-review` at it in the three
   presets; add the three golden-tree lines. Commit.
5. **Tests** (below). Commit.
6. **Full suite + `chisel update` on a scratch target**, then the two
   acceptance greps run by hand. Commit if anything moved.

**Test impact.** No existing value in `test/installer.sh` changes. The file
names no skill directory, and the render group's role loop stays
`architect mason inspector` — deliberately: it proves the renderer is thin
and role-agnostic, adding `checker` to it would buy nothing and would cost
six assertions against a budget of two. `checker`'s three rendered files are
already covered by the golden-tree comparison, which is a fixture edit, not
an assertion.

Net new assertions: **two**, both in the `render` group, both grepping a
fresh install rather than the socle so they cover the installed surface:

- one asserting the installed `.agents/` tree contains no `to-lessons`
  (criterion 1);
- one asserting it contains no invented numeric limit, using the criterion's
  own alternation (criterion 2).

Watch the pre-existing runner cap on total `test/` line count: the suite is
at 578 of the 600 the runner enforces, so the two assertions must be written
tight or step 5 turns red on the cap rather than on a finding. If they do not
fit, that is a finding for the Owner (raise the cap or drop an assertion),
not a licence to skip a criterion.

Out of scope, explicitly: `socle/agents/methodology.md` is not rewritten, the
formulas are not renamed (slice 07 owns both), and `inspector.md` is not
touched.

---

> 🤖 **AGENT ZONE**

## Notes

**Worklog.** Six commits, one per green step of the plan's execution order.
(1) `git mv skills/to-lessons → retro`, `SKILL.md` frontmatter `name`, lock
key relocated between `research`/`slice-task`, `discipline.md` rule 8, the
shared `close` sentence in all three formulas, golden-tree's two lines moved
next to `research`. (2) `mason.md`'s worklog/journal line pointed at the task
template, its "half of the slice's total spend" bullet deleted outright;
`architect.md`'s design-check bullet lost its `~40 lines` in favour of "the
shape the task template declares". Formula occurrences left untouched here,
per the plan's own warning against a two-step merge. (3) `design-check`'s
body in all three formulas lost the `~40 lines` sentence (architect.md
already covers it) and gained a closing `Duties:` pointer; `spec-review` was
deliberately left alone in this step — repointing it to a Checker that does
not exist yet would fail the integrity test (`dangling:
.agents/profiles/checker.md`), which is exactly what happened on a first
attempt and was reverted before committing. (4) `checker.md` written (Mission
carries the five duties in the Owner's order, Prohibitions, Escalation,
Inputs); `spec-review` repointed at the Checker in all three formulas;
`architect.md` lost its "Spec review" bullet and the now-orphaned "Never
reviews a spec it authored" paragraph (the same prohibition lives once, in
`checker.md`, worded for specs the way `inspector.md` words it for diffs).
(5) Two new `render`-group assertions in `test/installer.sh`, grepping a
fresh install rather than the socle: no `to-lessons`, no invented numeric
limit. Suite: 588/600 lines, comfortably under the cap — no compensating cut
needed. (6) `chisel update` run clean on a scratch target
(`/tmp/chisel-scratch.*`, "no managed files changed" — expected, since the
target was freshly initted from the already-renamed socle); both acceptance
greps re-run by hand and confirmed silent.

**Note without stopping.** The plan's "Design" section 3 describes the
*end state* of the dedup (spec-review pointing at the Checker, architect.md
missing its Spec review bullet) but the Mason execution order in section 5
sequences that repoint into step 4, after `checker.md` exists — the two
sections read as simultaneous on a first pass. Followed section 5 as the
authoritative sequencing once the integrity test caught the gap; no scope
change, just a corrected step boundary.
