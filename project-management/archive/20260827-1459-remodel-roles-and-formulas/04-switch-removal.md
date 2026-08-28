# 04 — Switch removal

**Status:** 🟢 Complete — closed 2026-08-28. Five commits; twelve criteria
satisfied, the last one closing when slice 03 landed its two carriers.
**Blocked by:** None — can start immediately. It shares exactly one file with
slice 03 — `socle/agents/discipline.md` — and never the same passage of it; see
"Overlap with slice 03" in the 🤖 zone for which half each slice owns, and for
the one criterion that closes at whichever of the two lands second.

**What to build:** the permission switch gone from the socle, with nothing in
its place. Ruled by the Owner on 2026-08-28 — "mais l'interrupteur, c'est
débile quoi, je ne veux pas d'interrupteur" — and recorded in full as the
ruling **G10** of `project-management/review-360-decisions.md`, which carries
both of his reproaches. The permission sat in the **wrong file**: whether a run
may go unattended is not a versioned team setting but a choice of the person
launching it — "c'est un choix de l'utilisateur ça". And it was the **wrong
question**: a permission toggle answers nothing anyone needed, the useful
question being "c'est quoi ton flow préféré ?", asked in `.agents/user.md`.

So the section that defines the switch leaves the glue template, and every
file that asks it, migrates it, points at it, or exempts itself from it stops
doing so. The human launches the flow they want, at each invocation. What
survives of the invocation-posture doctrine is its first half — choosing which
preset governs a run is the human's, made at invocation, never an agent's; what
dies is the second — "AND the versioned glue permits it".

**The preferred-flow question is deferred, not built.** Naming a favourite
preset in `.agents/user.md` is a consigned idea and explicitly out of this
slice's scope, because the Owner wants usage before machinery: "je ne sais même
pas si ça vaut le coup de se faire chier […] il faut que je voie c'est quoi le
plus pratique." Nothing in this slice reads, writes, or prepares a place for a
preferred flow. Building it before it has been wanted in practice is the
mistake the ruling is already an example of.

**Scope: eight of the ten carriers.** The switch is named in ten files of
`socle/`. Two of them belong to slice 03 and are already specced there — the
invocation-posture paragraph of `socle/agents/methodology.md` and the opt-in
sentence of `socle/templates/AGENTS-block.md`. This slice leaves both alone.
The inventory of all ten was first drawn in the 🤖 zone of
`project-management/archive/20260827-1459-remodel-roles-and-formulas/03-doctrine-alignment.md`,
under "The switch inventory"; it is cited here, not copied — with one
correction, recorded under "Corrections to the inventory" below. Until whichever
of the two slices lands second, the socle names the switch in some files and not
in others; that interim inconsistency is accepted per the parent's
Implementation Decisions, point 9, and no shim text is written for it.

## Acceptance criteria

Cite these by name. An amended criterion is never erased: strike the original,
date the new version below it.

- [x] **switch-gone-from-the-glue-template** — `grep -n "B3\|Autonomous runs"
  socle/agents/project.md.tpl` returns nothing; and Given the section
  "B · Coordination" of that file, When read, Then it holds the two
  sub-sections "B1 · Where task statuses live" and "B2 · Link to an external
  tracker", both under their existing names and unrenumbered, and no third.
- [x] **b-section-announces-two-decisions** — Given the comment that introduces
  "B · Coordination" in `socle/agents/project.md.tpl`, When read, Then it
  announces the two decisions the section actually holds, and the clause
  describing whether an agent may run a whole task without stopping is gone
  rather than reworded.
- [x] **formula-headers-drop-the-permission** — `grep -rn "B3\|Autonomous
  runs\|Requires the glue" socle/agents/formulas/` returns nothing; and Given
  the header comments of `chisel-auto.formula.toml`,
  `chisel-supervised.formula.toml` and `chisel-auto-light.formula.toml`, When
  read, Then each says the preset runs only when the human explicitly asks for
  it in that session and is never chosen by an agent on its own, with no second
  condition; and Given `chisel-light.formula.toml`, When read, Then the clause
  exempting it from the switch is gone entirely, its neighbouring sentence —
  light is chosen by the human at the sizing check — carrying what the reader
  needs; and Given the `description` field of each of the five formulas, When
  read, Then none of them requires anything of the glue.
- [x] **section-reference-rule-keeps-a-worked-example** — Given the
  section-reference rule of `socle/agents/discipline.md` (the rule requiring a
  cited section to carry both its file and its title), When read, Then its
  worked example names a section of `.agents/project.md` that still exists,
  quoted in the exact form the rule demands, and the rule's own text is
  otherwise unchanged. The rule's position and number are slice 03's business,
  not this slice's — see "Overlap with slice 03".
- [x] **setup-asks-two-questions-in-b** — `grep -n "B3\|autonomous"
  socle/agents/skills/chisel-setup/SKILL.md` returns nothing; and Given that
  skill, When read, Then its verbatim-question screen for the switch is gone,
  the one-question-per-message rule says §B is two questions and two messages,
  the recommended-values list of the section walk no longer poses the switch,
  and the hand-off at the end of the §B2 screen names the next thing actually
  asked instead of a screen that no longer exists.
- [x] **setup-write-spans-still-promise-byte-identity** — Given the surgical
  write rules of `socle/agents/skills/chisel-setup/SKILL.md` and the
  database step that cites them, When read, Then answering one sub-section of
  §B is still promised to leave the others byte-identical, stated without an
  enumeration of sub-section names that would need maintaining the next time
  §B's count changes; and Then no promise is weakened, dropped, or left naming
  a sub-section that no longer exists.
- [x] **migration-poses-no-switch** — `grep -n "B3\|autonomous"
  socle/agents/skills/upgrade-v2/SKILL.md` returns nothing; and Given that
  skill, When read, Then its inventory of what a v1 glue lacks, its list of
  screens to reuse from the setup skill, and the defaults it says a migration
  should pose all name only sections that exist, and no migration poses the
  switch in either position.
- [x] **nothing-replaces-it** — `grep -rin "preferred flow\|flow préféré"
  socle/` returns nothing, and this slice's diff touches neither
  `socle/agents/user.md.tpl` nor any file under `socle/agents/skills/` other
  than the two named above; and Given the whole diff, When read, Then no
  setting, question, field, or placeholder is introduced anywhere to stand in
  for the deleted switch. The Owner's decision is a deletion, not a move.
- [x] **no-switch-left-anywhere** — `grep -rn "Autonomous runs" socle/` and
  `grep -rn "B3" socle/` both return nothing. This one closes at whichever of
  slice 03 and this slice lands **second**, since two of the ten carriers are
  slice 03's; the slice landing first records in its worklog that the grep
  still matches the other slice's carriers and why. Deliberately not
  `grep -rin "autonomous" socle/`: the word survives twice in
  `socle/agents/skills/writing-great-skills/` in an unrelated sense — a
  model-invoked skill the agent can fire autonomously — and those two are
  untouched.
- [x] **equipped-projects-untouched** — Given this slice's diff, When read,
  Then it contains no migration, no cleanup pass, and no change to
  `bin/chisel`: a project already equipped keeps whatever its own
  `.agents/project.md` says, because `chisel update` never rewrites that file
  and this slice does not start. The reasoning, and whose problem the orphan is,
  are in the 🤖 zone under "Already-equipped projects".
