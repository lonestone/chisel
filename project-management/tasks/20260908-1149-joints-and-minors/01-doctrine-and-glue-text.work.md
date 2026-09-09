# 01 — Doctrine and glue text — work

Created by `mason` at `plan`, 2026-09-08. Spec:
`project-management/tasks/20260908-1149-joints-and-minors/01-doctrine-and-glue-text.spec.md`.

## Program Design

Persisted at `plan` by `mason`, 2026-09-08 15:56 CEST, from the spec's
approved system design.

Every edit below is one clause of prose or one table row. No function, branch
or data structure is added, so there is no seam to test and no TDD cycle: the
seam the spec names is the installed socle text surface, and its observable
behaviour is the criterion greps plus the installer suite. The design question
is therefore only *what exact words land where*, and *in what order*, so that
the suite and the counts can be checked after each file rather than at the end.

### Rules this design works under

- **The suite must provably survive.** `test/installer.sh` pins, and none of
  it may move: the formula parse check (step counts 9/7/9/9/6 and the human
  gate lists `plan,type,close` / `plan,diff-review` / `plan` / none / none,
  the `version` integer, unique step ids), the byte-for-byte profile-body
  renders for `architect`, `foreman`, `mason`, `inspector`, the two recursive
  prose greps over the installed `.agents/` (`to-lessons`, and the invented
  numeric limits `40 lines|8 lines|half of the slice|half the spend|target ~`),
  and the integrity scenario. So: no step, gate or `needs` change in any
  formula — only description prose; and no line written anywhere may contain
  one of those pinned strings.
- **Every pointer written is in the installed `.agents/…` form.** The
  integrity scenario counts as a pointer (1) any `.agents/…` path in the text
  and (2) a markdown link to a sibling file, and demands the target exist in
  the installed tree. The two pointers this slice writes are
  `.agents/project.md` (for §B2) and `.agents/methodology.md` (for the tier
  cascade). Both exist installed. `doc/architecture/ARCHITECTURE.md`, the new
  §D default, is neither shape — it is a project path in the glue template,
  exactly as the five formulas already name it — so it adds no pointer.
- **Rule 11 of the discipline** (a section reference names its file and its
  title) governs the two references written: "§B2 · Link to an external
  tracker of `.agents/project.md`" and the methodology section named by title.
- **G18, direct prose.** Statement first; an image only where it carries what
  the statement does not.
- **No sweep.** Parent Implementation Decision 2: the bare `§B`, `§C`, `§F`,
  `§H` citations elsewhere in these same files are chantier 5's. Untouched.

### Edit 1 — `socle/agents/methodology.md`, five edits

Line numbers are as of this working tree, 2026-09-08, branch `review-360`.

**1a · A3 (1), the SDD-bench pointer — line 14.** The provenance paragraph
ends at "series."; the trailing sentence "Full analysis:
`SDD-bench/fusion-pierrick-pocock.md`." is deleted, nothing replaces it. The
path is development context and the file is not in this repo.

**1b · A1 (1), the "ticket" pointer — line 35.** The sentence at lines 33-35
today ends `…if/when one is wired up — see `.agents/project.md`, Tracker
section.` Its closing clause is replaced so the whole sentence reads:

> We do NOT use the word "ticket" for local work. It is reserved for items in
> an external tracker (Linear, GitHub Issues), if/when one is wired up — see
> §B2 · Link to an external tracker of `.agents/project.md`.

Chosen because the sentence is about the reserved word "ticket", which means
the external tracker (parent Implementation Decision 1). Verified: that
section exists, `socle/agents/project.md.tpl:103`, spelt `### B2 · Link to an
external tracker`.

**1c · E1, the factory claim — line 65.** The `**Factory = auto × beads**`
paragraph is rewritten so that the factory is a possible destination, perhaps
outside chisel, with the question left open. What survives from the old
paragraph is the one fact it carried: plain auto is one chained session and
needs no beads. No queue, lane or asynchronous gate list is described, per the
ruling. Target wording:

> **A factory is a possible destination, not a cell of this product.**
> Whether it belongs inside chisel is an open question: chisel stays light
> enough to fit into any repo, and a factory implies a lot of bespoke work.
> Until a real need settles that question, no factory machinery is described
> here — no queues, no lanes, no asynchronous gate lists. Plain auto is one
> chained session and needs none of them.

