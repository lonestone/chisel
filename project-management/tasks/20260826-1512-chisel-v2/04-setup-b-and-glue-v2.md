# 04 — Setup §B redesigned + glue v2

**Status:** 🟢 Done
**Blocked by:** 02, 03 (both delivered)

**What to build:** The setup chooses the case. `project.md.tpl` §B is split
into three sub-sections and `chisel-setup` asks them in PLAIN HUMAN LANGUAGE —
zero jargon on screen (no "ledger"; formulations like "where do task statuses
live?", each option explained in one line):

- **B1 coordination**: markdown (default) | beads embedded | beads server —
  server pitched ONLY for several simultaneous agents on one machine, never
  as the multi-dev answer
- **B2 external-tracker bridge**: none (default) | GitHub | Plane — carried by
  the bead's `external_ref` when beads is active
- **B3 auto**: disabled (default) | enabled — the glue authorization without
  which an Auto invocation is refused (piloting stays an invocation posture;
  this is the switch that *allows* it)

The setup also poses `.agents/user.md` for the current dev (slice 03's
mechanism) and its gitignore entry. Whatever the case chosen,
profiles/formulas/generated definitions install ALWAYS. Changing case later:
piloting = trivial glue flag edit; B1 markdown→beads = tooled re-run of setup
§B (delegated to slice 05); downgrade = immediate `git revert`, late
downgrade not tooled. The actual beads execution path (bd init +
neutralization) is slice 05 — this slice ships the questionnaire, the glue
template, and the branch point.

## Acceptance criteria

- [x] Fresh init + questionnaire on a fixture writes §B1/B2/B3 into
      `project.md` with the documented defaults (markdown, none, disabled)
      when the user accepts everything
- [x] Questionnaire wording review: no occurrence of "ledger", "formula",
      "bead" (except naming the beads option itself) in what the user is
      shown for §B — one-line explanations per option
- [x] `user.md` created for the current dev at setup and gitignored;
      re-running setup does not clobber an existing one
- [x] With B3 = disabled, an "auto" invocation on the fixture is refused by
      the texts (formula/discipline reference the glue switch); with
      enabled, it proceeds
- [x] Profiles, formulas and generated definitions are present after setup in
      ALL B1 branches (markdown fixture asserted here; beads branch asserted
      in slice 05)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-26 · Architect+Mason fused, delegation pre-approved by the Owner)

### D0 — Decisions taken at this plan gate (no human in the loop)

**D0.1 — `§B` stays a heading; B1/B2/B3 are subsections under it.** Three
top-level `## B1 ·` / `## B2 ·` / `## B3 ·` headings would read closer to the
parent's wording, but `§B` is referenced by name from files this slice may not
touch — both formulas ("the coordination state per the tracker convention of
§B"), `discipline.md`'s side-lanes table ("dormant until one is wired up in
`.agents/project.md` §B") — and those references would stop resolving. So:
`## B · Coordination` keeps the letter alive, and `### B1 ·`, `### B2 ·`,
`### B3 ·` carry the three decisions. Bonus: slice 05's "re-run §B" is then
literally one section span, and the sub-headings are individually addressable
for a single-question re-run.

**D0.2 — the model-tier section is `## H · Model tiers`, appended after §G.**
Slice 03 handed this over without a letter, on purpose (its D0.3). A new letter
inserted mid-alphabet would renumber §C…§G, which `discipline.md` (§C, §F), both
formulas (§A, §B, §D, §G), `bin/chisel.sh` (§E) and the setup skill all name
literally. Appending is the only non-breaking placement. The section does NOT
restate the cascade or what a tier is for: it carries the team's mapping (empty
by default) and points at `.agents/methodology.md` — slice 03's "one normative
place" test greps for the exact heading `## Model tiers (and how they resolve)`
in exactly one socle file, and this heading deliberately is not it.