- [x] **tests-unchanged** — Given this slice's diff, When read, Then no file
  under `test/` is modified. The seam-by-seam reasoning is in the 🤖 zone under
  "The verification seam"; if implementing proves it wrong, this criterion is
  amended in place rather than quietly dropped.
- [x] **suite-green** — `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`
  passes: 9 scenarios, 94 assertions, 0 failed. The leading path element is not
  cosmetic — with the machine's default `python3` (a pyenv without `tomllib`)
  the formula parse check prints SKIP and proves nothing, a constat recorded
  under the Deno-port chantier of
  `project-management/review-360-decisions.md`.

## The three questions put to the Owner, and where they stand

None of these reopens G10. Each is a consequence of it that the artifacts
could answer or nearly answer; the recommendations are the Architect's, open to
correction at the gate.

1. **Already-equipped projects keep a §B3 nobody reads.** Answered from the
   code, not decided: nothing breaks, and the cleanup belongs to the Deno-port
   chantier, which already owns orphan cleanup for the same class of staleness.
   Full reasoning in the 🤖 zone under "Already-equipped projects".
2. **The discipline's worked example.** Recommended replacement:
   **"§A · Task workspace of `.agents/project.md`"**. Rationale, and the
   alternatives rejected, in the 🤖 zone under "The replacement worked
   example".
3. **`chisel-setup`'s arithmetic and write spans.** What the removal does to
   each promise is enumerated in the 🤖 zone under "What the removal does to
   `chisel-setup`" — five distinct edits, one of which is a rewrite of a
   promise rather than a deletion.

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan.

## Design — persisted at plan time

Persisted 2026-08-28 at the `plan` step, by the Mason implementing this slice,
from the artifacts alone. Read to write it: the 🧑 zones and the 🤖 Notes of
this file; the parent spec
`project-management/archive/20260827-1459-remodel-roles-and-formulas.md` with its
thirteen Implementation Decisions, of which points 9 (interim inconsistency
between slices is accepted) and 11 (a reported deviation from the files map is
the doctrine) bind here; the ruling **G10** and the rulings G5 through G9 that
close `project-management/review-360-decisions.md`; the section "The switch
inventory" in the 🤖 zone of the sibling slice file
`project-management/archive/20260827-1459-remodel-roles-and-formulas/03-doctrine-alignment.md`,
which first listed the ten carriers; and the Design sections of the two closed
slices in this folder, for the house shape of a persisted design. The eight
carriers were read whole before this was written — the two skills included, as
the 🧑 zone requires — and every edit below is quoted in the shape it will
take.

Nothing here reopens G10 or the system design: the *what* is the Owner's
deletion, already ruled. What follows is the *how* — which bytes leave, what
each surviving sentence says instead, and in which order the three commits
land.

### Decisions locked (plan level)

1. **The three autonomous presets get one shared replacement clause**, in one
   shape, with only the preset's own name varying — two comment lines in, two
   out, in each of `chisel-auto.formula.toml`,
   `chisel-supervised.formula.toml` and `chisel-auto-light.formula.toml`. It
   keeps the half of the invocation-posture doctrine G10 keeps and drops the
   half it kills, with no second condition of any kind:
   "<Preset> is opt-in: it runs only when the human explicitly asks for it in
   that session — never chosen by an agent on its own."
2. **The three `description` fields lose their last sentence and gain
   nothing.** Auto's "Requires the glue to enable auto.", supervised's
   "Requires the glue to enable it." and auto-light's "Requires the glue to
   enable autonomous runs." are struck; each description already says what its
   preset does. This folds in the correction the 🤖 zone records under
   "Corrections to the inventory": **three** descriptions carry the clause, not
   the one the sibling slice's inventory named.
3. **`chisel-light`'s exemption leaves with its own divider.** The two comment
   lines saying the switch does not govern light go, and so does one of the two
   bare `#` lines that fenced them, leaving the sentence above — light is
   chosen by the human at the sizing check, never a per-case elision an agent
   decides on its own — directly against the paragraph on what the file owns.
   An exemption from something that no longer exists is noise.
4. **§B's introductory comment loses one clause and one word, and is not
   otherwise reworded.** "Three decisions" becomes "Two decisions" and the
   clause naming whether an agent may run a whole task without stopping is
   deleted; the sentence about everything needing coordination state resolving
   through the section survives verbatim. Re-wrapping is confined to the lines
   the deletion touches.
5. **The sub-section is deleted from its heading to the blank line before
   `## C · Reading list`**, trailing comment included, leaving exactly one
   blank line between §B2's last paragraph and §C's heading. **No
   renumbering**: B1 and B2 keep their names and their order, and the only
   citation of a §B sub-section by title anywhere in the socle —
   "§B1 · Where task statuses live" in `socle/agents/methodology.md` — is
   unaffected.
6. **The discipline's worked example becomes "§A · Task workspace of
   `.agents/project.md`"** — the spec's own recommendation, adopted as written
   for the three reasons its 🤖 zone gives under "The replacement worked
   example": the installer rewrites the journal line inside §A and so cannot
   survive its renaming, the socle already cites it in exactly that form in the
   opening paragraph of `socle/agents/methodology.md`, and it sits outside §B,
   whose sub-section renaming another chantier owns. Nothing else in the rule
   moves — not its text, not its position, not its number, which are the
   sibling slice's business.
7. **The hand-off at the end of the §B2 screen names §C, the reading list** —
   the next thing the walk actually asks, verified against the walk's own
   letter order with §E read back only in Step 3. The file's habit is to name
   the next screen, and naming it keeps the walk auditable.
8. **Both write-span promises are restated symmetrically instead of
   enumerating sub-section names**, per the spec's recommendation, so they stop
   needing maintenance the next time §B's count changes: Step 4's sub-section
   rule ends "Answering one sub-section leaves the others byte-identical.", and
   the database step of Step 6 ends "Use Step 4's sub-section write span: §B's
   other sub-sections stay byte-identical." The generic span rule stated one
   line above the first is untouched, and neither promise weakens, drops, or
   names a sub-section that no longer exists.
9. **The arithmetic moves in both halves of its sentence**, and the rule above
   it does not move at all: "§B is two questions — B1 and B2 — and they are two
   separate messages, not one screen with both headings." Never presenting two
   sections in one message is stated in the sentence before it and is
   unchanged.
10. **The verbatim question screen is deleted whole** — heading and blockquote,
    the two options, the one-line note that it is a one-word edit with nothing
    to migrate, and the recommended answer. §B2's screen becomes the last of
    §B and the §H screen follows it directly. Nothing takes its place.