**1d · F1.7, the model claim — line 324.** "Nothing in this socle names a
model or a vendor." is replaced by a sentence that claims only what is true
and only about models and tiers, keeping the paragraph's job of introducing
the tier table. Target wording:

> The normative text of this socle names no model: what a step or a role
> declares is a **tier**. Tool names are not covered by that rule and appear
> wherever they are useful. The three tiers are the same three the roster
> uses:

Ruling E2's permission to give example model names is recorded and left
unexercised, per parent Implementation Decision 10.

**1e · F1.8, the rewrite-label rule — line 437.** The clause currently ends
the "Artifact ladder" paragraph as a trailing aside ("Protocol wording stays
generic: do not brand temporary rewrite labels…"). It leaves that paragraph
and becomes a short paragraph of its own, immediately after it, which names
what a temporary rewrite label is and gives an example. Target wording:

> **Keep temporary rewrite labels out of the promoted pages.** A temporary
> rewrite label is the name a migration gives itself while it runs — "v2",
> "the new pipeline", "phase 3". It means nothing to a reader who arrives
> after the migration has ended. An evergreen page says what the system does;
> the label belongs to the task documents that carry the migration, and it
> leaves the page with them.

This is the surviving copy of the rule, and after edit 6 the only one in the
socle.

### Edit 2 — `socle/agents/discipline.md`, two edits

**2a · F1.5 clauses 1 and 2, the prototype side-lane row — line 98.** The
"Then" column is unchanged. The "Use" cell drops "delete the code" and names
what rule 6 of the `prototype` skill actually prescribes — a throwaway branch
out of main, plus a pointer to it. Target cell:

> `prototype` — throwaway code, one command to run; keep the answer, and keep
> the code on a throwaway branch out of main with a pointer to that branch

Aligned on `socle/agents/skills/prototype/SKILL.md` rule 6, read at plan:
"commit it to a throwaway branch, out of main, and leave a context pointer to
that branch". **No close-time cleanup sentence is written here** — that is
clause 3 of the criterion, slice 02's, in the prototype skill; writing it here
would make "exactly one place" two. The triage row at line 102 is slice 03's
and is not touched.

**2b · F1.9, the rule deletion and renumber — lines 72-81.** Rule 11 ("A
refused `update` is a redirect", lines 72-75) is deleted whole, including its
blank line. Rule 12 (lines 77-81, "A section reference names its file and its
title") keeps its text byte for byte and is renumbered `11.`; its 4-space
continuation indent is unchanged, because `11.` and `12.` are the same width.
Result: 11 numbered rules. No other renumber: rules 1-10 keep their numbers.
Guard re-run at plan (parent Implementation Decision 9): the only rule-number
citations in the socle are `socle/agents/discipline.md:69` ("rule 9") and
`socle/agents/skills/retro/SKILL.md:8` ("discipline.md rule 8"), both below
11, so nothing cited moves. `bin/chisel.sh` already carries the redirect
(`grep -c "upgrade-v2"` → 2) and is not edited.

### Edit 3 — `socle/agents/project.md.tpl`, A1 (3)

One field added to the list of §D · Documentation reference (line 142
onward), between the living-docs root and the boilerplate variant:

> - **Architecture index:** `doc/architecture/ARCHITECTURE.md` — the page the
>   `close` step of every formula starts a promotion from

The section's questionnaire comment is left alone: parent Implementation
Decision 8 rules that §D is a prefill confirmed by the reader, so a new field
with a default ships without a `chisel-setup` change.

### Edit 4 — `socle/agents/profiles/README.md`, two edits

**4a · E2, the tier-resolution statement.** ANCHOR, one position only: a short
paragraph is added immediately **after `socle/agents/profiles/README.md:55`**
— the end of the "To add a role: drop a file here with `name`, `description`
and `tier` in its frontmatter…" paragraph, which is the last paragraph of the
section "The body is the source; the per-tool definitions are renders" and the
first place `tier` appears as a frontmatter field. That section is where a
reader learns what a generated definition contains, which is where the absent
model field has to be accounted for. Target wording, which carries the
two phrases the criterion greps (`resolved at read time`, `no model field`):

> A generated definition carries **no model field**. A profile's frontmatter
> declares a `tier`, which says how much judgement the role's work needs, and
> that tier is **resolved at read time** by the delegating agent, at the
> moment it spawns the role. Which concrete model a tier means is resolved
> through the cascade in "Model tiers (and how they resolve)" of
> `.agents/methodology.md`; choosing it belongs to each dev's own plumbing,
> not to chisel.

**4b · the invocation clause — line 67.** `work on slice <file>` → `work on
slice <spec-document>`, the form the **five** other invocation sites already
use — `socle/agents/discipline.md:65`, `socle/agents/methodology.md:279`,
`socle/agents/profiles/foreman.md:40`,
`socle/agents/formulas/chisel-default.formula.toml:97` and
`socle/agents/formulas/chisel-light.formula.toml:93` (re-counted at `type`).
Nothing else in that sentence changes. This is one of the two carriers of
`work-on-invocation-current`; the other is `AGENTS.md:12`, slice 02's, so the
criterion's grep stays at 1 after this slice.

### Edit 5 — `socle/agents/profiles/foreman.md`, ruling G16

One bullet in the "What it does" list, immediately after the two-part spawn
bullet (lines 34-37), per parent Implementation Decision 5. Not duplicated in
`methodology.md`. Target wording:

> - **Judging roles are spawned fresh; the Mason is reused.** An Architect, a
>   Checker or an Inspector meeting a piece of work for the first time gets a
>   fresh session — the separation of powers is what makes its verdict worth
>   reading. The same Architect may re-validate a program design it has just
>   sent back, because there it is checking the resolution of its own
>   findings. The Mason is the exception: the one that wrote the program
>   design also applies the `plan-review` corrections and types the slice,
>   within one live thread. Building fresh from the spec/work pair is the rule
>   for a RESUMED thread — another session, another day — and that is what the
>   persisted work document guarantees, not the continuity of a live one.

### Edit 6 — the five formulas, F1.8 clause removal

In each of `socle/agents/formulas/chisel-default.formula.toml:221-222`,
`chisel-auto.formula.toml:212-213`, `chisel-supervised.formula.toml:228-229`,
`chisel-light.formula.toml:196-197` and
`chisel-auto-light.formula.toml:175-176`, the `close` step's description
carries the identical two-line tail:

```
change is relevant to it. Protocol and evergreen pages stay generic — a
temporary rewrite label is never branded as part of the work system.
```

It becomes:

```
change is relevant to it.
```

That is the whole edit in these five files: one clause off the end of a
sentence and one line deleted, inside a description string. No `id`, `type`,
`needs`, `title`, `gate` or `version` is touched, so the parse check's step
counts and gate lists are untouched by construction.

### Order of operations

Ordered so that each step is verifiable on its own and the riskiest file (the
five formulas, the only one the parse check reads) lands last with a full
suite run behind it.

1. Edit 1, `methodology.md` — five edits, one commit. Verify:
   `sdd-bench-pointer-gone`, `model-claim-scoped`, the `Tracker section` count
   dropping 5 → 4, `§B2 · Link to an external tracker` ≥ 1, `Factory = auto`
   dropping 2 → 1, `rewrite label` in `methodology.md` still ≥ 1.
2. Edit 2, `discipline.md` — one commit. Verify: `delete the code` → 0,
   `throwaway branch` ≥ 1, `^[0-9]+\. ` → 11, the section-reference rule
   reading `11.`, and `grep -rn "rule [0-9]" socle/` still naming only rule 9
   and rule 8.
3. Edit 3, `project.md.tpl` — one commit. Verify `architecture-index-declared`.
4. Edit 4, `profiles/README.md` — one commit. Verify `tiers-prose-only` and
   the `work on slice <file>` count dropping 2 → 1.
5. Edit 5, `foreman.md` — one commit. Verified by the scheduled read-through
   of the bullet: the criterion is about what the bullet SAYS, and no command
   can check that. The suite's byte-for-byte profile-body render only proves
   the installed `.claude`/`.codex` renders still match the edited profile
   body — it cannot pin the bullet's content, so it is a consistency guard
   here, not the verification.
6. Edit 6, the five formulas — one commit. Verify with the FULL-socle grep
   `grep -rn "rewrite label" socle/` → exactly **one file**
   (`socle/agents/methodology.md`, the surviving copy), not the two partial
   greps: "exactly one socle file carries the rule" is the clause of
   `rewrite-label-selfstanding` that this turns on, and only the full-socle
   grep can show it.
7. Full run: `PATH=/opt/homebrew/bin:$PATH bash test/run.sh`, expecting 9
   scenarios, 94 assertions, 0 failed, with the formula parse check reporting
   PASS and not SKIP. Then `git diff --check`. Then record every after-count
   beside its before-count in the Worklog.

The suite is cheap, so it also runs opportunistically after steps 1 and 6 —
the two that can plausibly break something (a pointer, and the parse check).

### What this slice does NOT do

- No close-time prototype-cleanup sentence (slice 02 owns it).
- No edit under `test/`, `bin/`, `socle/templates/`, `socle/agents/skills/`,
  `project-management/` other than this work document, `README.md`,
  `PHILOSOPHY.md`, `AGENTS.md`.
- No section-reference sweep, no example model names, no CHANGELOG entry.
- No touch to the triage side-lane row of `discipline.md` (line 102).

### Open questions

**1 · Does the foreman bullet carry the literal string "G16"? Decided: no.**
The criterion's before-count is `grep -c "G16"
socle/agents/profiles/foreman.md` → 0, so a reviewer may grep for it after.
But the criterion's normative wording is "states ruling G16: judging roles are
spawned fresh, the Mason is reused from plan through typing within a live
thread" — the content, not the label. Checked at plan:
`grep -rn "ruling [A-Z]\?[0-9]" socle/` returns nothing, so no shipped socle
file cites a ruling id anywhere, and `review-360-decisions.md` does not exist
in an equipped repo — the id would be a reference a reader cannot follow, and
discipline rule 11 asks the opposite of that. So the bullet states the rule
and names no id. Recorded here rather than improvised, and reported to the
spawner: if the Owner would rather the label be traceable in the socle, the
fix is one parenthesis in one bullet.

**2 · Two criteria this slice cannot close, by construction.** After this
slice, `grep -rn "Factory = auto" socle/ PHILOSOPHY.md README.md` still
returns 1 (`PHILOSOPHY.md:134`, slice 02's) and `grep -rn "work on slice
<file>\|work on task <file>" socle/ AGENTS.md` still returns 1
(`AGENTS.md:12`, slice 02's). Both are recorded in the spec's Notes; neither
is a failure of this slice. Same for `tracker-pointer-resolves`, which drops
5 → 4 here and closes at slice 03.

## Worklog

- **2026-09-08 15:56 CEST · `mason` · `plan`.** Read the role contract, the
  slice spec, the parent spec (§Scope, §Architecture, §Implementation
  Decisions 1-12, §Slices & Dependencies), the rulings A1, A3, E1, E2, F1.5,
  F1.7, F1.8, F1.9 and the addenda carrying G16 and G18, `test/installer.sh`
  (the parse check, the recursive prose greps, the integrity scenario and its
  definition of a pointer), and every carrier named in the files map. Persisted
  this program design. Verified all **sixteen** grep before-counts **plus the
  suite baseline — seventeen rows** in the table below — against this working
  tree; every one matched the spec, no stop-and-re-read triggered. Nothing
  typed in any carrier.

- **2026-09-08 16:41 CEST · `mason` · `type` (fresh Mason, resumed thread, per
  ruling G16).** Read the role contract, the spec and this work document — the
  planning conversation is not an input. Folded the Architect's six
  non-blocking round-1 adjustments into the Program Design before typing
  anything: (1) the before-count denominator corrected from "thirteen" to
  sixteen greps plus the suite baseline, with the `G16` grep recorded as an
  intentionally-unchanged 0; (2) edit 1b's replacement sentence written out in
  full prose instead of arrow notation; (3) edit 4a's anchor reduced to the one
  position after `profiles/README.md:55`; (4) the after-count roll-call moved
  to the full-socle `grep -rn "rewrite label" socle/`; (5) order-of-operations
  step 5 reworded — the read-through verifies the G16 bullet, the suite's
  render check cannot; (6) edit 4b's invocation-site count corrected from four
  to five, each site re-counted against the tree. Also re-verified against the
  working tree before typing: the five `<spec-document>` sites, the six
  `rewrite label` carriers, the two `rule [0-9]` citations, and every line
  number the design names (`methodology.md` 14 / 35 / 65 / 324 / 437,
  `discipline.md` 72-81 and 98, `project.md.tpl` 142-150,
  `profiles/README.md` 55 and 67, `foreman.md` 34-42). All held.

- **2026-09-08 17:24 CEST · `mason` · `type`.** Typed all six edit groups in
  the design's order, one commit each, explicit paths only — the two untracked
  Owner files `project-management/review-360-*.md` were never staged. Commits:
  `3ec5ac5` methodology (five edits), `65c505e` discipline (row + rule
  deletion and renumber), `10d3ff1` `project.md.tpl` (§D field), `7c44d5d`
  `profiles/README.md` (tier paragraph + `<spec-document>`), `07e804f`
  `foreman.md` (role-reuse bullet), `e19775f` the five formulas (close-tail
  truncation). One deviation from the design's literal text, recorded below.
  Every criterion command re-run with its after-count in the table below; the
  suite is green with the parse check PASS.

  **After-counts, all measured on this tree after the sixth commit.**

  | Criterion / command | Before | After |
  |---|---|---|
  | `grep -c "Architecture index" socle/agents/project.md.tpl` | 0 | **1** ✅ |
  | `grep -rn "SDD-bench" socle/` | 1 | **0, empty** ✅ |
  | `grep -n "Nothing in this socle names a model or a vendor" socle/agents/methodology.md` | 1 (l.324) | **0, empty**; replacement at l.327 ✅ |
  | `grep -cE "resolved at read time\|no model field" socle/agents/profiles/README.md` | 0 | **2** ✅ |
  | `grep -rn "rewrite label" socle/agents/formulas/` | 5 | **0, empty** ✅ |
  | **full-socle** `grep -rl "rewrite label" socle/` | 6 lines / 6 files | **1 file** — `methodology.md` only ✅ |
  | `grep -cE "^[0-9]+\. " socle/agents/discipline.md` | 12 | **11**; section-reference rule reads `11.` at l.72 ✅ |
  | `grep -c "A refused \`update\` is a redirect" socle/agents/discipline.md` | 1 | **0** ✅ |
  | `grep -c "upgrade-v2" bin/chisel.sh` | 2 | **2**, untouched ✅ |
  | `grep -c "G16" socle/agents/profiles/foreman.md` | 0 | **0 — INTENTIONALLY UNCHANGED**, see below; bullet at l.38 ✅ |
  | `grep -n "delete the code" socle/agents/discipline.md` | 1 (l.98) | **0, empty** ✅ |
  | `grep -n "throwaway branch" socle/agents/discipline.md` | 0 | **1** (l.93) ✅ |
  | `grep -rn "Tracker section" socle/` | 5 / 5 files | **4** — wayfinder, slice-task, code-review, triage; methodology gone ✅ |
  | `grep -rn "§B2 · Link to an external tracker" socle/` | 0 | **1** (`methodology.md:35`); target exists at `project.md.tpl:103` ✅ |
  | `grep -rn "Factory = auto" socle/ PHILOSOPHY.md README.md` | 2 | **1** — `PHILOSOPHY.md:134`, slice 02's; `socle/` clean ✅ |
  | `grep -rn "work on slice <file>\|work on task <file>" socle/ AGENTS.md` | 2 | **1** — `AGENTS.md:12`, slice 02's; `socle/` clean ✅ |
  | `grep -rn "rule [0-9]" socle/` | 2, both < 11 | **2**, unchanged — `discipline.md:69` ("rule 9"), `retro/SKILL.md:8` ("rule 8"); `grep -rn "rule 1[12]" socle/` empty ✅ |
  | `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` | 9 / 94 / 0 | **9 scenarios, 94 assertions, 0 failed**; parse check PASS (python 3.13.1, `tomllib`), integrity scenario green ✅ |

  Two extra guards, neither in the spec: pointer check `grep -rn "socle/"` over
  the six touched paths returns **empty** — no repo-path leak into installed
  text; `git diff --check` and `git diff --cached --check` both **clean**.

  **The `G16` grep is the one row that does not move, and that is the design.**
  Open question 1 decided the bullet states the rule and carries no ruling
  label, ratified by the thread owner and confirmed by the Architect against
  the criterion's real pass condition (the content, not the label). The
  criterion is verified by read-through instead: the bullet sits at
  `foreman.md:38-47`, immediately after the two-part spawn bullet, and states
  both halves — judging roles fresh, the Mason reused from plan through typing
  within one live thread.

  **One deviation from the design's literal text, in `profiles/README.md`.**
  Substituting `<spec-document>` for `<file>` at line 67 pushed that line past
  the file's 80-column prose wrap, so the two-line sentence was rewrapped. The
  design did not mention it ("Nothing else in that sentence changes"). No word
  changed; only the line break moved, from after "which is also the" to after
  "which is". Recorded because the design said nothing else would change.

- **2026-09-09 18:26 CEST · `mason` · post-inspection corrections (fresh
  Mason, resumed thread).** Built from the persisted spec/work pair, not from
  any earlier session. Two Inspector findings closed, and nothing else.
  **S1** — in `socle/agents/profiles/foreman.md`, the role-reuse bullet
  justified spawning judging roles fresh with the image "the separation of
  powers is what makes its verdict worth reading". Ruling G18 wants the
  statement, and the image carried no information the statement does not, so
  the clause now reads: "a fresh reviewer has no stake in the work it judges
  and has not already read the intended meaning into it". The bullet's other
  sentences are unchanged; the paragraph was re-wrapped to 80 columns and
  still occupies eleven lines, `foreman.md:38-48`. **Sp1** — two citations in this document still gave
  the section-reference rule as discipline rule 12, the number it carried
  before Edit 2 of this slice deleted rule 11 and renumbered 12 to 11 (commit
  `65c505e`). The design bullet under "Rules this design works under" and the
  Open question 1 note now both say rule 11. The three remaining "rule 12"
  mentions describe the renumbering or its before-state — the Edit 2b design
  paragraph, the Edit 2 checkbox, and the before-count table row — and are
  correct as written, so they stand. `grep -rn "separation of powers" socle/`
  is empty; the suite is 9 scenarios, 94 assertions, 0 failed; `git diff
  --check` clean.

## Implementation Checkboxes

- [x] Edit 1 — `socle/agents/methodology.md`: A3 (1) line 14, A1 (1) line 35,
      E1 line 65, F1.7 line 324, F1.8 line 437 — commit `3ec5ac5`
- [x] Edit 2 — `socle/agents/discipline.md`: prototype row line 98; rule 11
      deleted and rule 12 renumbered to 11 — commit `65c505e`
- [x] Edit 3 — `socle/agents/project.md.tpl`: the "Architecture index" field
      in §D — commit `10d3ff1`
- [x] Edit 4 — `socle/agents/profiles/README.md`: the tier-resolution
      paragraph, and `<spec-document>` at line 67 — commit `7c44d5d`
- [x] Edit 5 — `socle/agents/profiles/foreman.md`: the G16 bullet — commit
      `07e804f`
- [x] Edit 6 — the five `socle/agents/formulas/*.formula.toml`: the
      rewrite-label clause off the `close` step — commit `e19775f`
- [x] Verification — every criterion command re-run, after-count recorded
      beside its before-count in the Worklog
- [x] `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` → 9 scenarios, 94
      assertions, 0 failed, parse check PASS not SKIP; then `git diff --check`

## Notes & Snippets

- 2026-09-08 — **foreman** — Ruling on the proposal-door finding below: no
  gap. Slice 02's spec owns the three surviving Tracker-section carriers
  explicitly — its `tracker-pointer-resolves` share names
  `wayfinder/SKILL.md:30`, `slice-task/SKILL.md:17`,
  `code-review/SKILL.md:18`, and its files map lists all three. The repoints
  land there; nothing falls through.

**Before-counts, verified by `mason` at `plan`, 2026-09-08, branch
`review-360`.** Each command was run against this working tree, not copied
from the spec. The table carries **sixteen grep rows plus the suite baseline —
seventeen rows**; all of them agree with the numbers the spec recorded, so no
stop-and-re-read applies.

**One row is an intentionally-unchanged 0: the `G16` grep.** `grep -c "G16"
socle/agents/profiles/foreman.md` is 0 before and stays 0 after, because Open
question 1 below decides the bullet states the rule and carries no ruling
label — a decision ratified by the thread owner and confirmed by the Architect
against the criterion's real pass condition (which is the content, not the
label). Recorded here so a `diff-review` does not read that unchanged 0 as a
missed edit.

| Command | Spec says | Measured |
|---|---|---|
| `grep -c "Architecture index" socle/agents/project.md.tpl` | 0 | 0 |
| `grep -rn "SDD-bench" socle/` | 1 (`methodology.md:14`) | 1, same line |
| `grep -n "Nothing in this socle names a model or a vendor" socle/agents/methodology.md` | 1 (line 324) | 1, line 324 |
| `grep -cE "resolved at read time\|no model field" socle/agents/profiles/README.md` | 0 | 0 |
| `grep -rn "rewrite label" socle/agents/formulas/` | 5, one per file | 5 — 222 / 213 / 176 / 229 / 197, as recorded |
| `grep -c "rewrite label" socle/agents/methodology.md` | 1 (line 437) | 1, line 437 |
| `grep -cE "^[0-9]+\. " socle/agents/discipline.md` | 12 | 12; rule 11 at line 72, rule 12 at line 77 |
| `grep -c "upgrade-v2" bin/chisel.sh` | 2 | 2 |
| `grep -c "G16" socle/agents/profiles/foreman.md` | 0 | 0; the two-part spawn bullet is at line 34 |
| `grep -c "delete the code" socle/agents/discipline.md` | 1 (line 98) | 1, line 98 |
| `grep -c "throwaway branch" socle/agents/discipline.md` | 0 | 0 |
| `grep -rn "Tracker section" socle/` | 5 across 5 files | 5 — `methodology.md:35`, `wayfinder:30`, `slice-task:17`, `code-review:18`, `triage:48` |
| `grep -rn "§B2 · Link to an external tracker" socle/` | 0 | 0 |
| `grep -rn "Factory = auto" socle/ PHILOSOPHY.md README.md` | 2 | 2 — `methodology.md:65`, `PHILOSOPHY.md:134` |
| `grep -rn "work on slice <file>\|work on task <file>" socle/ AGENTS.md` | 2 | 2 — `profiles/README.md:67`, `AGENTS.md:12` |
| `grep -rn "rule [0-9]" socle/` | 2, both below 11 | 2 — `discipline.md:69` ("rule 9"), `skills/retro/SKILL.md:8` ("rule 8") |
| `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` | 9 / 94 / 0 | 9 scenarios, 94 assertions, 0 failed; parse check PASS, integrity scenario green |

**Two extra facts checked at plan, not in the spec.**

- `socle/agents/project.md.tpl:103` really is `### B2 · Link to an external
  tracker`, so the A1 (1) rename in `methodology.md` lands on a section that
  exists — which is the whole point of the criterion.
- `grep -rn "ruling [A-Z]\?[0-9]" socle/` returns nothing: no shipped socle
  file cites a ruling id. That is the ground for Open question 1.

**One thing the suite pins that is easy to trip on.** `test/installer.sh:281`
greps the whole installed `.agents/` for `40 lines|8 lines|half of the
slice|half the spend|target ~` and fails if any of them appears. None of the
wording above contains one, and this note exists so a later revision of the
design does not introduce one by accident.

**Proposal door, `mason` at `type`, 2026-09-08 17:24 CEST — three "Tracker
section" carriers look unowned by any slice.** Renaming the methodology
carrier to §B2 leaves four, and the spec's Verification accepts them
(wayfinder, slice-task, code-review, triage). Slice 03 removes only the
`triage` one, with its file. So `socle/agents/skills/wayfinder/SKILL.md:30`,
`slice-task/SKILL.md:17` and `code-review/SKILL.md:18` keep pointing at
"`.agents/project.md`, Tracker section" **permanently** — a title that does
not exist in the template, which is the same defect A1 (1) was raised to fix,
and the thing discipline rule 11 forbids. Parent Implementation Decision 2
hands the *bare-number* citations (`§B`, `§C`, `§F`, `§H`) to chantier 5;
these three are a wrong *title*, so they may fall through that gap. The three
evaluations: **size** — three one-clause edits, identical to the one just
typed; **risk** — low, but all three are outside this slice's files map
(`socle/agents/skills/` is explicitly files-to-avoid, and one is slice 02's
neighbourhood); **can I deliver cleanly without it** — yes, entirely: this
slice's criterion is about its own carrier and is met, so nothing here is held
together by a workaround. Reported, not acted on. Not a blocker.

## Diff-Review Findings

Written by the Inspector at `diff-review`.