**D0.3 — `init` installs the TEMPLATE `.agents/user.md.tpl`; it still never
poses `.agents/user.md`.** This overturns one assertion of slice 03
("`init`: the user.md template stays in the socle") and needs saying out loud.
Slice 03's D3 called `user.md.tpl` "a template the setup poses, symmetric with
`project.md.tpl`" — but the symmetry does not hold: `project.md.tpl` is posed by
`chisel init` (`ensure_project_md`), and `init` is exactly what must NOT write a
personal file. That leaves the setup skill with a template it cannot reach: the
skill runs inside the equipped repo, and nothing there carries the socle's
`.tpl`. Worse, it breaks the light path the Owner asked me to document — a
second dev cloning the repo must be able to write their own `user.md` with no
package, no network, no `npx`.
So the template ships into the repo as a managed, committed file (the socle text
it is), and posing the personal copy from it is a one-line gesture available to
everyone forever. The invariant slice 03 actually cared about — *a shared
installer never writes a personal file* — is untouched and still asserted, on
both fixtures and after `update`. The two assertions that read `.tpl` absence
are re-aimed at its presence, with the reason in a comment.

**D0.4 — B1 = beads records a CHOICE and an explicit "not initialised yet"
state.** The Owner's line is that this slice poses the choice and executes
nothing. A glue that said "Mode: beads" with no database on disk would make
every later agent believe a database exists. §B1 therefore carries a **State**
line: in the default case it reads "the task files ARE the state — nothing to
initialise"; either database case replaces it with `- [ ] initialised`, which
slice 05 ticks when it runs the initialisation. That is not slicing
scaffolding: it stays useful forever, since the choice recorded in the glue and
the state on disk are genuinely two facts.

**D0.5 — GitLab is not added.** This slice's own Notes forbid adding it
silently, and the parent's resolution is that §B2 must be *shaped* as an open
list so GitLab costs one adapter page later. So the shape lands; the option
does not.

**D0.6 — what the user is shown is marked in the skill, so it can be tested.**
AC 2 is about the wording *the user sees*, which no grep can find inside prose
that also talks to the agent. Convention introduced here: every line the setup
puts on screen is written as a **blockquote** in `SKILL.md`. The suite extracts
the blockquoted lines, strips code spans (adapter and command names are facts,
not jargon), and asserts the vocabulary rule on what is left. The convention is
stated in the skill itself, so it survives the next editor.

**D0.7 — texts I may not edit, left consistent, recorded.** The parent's
`auto` switch is referenced by the AGENTS block ("the project glue allows it")
and by the Auto formula header ("the project glue enables it") — both generic,
both still true once §B3 exists, neither naming it. Naming `§B3` there would be
a one-word improvement in two delivered files that are out of my allotment
(slice 01's). Same for `methodology.md`'s cascade level 2, whose "if the team
has agreed on one and written it there" now has a section to point at. Both are
handed to slice 07 in the Notes. Nothing is contradicted by leaving them.

### D1 — `project.md.tpl` — the new §B, §E, §H

```
## A · Task workspace                     (untouched)
## B · Coordination                       ✎ split
   ### B1 · Where task statuses live      ★ markdown | beads embedded | beads server
   ### B2 · Link to an external tracker   ★ none | GitHub | Plane — OPEN list
   ### B3 · Autonomous runs               ★ disabled | enabled
## C · Reading list                       (untouched)
## D · Documentation reference            (untouched)
## E · Adapters                           ✎ + .claude/agents, .codex/agents
## F · Gate commands                      (untouched)
## G · Glossary & decisions               (untouched)
## H · Model tiers                        ★ NEW — the cascade's middle rung
```

**§B1** — default `**Statuses: in the task files.**` The block that follows is
today's §B body (active tasks, completed, format, status field, work the
frontier) — it is *the* markdown case, so it moves in unchanged rather than
being rewritten. The two other cases are documented as what the section would
say instead, plus the State line / `- [ ] initialised` rule (D0.4) and the rule
the server case exists for (several agents at once on ONE machine — never the
answer to "we are several people").

**§B2** — default `**External tracker: none.**` Carries the mechanism, not a
menu: a task records the ticket it came from in ONE place (the coordination
record's `external_ref` when B1 uses a database; a `**Ticket:**` line in the
task file when it does not), and the how-to of a given tracker lives in one
adapter page whose path this section declares. The last line is the open-list
rule: *adding another tracker later is one adapter page and one line here —
the socle does not change.* The "switching later" prose of v1 §B is replaced by
this (it said the same thing, less precisely).