11. **The migration skill loses the switch from three lists and keeps every
    citation of the retired v1 layer untouched — including the one inside the
    step this slice opens.** Corrected at the plan review, and it matters
    because it moves the hazard onto the first edit: the citations of
    `.agents/rules/task-*.md` and `.agents/workflows.md` are not in Step 2
    alone, where the migration deletes that layer. **The first bullet of Step
    1's inventory carries them too**, and Step 1 is exactly the step whose next
    bullet this slice edits. So the typing rule: in Step 1, the first bullet is
    untouchable and only the bullet listing which glue sections may be missing
    moves; Step 2 is not opened at all.
    **The assertion's real shape**, read in the suite's own source rather than
    inferred: the pointer group collects the *files* that cite those two paths
    and dedups per file, then compares that set against exactly
    `.agents/skills/upgrade-v2/SKILL.md`. So it stays green while any one
    citation survives anywhere in that file, and it fails two ways — if that
    file loses all of them (the citer set empties, and the waiver lines for
    those two paths go stale, failing a second assertion with it), or if
    another installed file gains one. Either failure could stand while every
    criterion of this slice still read green, which is why the two skill edits
    are surgical and quoted below.
12. **Nothing is added anywhere.** No preferred-flow question, field or
    placeholder; no shim sentence explaining the interim; no touch to
    `socle/agents/user.md.tpl`, to any skill other than the two named, to
    `bin/chisel`, or to anything under `test/`. The Owner's decision is a
    deletion, and the deletion is the deliverable.
13. **The interim with the sibling slice is recorded, not papered over.** As
    things stand this slice lands first — slice 03 is 🔴 Not Started — so its
    worklog records that `grep -rn "Autonomous runs" socle/` and
    `grep -rn "B3" socle/` still match the two carriers slice 03 owns, the
    invocation-posture paragraph of `socle/agents/methodology.md` and the
    opt-in sentence of `socle/templates/AGENTS-block.md`, and why. If slice 03
    lands first instead, that note is dropped and the criterion
    **no-switch-left-anywhere** closes here.
14. **The discipline edit travels alone, in its own commit, and a context
    conflict there is expected rather than a deviation.** It is the one file
    both slices touch. The 🤖 zone's prediction that "the hunks do not touch"
    is wrong by two lines, checked in the file at plan review: slice 03
    rewrites the `update`-redirect rule and renumbers the section-reference
    rule below it, while this slice changes the worked example inside that same
    rule, one unchanged line further down. At the usual three lines of context
    the two hunks are one, so whichever Mason lands second resolves a
    single-hunk conflict there. The conclusion survives — one file, one hunk,
    trivial resolution — but it is announced here so the Mason landing second
    reads that conflict as planned, and not as someone having re-scoped the
    shared file.
15. **The surviving-§B3 orphan in already-equipped projects is recorded under
    the Deno-port chantier, and this slice records it.** The 🤖 zone
    recommends exactly that under "Already-equipped projects", and the first of
    the three questions put to the Owner points at it; this design first
    neither adopted nor deferred it, which would have left the orphan recorded
    nowhere but a slice file about to be archived. **Ruled by the thread owner
    at the plan review: take it.** One line goes under chantier 4 of
    `project-management/review-360-decisions.md`, beside the `tomllib` constat
    already recorded there, in the same commit as the glue template. It is
    written in French, like every other note in that file and like the widening
    the thread owner recorded under its chantier 5 the same day: the
    all-English rule governs new artifacts, and consistency inside an existing
    French file governs an addition to it. What it says, in substance: a
    project equipped before this slice keeps a "B3 · Autonomous runs"
    sub-section the socle no longer names anywhere; nothing reads it, and
    `chisel check` never reports it because the glue sits outside the managed
    set; the cleanup joins the deleted Foreman doc page in that chantier's
    orphan pass.

### Writing order — and how the suite stays green

No ordering constraint comes from the suite — but not for the reason this
design first gave, which was false and load-bearing. **Corrected at the plan
review: the template's content IS installed.** The installer copies
`socle/agents/project.md.tpl` verbatim to `.agents/project.md` when it creates
one, `.agents/project.md` is listed in `test/fixtures/golden-tree.txt`, and
both the dangling-pointer group and the render group's two greps walk the
installed `.agents/` tree recursively, that file included. What is true is
narrower, and does not carry any weight here: no `.tpl` file but
`user.md.tpl` is installed.

The reasons that actually hold — the ones the 🤖 zone gives in full, which is
why the two contradicted each other: this slice creates and deletes no file, so
the golden tree does not move; the deleted sub-section, the deleted §B clause
and the new §B comment carry no `.agents/…` path, so no pointer appears or
disappears and no waiver line goes stale; neither the render group's
to-lessons grep nor its numeric-limit grep matches the deleted text or the
added text; and the formula parse check reads `version`, `formula`, the step
ids and the human gates, never a comment and never a `description`. The order
below is chosen for reviewability and for the rebase, not to keep the gate
green.

