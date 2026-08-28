# 03 — Doctrine alignment

**Status:** 🔴 Not Started
**Blocked by:** 02 — formulas rewrite (closed 2026-08-27). This slice names
`chisel-light` and `chisel-auto-light` in the doctrine tables and in the
routing block, and it makes the two doctrine documents agree with the five
formulas and the five profiles slices 1 and 2 shipped — those files are the
truth here, not a party to the alignment.

**What to build:** the last two documents that still describe the old system,
plus the block that routes every equipped project into it. `discipline.md`
loses the fixed escalation ladder and the word the Owner did not recognize,
gains the incoming-session rule that makes the Mason contract reachable by a
session a human opens by hand, and loses the preset wiring of its
`update`-redirect rule. `methodology.md` — the *why* of the whole socle —
stops contradicting the roles and the formulas in eight places: the escalation
section (retitled, the blocked-task report form defined there once and
nowhere else), the cost-gradient corollary (the Mason is no longer optional and
no longer a typist of someone else's plan), the preset table and the zone
ownership doctrine (five presets, not three), the model-tiers table and the
dex-phases table (the interview is the Foreman's, the program design is the
Mason's), the nine-steps section (where the two light presets are noted), and
the Foreman's roster row (which still omits the interview). The AGENTS block
gains the Foreman and the two new presets, and says truthfully who relaunches
and which presets need enabling. One live miss from slice 2 is repaired:
`socle/agents/profiles/inspector.md` still says it runs the `review` step,
which was renamed `diff-review` — the only stale step name left anywhere in
the socle. The parent's final full-socle greps close here.

## Acceptance criteria

Cite these by name. The first eight restate the parent criteria that close in
this slice; the rest are this slice's own. An amended criterion is never
erased: strike the original, date the new version below it.

- [ ] **no-digest-left** — `grep -rin "digest" socle/` returns nothing. Six
  matches today, all in the two files this slice rewrites: the escalation
  section of `socle/agents/methodology.md` (its title, its ladder line, its
  definition sentence) and rule 6 of `socle/agents/discipline.md` (the rule
  itself and its pointer).
- [ ] **no-fixed-ladder** — `grep -rn "Mason → Architect" socle/` and
  `grep -rn "Architect → Inspector" socle/` both return nothing. Two matches
  today, in the same two files and the same two passages.
- [ ] **no-allotment-left** — `grep -rin "allotment" socle/` returns nothing.
  It already does, since slice 1; this is a check, not work, and it is listed
  so the parent's grep is re-run once over the finished socle.
- [ ] **rule-6-reports-to-the-spawner** — Given rule 6 of
  `socle/agents/discipline.md`, When read, Then a sub-agent reports to its
  spawner, above the owner of the thread sits the human and nothing else, no
  fixed chain of roles is named, and the pointer to where the blocked-task
  report form is defined carries both its file and its section title.
- [ ] **incoming-session-rule** — Given `socle/agents/discipline.md`, When
  read, Then a numbered rule states that a session opened to execute a step
  takes that step's role and reads its profile before acting, and it sits
  adjacent to the rule that binds the spawner side of the same handover.
- [ ] **rule-10-unwired** — `grep -n "chisel-supervised\|chisel-auto"
  socle/agents/discipline.md` returns nothing.
- [ ] **escalation-form-survives** — Given the rewritten escalation section of
  `socle/agents/methodology.md`, When read, Then the blocked-task report form
  is defined there once and nowhere else — a dated ⚠️ line in the journal
  declared in §A · Task workspace of `.agents/project.md`, plus a blocking
  escalation item assigned to the Owner when the coordination state is kept in
  beads — and the section's title carries no word the remodel killed.
- [ ] ~~**mason-not-optional** — `grep -n "optional Mason"
  socle/agents/methodology.md` and `grep -n "OFFERS this choice"
  socle/agents/methodology.md` return nothing; Given the methodology's
  delegation passage, When read, Then it states the two mandatory paths.~~
  *Amended 2026-08-28 at spec time: both greps already return nothing in the
  working tree, because a line break splits "OFFERS this / choice" and bold
  markers split "an optional **Mason**", while the prose they were meant to
  catch still stands. The parent criterion is satisfied vacuously; the version
  below is what bites. Reported to the thread owner as a finding against the
  parent spec's check, not against its ruling.*
- [ ] **mason-not-optional** (amended 2026-08-28) — `grep -ni "optional"
  socle/agents/methodology.md`, `grep -n "opt-in delegation"
  socle/agents/methodology.md`, `grep -n "✅ opt-in"
  socle/agents/methodology.md` and `grep -n "OFFERS"
  socle/agents/methodology.md` all return nothing (the file's only other use
  of "opt-in", in the bridge rule — formality is opt-in, detection is not —
  is legitimate and survives, which is why the greps name the delegation
  senses); and Given the cost-gradient corollary of the section "The two
  designs — and why they do not happen at the same moment" and the
  "Delegable?" column of the section "Where dex's phases live (and who owns
  each)", When read, Then typing always goes through the Mason contract by the
  two mandatory paths — a Mason sub-agent where the tool can spawn one,
  otherwise a fresh session running `work on slice <file>` — and no cell
  presents the delegation as a choice offered to the user.
- [ ] **tiers-follow-the-authorship** — `grep -n "interview, design, plan"
  socle/agents/methodology.md` and `grep -n "already persisted\|already-persisted"
  socle/agents/methodology.md` return nothing; and Given the section "Model
  tiers (and how they resolve)" and the tier paragraph of the cost-gradient
  corollary, When read, Then the interview is the Foreman's, the system design
  and the `plan-review` verdict are the Architect's, the program design is the
  Mason's own, and what the cheap and mid tiers buy is stated as the Tier
  section of `socle/agents/profiles/mason.md` states it — a slice whose system
  design is settled, mid when it is delicate or the codebase unfamiliar.
- [ ] **dex-phases-follow-the-remodel** — Given the Program Design row of the
  section "Where dex's phases live (and who owns each)", When read, Then it is
  produced by the session that implements, at its `plan` step, and validated by
  an Architect at `plan-review`, at the tier that session runs at — not by an
  Architect at a gate, and not at the frontier tier.
- [ ] **presets-table-holds-five** — `grep -n "Three presets"
  socle/agents/methodology.md` returns nothing; and Given the section "A
  default, and two options", When read, Then all five presets are in its table
  with what each gates and which validation sub-agents each runs, and the full
  reading of the two axes they sit on is pointed at in the header of
  `.agents/formulas/chisel-default.formula.toml` rather than restated here —
  and the wording keeps the presets' axes distinct from the two axes of the
  completion review, which this same file names elsewhere.
- [ ] ~~**posture-and-permission-separated** — Given the invocation-posture
  paragraph of the section "A default, and two options", When read, Then
  choosing which preset governs a run is the human's in every case and never an
  agent's, and needing §B3 · Autonomous runs of `.agents/project.md` enabled is
  said only of the presets that run without a human gate — `chisel-light`
  keeps its gates and needs no enabling, which the paragraph states today of no
  preset at all.~~
  *Superseded 2026-08-28 by the Owner's ruling G10: the permission switch is
  deleted, so there is no longer a permission half to scope.*
- [ ] **posture-and-permission-separated** (amended 2026-08-28) — `grep -n
  "B3\|Autonomous runs" socle/agents/methodology.md
  socle/templates/AGENTS-block.md` returns nothing; and Given the
  invocation-posture paragraph of the section "A default, and two options",
  When read, Then choosing which preset governs a run is the human's, made at
  invocation and never by an agent on its own, with no permission granted
  anywhere in the versioned glue.
- [ ] ~~**zones-owned-in-five-presets** — Given the section "Zone ownership",
  When read, Then the owner of the spec zone and the owner of the program
  design zone are stated for each of the five presets, by one rule — a zone
  belongs to whoever approved it, and where nobody approves it, to whoever
  authored it — with the light row exactly as the Owner ruled it: the spec the
  human's, the program design the Mason's.~~
  *Superseded 2026-08-28 by the Owner's ruling that under `chisel-auto-light`
  the zones are ignored rather than owned by their author.*
- [ ] **zones-owned-in-five-presets** (amended 2026-08-28) — Given the section
  "Zone ownership", When read, Then the owner of the spec zone and of the
  program design zone is stated for the four presets that have one, by one
  rule — a zone belongs to whoever approved it, and where nobody approved it,
  to whoever authored it — with the light row exactly as the Owner ruled it
  (the spec the human's, the program design the Mason's); and Then
  `chisel-auto-light` is named as the preset where the zones are IGNORED, not
  reassigned, because it designs, plans and types in one go.
- [ ] **nine-steps-notes-the-light-presets** — Given the section "The pipeline
  is nine steps", When read, Then the nine are said to be the full pipeline,
  the two light presets are named with the steps they drop, and
  `.agents/formulas/` is named as the authority on the order so the count is
  not maintained in two places.
- [ ] **light-in-the-tables** — `grep -n "chisel-light"
  socle/agents/methodology.md socle/templates/AGENTS-block.md` finds a match in
  both files. (The methodology side already matches, from the sizing passage
  slice 2 wrote; the block is this slice's, and the preset table is the
  substance the parent criterion cannot see.)
- [ ] **the-block-tells-the-truth** — Given `socle/templates/AGENTS-block.md`,
  When read, Then its role line names the Foreman as the session that runs the
  formula and holds the interview, the mechanical verify and the close,
  alongside the four roles it spawns (Architect, Checker, Mason, Inspector);
  its formula list names `chisel-light` and `chisel-auto-light` with their
  position in one clause each; the sentence on stopping and relaunching says
  who relaunches in which preset; and the opt-in sentence covers exactly the
  presets that need §B3 · Autonomous runs enabled, per the Owner's answer to
  the open question below.
- [ ] **inspector-runs-diff-review** — ``grep -rn '`review` step' socle/`` and
  `grep -rn "design-check" socle/` both return nothing, and Given the Mission
  of `socle/agents/profiles/inspector.md`, When read, Then the step it runs is
  `diff-review`. (One match today, in that Mission: the last stale step name in
  the socle. Slice 2's rename criterion grepped `design-check` over the whole
  socle and the step id over the formulas alone, so a profile naming the old
  step in prose slipped between the two.)
- [ ] **tests-unchanged** — Given this slice's diff, When read, Then no file
  under `test/` is modified. The reasoning is in the 🤖 zone, under "The
  verification seam"; if implementing proves it wrong, this criterion is
  amended in place rather than quietly dropped.
- [ ] **suite-green** — `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`
  passes: 9 scenarios, 94 assertions, 0 failed. The leading path element is not
  cosmetic — with the machine's default `python3` (a pyenv without `tomllib`)
  the formula parse check prints SKIP and proves nothing, a constat recorded
  under the Deno-port chantier of
  `project-management/review-360-decisions.md`.

## The open question, closed — and what it changed

**The question asked:** does §B3 · Autonomous runs of `.agents/project.md`
govern `chisel-auto-light`? That section named exactly two presets an enabled
project may run, and the shipped `chisel-auto-light.formula.toml` already told
its reader §B3 permits it — a pointer at a permission the glue did not grant.

**The Owner's answer, 2026-08-28, went past the question and killed its
subject:** "mais l'interrupteur, c'est débile quoi, je ne veux pas
d'interrupteur." Recorded in full as the ruling G10 of
`project-management/review-360-decisions.md`, which carries his reasoning: the
permission is in the wrong file — "c'est un choix de l'utilisateur ça" — and
it is the wrong question, the useful one being "c'est quoi ton flow préféré ?"
in `.agents/user.md`. For now nothing replaces it: the human launches the flow
they want, at each invocation. The preferred-flow idea is deferred until he has
used the thing — "il faut que je voie c'est quoi le plus pratique".

**What that does to this slice.** Neither branch of the question survives:
there is no §B3 to extend, and nothing to remove from the auto-light header on
account of a switch that is itself leaving. Two of this slice's own targets are
the doctrine side of the switch, so they are written once, in their final
shape, rather than rewritten later:

- The invocation-posture paragraph of the section "A default, and two options"
  in `socle/agents/methodology.md` loses its second half — the glue's
  permission — and keeps its first: choosing which preset governs a run is the
  human's, at invocation, never an agent's. The criterion
  **posture-and-permission-separated** below is amended to that.
- The opt-in sentence of `socle/templates/AGENTS-block.md` loses its pointer at
  the switch, per the criterion **the-block-tells-the-truth**.

**What that does NOT put in this slice.** The other eight carriers of the
switch — the glue template that defines it, four formula headers, the example
in the discipline's section-reference rule, and the `chisel-setup` and
`upgrade-v2` skills that ask and migrate it — are a removal of their own, and
its placement is the thread owner's question to the Owner. The inventory is in
the 🤖 zone, under "The switch inventory".

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan.

## Design — persisted at plan time

Persisted 2026-08-28 by the `plan` step of this slice, from the files as they
stand on `review-360`. Read first the 🧑 zones of
`project-management/tasks/20260827-1459-remodel-roles-and-formulas.md` and its
thirteen Implementation Decisions (points 1, 8, 12 and 13 bind here), then the
two addenda and the rulings G5 through G10 of
`project-management/review-360-decisions.md`, G10 being the newest and the one
that removes the permission switch whose doctrine half this slice writes.
Nothing below reopens a decision: every ruling is already the Owner's. What it
does is turn the criteria above into an ordered edit list, lock the wording
where a criterion bites, and record the constraints the real files impose.

The reference this slice aligns TO — the five formulas in
`socle/agents/formulas/` and the five profiles in `socle/agents/profiles/` —
was read at plan time and is edited nowhere, `inspector.md` excepted for its
one stale step name.

### Decisions locked (plan level)

1. **The escalation section is titled "Escalation, and the blocked-task
   report".** The slice file recommended it and nothing competes: it names the
   artifact the section defines, and it carries no word the remodel killed.
   Verified: the only inbound citation of that section anywhere in `socle/`,
   `test/` or `bin/` is rule 6 of `socle/agents/discipline.md`, which cites it
   by title and is rewritten in the same slice; no markdown anchor link points
   at it, so no `#escalation-…` fragment breaks. (The anchors that DO exist in
   `socle/agents/methodology.md` point at "Zone ownership", "A default, and two
   options" and "Model tiers (and how they resolve)" — and the `code-review`
   skill links the tiers anchor from outside the file. None of those three
   titles moves.)

2. **The incoming-session rule lands as rule 10, immediately after rule 9.**
   Rule 9 binds the spawner, the new rule binds the session that arrives to
   execute a step — adjacent by construction, which is what the criterion
   **incoming-session-rule** asks for. The insertion pushes the
   `update`-redirect rule to 11 and the section-reference rule to 12.
   Re-verified at plan time: the only citation of a discipline rule BY NUMBER
   anywhere in `socle/`, `test/` or `bin/` is the `retro` skill's citation of
   rule 8 (the repo is the only memory), twice, and rule 8 sits above the
   insertion point — unaffected. No test asserts a rule number.

3. **The presets table keeps its section title, and its columns change.** The
   title "A default, and two options" is cited by name by three criteria of
   this slice, so it stays; the body carries the corrected reading, and the
   "two options" of the title become the two axes the presets actually sit on —
   the human gates and the validation sub-agents. Beads keeps its own clause as
   the third and orthogonal choice (coordination, additive, usable under any
   preset), which is where the section already puts it. The table's columns
   become **Human gates**, **Validation sub-agents** and **Who relaunches**;
   the current "Coordination" column is dropped because its content ("markdown
   or beads") is the orthogonal axis the prose beside it already states, and
   keeping it in the table is what made the presets read as combinations of
   beads × auto. The vocabulary stays clear of the completion review's two axes
   (Standards and Spec), which this same file names in "Why a two-axis review at
   completion": here the word is **preset axes**, and the sub-agents are named
   as sub-agents, never as "axes of review".

4. **The full two-axis reading is pointed at, not restated.** The header of
   `.agents/formulas/chisel-default.formula.toml` is where slice 2 put it, per
   its criterion **two-axes-said-once**; the methodology's table carries one
   line per preset and one clause pointing there. The three deliberate
   non-changes of that section stand — "Factory = auto × beads", the
   `SDD-bench` pointer and the glossary's tracker pointer all belong to the
   joins-and-minors chantier.

5. **The word "opt-in" leaves the AGENTS block with the switch it named.** In
   the block it meant permission — "either runs only when a human asks AND
   `.agents/project.md` permits it (§B3 · Autonomous runs)". G10 deletes the
   permission, so the sentence is replaced rather than trimmed: which preset
   governs a run is the human's choice at invocation, and the relaunch sentence
   says who relaunches in which preset. No preset needs enabling, so the block
   names no permission at all. The word survives elsewhere in the socle only in
   its legitimate sense (the bridge rule's "formality is opt-in, detection is
   not"), which this slice does not touch.

6. **Rule 6 keeps its trigger clause verbatim.** "Blocked twice on the same
   thing, or pushed outside the approved plan" stays as it is: what this slice
   owns in rule 6 is the escalation doctrine — the ladder, the dying word, the
   pointer — and rule 2 of the same file still speaks of "the approved plan",
   so changing the phrase in one rule and not the other would trade a stale
   sentence for an inconsistent pair. The discipline's own rewrite is the
   normative-extraction chantier's, and that phrase belongs to it. Recorded so
   a reviewer reads the omission as chosen, not missed.

7. **Rule 9 gains exactly one clause.** The clause names the owner of the
   thread — the Foreman — as the role that carries the duty, with its profile
   path. It does NOT grow the paste-the-body-verbatim statement: that mechanism
   is stated once, in `socle/agents/profiles/README.md`, and duplicating it
   into the discipline is the surface the normative-extraction chantier exists
   to remove.

8. **The dex-phases table changes two "Delegable?" cells, not one.** The slice
   inventory names the implementation row; the Program Design row's cell says
   "never", which point 12 of the parent's Implementation Decisions makes false
   — the program design is now the implementing session's own work, so it is
   delegated by construction. Both cells are rewritten in the same edit, and
   the Product and System Architecture rows keep their "never", which is the
   delegation boundary of point 13. Flagged here because it extends the slice's
   own inventory by one cell.

9. **The Foreman joins the frontier row of the model-tiers table.** The
   criterion **tiers-follow-the-authorship** requires the interview to be the
   Foreman's in that section, and the row currently lists Architect, Checker
   and Inspector only. Adding the Foreman is how the section can say it — and
   it levels the table with the roster, which already carries the Foreman at
   frontier.

10. **Four commits, one per file, each green — and the methodology lands
    before the discipline.** No edit in this slice depends on another to keep
    `test/run.sh` green: no file is created or deleted, no formula is touched,
    and every new pointer resolves in the installed tree. The order is
    nevertheless not free. Rule 6 of the discipline cites the escalation
    section BY TITLE, and that title only exists once
    `socle/agents/methodology.md` is rewritten — so the methodology commit
    comes first and the citation never dangles, not even between two commits of
    the same slice. The suite would be green either way (the pointer group
    checks paths, not section titles), which is exactly why the order has to be
    decided by reading rather than by the gate. It also keeps the two greps
    that span both doctrine files (**no-digest-left**, **no-fixed-ladder**)
    adjacent, going green at the discipline commit.
    *Corrected at `plan-review` round 1, 2026-08-28: the first version of this
    plan had the discipline second-to-last and the methodology last, which
    published a rewritten rule 6 pointing at a section title that did not yet
    exist.*

11. **The two records that cite the section-reference rule as "rule 11" are
    left alone.** Renumbering it to 12 makes them stale:
    `project-management/tasks/20260827-1459-remodel-roles-and-formulas/01-roles-remodel.md`,
    a closed slice, and `project-management/vendored-skills-audit.md`, an audit
    that is not a task yet. **Ruled by the thread owner at `plan-review` round
    1, 2026-08-28: touch neither.** A closed record states what was true when it
    was written, and editing it would falsify the history the two-axis review
    reads. Recorded here so the Inspector reads the two stale numbers as a
    ruling and not as a miss. (Both sit outside `socle/`, so no criterion of
    this slice greps them.)

### Writing order — and how the suite stays green

The gate command, in this exact form, runs after every commit:
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`. Baseline: 9 scenarios, 94
assertions, 0 failed, test files at 592 lines. Without that leading path
element the formula parse check prints SKIP and proves nothing.

**Commit 1 — `socle/agents/profiles/inspector.md`, the stale step name.** One
phrase in its Mission. Independent of everything else in the slice and the
cheapest criterion to close (**inspector-runs-diff-review**). The render group
re-derives the expected agent definitions from the profile itself, so editing a
profile body cannot break it.

**Commit 2 — `socle/agents/methodology.md`.** The eight edits, in file order.
They land together because five of the eight are the same doctrine seen from
five angles — a file that makes the Mason mandatory in its corollary while its
tiers table still buys "typing from an already-persisted plan" contradicts
itself in the reader's hands. It comes before the discipline so that the
escalation section exists under its new title before rule 6 cites it (plan
decision 10).

**Commit 3 — `socle/agents/discipline.md`.** Rule 6 rewritten, the
incoming-session rule inserted as rule 10, rule 9's one clause, the
`update`-redirect rule de-wired, and the two renumbers the insertion forces.
One file, one commit: renumbering across commits would leave the file with two
rules numbered 10.

**Commit 4 — `socle/templates/AGENTS-block.md`.** The role line, the formula
list, the relaunch sentence. The rendered-block assertion extracts the managed
block from the installed `AGENTS.md` and compares it byte for byte against this
template, so editing the template cannot break it; the two routing assertions
beside it look for `.agents/discipline.md` and
`.agents/formulas/chisel-default.formula.toml`, and both strings survive the
rewrite — checked against the target text below.

New pointers this slice introduces, all resolving in the installed tree:
`.agents/profiles/foreman.md` (discipline rule 9, the block's role line),
`.agents/formulas/chisel-light.formula.toml` and
`.agents/formulas/chisel-auto-light.formula.toml` (the block's formula list,
the methodology's preset table).

### `socle/agents/profiles/inspector.md` — one phrase

In the Mission's opening sentence, "It runs the `review` step of the pipeline in
`.agents/formulas/`" becomes "It runs the `diff-review` step of the pipeline in
`.agents/formulas/`". Nothing else in the file moves: its Escalation section,
its files-map duty and its Inputs are all level with the remodel (slice 1).

### `socle/agents/discipline.md` — three rules and one insertion

Commit 3, after the methodology (plan decision 10). The per-file sections below
are in file-reading order, not in commit order.

**Rule 6, rewritten.** Trigger clause unchanged (plan decision 6); the ladder,
the dying word and the pointer replaced:

> 6. **Escalate, don't improvise.** Blocked twice on the same thing, or pushed
>    outside the approved plan → stop and ask. A sub-agent reports to its
>    **spawner** — the owner of the thread of work it was spawned into, which
>    decides within what it owns; above the thread owner sits the human, and
>    nothing else. Where there is no human at the gate, block the task, write
>    the blocker into the spec file and send the report one rung up; never force
>    a passage on your own authority. What the report is made of:
>    `.agents/methodology.md` ("Escalation, and the blocked-task report").

**Rule 9, one clause added** at the end, after "The contract lives with the role
that consumes it.":

> This duty belongs to the owner of the thread — the Foreman, whose contract is
> `.agents/profiles/foreman.md`.

**Rule 10, new**, inserted immediately after rule 9:

> 10. **A session opened to execute a step takes that step's role.** A fresh
>     session started to run a step of the pipeline — `work on slice <file>`
>     and its kin — reads that step's role profile in `.agents/profiles/`
>     before acting, and works under it for the whole session. The profile is
>     the contract whether the session was spawned or opened by hand: rule 9
>     binds the side that delegates, this one binds the side that arrives.

**Rule 11 (was 10), de-wired.** Its second half loses the presets and keeps the
chaining:

> 11. **A refused `update` is a redirect.** An agent whose `chisel update` is
>     refused for a v1 layout does not stop there: it chains onto the
>     `upgrade-v2` skill and proposes the upgrade instead of stopping at the
>     refusal, then puts the new glue questions to the human.

**Rule 12 (was 11), number only.** The section-reference rule's text, position
and worked example are untouched here — the example is slice 4's single edit to
this file (`04-switch-removal.md`, its section
"`socle/agents/discipline.md` — one edit, inside one rule").

**The two slices collide inside that rule, and it is planned, not a re-scope.**
Renumbering the rule changes its first line; slice 4 changes the worked example
one unchanged line below it. At three lines of context the two hunks are ONE
hunk, so whoever lands second resolves a single-hunk conflict by hand — keeping
the other slice's number and its own example, or the reverse. The resolution is
mechanical and the two edits are still disjoint in substance: this slice never
touches the example, slice 4 never touches the number, and slice 4's design
announces the same collision from its side.
*Corrected at `plan-review` round 1, 2026-08-28: the first version of this plan
claimed the hunks do not touch, which is true of the lines and false of the
hunks.*

### `socle/agents/methodology.md` — eight edits, in file order

Commit 2, the first of the two doctrine files to land.

**(a) Section "A default, and two options" — the opening paragraph.** The §B3
pointer goes with the switch, and "auto" stops being one of two options:

> chisel has one default behaviour: the human holds every gate. Two things vary
> from there, and they vary independently — the **human gates** (who stops the
> run and reads) and the **validation sub-agents** (which fresh reviewers run:
> a Checker on the spec, an Architect at `plan-review`, an Inspector on the
> diff). Five presets place themselves on those two axes.

**(b) Same section — the table.** "Three presets combine them:" becomes "The
five presets, and where each sits:", and the table gains the two light presets
and loses its Coordination column (plan decision 3). The "Who relaunches"
column stays — **ruled by the thread owner at `plan-review` round 1,
2026-08-28**: the information is worth having in the table the Owner reads, and
what must not stand is a table implying a third axis, which the clause below it
now denies in half a sentence. Ruling G6(d) of
`project-management/review-360-decisions.md` is explicit that the presets are
two axes and not a scale.

> | Preset | Human gates | Validation sub-agents | Who relaunches |
> |---|---|---|---|
> | `chisel-default` | every gate awaits the human — the spec, the Mason's program design, the review arbitration | all three | the human, at every step |
> | `chisel-light` | two — the spec, and the diff review the human holds himself | none | the human, at every step |
> | `chisel-supervised` | one — the Owner approves the spec, nothing else | all three | the Foreman, spawning the next step fresh |
> | `chisel-auto` | none; a doubting step blocks and reports instead | all three | the Foreman, spawning the next step fresh |
> | `chisel-auto-light` | none | none | the Foreman, spawning the next step fresh |

Followed by one clause pointing at the full reading, and one naming the floor:

> The full reading of the two axes — what each preset buys and gives up on each
> — is in the header of `.agents/formulas/chisel-default.formula.toml`, and it
> is written there once. The third column is not a third axis: who relaunches
> follows from whether the run is driven by the human or by the Foreman, and
> nothing places a preset on it independently. `chisel-auto-light` empties both
> axes: it is an instrument built to be measured against the others, not a
> notch on either.

The "Factory = auto × beads" paragraph that follows is untouched (the
joins-and-minors chantier owns the degraded factory claim).

**(c) Same section — the invocation-posture paragraph.** Its second half — the
glue's permission — goes; its first half stays and is the whole paragraph:

> **The invocation-posture principle.** Piloting — which preset governs this
> run — is chosen per invocation, never baked into the project as a permanent
> setting, and the choice is the human's: a non-default preset runs when a
> human asks for it in that session, never because an agent decided it. Nothing
> in the versioned glue grants or withholds it. Coordination (beads) is the
> other axis entirely: repo state, additive, and orthogonal to which preset is
> running — a beads-equipped repo stays fully usable under the default.

**(d) Section "The roster" — one cell.** The Foreman's "Does" cell becomes:
"Owns one thread of work — carries the context, **leads the interview**, spawns
the other roles, collects their reports and rules on them". Every other row is
already level with the profiles.

**(e) Section "Zone ownership" — three presets become four, plus the one where
the question does not arise.** One rule, then the presets:

> The 🧑 mark names the zone's **owner**, not simply "the human" — and
> ownership follows one rule: a zone belongs to whoever **approved** it, and
> where nobody approves it, to whoever **authored** it.
>
> - In the **default**, the human approved both the spec and the Mason's
>   program design, so both are his.
> - In **light**, the human approved the spec, so it is his; nobody approves
>   the program design — no `plan-review`, no gate on it — so it belongs to its
>   author, the Mason.
> - In **supervised**, the spec is the human's (the one asynchronous gate); the
>   program design is the Architect's, who approved it at `plan-review`.
> - In **auto**, no human approved anything: the spec is the Architect's, who
>   authored it (the Checker reviews it, it does not author it), and the
>   program design is the Architect's, who approved it at `plan-review` — a
>   Mason's escalation on either terminates there, and the human never hears of
>   it.
> - Under **`chisel-auto-light`** the zones are **ignored**, not reassigned to
>   their author: the preset designs, plans and types in one go. Ruled by the
>   Owner on 2026-08-28: "Dans le cas d'un chisel-auto-light ces zones sont à
>   ignorer : ça design + plan + code d'une traite."

The closing "The Brief is always the human's, in every mode" paragraph is
untouched — it is upstream of every preset, auto-light included.

**(f) Section "Escalation, and the Owner's digest" — retitled and rewritten.**
Title: "Escalation, and the blocked-task report". Body:

> There is no chain of roles. A role that cannot decide reports to its
> **spawner** — the owner of the thread it was spawned into. The thread owner
> decides within what it owns and hands anything above that one rung up; above
> the Foreman sits the human, full stop. Which rung a question goes to depends
> on who spawned whom, not on a hierarchy between roles: there is none.
>
> Whoever cannot decide **blocks the task** and writes the report. Its form is
> named across the profiles and the formulas and defined here, once, and it
> creates **no new artifact**: a dated ⚠️ line in the journal declared in §A ·
> Task workspace of `.agents/project.md`, plus — when §B1 · Where task statuses
> live of `.agents/project.md` keeps the coordination state in beads — a
> blocking `escalation` item assigned to the Owner, per the §B convention. That
> is the whole mechanic.

**(g) Section "The pipeline is nine steps" — the light presets noted, the
authority named.** "Not seven." goes with the rewrite:

> Nine is the FULL pipeline, and `chisel-default`, `chisel-supervised` and
> `chisel-auto` run all nine. What varies is the validation sub-agents:
> `chisel-light` drops `spec-review` and `plan-review`; `chisel-auto-light`
> drops those two and `diff-review` as well. Nothing else leaves, and the count
> is not maintained here twice — `.agents/formulas/` owns the order and the
> steps of every preset.
>
> The two reviews light drops are doctrine, not afterthought: `spec-review` is
> a Checker in a fresh session, never the spec's author, two rounds max;
> `plan-review` is an Architect answering VALIDATED or corrections on the
> program design the implementing session posted, two rounds max, then a
> finding against the spec. Where the gates sit is the formulas' business,
> named per preset — see [A default, and two
> options](#a-default-and-two-options) above; this file does not restate it
> step by step.

**(h) Section "The two designs …" — the cost-gradient corollary.** The label
loses "(opt-in delegation)"; the optional Mason, the offered choice, the
Architect's "interview, design, plan" and the "already-persisted plan" all go:

> **Corollary — the cost gradient.** Persisting the program design makes the
> slice file a complete brief, which unlocks a division of labor: the
> **Architect** does the upstream thinking with the human — the exploration,
> the spec and the system design — and answers the `plan-review`; the **Mason**
> designs the how for itself at its `plan` step and types it. Typing always
> goes through the Mason contract, by one of two mandatory paths: a Mason
> sub-agent where the tool can spawn one, otherwise a fresh session running
> `work on slice <file>`. It is not a choice offered to the user, and no agent
> elides it.

The delegation-boundary sentences are **the tail of that same paragraph**, not
a paragraph after it: they run from "The delegation boundary is the **system
design**" to "it is what the `plan` step is for", they are slice 2's, and the
splice keeps them word for word — the replacement above swaps the sentences
before them and the paragraph is re-wrapped as one block. Then the tier
paragraph:

> That gradient is a **tier** gradient, not a licence to spend: the upstream
> thinking and the reviews run at the frontier tier, and a slice whose system
> design is settled runs at the cheap tier — mid when the slice is delicate or
> the codebase unfamiliar. Which concrete model each tier means is resolved per
> dev and per project — see [Model
> tiers](#model-tiers-and-how-they-resolve) below.

The economics paragraph keeps its meaning; its "keeping the Architect's context
clean enough to review" survives, since the Architect still reviews — the
program design, at `plan-review`. Then the SECOND of the two bullets below it
(the first, "Explicit references beat shared memory", is untouched):

> - **The Architect never implements** — its context stays clean for the
>   `plan-review` verdict it answers on the program design; the diff is the
>   Inspector's. All completion gates still run; the two-axis review is a
>   decorrelated lens by construction (at the frontier tier).

And the closing quality-measure sentence takes its object from
`socle/agents/profiles/architect.md`, which already states it: a Mason that
could not implement from the artifacts is a finding **against the spec** — fix
the file, not the Mason's context.

**(i) Section "Model tiers (and how they resolve)" — the table's three role
cells.** Title and anchor unchanged (the `code-review` skill links it):

> | **frontier** | Thinking, grilling, reviewing — where a wrong judgement is expensive and only caught much later | Foreman (owns the thread, leads the interview, rules on reports); Architect (exploration, spec and system design, the `plan-review` verdict); Checker (spec review); Inspector (the two-axis review) |
> | **mid** | Ordinary tasks and dispatch — work that needs competence but not judgement | A Mason on a slice that is delicate, or in a codebase it does not know |
> | **cheap** | The how of a slice whose system design is settled, when that how is mechanical | A Mason on such a slice |

**(j) Section "Where dex's phases live (and who owns each)" — two rows, three
cells.** The Program Design row. The tier qualifier binds the PRODUCING
session, which is what replaces the cell's current "frontier tier"; the
Architect's `plan-review` verdict carries no tier here, because it is frontier
work and edit (i) says so in the frontier row:

> | **Program Design** (types, signatures, layout, call stacks) | Unsliced task: Implementation Decisions. Sliced task: each slice's **Design** section, persisted at plan time | The session that implements, at its `plan` step — at that session's tier, not the frontier; an Architect validates it at `plan-review` | ✅ always — it is the implementing session's own work |

The Vertical Slices row, both of its cells that this slice's own changes make
false:

> | **Vertical Slices** (implementation) | The code, cycle by cycle | Mason, cheap tier — mid when the slice is delicate, or in a codebase it does not know | ✅ always — through the Mason contract |

Two things left that row: `✅ opt-in` in the "Delegable?" cell, and "the only
delegable phase" in the *Produced by* cell — untrue the moment the row above it
becomes always-delegable. Its "mid when the slice is not purely mechanical" is
the pre-remodel wording and is levelled with `socle/agents/profiles/mason.md`
in the same pass, exactly as edit (i) levels the tiers table.

The Product and System Architecture rows keep their "never": the delegation
boundary is the system design.

*Corrected at `plan-review` round 1, 2026-08-28: the first version of this plan
hung the tier qualifier on the Architect's validation, contradicting edit (i)
in the same commit, and left both Vertical Slices cells out of the edit.*

### `socle/templates/AGENTS-block.md` — two lines and a paragraph

It stays a routing block: one clause per preset, no doctrine, and its closing
line still promises the socle carries the content.

**The role bullet**, last of the four in the pipeline list:

> - The invoking session is the **Foreman** (`.agents/profiles/foreman.md`): it
>   runs the formula, and it holds the interview, the mechanical verify and the
>   close itself. Every other step is a fresh sub-agent it spawns — Architect,
>   Checker, Mason, Inspector. Read a role's profile in `.agents/profiles/`
>   before spawning it; the contracts live there.

**The formula list**, replacing the paragraph that names auto and supervised.
**Four clauses, one per preset, starting at light** — the default is not among
them: it is routed in the paragraph above this one ("the pipeline is
`.agents/formulas/chisel-default.formula.toml`"), which this slice does not
touch. Order: light, supervised, auto, auto-light.

> `.agents/formulas/chisel-light.formula.toml` keeps the human gates and drops
> the validation sub-agents: no Checker on the spec, no `plan-review`, and at
> the diff review the human reads in the Inspector's place.
> `.agents/formulas/chisel-supervised.formula.toml` keeps exactly one human
> gate — the Owner approves the spec, nothing else — with every sub-agent.
> `.agents/formulas/chisel-auto.formula.toml` is the same pipeline with every
> human gate replaced by escalation: a doubting step blocks and reports one
> rung up instead of waiting. `.agents/formulas/chisel-auto-light.formula.toml`
> drops both — no gate, no sub-agent — and exists to be measured against the
> others, not as a lighter way to work.

**The relaunch and choice sentence**, replacing "Both are opt-in…
(§B3 · Autonomous runs)":

> Which preset governs a run is the human's choice, made at invocation and
> never an agent's. Under the default and light the run stops at each step and
> the human relaunches it; under supervised, auto and auto-light the Foreman
> spawns the next step itself, fresh.

Untouched, and checked against the two routing assertions of the suite: the
"**Always** — follow `.agents/discipline.md`" opening, and the "the pipeline is
`.agents/formulas/chisel-default.formula.toml`" line.

### Verification order

1. After each commit: `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` — 9
   scenarios, 94 assertions, 0 failed. A red suite stops the slice at that
   commit.
2. After commit 4, the greps of every named criterion, in the file's order:
   **no-digest-left**, **no-fixed-ladder**, **no-allotment-left**,
   **rule-10-unwired**, **mason-not-optional** (its four greps),
   **tiers-follow-the-authorship** (its two), **presets-table-holds-five**,
   **posture-and-permission-separated**, **light-in-the-tables**,
   **inspector-runs-diff-review** (its two).
3. Then the read-through criteria, each against the finished file:
   **rule-6-reports-to-the-spawner**, **incoming-session-rule**,
   **escalation-form-survives**, the Given/When/Then halves of
   **mason-not-optional**, **tiers-follow-the-authorship**,
   **dex-phases-follow-the-remodel**, **presets-table-holds-five**,
   **posture-and-permission-separated**, **zones-owned-in-five-presets**,
   **nine-steps-notes-the-light-presets**, **the-block-tells-the-truth**.
4. Then **tests-unchanged** (`git diff --name-only` names no path under
   `test/`) and **suite-green** one last time on the whole slice.

The count to tick against is **19 distinct criterion names across 22
checkboxes** — three names appear twice, once struck and once amended, and a
struck criterion is verified in its amended form only. Counted at `plan-review`
round 1, 2026-08-28, against this file; the brief that opened the slice said
seventeen, which is not the number to trust while ticking.

### Implementation checkboxes — the resume point

A fresh session picking this slice up restarts at the first unticked box.

- [ ] Commit 1 — `socle/agents/profiles/inspector.md`: `review` →
  `diff-review` in the Mission. Suite green.
- [ ] Commit 2 — `socle/agents/methodology.md`: edits (a) through (j) above,
  in file order. Suite green.
- [ ] Commit 3 — `socle/agents/discipline.md`: rule 6 rewritten, rule 9's
  clause, the new rule 10, the `update`-redirect rule de-wired, rules 10 and 11
  renumbered to 11 and 12. Suite green. (After the methodology, so rule 6's
  citation of the escalation section never dangles — plan decision 10.)
- [ ] Commit 4 — `socle/templates/AGENTS-block.md`: the role bullet, the
  formula list, the relaunch sentence. Suite green.
- [ ] Verification: the grep criteria, then the read-through criteria, then
  **tests-unchanged** and **suite-green**.
- [ ] Worklog and status written into this file, per the task template.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### The inventory, verified in the working tree on 2026-08-28

What each file still owes, checked file by file rather than inferred from the
parent spec.

**`socle/agents/discipline.md`** — three edits.

- Rule 6 ("Escalate, don't improvise") carries the fixed ladder and the dying
  word twice: once in the rule, once in the pointer that tells the reader what
  the concept is. The replacement doctrine is already written in the profiles:
  a sub-agent reports to its spawner, the thread owner decides within what it
  owns, above it sits the human, full stop. The report's FORM survives, and it
  is defined in `methodology.md`, not here — this rule points at it.
- The incoming-session rule is missing. It lands as a new numbered rule
  adjacent to rule 9 ("Read a role's profile before spawning it"), which is
  its spawner-side twin: rule 9 binds the delegator, the new one binds the
  session that arrives to execute a step. Inserting it there pushes the
  `update`-redirect rule and the section-reference rule down one number each.
  Verified: the only inbound citation of a discipline rule by number anywhere
  in `socle/`, `test/` or `bin/` is the `retro` skill's citation of rule 8
  (the repo is the only memory), which sits above the insertion point and is
  unaffected. Why the discipline and not the AGENTS block: parent
  Implementation Decisions, point 1 — the discipline is the ambient core every
  conversation loads, including the fresh session a human opens by hand, and
  the block only routes.
- Rule 9 keeps its text and gains one clause naming the owner of the thread
  (the Foreman) as the role that carries it, per the roles ruling. It does NOT
  grow the paste-the-body-verbatim statement: that mechanism is stated once, in
  `socle/agents/profiles/README.md`, and the compact rewrite of the discipline
  belongs to the normative-extraction chantier.
- The `update`-redirect rule loses "runs it under `chisel-supervised` or
  `chisel-auto`" and keeps the rest: de-wired here, deleted outright by the
  joins-and-minors chantier (parent Implementation Decisions, point 8).

**`socle/agents/methodology.md`** — eight edits, all in sections the parent's
Deliverables list.

- Section "Escalation, and the Owner's digest": retitled and rewritten. There
  is no chain; whoever cannot decide blocks the task and reports to its
  spawner, and the rung above — ultimately the human — decides. The section
  stays the single definition point of the report form, which is what the
  criterion **escalation-form-survives** protects; the Foreman profile is the
  only other file that states the form, in one clause, because the Foreman is
  the actor who writes it (slice 1's plan decided that split deliberately).
  Recommended title, not locked: "Escalation, and the blocked-task report" —
  whatever it becomes, rule 6 of the discipline cites it by that title.
- The cost-gradient corollary of "The two designs — and why they do not happen
  at the same moment": the label "(opt-in delegation)" goes, the optional Mason
  and the offered choice go, the two mandatory paths arrive. Three sentences in
  the same passage are false for the same reason and are rewritten with it: the
  Architect no longer "does the thinking (interview, design, plan)" — the
  interview is the Foreman's and the program design the Mason's; the tier
  sentence no longer buys "typing from an already-persisted plan"; and the
  bullet claiming the Architect's clean context is for "reviewing the Mason's
  diff against the plan" is doubly wrong now — the diff is the Inspector's and
  the Architect's own review is the `plan-review` verdict. The quality-measure
  sentence at the end of the passage ("if a Mason cannot implement the slice
  from the persisted design") keeps its meaning but takes its object from the
  Architect profile, which already says it: a Mason that could not implement
  from the artifacts is a finding against the spec.
- Section "A default, and two options": the table gains `chisel-light` and
  `chisel-auto-light`, and "Three presets combine them" goes. Framing to
  watch: the section presents the presets as combinations of two OPTIONS
  (beads, auto), which the light presets do not fit — they vary the validation
  sub-agents, not the permission to run unattended. The table's columns become
  what each preset gates and which sub-agents it runs, with the full two-axis
  reading pointed at in the default formula's header, where the criterion
  **two-axes-said-once** of slice 2 put it. Keep the vocabulary distinct from
  the two axes of the completion review, which this same file names in "Why a
  two-axis review at completion".
- The invocation-posture paragraph in that section: it says a non-default
  posture runs only when a human asks AND §B3 permits it — true of the
  autonomous presets, false of light, whose own formula header states it is not
  an autonomous run. The two halves are separated: the human always chooses,
  and only the gateless presets need enabling.
- Section "Zone ownership": three presets become five, under one rule — the
  zone belongs to whoever approved it; where nobody approves it, to whoever
  authored it. Applied, that reads: default, spec and program design both the
  human's; light, spec the human's and program design the Mason's (the Owner's
  own ruling, parent Implementation Decisions, point 6); supervised, spec the
  human's and program design the Architect's, who approves it at
  `plan-review`; auto, spec the Architect's (the Checker reviews it, it does
  not author it) and program design the Architect's. For auto-light the
  question does not arise, **ruled by the Owner on 2026-08-28** when it was
  put to him: "Dans le cas d'un chisel-auto-light ces zones sont à ignorer :
  ça design + plan + code d'une traite." The zones are not reassigned to an
  author under that preset — they are IGNORED, and the section says that in
  one clause instead of inventing an owner for them.
- Section "The roster": one cell. Every other row is already level with the
  profiles — the Architect answers the `plan-review`, the Mason authors its own
  program design, the Foreman has its tier and its contract path — but the
  Foreman's "Does" cell omits the interview, which its profile and all five
  formulas give it.
- Section "The pipeline is nine steps": the nine are the full pipeline
  (default, supervised, auto). Light runs seven — no `spec-review`, no
  `plan-review` — and auto-light six, dropping `diff-review` as well. Name the
  steps that leave rather than maintaining arithmetic in prose, and point at
  `.agents/formulas/` as the authority on the order; the section's own opening
  ("Not seven") is a leftover of an older count and goes with the rewrite.
- Section "Where dex's phases live (and who owns each)": the Program Design
  row is produced by the implementing session at its `plan` step and validated
  by an Architect at `plan-review`, at that session's tier; the "Delegable?"
  cell of the implementation row stops saying the delegation is opt-in. The
  Product and System Architecture rows keep their "never" — the delegation
  boundary is the system design, per parent Implementation Decisions, point 13.

**`socle/templates/AGENTS-block.md`** — two lines and a paragraph. The role
line enumerates "Architect, Checker, Mason, Inspector" and misses the Foreman,
which is the session running the formula. The formula list names auto and
supervised only. The sentence "Both are opt-in… (§B3 · Autonomous runs)"
follows from the answer to the open question above. Keep it a routing block:
one clause per preset, and no doctrine — its own closing line promises the
socle carries the content.

**`socle/agents/profiles/inspector.md`** — one phrase in its Mission: the step
it runs is `diff-review`, not `review`. Verified by grep as the last stale step
name anywhere in `socle/`: `design-check` is gone from every file, and every
other profile names the renamed steps correctly. Slice 2's rename criterion
checked the formulas and the two profiles it was editing, and this Mission fell
between them.

### Verified aligned already — no work owed, do not re-check

- `grep -rin "allotment" socle/` returns nothing (slice 1 cleared all three
  carriers).
- The five formulas, the five profiles other than `inspector.md`, and
  `socle/agents/profiles/README.md` are level with the remodel. This slice
  reads them as the reference and edits none of them.
- The sizing section of `methodology.md` ("Why slicing is conditional (the
  sizing check)") already asks "light or full?" and points at the light
  formula, so the parent's **light-in-the-tables** grep is already green on
  that file.
- The section "The two designs" already puts the delegation boundary at the
  system design (slice 2). What lags inside it is the corollary, listed above.

### The switch inventory — the ten carriers of "Autonomous runs"

Verified by grep on 2026-08-28, after the Owner's ruling G10. Two are this
slice's, written in their final shape here; the eight others belong to whatever
work the Owner places the removal in.

**This slice's two:** the invocation-posture paragraph of
`socle/agents/methodology.md` (section "A default, and two options"), which
also frames auto itself as "an invocation posture — §B3"; and the opt-in
sentence of `socle/templates/AGENTS-block.md`.

**The eight others:**

- `socle/agents/project.md.tpl` — the section "B3 · Autonomous runs", which
  defines the switch, plus the comment introducing §B · Coordination, which
  announces three decisions and would announce two. §B needs no renumbering:
  B1 and B2 keep their names.
- `socle/agents/formulas/chisel-auto.formula.toml`,
  `chisel-supervised.formula.toml` and `chisel-auto-light.formula.toml` — one
  header clause each, and in auto-light also the `description` field, which
  ends on "Requires the glue to enable autonomous runs."
- `socle/agents/formulas/chisel-light.formula.toml` — the reverse clause,
  saying the switch does not govern it; it goes with the switch.
- `socle/agents/discipline.md` — the section-reference rule uses "§B3 ·
  Autonomous runs" as its worked example of a good reference, so it needs
  another example.
- `socle/agents/skills/chisel-setup/SKILL.md` — the §B3 question asked
  verbatim, the statement that §B is three questions, and the write-span rules
  that name B3 where they promise the other sub-sections stay byte-identical.
- `socle/agents/skills/upgrade-v2/SKILL.md` — the §B3 screens, the list of
  sections a v1 glue may lack, and the defaults a migration poses.

Test cost: none visible. `grep -rin "autonomous\|B3" test/` returns nothing —
no assertion reads the switch, and the golden tree lists `.agents/project.md`
as a path, which survives.

### Deliberate non-changes, and whose they are

- "Factory = auto × beads" in the preset section, the `SDD-bench` pointer in
  the provenance paragraph, and the glossary's "see `.agents/project.md`,
  Tracker section" pointer: the joins-and-minors chantier owns all three (the
  degraded factory claim, the broken pointers, the §B renaming).
- The `update`-redirect rule is de-wired, not deleted; the section-reference
  rule stays whole. Their deletion and their absorption into one compact
  writing rule belong to the joins-and-minors and normative-extraction
  chantiers respectively.
- The token figure in the session-hygiene rule of the discipline is noted and
  left: the discipline's own rewrite is the normative-extraction chantier's,
  and nothing in this slice's scope touches that rule.
- `socle/agents/project.md.tpl`, and the eight other carriers of the deleted
  permission switch: they are slice 4's, `04-switch-removal.md` beside this
  file, opened on the Owner's ruling G10 and run immediately at his order. This
  slice keeps only the two carriers it already owned — the invocation-posture
  paragraph and the block's opt-in sentence — and writes them in their final,
  switchless shape. The interim between the two slices is accepted per the
  parent's Implementation Decisions, point 9. ~~The order in which they land
  does not matter, since neither touches the other's files.~~
  *Corrected 2026-08-28 by the thread owner, on the plan review's finding
  against this note: the two slices DO share `socle/agents/discipline.md`. This
  slice inserts a rule and renumbers the two below it; slice 4 changes the
  worked example inside the section-reference rule, one unchanged line further
  down. At three lines of context that is one hunk, so whichever slice lands
  second resolves a single-hunk conflict by hand — planned on both sides, and
  not a deviation. The two edits stay disjoint in substance, which is why the
  order still does not matter.*

### The verification seam

Gate command, in this exact form:
`PATH="/opt/homebrew/bin:$PATH" bash test/run.sh`. Baseline today: 9
scenarios, 94 assertions, 0 failed, test files at 592 lines.

**No test change is expected, and here is why, seam by seam.** The suite is a
CLI-seam suite — file tree in, file tree out — and this slice changes prose
inside files that already exist.

- The rendered-block assertion extracts the managed block from the installed
  `AGENTS.md` and compares it byte for byte against
  `socle/templates/AGENTS-block.md`, so editing that template cannot break it;
  the two routing assertions beside it look for `.agents/discipline.md` and
  `.agents/formulas/chisel-default.formula.toml`, both of which survive.
- The golden tree lists paths, and this slice creates and deletes none.
- The formula parse check reads the five formulas, which this slice does not
  touch — the step counts and gate lists it pins (nine, seven, nine, nine, six
  steps; gates three, two, one, none, none) stay as slice 2 left them.
- The pointer-integrity group requires every `.agents/…` path in the installed
  text to resolve. New pointers this slice may add —
  `.agents/formulas/chisel-light.formula.toml`,
  `.agents/formulas/chisel-auto-light.formula.toml`,
  `.agents/profiles/foreman.md` — all resolve in the installed tree.
- The render group greps the installed tree for invented numeric limits; the
  writing rules already forbid writing one.
- The line cap on `test/` is untouched by definition if `test/` is untouched.

**Deliberately absent:** any grep asserting a wording of the doctrine. The
Owner rejected that class of check on the formulas ("revient à des checks sur
des magic strings comme les greps, pas fou"), and the same reasoning holds
here: the named criteria above are the tests, and the suite's job in this slice
is to prove the socle still installs and renders.

### Findings against the parent spec, reported not patched

- **Two of the parent's greps do not bite.** The criterion
  **mason-not-optional** greps `"optional Mason"` and `"OFFERS this choice"` in
  `methodology.md`; both already return nothing, because the file wraps
  "OFFERS this / choice" across a line break and writes "an optional
  **Mason**" with bold markers between the two words. The prose those greps
  were written to kill is still there, word for word in substance. The
  criterion is amended above with greps that match what the file actually
  contains. The ruling is untouched; only its check was toothless.
- **Leftovers of the parent's own wording, harmless.** Its Scope bullet on the
  light formula says the preset table and the AGENTS block "gain it" — the
  singular predates `chisel-auto-light`, which the Owner ruled in afterwards;
  this slice adds both presets to both places, and names its own criterion for
  the block. Slice 2 recorded three leftovers of the same kind. None is this
  slice's to edit; they are the thread owner's.

### Writing rules in force

English throughout; the Owner's quotes stay in French, in quotation marks; no
naked codes — things are named by their meaning; a section reference carries
its file and its title, never a bare number and never a line number; every
pointer says in one clause what the reader finds there; no invented numeric
limits ("on n'a pas de limites à mettre, c'est une fausse bonne idée"); named
acceptance criteria, cited by name, an amended one struck and dated rather
than erased; the reading gradient — the 🧑 zones short and decision-rich, the
detail here.