**§B3** — default `**Autonomous runs: disabled.**` States the refusal in the
imperative, so an agent reading the glue has its answer without inference: an
autonomous run asked for while this says disabled is REFUSED, and the agent
says which line refused it. Flipping the word is the whole migration.

**§E** — two lines added, `.claude/agents/` and `.codex/agents/` (generated
role definitions), ticked by `init` like the other three. Closes slice 02's
recorded residual.

**§H** — the team mapping, empty by default (`_(not set — each dev's
`.agents/user.md`, then the socle default, answer)_`), one line per tier, plus
the pointer to `methodology.md`. No tier definition, no cascade restatement.

### D2 — The three questions, verbatim as shown

Plain language, one screen each, one message each, recommendation last. These
are the texts the ACs' wording review is about.

**B1**

> **Where do your tasks' statuses live?**
>
> Today every task is a markdown file in this repo, and its status is a line
> inside that file. That works, and most projects should keep it.
>
> 1. **In the task files** — nothing to install, everything shows up in a
>    normal diff, and two people can only collide on the same file. The cost:
>    nothing can tell an agent "these three tasks are ready to start" without
>    reading them all.
> 2. **In a small database committed next to them** — the files still hold the
>    content; a tool keeps the statuses and what-blocks-what, so "what is ready
>    to start?" is one command instead of a reading session. The cost: one tool
>    to install, and one habit — pull when you start, push when you stop.
> 3. **The same database, with a background service** — worth it only if you
>    run several agents at the same time on the same machine and they would
>    otherwise trip over each other. It is not what makes a team work: for
>    several people on several machines, option 2 is already the answer.
>
> You can move from 1 to 2 later: that move is tooled and only touches tasks
> that are still open. Moving back is a `git revert` on the spot; later than
> that, it is by hand.
>
> Recommended: **1 — in the task files**.

**B2**

> **Should tasks here point back to tickets in another tool?**
>
> Some teams keep their client discussion, or their bug reports, somewhere
> else. Each task can carry a link back to the ticket it came from, so a reader
> can jump between the two. Nothing is copied or synchronised: the task file
> stays the place where the work is described.
>
> 1. **No link** — tasks live here and nowhere else.
> 2. **GitHub Issues** — each task records the issue it came from.
> 3. **Plane** — the same, with a Plane work item.
>
> Another tool can be added later without changing anything in the toolkit: it
> takes one page saying how to read a ticket there and where to write the link
> back. This list is open, not a menu of three.
>
> Recommended: **1 — no link**.

**B3**

> **May an agent run a whole task here without stopping to ask you?**
>
> By default an agent working on a real task stops and waits for you three
> times: once the spec is written, once the plan is written, and once the
> review comes back. Turning this on lets it pass those three points on its
> own — and only when someone asks for that explicitly in the session. It never
> becomes the normal way of working.
>
> 1. **No** — an agent asked to run on its own is refused, and says so.
> 2. **Yes** — allowed. Worth it on a repo where you would rather review a
>    finished branch than a plan.
>
> This is one line in the project's settings: turning it on or off later is a
> one-word edit, nothing to migrate.
>
> Recommended: **1 — no**.

Vocabulary check on those three screens: no "ledger", no "formula", no
"bead"/"beads" (option 2 of B1 is described by what it does; the tool's name
appears only in the install line, in a code span, and only if the user picks
it), no "coordination substrate", no "glue", no "socle", no section letters.

**B1 = option 2 or 3, the prerequisite screen** (shown only then):

> **This one needs a tool installed: `bd`, version 1.2.2 or newer.**
> I will not install it for you. On this machine: <what `bd --version` said>.
> To install it: `curl -sSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash` (or your usual package manager).
>
> You can also say the word and I will keep the statuses in the task files for
> now — moving to the database later is tooled, and only touches tasks that are
> still open. Choosing the files today costs you nothing tomorrow.

**§H** (one short screen, recommendation = leave it alone):

> **Does the team want to pin which model does which kind of work?**
>
> The toolkit asks for a *level* rather than a name — the strongest model for
> thinking and reviewing, the cheapest for typing out a plan that is already
> written. Each of you answers that for your own tool in your own file, which
> is never committed. This section only matters if the team has agreed on one
> answer for everybody.
>
> Recommended: **leave it unset**.