**Commit 1 — the switch leaves the glue template and the pipeline.**
`socle/agents/project.md.tpl` (the sub-section deleted, the count above it
corrected), the four formula files (three header clauses rewritten, three
`description` fields shortened, light's exemption removed), and
`project-management/review-360-decisions.md` (the one orphan line under
chantier 4, per decision 15). This is the substance of the slice: the thing
itself, everything in the pipeline that pointed at it, and the one line naming
who cleans up after it. Then the gate command, and the criteria named
**switch-gone-from-the-glue-template**, **b-section-announces-two-decisions**
and **formula-headers-drop-the-permission**.

**Commit 2 — the two skills stop asking it and stop migrating it.**
`socle/agents/skills/chisel-setup/SKILL.md` (five edits) and
`socle/agents/skills/upgrade-v2/SKILL.md` (three edits), together rather than
apart: the migration skill tells a migrating session to reuse the setup
skill's screens by name, so the two lists are one edit living in two files.
Then the gate command, and **setup-asks-two-questions-in-b**,
**setup-write-spans-still-promise-byte-identity** and
**migration-poses-no-switch**.

**Commit 3 — the discipline's worked example.**
`socle/agents/discipline.md` alone, for the rebase reason in decision 14. Then
the gate command, and **section-reference-rule-keeps-a-worked-example**,
followed by the criteria that read the whole diff —
**nothing-replaces-it**, **equipped-projects-untouched**, **tests-unchanged**
and **no-switch-left-anywhere** with the interim note decision 13 prescribes.

### `socle/agents/project.md.tpl` — two edits

**The comment introducing "B · Coordination."** Two clauses of it change:

> Two decisions, asked separately by the questionnaire and readable separately
> here: B1 where task statuses live, B2 whether tasks point back to tickets in
> another tool. Everything that needs coordination state — the pipeline steps,
> the skills — resolves through this section and never hardcodes a tool.

**The sub-section "B3 · Autonomous runs".** Deleted whole: the heading, the
verdict line, the paragraph telling an agent to refuse and name that line as
the reason, the paragraph on what flipping the word would permit — which also
names two presets — and the trailing comment on turning it back off. §B ends
on §B2.

### `socle/agents/formulas/` — five files accounted for, four edited

- **`chisel-auto.formula.toml`** — the header's last two comment lines become
  "Auto is opt-in: it runs only when the human explicitly asks for it in that
  session — never chosen by an agent on its own."; the `description` field
  loses its final sentence, ending on "A doubting step blocks and reports
  instead of guessing."
- **`chisel-supervised.formula.toml`** — the same clause in its own name; the
  `description` field ends on "The program design and the review arbitration
  are not the Owner's here."
- **`chisel-auto-light.formula.toml`** — the same clause in its own name, in
  place, mid-header; the `description` field ends on "the measurable floor of
  the pipeline, kept to be benchmarked against the other presets."
- **`chisel-light.formula.toml`** — the two-line reverse clause and one of its
  fencing `#` lines are deleted; its `description` field carries nothing of the
  switch and is untouched.
- **`chisel-default.formula.toml`** — read and **verified untouched**: its
  header carries no opt-in clause, and its `description` requires nothing of
  the glue, ending on "The spec file owns the content; this formula owns the
  order and the gates." Named here so the last clause of
  **formula-headers-drop-the-permission** — the `description` field of each of
  the five formulas — is auditable from this design alone.

Left alone deliberately, in all five headers: the block listing what resolves
through the glue ("§A paths, §B tracker convention, §D living docs, §F gate
commands, §G glossary and decisions"). It names §B by its bare letter for the
tracker convention, which survives; it is not a carrier.

### `socle/agents/discipline.md` — one edit, inside one rule

The section-reference rule's worked example becomes
"§A · Task workspace of `.agents/project.md`", quoted in the exact form the
rule demands — file and title. The rule's own text, its position and its
number do not move.

### `socle/agents/skills/chisel-setup/SKILL.md` — five edits

1. **The section walk's recommended values**, in Step 2: "autonomous runs
   disabled;" is removed from the parenthetical list of questionnaire
   defaults, the other items and their order untouched, re-wrapping confined to
   the lines the removal touches.
2. **The one-question-per-message arithmetic**, in the same step, per decision
   9.
3. **The verbatim §B3 screen**, deleted whole per decision 10, together with
   the blank line that separated it from the §H screen.
4. **The hand-off at the end of the §B2 screen**: "Write it with the user, now,
   before moving to §C, the reading list:".
5. **The two write-span promises**, in Step 4's sub-section rule and in the
   database step of Step 6, restated per decision 8.

Verified unaffected, so nobody re-checks them: Step 7's closing summary prints
one line per section A–H, not per sub-section; Step 1's silent exploration
never scans for the switch; §B1's hand-off into Step 6 and its "before moving
on to §B2" clause stay as they are; and the §B2 screen's own content, its
adapter bullets included, changes only in that final clause.

### `socle/agents/skills/upgrade-v2/SKILL.md` — three edits

1. **Step 1's inventory bullet** — "which of §B1, §B2 and §H are missing — a v1
   glue has none of them".
2. **Step 5's two lists** — the opening sentence keeps the glosses on the
   sections that exist ("§B1 (where task statuses live), §B2 (the link to an
   external tracker) or §H (the team's model tiers)"), and the sentence sending
   the migrating session to the setup skill names "its §B1, §B2 and §H screens
   as they stand". The second list must keep pointing at screens that still
   exist there, which is the coupling that makes commit 2 one edit in two
   files.
3. **Step 5's defaults sentence** — "statuses in the task files, no external
   tracker, model tiers unset". A migration that posed a default for a section
   it no longer creates would be posing that section into existence.

Not opened, per decision 11: Step 2 at all, and in Step 1 the first bullet.
Both carry the citations of the retired v1 layer that the pointer-integrity
group depends on — Step 2 where the migration deletes that layer, Step 1's
first bullet where the inventory reports finding it. Only Step 1's
glue-sections bullet moves.

### `README.md` — one bullet deleted, one count corrected (added 2026-08-28)

Added to this design after the diff review, on the Owner's ruling at the
arbitration gate: the residue the Inspector found is fixed here and now rather
than deferred to the joins-and-minors chantier. It is a deviation from the
parent's files map, recorded below under "Deviations from the parent's files
map".

Two edits, both inside the section that tells the reader what setup asks, and
nothing else in that file:

- **The bullet documenting the switch is deleted whole** — how to turn it on,
  the two presets it would have permitted, and the in-session-permission
  doctrine the ruling G10 struck down. Nothing replaces it: G10 put nothing in
  the switch's place, and the preferred-flow idea for `.agents/user.md` is
  deferred until the Owner has used the thing, so the README must not promise
  it.
- **The count above it becomes one, and the heading with it** — one question
  beyond the paths, written as one line in `.agents/project.md` and changeable
  later by re-running the question. The surviving bullet,
  "§B1 · Where task statuses live, of `.agents/project.md`", is verified true
  against `socle/agents/project.md.tpl` rather than trusted: that sub-section's
  verdict line defaults to the task files, the other case the setup offers is
  the committed database, and the move between them is tooled and touches only
  open tasks.

**Deliberately not done, so the chantier that owns it still has its subject:**
the clause saying `chisel init` is what asks. The ruling A4 of
`project-management/review-360-decisions.md`, recorded there as
"README : « init asks two questions »", hands the joins-and-minors chantier a
truthfulness pass on exactly that point — init installs the socle silently with
safe defaults, and the questionnaire is the `chisel-setup` skill run afterwards
in the agent session. Correcting the count is not that pass, and this edit
leaves its subject standing rather than half-doing it.

### Verification

The gate command, in this exact form, after each commit:
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`. Expected: 9 scenarios, 94
assertions, 0 failed, unchanged from the baseline in every commit, since no
file under `test/` is touched and no file is created or deleted. Without that
leading path element the machine's default `python3` — a pyenv without
`tomllib` — makes the formula parse check print SKIP and prove nothing, a
constat recorded under the Deno-port chantier of
`project-management/review-360-decisions.md`.

Then the twelve named criteria, cited by name, in the grouping the writing
order gives them. **tests-unchanged**, **equipped-projects-untouched** and the
diff half of **nothing-replaces-it** are read off **this slice's own commits**
— `git diff --stat <base>..HEAD`, where the base is **whatever `HEAD` is
immediately before commit 1 lands**, recorded at that moment and not inferred
afterwards. Deliberately not "the tip of the branch as this slice began": the
thread owner's plan-time paperwork on the parent spec and on
`project-management/review-360-decisions.md` may be committed before commit 1
or ride along inside it, and a base fixed at the slice's start would pull that
commit into the range and break the enumeration below. Never read off the
working tree either, which carries that same paperwork uncommitted today.
Expected in the range so defined, and nothing else: the eight carriers, this
slice file, and the decisions file for the one line of decision 15 — no path
under `test/`, none under `bin/`, and none under `socle/agents/skills/` beyond
the two named. Whether the thread owner's pending edits to the decisions file
ride along in commit 1 or land before it is his to decide and changes nothing
here: either way they are outside the base, and the three criteria read the
same.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### The eight carriers, verified in the working tree on 2026-08-28

What each file owes, checked file by file. The two carriers belonging to slice
03 are not repeated here.

**`socle/agents/project.md.tpl`** — two edits, and the substance of the slice.

- The sub-section "B3 · Autonomous runs" is deleted whole: its verdict line
  ("Autonomous runs: disabled."), the paragraph telling an agent to refuse and
  name the line as the reason, the paragraph explaining what flipping the word
  to `enabled` would permit — which also names `chisel-supervised` and
  `chisel-auto` — and the trailing comment saying turning it back off is the
  same one-word edit with nothing to migrate. Verified: **§B needs no
  renumbering.** B1 and B2 keep their names and their order, and no other file
  cites a §B sub-section by a number this deletion would shift (the only
  citation of a §B sub-section by title anywhere in the socle is
  "§B1 · Where task statuses live" in `socle/agents/methodology.md`, which is
  unaffected).
- The comment introducing "B · Coordination" announces "Three decisions" and
  enumerates them, the third being "whether an agent may run a whole task
  without stopping". It becomes two, by deleting the third clause rather than
  rewording the sentence around it.

**`socle/agents/formulas/`** — four files, and more than the inventory said.

- `chisel-auto.formula.toml`, `chisel-supervised.formula.toml` and
  `chisel-auto-light.formula.toml` each carry a two-line header comment of the
  same shape: the preset "is opt-in: it runs only when the human explicitly
  asks for it AND `.agents/project.md` permits it (§B3 · Autonomous runs)". The
  first half survives and the second goes — which is exactly the half of the
  invocation-posture doctrine G10 keeps, and the half it kills, in one edit
  each.
- The `description` field of **all three** of those formulas ends on a clause
  requiring the glue: auto's "Requires the glue to enable auto.", supervised's
  "Requires the glue to enable it.", auto-light's "Requires the glue to enable
  autonomous runs." All three sentences go, with nothing in their place — each
  description already says what its preset does. See "Corrections to the
  inventory" below: the earlier inventory and this slice's brief named only
  auto-light's.
- `chisel-light.formula.toml` carries the reverse clause — "Light is NOT an
  autonomous run: the 'Autonomous runs' switch of `.agents/project.md` §B3
  does not govern it." It goes with the switch: with nothing to be governed by,
  an exemption is noise. The sentence immediately above it already tells the
  reader what matters — light is chosen by the human at the sizing check, never
  a per-case elision an agent decides on its own.
- Note for the writer: the header comments of all five formulas end on a block
  listing what resolves through the glue — "(§A paths, §B tracker convention,
  §D living docs, §F gate commands, §G glossary and decisions)". That line
  names §B by its bare letter for the tracker convention, which survives; it is
  **not** a carrier and is left alone.

**`socle/agents/discipline.md`** — one edit, inside one rule.

The section-reference rule (the one requiring a cited section to carry both its
file and its title) uses the dying section as its worked example:
"§B3 · Autonomous runs of `.agents/project.md`". A rule that demands a worked
example cannot be left without one, so this is a substitution, not a deletion.
Recommendation and rationale under "The replacement worked example". Nothing
else in the rule moves — its text, its position and its number are slice 03's
business, per "Overlap with slice 03".

**`socle/agents/skills/chisel-setup/SKILL.md`** — the delicate one, five
edits. Enumerated under "What the removal does to `chisel-setup`".

**`socle/agents/skills/upgrade-v2/SKILL.md`** — three edits, all naming the
section rather than asking it.

- The Step 1 inventory bullet listing which sections a v1 glue may lack —
  "which of §B1, §B2, §B3 and §H are missing — a v1 glue has none of them" —
  drops the switch and keeps its claim true.
- Step 5's opening sentence names the same list in prose, with a gloss on each
  ("§B3 (autonomous runs)"), and its next paragraph tells the migrating session
  to reuse the setup skill's "§B1, §B2, §B3 and §H screens as they stand". Both
  lists drop the switch — and the second must keep pointing at screens that
  still exist in `chisel-setup`, which is the coupling that makes these two
  files one edit rather than two.
- Step 5's defaults sentence — "statuses in the task files, no external
  tracker, autonomous runs disabled, model tiers unset" — loses its third item.
  A migration that poses a default for a section it no longer creates would be
  posing a section into existence.
- **Hazard, named because a grep-driven edit walks straight into it:** the
  pointer-integrity group of the suite asserts that
  `.agents/skills/upgrade-v2/SKILL.md` is the **only** installed file naming
  the retired v1 layer (`.agents/rules/task-*.md` and `.agents/workflows.md`).
  ~~Those citations live in this skill's Step 2 and must survive untouched;~~ a
  broad cleanup pass over this file that removed them would flip that
  assertion from pass to fail while every criterion above still read green.
  *Corrected 2026-08-28 at this slice's plan review: the citations are in
  **Step 1's first bullet as well as Step 2**, and Step 1 is the step this
  slice's first edit opens. All of them must survive untouched; only Step 1's
  bullet listing which glue sections may be missing moves. The design's
  decision 11 carries the full shape of the assertion.*

### Corrections to the inventory in slice 03

The inventory under "The switch inventory" in
`.../03-doctrine-alignment.md` is the first list of the carriers and is
correct on the file set — ten files, eight of them this slice's. One
correction, found by reading the four formulas rather than the inventory:

- It attributes the switch-bearing `description` field to
  `chisel-auto-light.formula.toml` alone. **Three** descriptions carry it:
  auto's, supervised's and auto-light's, each in a differently worded final
  sentence ("Requires the glue to enable auto.", "…to enable it.", "…to enable
  autonomous runs."), which is why a single grep on the switch's own name misses
  two of them. The per-task brief that spawned this slice repeated the same
  omission. Corrected here rather than in slice 03's file, which is awaiting its
  own gate and is not this slice's to edit; reported to the thread owner.

Also stale, and reported rather than patched: slice 03's 🤖 note under
"Deliberate non-changes, and whose they are" still says of
`socle/agents/project.md.tpl` that it is "pending the Owner's answer to the
open question", and describes the possible edit as "one enumeration in §B3 ·
Autonomous runs". G10 answered past that question and deleted the subject, which
slice 03's own 🧑 zone records under "The open question, closed"; the 🤖 note
below it was not brought level. Harmless — the note only defers work this slice
now carries — but it is an internal contradiction inside a file awaiting a gate,
and the thread owner should decide whether to correct it before that gate.

### Already-equipped projects

**The fact.** `chisel update` never rewrites `.agents/project.md` — the glue is
project-owned, and the suite asserts it byte-for-byte across an update. So a
project equipped before this slice keeps a "B3 · Autonomous runs" sub-section
that the socle no longer knows about.

**Why nothing breaks.**

- The switch was only ever reachable through the socle's own pointers at it.
  With every pointer gone, a surviving §B3 has no reader: no formula header
  sends anyone there, no skill asks it, no discipline rule cites it.
- A stale §B3 reading `enabled` grants nothing, because nothing asks for the
  permission any more. The failure mode of a leftover switch is a switch still
  wired to something; this one is wired to nothing by construction.
- `chisel check` never reports it. The glue is deliberately outside the managed
  set — `check` compares installed managed files against their socle sources,
  and `.agents/project.md` is not one of them (the CLI copies the template once,
  on the init that creates it, and never again). No `DIVERGED`, no `MISSING`.

**What is left, and whose it is.** One cosmetic residue: a human re-reading
their own glue finds a section the doctrine no longer mentions anywhere. That is
the same class of staleness as the deleted Foreman doc page surviving in
equipped projects, and the parent spec already assigns that class to the
Deno-port chantier ("Stale `foreman.md` copies in already-equipped projects are
an orphan-cleanup problem solved there"). **Recommendation:** name this second
orphan in that chantier alongside the first, and build nothing here.

**Two things deliberately NOT done, with reasons.**

- No cleanup in `upgrade-v2`. That skill migrates a v1 layout to v2; a v2 glue
  carrying a section a later socle dropped is not a v1 layout, and teaching the
  v1 migration to also tidy v2 glues would give one skill two jobs and put the
  orphan cleanup in the file least likely to be run by the projects that need
  it.
- No touch to `bin/chisel`. Slice 01 established that a reported deviation into
  `bin/` is legitimate when the deletion mechanically breaks the suite (parent
  Implementation Decisions, point 11). Nothing here does: verified that the CLI
  names neither the switch nor §B3 anywhere, and its only dealings with the glue
  are copying the template on a first init, ticking §E, and rewriting the
  journal path inside §A.

### The replacement worked example

**Recommended: "§A · Task workspace of `.agents/project.md`".**

Why it will not rot, in order of weight:

1. **The CLI structurally depends on §A.** `chisel init` copies the template
   and then rewrites the journal path *inside* §A, keyed on the literal
   `**Changelog:**` line it finds there. §A cannot be renamed or dissolved
   without breaking the installer, which makes its title the most
   rot-resistant one in the whole glue.
2. **It is already cited in exactly that form**, in the opening paragraph of
   `socle/agents/methodology.md`, where the task template is pointed at
   through it. An example that quotes a citation the socle actually makes is a
   better teacher than an invented one, and it costs the rule nothing.
3. **It is outside §B**, whose sub-section renaming is owned by the
   joins-and-minors chantier per slice 03's "Deliberate non-changes". Putting
   the rule's only worked example inside a section another chantier is queued to
   rename would reproduce the fault this slice is fixing.

Alternatives considered and rejected:

- **"§H · Model tiers"** — cited once today, in `methodology.md`, but the model
  tiers doctrine moves under the normative-extraction chantier, so the example
  would sit on ground that is scheduled to shift.
- **"§B1 · Where task statuses live"** — inside §B's rename queue, per the
  point above.
- **"§F · Gate commands"** — stable in substance, but never cited by title
  anywhere in the socle today. An example that is the only citation of a title
  can rot without a second reader noticing, which is precisely the class of
  breakage that produced this edit.

Worth stating for whoever writes it: after this slice, "§B3 · Autonomous runs"
was the single most-cited section title in the socle — six of the ten
citations-with-title, all of them carriers of the dying switch. What remains is
three citations across three sections. The rule's example being one of them is a
feature, not a coincidence.

### What the removal does to `chisel-setup`

Five edits. The first three are deletions; the fourth is a hand-off that would
otherwise point at nothing; the fifth is the one that needs judgement rather
than a delete key.

1. **The verbatim question screen goes.** The whole "§B3 — ask this, verbatim"
   heading and its blockquote — the question, its two options, the one-line
   note that it is a one-word edit with nothing to migrate, and the
   "Recommended: 1 — no" line. Nothing takes its place: §B2's screen becomes
   the last of §B.
2. **The recommended-values list in the section walk.** Step 2's numbered
   instruction carries a parenthetical list of the questionnaire defaults, in
   which "autonomous runs disabled" sits third. The item goes; the list's other
   items and its order are untouched.
3. **The arithmetic in the one-question-per-message rule.** The same step says
   "§B is three questions — B1, B2, B3 — and they are three separate messages,
   not one screen with three headings." §B becomes two questions and two
   messages. **The rule itself does not weaken** — never presenting two sections
   in one message is stated in the sentence above and is unchanged; only its
   worked count moves.
4. **The hand-off at the end of the §B2 screen.** The adapter-page instruction
   says to write the page "with the user, now, before moving to §B3". With no
   §B3, that clause names a screen that does not exist. It should name the next
   thing the walk actually asks, which is §C, the reading list — verified
   against the walk's own order (letter order, with §E read-back only in Step
   3). Leaving it as "before moving on" would also be true, but the file's habit
   is to name the next screen, and naming it keeps the walk auditable.
5. **The write-span promises — a rewrite, not a deletion.** Two places promise
   byte-identity by naming sub-sections:
   - Step 4's sub-section rule ends "Answering B2 must leave B1 and B3
     byte-identical."
   - Step 6, the database step, ends its write instruction with "Use Step 4's
     sub-section write span: B2 and B3 stay byte-identical."

   Neither promise weakens with §B3 gone: the span rule is stated generically
   one line above the first ("from just after its heading to the next `###`
   **or** `##` heading, whichever comes first"), and the named sentences are
   instances of it. **Recommendation: state both symmetrically instead of
   enumerating names** — answering one sub-section of §B leaves the others
   byte-identical — so the promise stops needing maintenance the next time §B's
   count changes, which this slice is itself the second instance of. Step 6's
   line becomes the same shape: the write leaves §B's other sub-sections
   byte-identical.

   What must NOT happen: dropping the promise because its enumeration became
   awkward. It is the sentence that makes Step 4's "never rewrite the whole
   file" checkable, and the surgical write is the whole reason that step exists.

Verified unaffected, so nobody re-checks them: Step 7's closing summary prints
one line per section A–H, not per sub-section; Step 1's silent exploration
never scans for the switch; §B1's hand-off into Step 6 and its "before moving
on to §B2" clause are untouched; and the §B2 screen's own content, the adapter
bullets included, changes only in its final clause.

### Overlap with slice 03

Two slices, one shared file, no shared passage.

- `socle/agents/discipline.md` is touched by both. Slice 03 owns the escalation
  rule, the new incoming-session rule it inserts, and the de-wiring of the
  `update`-redirect rule; inserting a rule pushes the section-reference rule
  down one number. This slice owns **only the worked example inside the
  section-reference rule** and changes neither its position nor its number.
  ~~Whichever lands second rebases onto the other; the hunks do not touch.~~
  *Corrected 2026-08-28 at this slice's plan review: whichever lands second
  still rebases onto the other, but the hunks nearly touch. Slice 03's
  renumbering of the section-reference rule sits one unchanged line above this
  slice's edit to the worked example inside it, so at the usual three lines of
  context the two hunks are one and the slice landing second resolves a
  single-hunk conflict there. The conclusion holds — one file, one hunk,
  trivial — and the design's decision 14 announces the conflict as expected.*
- `socle/agents/methodology.md` and `socle/templates/AGENTS-block.md` are slice
  03's alone, for both the switch and everything else. This slice must not
  touch them, even though a full-socle grep on the switch will point at them —
  that is the interim inconsistency the parent's Implementation Decisions,
  point 9, accepts.
- The criterion **no-switch-left-anywhere** is the only one that cannot close
  from inside one slice. It closes at whichever lands second. Slice 03's own
  criterion for the same subject, **posture-and-permission-separated**, is
  scoped to its two files precisely so the two slices can land in either order.

### Deviations from the parent's files map, declared up front

The parent spec's files-to-avoid map names both places this slice works. Per
the parent's Implementation Decisions, point 11, a reported deviation is the
doctrine and not a violation — declared here at spec time rather than
discovered at review:

- **`socle/agents/project.md.tpl`** is in the map, with the reason "light needs
  no autonomous-runs enabling", and the parent's Not Included section says the
  glue template stays untouched. Both statements were true of the light
  formula's arrival and are simply overtaken by G10, which is dated after them.
  This slice deletes a sub-section of that file — the deepest deviation from the
  map in the task so far, and the reason the removal is its own slice rather
  than a rider on slice 03.
- **The skills directory `socle/agents/skills/`** is in the map, with the
  reason "verified: no skill carries the ladder, the digest or the allotment" —
  which remains true.
  It says nothing about the switch, because the switch was not yet dying when
  the map was drawn. Two skills are touched.

**A third deviation, declared at the diff review rather than at spec time**,
because that is where the Owner ruled it in. `README.md` sits in the parent's
files-to-avoid map with the reason "the joins-and-minors chantier", and the
Inspector found at `diff-review` that the file still teaches the deleted
switch — a residue the routing would have left standing. Ruled by the Owner on
2026-08-28 at the arbitration gate: fixed now. What stays with that chantier is
the rest of the file, the truthfulness pass of the ruling A4 included, so the
two do not collide; this slice corrects a count and deletes a bullet, and
touches nothing else in the file.

Neither of the first two deviations is a finding against the parent's
reasoning; both are the parent's map being older than a ruling, and so is the
third. Recorded here so the Inspector judges
them a posteriori with the reasons in hand, which is what the map doctrine this
task ships asks for.

### Findings against the parent spec, reported not patched

Not this slice's to edit — the parent file belongs to the thread owner. Two of
the four below have since been applied by him; they are struck rather than
erased, so the record of what was found survives.

- ~~**The parent has three slices and this is the fourth.** Its "Slices &
  Dependencies" section enumerates roles-remodel, formulas-rewrite and
  doctrine-alignment, and its sizing check reasons over that set. A fourth slice
  needs an entry there, with its blocker (none) and its overlap with slice 03.~~
  *Applied 2026-08-28 by the thread owner, before this slice's plan step: the
  parent's "Slices & Dependencies" section now carries the fourth entry, with
  its blocker (none) and the note that it shares no file with slice 03, so the
  two land in either order.*
- ~~**The parent's Not Included bullet on the glue template is now false.**
  "`socle/agents/project.md.tpl` — `chisel-light` keeps its human gates, so it
  is not an autonomous run and needs no enabling under '§B3 · Autonomous runs'
  of the glue; the glue template stays untouched." Every clause of it was true
  when written; G10 removes its subject. It should be struck and dated rather
  than erased, per the task's own writing rules.~~
  *Applied 2026-08-28 by the thread owner, before this slice's plan step: the
  bullet is struck in place in the parent, with a dated note naming the ruling
  G10 as what overtook it and this slice as where the removal happens.*
- **The parent has no acceptance criterion for the switch**, because the switch
  was not in its scope. The criteria above are this slice's own; if the Owner
  wants the removal visible at the parent level, one parent criterion naming
  the full-socle grep would carry it, and it would close where
  **no-switch-left-anywhere** closes.
- **The parent's files-to-avoid map** carries the two reasons quoted above,
  both overtaken. Amending the map or leaving the deviations to the worklog is
  the thread owner's call; slice 01 set the precedent of recording the
  deviation rather than editing the map.

### The verification seam

Gate command, in this exact form:
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`. Baseline today: 9 scenarios,
94 assertions, 0 failed, test files at 592 lines against a 600-line cap.

**No test change is expected, and here is why, seam by seam.** Checked in the
suite's own source rather than inferred from slice 03, because this slice has a
different blast radius: it deletes a sub-section of the glue template and edits
two setup/migration skills, where slice 03 edits prose.

- **Re-verified:** `grep -rn "Autonomous\|autonomous\|B3" test/` returns
  nothing. No assertion reads the switch, in any case, anywhere in the suite.
- **No assertion compares an installed `.agents/project.md` against the
  template.** The three places the suite touches that file are: the update
  group, which compares it to a copy of *itself* taken before the update (the
  point being that update leaves it alone); the idempotence group, which checks
  that a §E line a human deliberately unticked survives a re-init; and the
  golden tree, which lists `.agents/project.md` as a **path**. Verified in the
  CLI that a first init copies the template verbatim and then edits only §E's
  ticks and the journal line inside §A. Deleting §B3 changes what a fresh
  install's glue *says* and nothing the suite *reads*.
- ~~**`.agents/project.md.tpl` is never installed.** The only template in the
  installed tree is `.agents/user.md.tpl`, per the golden tree. So the edited
  file never enters the tree the integrity and render groups walk.~~
  *Corrected 2026-08-28 at this slice's plan review: the FILE is not installed,
  but its CONTENT is — the installer copies it verbatim to
  `.agents/project.md`, which the golden tree lists and which both the
  dangling-pointer group and the render group's greps walk. The bullet above
  this one is what actually holds: the suite reads nothing this slice deletes.
  What is true of the templates is only that `user.md.tpl` is the one installed.*
- **The golden tree lists paths**, and this slice creates and deletes no file.
- **The formula parse check** loads each formula with `tomllib` and reads
  `version`, `formula`, the step ids and the human gates — never a
  `description`, never a comment. All four formula edits are header comments
  and three `description` strings; the pinned step counts and gate lists stay as
  slice 02 left them.
- **The pointer-integrity group** requires every `.agents/…` path in an
  installed file to resolve. Verified that no text this slice deletes contains
  such a path: §B3 of the template names two preset names but no path, and
  neither skill's switch passages carry one. So no pointer disappears and no
  waiver line goes stale. **One hazard, restated because it is the real risk of
  this slice:** the same group asserts that `upgrade-v2/SKILL.md` is the only
  file naming the retired v1 layer. ~~Its Step 2 citations of
  `.agents/rules/task-*.md` and `.agents/workflows.md` must survive.~~
  *Corrected 2026-08-28 at this slice's plan review: those citations sit in
  **Step 1's first bullet and in Step 2**, not Step 2 alone, and every one of
  them must survive. The assertion dedups per file, so it holds while any one
  survives in that file and fails if the file loses them all — which also
  makes two waiver lines stale — or if another installed file gains one.*
- **The render group's numeric-limit grep** (`40 lines|8 lines|half of the
  slice|half the spend|target ~`) and its "no to-lessons" grep match nothing in
  the deleted text and nothing this slice writes — the writing rules forbid
  inventing a limit anyway.
- **The line cap on `test/`** is untouched by definition if `test/` is
  untouched, so the headroom against the cap is not spent here.

**Deliberately absent:** any assertion on the doctrine's wording. The Owner
rejected that class of check on the formulas — "revient à des checks sur des
magic strings comme les greps, pas fou" — and the named criteria above are the
tests. The suite's job in this slice is to prove the socle still installs and
renders with a sub-section fewer in its glue template.

### Writing rules in force

English throughout; the Owner's quotes stay in French, in quotation marks; no
naked codes — things are named by their meaning; a section reference carries its
file and its title, never a bare number and never a line number; every pointer
says in one clause what the reader finds there; no invented numeric limits ("on
n'a pas de limites à mettre, c'est une fausse bonne idée"); named acceptance
criteria, cited by name, an amended one struck and dated rather than erased; the
reading gradient — the 🧑 zones short and decision-rich, the detail here.

### Worklog

**Commit 1 — the switch leaves the glue template and the pipeline.** Commit
`dbb0f80`, typed 2026-08-28 from the persisted design as validated at round 2.

- `socle/agents/project.md.tpl` — the sub-section "B3 · Autonomous runs"
  deleted whole (heading, verdict line, the refusal paragraph, the
  what-enabling-would-permit paragraph, the trailing comment), leaving one
  blank line between §B2's last paragraph and §C's heading; the comment
  introducing §B announces two decisions, the third clause deleted rather than
  reworded. No renumbering: B1 and B2 keep their names and their order.
- `socle/agents/formulas/chisel-auto.formula.toml`,
  `chisel-supervised.formula.toml`, `chisel-auto-light.formula.toml` — the
  two-line opt-in clause of each header rewritten to the one shared shape
  (opt-in, asked by the human in that session, never chosen by an agent), with
  no second condition; the last sentence of each `description` field struck.
  All **three** carried it, as the design's decision 2 corrected.
- `socle/agents/formulas/chisel-light.formula.toml` — the two-line reverse
  clause and one of its fencing comment dividers deleted; the sentence above it
  now sits against the paragraph on what the file owns.
- `project-management/review-360-decisions.md` — one note under chantier 4,
  beside the `tomllib` constat, recording the orphan sub-section surviving in
  already-equipped projects and why nothing reads it (decision 15). Written in
  French, like the rest of that file.

**Commit 2 — the setup stops asking it, the migration stops posing it.** Commit
`05fadf5`.

- `socle/agents/skills/chisel-setup/SKILL.md` — the five edits: the verbatim
  question screen deleted whole so §B2's screen is the last of §B and the §H
  screen follows it directly; "autonomous runs disabled" out of the
  recommended-values list; the arithmetic now two questions, two messages, both
  headings; the §B2 hand-off naming §C, the reading list; and the two
  write-span promises restated symmetrically — answering one sub-section leaves
  the others byte-identical — so neither enumerates a name that can go stale.
- `socle/agents/skills/upgrade-v2/SKILL.md` — the three edits: Step 1's
  glue-sections bullet, Step 5's two lists (the prose one and the reuse-these-
  screens one), and Step 5's defaults sentence. Verified after typing that
  every citation of the retired v1 layer survives — Step 1's first bullet and
  Step 2 both — and the pointer group's assertion that this is the only
  installed file naming it stayed green.

**Commit 3 — the section-reference rule keeps a worked example.** Commit
`9a36c27`.

- `socle/agents/discipline.md` — the worked example of the section-reference
  rule becomes "§A · Task workspace of `.agents/project.md`", in the exact form
  the rule demands. The rule's text, its position and its number are untouched.

**Suite after each of the three commits**, run as the brief prescribes
(`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`): 9 scenarios, 94 assertions,
0 failed, test files at 592 lines against the suite's own cap — identical to the
baseline, in all three runs. No gate command went red at any point.

**The conflict decision 14 announced did not happen, and the decision stands
as written.** The thread owner placed slice 03 after this one in the same
working tree rather than on a parallel branch, so the other Mason edits
`socle/agents/discipline.md` with this slice's commit already in. The geometry
the decision describes was right — one unchanged line between the two hunks —
and only its resolution is moot. Kept rather than deleted, because the
prediction is what makes the absence of a conflict readable.

**The criterion no-switch-left-anywhere does not close here, by design.** This
slice lands first, so `grep -rn "Autonomous runs" socle/` and
`grep -rn "B3" socle/` still match slice 03's two carriers: the
invocation-posture paragraph of `socle/agents/methodology.md` (twice — the
parenthetical framing auto as a posture, and the paragraph's own "AND the glue
permits it") and the opt-in sentence of `socle/templates/AGENTS-block.md`. Both
are outside this slice's scope and specced in slice 03, whose own criterion
greps those two files whole. Nothing else in `socle/` matches. The criterion
closes when slice 03 lands.

**No deviation from this slice's files map**, and none from the parent's beyond
the two the spec declared up front — the glue template and the skills
directory. Nothing under `test/` or `bin/` was touched. Diff of the three
commits, read against `3b1c0cd` as the base: the eight carriers plus the
decisions file, nine files, 39 insertions and 72 deletions. Read as **this
slice's own commits**, not as the contiguous range from that base: slice 03
began committing into the same branch on 2026-08-28, so a plain
`3b1c0cd..HEAD` now also contains its work — `socle/agents/profiles/inspector.md`
in its commit `60fd65f`, and its in-flight edits to
`socle/agents/methodology.md`. Neither is this slice's, and neither was touched
here.

**Diff review, one finding applied — Standards axis, low.** Ordered in by the
thread owner on 2026-08-28: the note this slice added under chantier 4 of
`project-management/review-360-decisions.md` wrote its section reference
without the file, which the section-reference rule of
`socle/agents/discipline.md` forbids — and this slice's own commit installed
that rule's worked example. The reference now reads
« §B3 · Autonomous runs » de `.agents/project.md`, the § restored with it, and
the rest of the note stands as written; the paragraph was re-wrapped around the
longer sentence. Suite re-run after the fix: 9 scenarios, 94 assertions, 0
failed, 592 lines. ~~The Inspector's second finding — `README.md` still
teaching the deleted switch — is a residue at the Owner's gate, outside this
slice's scope and not acted on here.~~
*Overtaken 2026-08-28: the Owner ruled at the arbitration gate that the residue
is fixed in this slice, not deferred. Its own worklog entry is below.*

**Commit 5 — the README stops teaching the switch.** The last edit of the
slice, ordered by the Owner at the arbitration gate on 2026-08-28 against the
parent's own routing: `README.md` is in the files-to-avoid map, and the Owner
overruled the map for this one residue rather than leaving a file that teaches a
deleted setting until another chantier gets to it.

- `README.md`, the section on what setup asks — the bullet documenting the
  switch deleted whole with nothing in its place, the count and the heading
  down to one question, and the surviving §B1 bullet left as it stands, its
  claims first verified against `socle/agents/project.md.tpl`. The clause
  naming `chisel init` as the asker is deliberately untouched: the ruling A4
  gives that correction to the joins-and-minors chantier, and doing it here
  would take its subject away.

**The criterion no-switch-left-anywhere now closes, and is ticked.** Slice 03
landed while this slice was in review, so `grep -rn "Autonomous runs" socle/`
and `grep -rn "B3" socle/` both return nothing: the two carriers named in the
paragraph above — the invocation-posture paragraph of
`socle/agents/methodology.md` and the opt-in sentence of
`socle/templates/AGENTS-block.md` — were written switchless there. This slice
landed first and recorded the interim, as the criterion asks; the criterion
closed at the second, which is where it always said it would.

**Nothing for the proposal door.** The one finding this slice raised at plan
time — the under-counted scope of the bare-section-reference sweep — was
recorded by the thread owner under chantier 5 of
`project-management/review-360-decisions.md` before typing began.