**The personal file** (its own step, re-runnable on its own):

> **Your own file.** I can create `.agents/user.md` for you from the template
> and add it to `.gitignore`, so it is never committed. It is where you say
> which model your tool should use for each level of work; left as it comes, it
> changes nothing. Teammates get theirs the same way — copy
> `.agents/user.md.tpl`, or ask any session to do it.

### D3 — `chisel-setup/SKILL.md` v2

The pattern is kept exactly: silent scan first, facts stated not asked, one
section per message, surgical writes, re-runnable. What changes:

1. **Step 1 (scan)** gains three probes: `bd --version` (recorded, never acted
   on — feeds B1's prerequisite screen), whether `.beads/` already exists (then
   B1's recommendation is "keep what you have"), and whether `.agents/user.md`
   already exists (then the personal step reports and does not touch it).
2. **Step 2** walks **A → H**. §B is three questions in three messages; the
   "never two sections in one message" rule is restated for them.
3. **Step 3** stays "§E is read-back only" and now reads back five adapters.
4. **Step 4 (surgical writes)** gains the sub-section rule: a `### ` span runs
   to the next `###` or `##`, whichever comes first. Everything else unchanged,
   including "never rewrite the whole file".
5. **New Step 5 — the personal file**, callable on its own ("set up my personal
   file" / a fresh dev's first session): pose `.agents/user.md` from
   `.agents/user.md.tpl` if it is absent (never overwrite), ensure
   `.agents/user.md` is in `.gitignore` (append once, never duplicate), say what
   it did. Explicitly: this step does not need a chisel package, and it is the
   whole path for the second, third, nth dev.
6. **Step 6 — B1 branch**: if the answer is a database, check `bd --version`
   ≥ 1.2.2; below or absent → the prerequisite screen (D2), never an install.
   Whatever the answer, this slice's setup **records the choice and stops
   there**: the initialisation itself (creating the database, quieting the
   tool's own instructions, the working convention) is a separate, named step
   that ships with the beads convention. The skill says so on screen, so nobody
   believes a database exists: §B1's State line becomes `- [ ] initialised`, and
it stays unticked until that step has run.
7. **Step 7 — closing summary**: A–H, one line each, plus the personal file and
   (when relevant) the one thing left to do for B1.

### D4 — `bin/chisel.sh` (glue only)

- New constant `USER_MD_TPL="$SOCLE/agents/user.md.tpl"`.
- `copy_managed_files`: one `cp` into `.agents/user.md.tpl` (D0.3). It is socle
  text: managed, re-rendered by `update`, drift-checked.
- `managed_relative_files`: `.agents/user.md.tpl` joins the literal list.
- `tick_adapter_inventory`: two more `sub()` rules, for
  `` `.claude/agents` `` and `` `.codex/agents` ``, each ticked when the
  directory holds at least one file carrying `$GEN_MARKER` — i.e. when chisel
  actually rendered something, not merely when a directory exists.
- Untouched: profile rendering, formulas, adapters, manifest shape,
  `check`/`update` semantics, and `ensure_project_md`'s write-once contract.

### D5 — `test/run.sh`

Amended in place (group 9, slice 03's): the two `.agents/user.md.tpl`-absent
assertions become presence assertions, with a comment giving D0.3's reason. The
`.agents/user.md`-absent assertions stay exactly as they are — that is the
invariant, and it is the one that matters.

`assert_full_layout` gains: `.agents/user.md.tpl` exists, `.agents/user.md`
does not, and the two new §E lines are ticked.

New group 10 — `-- 10. setup v2: the case, the glue, the personal file --`

1. §B carries B1/B2/B3 as sub-sections of a §B that still exists (both facts:
   the letter and the three).
2. Fresh init writes the three documented defaults: statuses in the task files,
   no external tracker, autonomous runs disabled.
3. The three cases of B1 are all documented in the glue, and the server case is
   qualified by "same machine" and disclaimed for multi-dev.
4. §B1 carries a State line, and documents the `- [ ] initialised` line the
   database cases put there instead — the choice and the on-disk state are two
   facts, and the default case says outright there is nothing to initialise.
5. §B2 states the open-list rule and the `external_ref` mechanism; the
   questionnaire's shown text says the list is open.
6. §B3 states the refusal, and the two delivered texts that route to it (the
   AGENTS block, the Auto formula) still say an autonomous run needs the
   project glue — the pointer chain holds end to end.
7. **AC 2, mechanised**: extract every blockquoted line of `SKILL.md`, strip
   code spans, then assert zero "ledger", zero "formula", zero "bead(s)", and
   assert every option line of the three §B screens carries an explanation
   (each `N. **…**` line has a `—` and more than a handful of words).
8. The skill: walks A–H, keeps "never present two sections in the same
   message", keeps §E read-back-only, and knows the sub-section write span.
9. The skill's B1 branch: names 1.2.2, says it never installs, offers the task
   files as a fallback, says the upgrade is tooled, and does NOT run the
   initialisation (no `bd init` anywhere in the skill).
10. The personal file: the skill poses it from `.agents/user.md.tpl`, never
    overwrites an existing one, adds the ignore line, and documents the light
    path for the next dev. `init` still poses no personal file; `check` stays
    clean when a dev has written one (already covered by group 9's t8, kept).
11. §H exists in the template, is unset by default, points at
    `methodology.md`, and does not carry the normative heading (slice 03's
    one-normative-place assertion keeps passing — asserted from this side too).
12. Neutrality: the socle-wide model-name scan (group 9) and the W-label scan
    cover the two files this slice rewrites for free; asserted explicitly for
    the template and the skill so a regression names them.

### D6 — Order of execution

1. Persist this design (done — nothing half-decided crosses the line).
2. `socle/agents/project.md.tpl`.
3. `socle/agents/skills/chisel-setup/SKILL.md`.
4. `bin/chisel.sh`, then `test/run.sh`.
5. `bash test/run.sh` green (real output into Notes) + `bash -n` on both
   scripts + the ACs' greps + the unchanged neutrality greps.
6. Two-axis review per `skills/code-review`: 2 sub-agents in parallel, fixed
   point `b05574d`, spec = the 🧑 zones of this slice and of the parent;
   confirmed findings applied.
7. Slice status/ACs/deliverables, Notes with the remaining hand-offs (05, 07),
   dated CHANGELOG entry, explicit-path commit on `main`. No push.

### Verification

- `bash test/run.sh` → all green, real output in Notes (group 10 verbatim).
- `grep -rniE '<model regex>' socle/` → empty (unchanged).
- `grep -rn 'W0\|W1\|W2' socle/` → empty (unchanged).
- The §B screens, read once out loud against the jargon list of D2.
- `chisel init` → `check` on a scratch fixture: §E five lines ticked,
  `.agents/user.md.tpl` present, `.agents/user.md` absent, exit 0.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

_GitLab as a B2 option stays an OPEN question (reopened by the v1 field test,
not covered by the chantier) — it was NOT added. What landed instead is the
shape the parent asked for: §B2 is an open list, so GitLab costs one adapter
page and zero socle change, whenever a real project asks._

### Worklog (2026-08-26)

- **`socle/agents/project.md.tpl`** — §B recut. `## B · Coordination` keeps the
  letter (both formulas and `discipline.md` point at "§B"), and carries
  `### B1 · Where task statuses live`, `### B2 · Link to an external tracker`,
  `### B3 · Autonomous runs`. §E gained the two generated-definition lines
  slice 02 flagged. New `## H · Model tiers`, appended after §G — the cascade's
  middle rung, empty by default, pointing at `methodology.md` and restating
  nothing.
- **`socle/agents/skills/chisel-setup/SKILL.md`** — v2. Same pattern (silent
  scan, facts stated not asked, one section per message, surgical writes,
  re-runnable), now walking A→H with §B as three separate questions. Three
  probes added to the scan (`bd --version`, `.beads/`, an existing
  `.agents/user.md`), a sub-section write span, a standalone personal-file step,
  and the §B1 prerequisite branch that checks 1.2.2, never installs, offers the
  task files, and records the choice WITHOUT executing anything.
- **`bin/chisel.sh`** — `.agents/user.md.tpl` joins the managed files (D0.3),
  and §E's two new lines are ticked by `tick_adapter_inventory` when chisel
  actually rendered a definition there (a directory holding only the user's own
  files earns no tick — probed).
- **`test/run.sh`** — group 10, plus two of slice 03's assertions re-aimed
  (D0.3), plus the new §E and `user.md.tpl` layout assertions.

### The wording, which is the point of this slice

The three §B screens are written out verbatim in D2 above and live verbatim in
the skill. The convention that makes AC 2 testable: **everything the user is
shown is a blockquote in `SKILL.md`**. The suite extracts those lines, strips
code spans (a command or an adapter path is a fact, not jargon) and asserts:
zero "ledger", zero "formula", zero "bead", zero section letters, zero glue
paths — and that each of the eight numbered options carries `** — ` followed by
what it buys and what it costs.

```
$ grep '^>' socle/agents/skills/chisel-setup/SKILL.md | sed -e 's|`[^`]*`||g' \
    | grep -ciE 'ledger|formula|bead|glue|socle|§'
0        (79 lines of user-facing text)
```

### Decisions taken at the plan gate (recorded, per the mode)

All six are argued in D0 above. The one that needs the Owner's eye:

**`chisel init` now installs `.agents/user.md.tpl`** — the template, never the
personal file. Slice 03 had assumed the setup could pose `user.md` from the
socle's own copy; a repo equipped through `npx` cannot reach it, and neither can
the second dev who clones the repo a month later. So the template ships as a
managed, committed file and posing a personal copy is `cp .agents/user.md.tpl
.agents/user.md` — no package, no network, forever. The invariant slice 03
actually protected is untouched and still asserted on both fixtures and after
`update`: **a shared installer never writes a personal file**. Two of its
assertions changed direction, with the reason in a comment next to them; its own
Notes still carry the old line ("init: the user.md template stays in the socle")
as the record of a run that really happened — that record is history and was not
rewritten.

### Verification output

`bash test/run.sh`, real run against the committed fixtures (TMPDIR pointed at
the session scratchpad): **297 passed, 0 failed** on the default interpreter
(3.9 — the two optional TOML parse checks print `SKIP` out loud), and **299
passed, 0 failed** with a 3.13 interpreter on PATH, both optional checks
running. 223 before this slice, so 74 new: group 10 contributes 65, the other 9
are the §E and `user.md.tpl` layout assertions, which run on both fixtures.

Group 10 lines, verbatim (3.13 run):

```
-- 10. setup v2: the case, the glue, the personal file --
PASS: glue: §B is still one section, by letter
PASS: glue: B1 asks where statuses live
PASS: glue: B2 is the external-tracker bridge
PASS: glue: B3 is the autonomous-run switch
PASS: defaults: B1 = statuses in the task files
PASS: defaults: B2 = no external tracker
PASS: defaults: B3 = autonomous runs disabled
PASS: B1: the other two cases are visible, not buried in a comment
PASS: B1: the visible line scopes the served case to one machine
PASS: B1: the committed-database case is documented
PASS: B1: the server case is scoped to one machine
PASS: B1: the server case is disclaimed for multi-dev
PASS: B1: the prerequisite version is named
PASS: B1: the default states there is nothing to initialise
PASS: B1: a database case carries an unticked initialised line
PASS: B1: creating the database is a separate, named step
PASS: B2: the open list is visible, not buried in a comment
PASS: B2: adding one is one adapter page, no toolkit change
PASS: B2: an adapter page has a declared home
PASS: B2: the link travels in external_ref when there is a database
PASS: B2: the link travels in the task file otherwise
PASS: B3: the glue refuses an autonomous run when disabled
PASS: B3: the glue says what enabling changes
PASS: B3: enabled is still never the default posture
PASS: B3: nobody may grant it in-session
PASS: B3: the router defers to the project glue
PASS: B3: the auto pipeline defers to the project glue
PASS: setup: the user-facing screens are extractable (blockquote convention)
PASS: setup: the blockquote convention is stated in the skill
PASS: setup: no toolkit jargon on screen (ledger / formula / bead)
PASS: setup: no section letters or glue paths on screen
PASS: setup: the questionnaire offers exactly 8 numbered options (3 + 3 + 2)
PASS: setup: every option carries its one-line explanation
PASS: setup: walks A through H
PASS: setup: one section per message, still
PASS: setup: §B is three messages, not one screen
PASS: setup: §E stays read-back only
PASS: setup: §E reads back all five adapters
PASS: setup: a sub-section write span is bounded
PASS: setup: answering one sub-question leaves the others alone
PASS: setup: still never rewrites the whole file
PASS: B2 branch: every tracker, listed or not, needs its adapter page
PASS: B2 branch: the page is written before the next question
PASS: B2 branch: never a path to a page that does not exist
PASS: B1 branch: a minimum version is checked
PASS: B1 branch: that minimum is 1.2.2
PASS: B1 branch: the setup never installs the tool
PASS: B1 branch: it shows the install command instead
PASS: B1 branch: it offers the task files as the fallback
PASS: B1 branch: it says the upgrade is tooled
PASS: B1 branch: it records the choice and stops
PASS: B1 branch: the questionnaire never initialises anything
PASS: B1 branch: the questionnaire creates no records
PASS: user.md: the setup poses it from the installed template
PASS: user.md: an existing one is never clobbered
PASS: user.md: the setup adds the ignore rule
PASS: user.md: the ignore line is appended once, not per run
PASS: user.md: the next dev's path is documented and light
PASS: glue: §H exists
PASS: glue: §H is unset by default
PASS: glue: §H points at the one normative place
PASS: glue: §H does not restate the rule
PASS: setup: §H is asked, with 'unset' as the recommendation
PASS: neutrality: no W0/W1/W2 mode label in the glue or the questionnaire
PASS: neutrality: no model name in the glue or the questionnaire
```

Seven new invariants were mutation-tested rather than trusted: the word
"ledger" dropped into one option turns the jargon scan red; an option stripped
of its explanation is named back at you; a `**Plane — the tracker**` label with
no explanation still fails (the needle is the bold CLOSING, not any dash); a
renderer that produces nothing leaves §E's two new boxes UNTICKED (the ticks are
earned, not printed); a `.codex/agents/` holding only a hand-written file earns
no tick either; dropping the `user.md.tpl` copy turns five assertions red; and
pushing the open-list rule back inside an HTML comment turns the two
visible-text assertions red.

Greps (AC 2, and the parent's neutrality ACs for the files this slice ships):

```
$ grep -rniE 'cursor|grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai|copilot|claude-|llama|mistral|deepseek|qwen' socle/
(none)
$ grep -rnE 'W0|W1|W2' socle/
(none)
$ grep -in 'ledger' socle/agents/project.md.tpl socle/agents/skills/chisel-setup/SKILL.md
SKILL.md:21   ← the rule itself ("no 'ledger' on screen"), not a use
```

`bash -n bin/chisel.sh` and `bash -n test/run.sh` → syntax OK. Manual probe on
a scratch fixture, beyond the suite: `init` → §E's five lines all ticked,
`.agents/user.md.tpl` present, `.agents/user.md` absent, `check` clean; then the
setup's Step 5 gesture by hand (`cp` the template, append the ignore line) →
`check` still clean, `update` leaves the personal file byte-intact.

### Two-axis review (2026-08-26, fixed point `b05574d`)

Run per `skills/code-review`: two sub-agents in parallel, Standards and Spec
(the spec being the 🧑 zones of this slice — its ACs and its persisted Design —
and of the parent), aggregated without re-ranking. The Spec axis confirmed the
allotment is clean: only the five allotted files are touched.

**Applied**

| Axis | Finding | Fix |
|---|---|---|
| Spec | B1's other cases, B2's whole mechanism and the open-list rule lived inside `<!-- -->`: the assertions proved a COMMENT existed, and a reader of a default `project.md` saw three one-line verdicts and nothing else | the load-bearing rules moved into visible prose (§B1 "Other cases", §B2's mechanism + open list, §B3's two states); the suite now strips the HTML comments and asserts them on what is left. Mutation-tested |
| Spec | AC 4's second half ("with enabled, it proceeds") existed only inside a comment, and nothing asserted it | §B3 now states both states in visible prose — refuse while disabled, proceed when enabled *and* explicitly asked for — with an assertion per half |
| Spec | §B2's adapter page had no author: the skill instructed the agent only for a tracker NOT on the list, so picking GitHub or Plane declared a path nothing writes | the skill now says every tracker is wired the same way — the list being open means no tracker is built in — with the page written before §B3, or the line left `_(to write)_`, never a path to a page that does not exist |
| Standards | `glue_tpl` assigned and never read | deleted |
| Standards | The neutrality loop was a fourth near-copy of the same shape AND diverged from it (one accumulator with `(label)`/`(model)` suffixes where its neighbours keep two) | two accumulators, same shape and same message style as groups 7 and 8 |
| Standards | `awk -v cd=… -v xd=…` — `cd` reads as the shell builtin, `xd` decodes to nothing | `cdefs` / `xdefs` |
| Standards | The option check matched an em dash ANYWHERE on the line, so a dash inside the label alone would pass | the needle is `** — ` (the bold closing); mutation-tested with `**Plane — the tracker**` |
| Standards | "the three §B screens offer 3 + 3 + 2" counts every numbered option in the file — an option added to another section would fail with a message pointing at the wrong place | renamed to what it counts, with the 3 + 3 + 2 kept as the arithmetic |
| Standards | `grep -c` counts lines, not hits | comment saying only the `= 0` comparison is meaningful — which is the assertion being made |
| Spec | Slice status 🟡, ACs unticked, Notes a placeholder, CHANGELOG untouched at review time | done in this pass (D6 step 7 — the review is step 6) |

**Declined, with reason**

- *Spec: `bin/chisel.sh` gains a managed copy + a manifest entry, beyond the
  allotted "ensure_project_md, the §E tick".* The reviewer itself judged it
  justified and honestly recorded. Kept: without it the setup has a template it
  cannot reach and the "light path for the next dev" the Owner asked for does
  not exist. It is three lines, all in the glue's own lane, and D0.3 argues it
  in full.
- *Spec: slice 03's Notes still read "init: the user.md template stays in the
  socle" with no annotation.* That line is inside slice 03's **verification
  output** — the log of a run that really happened. Rewriting a past run's
  output to match today's design would be falsifying a record. The reversal is
  recorded here, in the CHANGELOG, and in a comment next to the two assertions
  that changed direction.
- *Spec: `## H · Model tiers` is scope this slice's own 🧑 zone never states.*
  True of the slice file; it is the explicit hand-off slice 03 recorded for this
  slice ("Add a model-tier section to `project.md.tpl` — the middle rung of the
  cascade") and the Owner restated it in this session's brief. Recorded in D0.2
  rather than smuggled.
- *Standards: `setup_skill` is bound as a variable and the same relative path is
  re-listed in the neutrality loop.* Deliberate, and the shape its two
  neighbours already use: the loop needs the RELATIVE path both to join safely
  and to name the file in the failure message.

### Hand-offs — what this slice deliberately leaves to others

| To | What | Why here |
|---|---|---|
| **Slice 05** | The whole beads execution path: `bd init`, neutralisation, the chisel-beads convention, the sync routine, the tooled markdown→beads upgrade. §B1 records the CHOICE and the questionnaire says out loud that nothing was created; the case's State line becomes `- [ ] initialised` and slice 05 ticks it | the Owner scoped execution out of this slice; the questionnaire must never leave a repo believing a database exists |
| **Slice 05** | Re-running §B1 as the tooled upgrade: the sub-section write span (Step 4) is what makes "re-run one question" a one-span rewrite | the mechanism lands here, the migration belongs there |
| **Slice 07** | Two one-word precisions in files this slice may not touch: the AGENTS block says "the project glue allows it" and the Auto formula header "the project glue enables it" — neither names **§B3**, which now exists. The pointer chain resolves by search, not by reference | slice 01's files; asserted end-to-end here, but a reference would be better than a search |
| **Slice 07** | `methodology.md`'s cascade level 2 says "if the team has agreed on one and written it there" — it now has a section to name: **§H** | slice 03's file, delivered; the wording is still true, just less precise than it could be |
| **Owner** | Nothing blocking. The one decision worth a glance is D0.3 (`init` installs `user.md.tpl`), argued above | it reverses one assertion of a delivered slice |
