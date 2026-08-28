# 01 — Roles remodel

**Status:** 🟢 Complete — closed 2026-08-27.
**Blocked by:** None — can start immediately.

**What to build:** the new role topology, live in the shipped profiles. The
Foreman profile is written (`socle/agents/profiles/foreman.md`) — the owner
of one thread of work, who spawns the other roles and collects their reports.
Architect, Mason and Inspector are rewritten: coordination moves to the
Foreman, the fixed escalation ladder and the "digest" leave their Escalation
sections, the hard allotment boundary becomes the indicative
files-to-modify / files-to-avoid map, and every body is reworked as its own
verbatim spawn prompt. The Checker gets that spawn-framing pass and nothing
else. The Foreman doc page (`socle/agents/foreman.md`) is deleted and both
of its inbound pointers rewired. The profiles README states the spawn rule.
The installer suite stays green: golden tree and render checks cover the new
file set.

## Acceptance criteria

Cite these by name. The first five restate the parent criteria this slice
fully satisfies; the last two are this slice's own share of the parent's
final greps.

- [x] **foreman-is-a-profile** — `test -f socle/agents/profiles/foreman.md
  && test ! -f socle/agents/foreman.md` passes, and the new profile carries
  `name`, `description` and `tier` frontmatter like the other profiles.
- [x] **no-allotment-left** — `grep -rin "allotment" socle/` returns
  nothing. (All three carriers die in this slice: the doc page is deleted,
  `architect.md` and `mason.md` are rewritten.)
- [x] **map-replaces-the-boundary** — Given `architect.md`, `mason.md`, the
  Foreman profile and `inspector.md`, When read, Then the system design's
  files-to-modify / files-to-avoid map is described as indicative and
  motivated, never a strict limit, and the Inspector judges deviations a
  posteriori instead of forbidding them.
- [x] **profiles-carry-the-framing** — Given each of the five role
  profiles — `foreman.md`, `architect.md`, `checker.md`, `mason.md`,
  `inspector.md` — When its body is pasted verbatim as a spawned session's
  instructions, Then the session knows its mission, whom it reports to, and
  what it never does, with no doctrine added by the delegator; and Given
  `socle/agents/profiles/README.md`, When read, Then paste-the-body-verbatim
  is stated as the rule of spawning (no longer a fallback) and the
  delegator's contribution is the per-task brief from the `Inputs` section,
  nothing else.
- [x] **suite-green** — `test/run.sh` passes with the updated golden tree
  and with the render loop covering the Foreman profile the same way it
  covers architect/mason/inspector.
- [x] **profiles-shed-ladder-and-digest** — `grep -rin "digest"
  socle/agents/profiles/`, `grep -rn "Mason → Architect"
  socle/agents/profiles/` and `grep -rn "Architect → Inspector"
  socle/agents/profiles/` all return nothing. (The parent's
  **no-digest-left** and **no-fixed-ladder** close over all of `socle/` at
  slice 3; this is their profiles share.)
- [x] **foreman-page-unreferenced** — `grep -rn "\.agents/foreman\.md"
  socle/ test/` returns nothing, and the roster table of
  `socle/agents/methodology.md` points the Foreman row at
  `.agents/profiles/foreman.md` with a tier. (Keeps the suite's pointer
  integrity group green after the deletion.)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan.

## Design — persisted at plan time

Persisted 2026-08-27 by the plan step of the parent task
`project-management/archive/20260827-1459-remodel-roles-and-formulas.md` —
read its 🧑 zones first: every decision below applies an Owner ruling
recorded there or in `project-management/review-360-decisions.md`; nothing
here is open.

### Decisions locked (plan level)

1. **House profile shape kept.** The Foreman profile uses the same section
   skeleton as the existing profiles — frontmatter (`name`, `description`,
   `tier`), then Mission / Tier / role-specific section / Prohibitions /
   Escalation / Inputs. Role-specific extra sections are house practice
   (the Architect has "Reviewer duties", the Mason "Speed contract"); the
   Foreman's is "Ruling on a report".
2. **Third-person contract voice kept.** The spawn-framing rework does NOT
   rewrite bodies into second person. The bodies are already pasted verbatim
   into the rendered `.claude/agents/` and `.codex/agents/` definitions and
   work as instructions in third person. What the framing pass adds is
   self-sufficiency: each Mission opens by stating the role's mission and
   **whom it reports to** (its spawner — the thread owner), so that profile
   body + brief needs zero doctrine from the delegator. "What it never does"
   is already each profile's Prohibitions section.
3. **Only the Foreman states the blocked-task report form.** The form (a
   dated ⚠️ line in the journal declared in `.agents/project.md` §A, plus a
   blocking bead when §B keeps the coordination state in beads) is written
   in the Foreman profile in one clause, because the Foreman is the actor
   who blocks and writes, and a verbatim spawn prompt must carry what its
   role acts on. The other profiles say only "report to your spawner" — they
   hand their report to a living session and never write the blocked-task
   form themselves. The single definition point the parent criterion
   **escalation-form-survives** demands lands in `methodology.md` at
   slice 3; the profiles do not cite that section by its current title,
   because the current title carries the dying word.
4. **"The Ledger" does not survive the rewrite of its sentence.** Proposed
   by the plan, ruled by the Owner on 2026-08-27 at the plan gate: it dies
   now, in this slice, not at the joins-and-minors chantier where the
   broken-pointers ruling was originally filed. The
   Architect's coordination-state paragraph is rewritten anyway (its
   channel claim contradicts the new report-to-spawner doctrine), and the
   Owner already ruled the label dead — agent-invented jargon, replaced by
   "the coordination state", the wording of the three other profiles (the
   broken-pointers ruling in `project-management/review-360-decisions.md`,
   its third point). Applied in passing, not reopened.
5. **Two commits, both green.** Content rewrites of existing files first
   (the render group re-derives expected bodies from the profiles, so
   editing them cannot break it), then the file-set flip as one atomic
   commit (new profile + page deletion + pointer rewiring + fixture
   parity). See the writing order below.

### Writing order — and how the suite stays green

**Commit 1 — carrier rewrites, file set unchanged.** Rework
`architect.md`, `mason.md`, `inspector.md`, `checker.md`, and the two
spawn-rule sections of `profiles/README.md` ("Before spawning a role…",
"The universal fallback"). Do NOT touch the README's "The Foreman is
deliberately not here" paragraph yet — it points at the doc page, which
still exists, so the integrity group stays green. Run `test/run.sh`: green
(golden tree unchanged, render bodies re-derived from the edited profiles).

**Commit 2 — the file-set flip, atomic.** In one commit: create
`socle/agents/profiles/foreman.md`; delete `socle/agents/foreman.md`;
replace the README's Foreman paragraph; rewrite the Foreman roster row in
`methodology.md`; update `test/fixtures/golden-tree.txt`; extend the render
loop in `test/installer.sh`. Splitting any of these across commits leaves
either a dangling pointer (integrity group) or a tree mismatch (init /
boilerplate groups). Run `test/run.sh`: green. Then run every named
criterion above.

### `socle/agents/profiles/foreman.md` — new file, full outline

**Frontmatter:**

- `name: foreman`
- `description:` one paragraph in the house style: owns one thread of
  work — carries the business context, spawns Architect / Checker / Mason /
  Inspector with their profile body verbatim plus a brief composed from the
  spawned profile's `Inputs` section, collects their reports and rules on
  them. Decides within what it owns; above that, blocks the task and reports
  to the human. Never types the code and never reviews a diff itself.
- `tier: frontier`

**`# Foreman` → `## Mission`:**

- Opens on the role's own framing: the Foreman owns **one thread of work** —
  one conversation or work session. It reports to the human (the Owner),
  who sits above it, full stop. It carries the business context of the
  thread from Brief to close.
- The normal case, said plainly: the invoking session itself takes this
  role — in the default preset the human co-owns the thread, and the
  Foreman IS the main session. The frontmatter exists so a tool that runs a
  whole formula in a spawned session has a definition to spawn it with.
- Duties, as a short list:
  - runs the formula chosen at invocation, step by step, each step a fresh
    sub-agent spawned with the step role's profile;
  - **spawning a role is exactly two parts**: the spawned role's profile
    body pasted verbatim (it carries its own framing), plus the per-task
    brief the Foreman composes from that profile's `Inputs` section —
    paths, scope, artifacts, and nothing doctrinal. Read the profile
    first, every time (this duty moves here from `architect.md`);
  - typing always goes through the Mason contract: spawn a Mason sub-agent
    when the tool can; when it cannot, invite the human to open a fresh
    session and run `work on slice <file>`;
  - collects the reports of the roles it spawned and rules on them (the
    "Ruling on a report" section below);
  - decides within what it owns — and only that.
- The recognized two-conversation variant of default, named:
  human+Architect for the plan, then human+Mason for the work — the
  Inspector then reports to the human+Mason thread.
- Signs its acts in the project's coordination state as `foreman`, per the
  tracker convention of `.agents/project.md` §B.

**`## Tier`:** frontier. Ruling on reports, arbitrating within what it
owns, and composing briefs are judgement work by the socle's own tier
definition. In default the Foreman is the main session anyway, so the tier
binds only where a Foreman is itself run headless.

**`## Ruling on a report`** — the "Rule on a report" passage moves here
from `architect.md`, reworded for the thread owner. Content to carry, same
skeleton as the source passage:

- A role that reports has done exactly its job: it evaluated and decided
  nothing. **The receiver decides, never the reporter** — and here that is
  you.
- Small, and inside what you own → rule on it now: fold it into the current
  task's persisted plan, or create a task and order it.
- Too big, or risky — core code, outside what you own, broad impact → you
  do not decide it either: block the task and hand it one rung up (the
  human), with the reporter's evaluations and your own opinion attached.
  Your ownership is the limit of your arbitration.
- One verdict is always available and always legitimate: "noted, later —
  the current task matters more, carry on." Deferring on purpose is a
  decision; the report is recorded as candidate work.
- **Answering nothing is the only forbidden answer** — an unanswered report
  trains every role that reporting is a waste of breath (keep the source
  passage's closing rationale).
- Reporting up does not stop the work: unless delivering cleanly is
  impossible without the decision, the reporter carries on while the report
  travels.

**`## Reporting to the Owner`** — added 2026-08-27 on the Owner's ruling
(parent task, Implementation Decisions, point 10), which he made while
watching this task run. Two shapes, and they are sober by mandate — the Owner
reads them daily:

- A **waiting report** is the step name and whom it waits on. Nothing else.
- A **step-delivery report** carries, in this order: the step and what
  landed; what the role produced in substance, short; the decisions taken;
  the questions awaiting the Owner; the Owner's actions. The last two are
  numbered lists, and every action names the artifact it acts on.
- The Foreman's own verification of a report it received is not narrated —
  unless verifying changed a conclusion, which makes it a finding, not
  process talk.

**`## Prohibitions`:**

- **Never types the code itself.** Typing goes through the Mason contract,
  always — one of the two paths above, never the Foreman's own hands.
- **Never reviews a spec or a diff itself.** Those are the Checker and the
  Inspector — or the human where the formula puts the review in the
  human's hands.
- **Never invents doctrine at spawn time.** The profile body is the spawn
  prompt, pasted verbatim; the brief carries paths, scope and artifacts,
  nothing else. A framing composed on the fly is unversioned and
  model-dependent — the failure this rule exists to prevent.
- **Never decides above what it owns.** A 🧑 zone owned by the human, a
  scope change, a report too big to arbitrate — surface, block, wait.

**`## Escalation`:**

- Above its authority → the task blocks and a written report goes one rung
  up; above the Foreman: the human, full stop.
- The report's form, in one clause: a dated ⚠️ line in the journal declared
  in `.agents/project.md` §A, plus a blocking `escalation` bead assigned to
  the Owner when §B keeps the coordination state in beads.
- A role it spawned reporting a blocker → rule on it per "Ruling on a
  report"; never leave it unanswered.

**`## Inputs — what this role receives`:**

- **The Brief** — what to build and why. It is the Owner's, always, in
  every mode.
- **The formula governing the run** — the preset chosen at invocation, per
  the invocation-posture principle.
- **The ambient layer** any session in this repo gets:
  `.agents/discipline.md` and the reading list of `.agents/project.md` §C.
- **The repo and its coordination state** — where task statuses live per
  `.agents/project.md` §B.
- What it produces: a delivered thread — the artifacts of every step it
  spawned, plus its rulings recorded in the coordination state.

### `socle/agents/profiles/architect.md` — edits by section

- **Frontmatter `description`** — rewritten: drop "cuts it into slices with
  their allotment" in favour of the indicative files-to-modify /
  files-to-avoid map; add that it renders artifacts to its spawner and
  pilots no one.
- **Mission, opening** — gains the framing clause: the Architect owns the
  thinking; it reports to its spawner — the thread owner — renders
  artifacts, and pilots no one.
- **Mission, "Spec" bullet** — the allotment sentence is replaced: with
  each slice, the system design declares an indicative **files-to-modify /
  files-to-avoid map** — motivated by the architecture choice, never a
  strict limit (implementing always discovers things; the grey zone is
  assumed, the reviewer judges deviations a posteriori). Keep the
  low-overlap rationale: low overlap between the maps of two slices is what
  lets two Masons work at once without a merge war.
- **Mission, "When it delegates…" paragraph** — deleted; the duty lives in
  the Foreman's Mission now.
- **Mission, coordination-state paragraph** — the `architect` signing
  sentence stays; the "The Ledger" sentence is rewritten per plan decision
  4: a spawned Architect returns its report to its spawner; everything else
  travels through artifacts in the coordination state — roles do not talk
  to each other sideways.
- **Reviewer duties** — unchanged (the design-check verdict stays with the
  Architect per the parent Scope).
- **Prohibitions** — unchanged in substance; keep all four.
- **Escalation** — rewritten without the ladder: blocked twice on the same
  thing, or pushed outside the agreed scope → stop and ask your spawner;
  where there is no one to ask, write the blocker into the spec file and
  report to your spawner. A question the artifacts cannot answer → report
  it to your spawner (keep the no-human variant: write the assumption into
  the spec Notes and keep going). Keep "work that resists slicing" and the
  "finding against the plan" lines, the latter reworded to arrive through
  the spawner. The whole "Rule on a report" passage moves out (→ Foreman).
- **Inputs** — "The Brief" bullet reworded: the Brief is the Owner's, in
  every mode; it reaches the Architect through its spawner. Other bullets
  unchanged.

### `socle/agents/profiles/mason.md` — edits by section

- **Mission, claim sentence** — "work inside the allotment their slice
  declares" → work from the indicative files-to-modify / files-to-avoid
  map the slice's design declares; a needed touch outside it is not
  forbidden — it is noted in the worklog and judged at review. Keep claim /
  pull-never-push.
- **Mission, opening** — gains the framing clause: the Mason cuts the
  stone and reports to its spawner — the thread owner.
- **Prohibitions, last bullet** — "and never touches files outside the
  slice's allotment" dies; the bullet becomes "Never reviews its own
  diff." The map needs no prohibition: it is indicative by construction.
- **Escalation, first bullet** — the ladder parenthesis dies: stop, write
  the blocker into the spec file, and report to your spawner (the thread
  owner). Never force a passage.
- **Proposal door** — "outside the allotment of this slice" → outside the
  files map of this slice; "The rung above rules on it" and every "one
  rung up" → "your spawner (the thread owner) rules on it". The three
  evaluations and both rules keep their substance.
- **Inputs, item 4** — "which allotment is yours" → which files-to-modify /
  files-to-avoid map the design declares for this slice.

### `socle/agents/profiles/inspector.md` — edits by section

- **Mission** — gains the framing clause (reports to its spawner — the
  thread owner) and a **new duty**: judge deviations from the system
  design's files-to-modify / files-to-avoid map a posteriori — a touched
  "avoid" file can be validated, or reveal a bad pattern; the Inspector
  judges deviations, it never forbids them.
- **Prohibitions** — unchanged.
- **Escalation, first bullet** — "the Owner's digest when there is not" →
  where there is no human at the gate, the task blocks and a written
  report goes to the thread owner — ultimately the human.
- **Escalation, second bullet** — "one rung up" → to your spawner rather
  than a second round.
- **Inputs, item 3** — one clause added: the spec's system design also
  carries the files map the deviations duty reads.

### `socle/agents/profiles/checker.md` — the spawn-framing pass only

- **Mission, opening** — gains the framing clause: the Checker reviews the
  spec against reality and reports to its spawner — the thread owner.
  Nothing else in the file changes: no ladder, no digest, no allotment to
  remove (verified by grep), and its readability duty belongs to a later
  chantier.

### `socle/agents/profiles/README.md` — edits by section

- **Intro paragraph** — the role list gains `foreman.md` (owns the thread).
  The paragraph "The Foreman is deliberately **not** here…" is replaced by
  its reversal: the Foreman is a role with a profile like the others — the
  owner of one thread of work, who spawns the rest; see
  `foreman.md`. (Commit 2 only — see the writing order.)
- **"Before spawning a role, read its profile"** — gains the delegator
  side: spawning a role is the profile body pasted verbatim as the spawned
  session's instructions (it carries its own framing — mission, whom it
  reports to, what it never does), plus the per-task brief composed from
  its `Inputs` section — paths, scope, artifacts. The delegator invents
  zero doctrine at spawn time.
- **"The universal fallback"** — retitled and reframed as the RULE, not
  the fallback: inline-at-spawn (body verbatim + brief) is how every role
  is spawned, whatever the tool; the fresh-session path (open one, give it
  the profile to read and the same brief) is the **mandatory second path
  for typing** when the tool cannot spawn — `work on slice <file>`. Keep
  the closing line: nothing about a role lives in the adapter.
- **"The body is the source; the per-tool definitions are renders"** —
  unchanged.

### `socle/agents/foreman.md` — deleted

Deleted outright, not converted (the parent's Implementation Decisions,
point 2): the profile replaces it wholesale, and a stub would preserve the
pointer confusion the ruling kills. Its two inbound pointers are the roster
row and the README paragraph — both rewired in commit 2.

### `socle/agents/methodology.md` — the roster row only

The Foreman row of "The roster" becomes: tier **frontier**; Does: owns one
thread of work — carries the context, spawns the other roles, collects
their reports and rules on them; Contract:
`.agents/profiles/foreman.md`. Nothing else in the file — the escalation
section, presets, corollaries and tables belong to slice 3, and the
intermediate inconsistency (methodology still naming the ladder while the
profiles no longer do) is accepted by the parent's Implementation
Decisions, point 9.

### `test/fixtures/golden-tree.txt` — parity

- Remove the line `.agents/foreman.md`.
- Add, in C-locale sort order: `.agents/profiles/foreman.md` (between
  `checker.md` and `inspector.md`), `.claude/agents/foreman.md` (between
  `checker.md` and `inspector.md`), `.codex/agents/foreman.toml` (between
  `checker.toml` and `inspector.toml`).
- Net: +2 lines. The renders appear because the CLI renders every profile
  carrying frontmatter — no CLI change is needed or allowed (the CLI is
  the Deno-port chantier).

### `test/installer.sh` — the render loop only

In `group_render`, the loop `for role in architect mason inspector; do`
gains `foreman`. That is the whole edit: +0 lines, +5 assertions (one loop
iteration), within the suite's net budget of +10 assertions per slice and
far under the 600-line cap `test/run.sh` enforces. The Checker was never in
that loop and adding it is not this slice's business.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

- **Carrier inventory, verified by grep 2026-08-27 at plan time.**
  "Allotment" lives in exactly three files, all handled here:
  `socle/agents/foreman.md` (two occurrences — dies with the page),
  `socle/agents/profiles/mason.md` (four occurrences: claim sentence,
  prohibition, proposal-door risk item, Inputs item 4),
  `socle/agents/profiles/architect.md` (two: frontmatter description, Spec
  bullet). The ladder/digest occurrences inside `socle/agents/profiles/`
  are: `mason.md` Escalation first bullet, `architect.md` Escalation first
  bullet, `inspector.md` Escalation first bullet. Everything else
  (methodology, discipline, the two formulas) belongs to slices 2–3.
- **Inbound pointers to the doc page, verified by grep:** exactly two —
  the roster row of `socle/agents/methodology.md` and the intro paragraph
  of `socle/agents/profiles/README.md`. `test/` never names it.
- **Render-group traps for the new profile:** the installed `.agents/`
  tree is grepped for invented numeric limits (`40 lines`, `8 lines`,
  `half of the slice`, `half the spend`, `target ~`) — the Foreman profile
  must contain none, which the writing rules already demand. Every
  `.agents/...` path it cites must resolve in the installed tree
  (integrity group): `.agents/project.md`, `.agents/discipline.md`,
  `.agents/profiles/` and `.agents/formulas/` all do.
- **Writing rules in force** (from the parent's Notes): English
  throughout; Owner quotes stay in French in quotation marks; no naked
  codes — name things by their meaning; no line-number references — file +
  section title; every pointer says in one clause what the reader finds
  there; no invented numeric limits.
- **Worklog.** Commit 1 (`31cebc3`) — the four carrier rewrites and the two
  spawn-rule sections of the profiles README; suite green at 88 assertions.
  Commit 2 (`c450029`) — the Foreman profile created, the doc page deleted,
  the CLI stripped of its three references to it per the Owner's "Retire oui",
  the README intro reversed, the roster row rewritten, golden tree and render
  loop brought to parity; suite green at 93 assertions, test files at 588
  lines. No TDD cycle applies: the seam is the installer suite, which asserts
  the file set and the renders, not wording.
- **Deviation from the files map, reported and ruled before typing:**
  `bin/chisel.sh` sits in the parent's files-to-avoid list and was touched.
  Escalated at design-check as Finding 1, ruled by the Owner (parent spec,
  Implementation Decisions, point 11). Three lines removed, nothing else in
  `bin/`.
- **Left for the close, deliberately:** the slice Status line still reads
  🔴 Not Started, and the parent's own criteria are untouched — both are the
  thread owner's to move.

### Program design

Written at the `design-check` step, 2026-08-27, from the files as they are
today. Nothing below reopens a decision: it turns the persisted plan into an
ordered edit list and records where the plan is not executable as written.

#### Findings against the plan

**Finding 1 — the plan's claim that the deletion needs no CLI change is
false, and it is a blocker for the criterion `suite-green`.** The plan's
section "`test/fixtures/golden-tree.txt` — parity" states: "no CLI change is
needed or allowed (the CLI is the Deno-port chantier)". `bin/chisel.sh`
hard-codes the doc page in three places — the source path constant next to
the other socle sources, one line of the managed-file manifest, and one copy
in the install routine. Under `set -euo pipefail` the copy of a file that no
longer exists aborts `chisel init` mid-body.

Verified, not deduced: in a throwaway copy of the repo, deleting
`socle/agents/foreman.md` alone takes the suite from 88 passing assertions
and 0 failures to `init` exiting 1 and 10 assertions failing — the install
stops before the AGENTS block is even written. The whole suite goes red, not
one group.

Minimal resolution, also verified in the same throwaway copy: delete those
three lines and nothing else in the CLI. With them gone, plus the rest of
commit 2 as the plan describes it, the suite is green at 93 assertions
(88 + the 5 the new render-loop iteration adds, exactly the plan's
prediction) and the test files stay at 588 lines.

`bin/chisel` sits in the parent spec's *files to avoid* list, so this is a
ruling for the thread owner, not a call to make while typing. Note that the
files-to-avoid map is indicative by the very doctrine this slice writes, and
that the Inspector judges such a deviation a posteriori — but the decision
is still not the Mason's. **Typing of commit 2 cannot deliver cleanly
without this ruling.** Commit 1 is unaffected and can proceed regardless.

**Finding 2 — `mason.md` keeps two Architect-routed sentences the plan does
not list.** Its Prohibitions say a reality that contradicts the plan "is news
for the Architect", and its Inputs close with "it goes back to the
Architect". Both name a role rather than the spawner, which sits awkwardly
beside the report-to-your-spawner doctrine the same file now states. No
named criterion greps them, and the plan's per-file edit list does not touch
them. Reported for a ruling; absent one, they stay as written.

**Finding 3 (minor) — the frontmatter `description` must be one physical
line.** The plan says the Foreman's description is "one paragraph in the
house style". The renderer reads a flat frontmatter key off a single line and
stops there, so a wrapped description would be truncated in every generated
definition. Read as: one long unwrapped line, like the four existing
profiles. No ruling needed; recorded so the constraint is not rediscovered.

**Finding 4 (minor) — one grep of `profiles-shed-ladder-and-digest` is
already satisfied and proves nothing.** `grep -rn "Mason → Architect"
socle/agents/profiles/` returns nothing *today*, because the ladder in
`mason.md` wraps across two lines between "Mason →" and "Architect". The
load-bearing checks for that criterion are the `digest` grep and the
`Architect → Inspector` grep, which do match today. The criterion is
verified by running all three plus reading the two Escalation sections.

#### Commit 1 — carrier rewrites, file set unchanged

Written in this order. Every edit below quotes what it replaces.

**1. `socle/agents/profiles/architect.md`**

- *Frontmatter `description`.* Replace "cuts it into slices with their
  allotment" with: cuts it into slices, each carrying an indicative
  files-to-modify / files-to-avoid map; add that it renders artifacts to its
  spawner and pilots no one. One line; the two closing "never" clauses stay.
- *Mission, opening.* "The Architect owns the thinking." gains the framing
  clause: it reports to its spawner — the thread owner — renders artifacts,
  and pilots no one.
- *Mission, "Spec" bullet.* Replace "and with each slice, its **allotment**:
  the files and zones that slice may touch" with: with each slice, the system
  design declares an indicative **files-to-modify / files-to-avoid map** —
  motivated by the architecture choice, never a strict limit; implementing
  always discovers things, the grey zone is assumed, and the reviewer judges
  deviations a posteriori. The following sentence, "Low overlap between lots
  is what lets two Masons work at once without a merge war", keeps its
  substance with "lots" becoming the maps of two slices.
- *Mission, delegation paragraph.* Delete outright: "When it delegates, the
  Architect composes the brief from the `Inputs` section of the profile it is
  about to spawn — read the profile first, every time." The duty is written
  into the Foreman's Mission in commit 2.
- *Mission, coordination paragraph.* The `architect` signing sentence stays
  verbatim. Replace "The Ledger is the only channel between roles: they do
  not talk to each other, they read and write artifacts." with: a spawned
  Architect returns its report to its spawner; everything else travels
  through artifacts in the coordination state — roles do not talk to each
  other sideways.
- *Escalation, first bullet.* Replace "stop and ask; where there is no one to
  ask, write the blocker into the spec file and escalate one rung (Architect
  → Inspector → the Owner's digest)" with: stop and ask your spawner; where
  there is no one to ask, write the blocker into the spec file and report it
  to your spawner.
- *Escalation, second bullet.* "A question the artifacts cannot answer → to
  the Owner." becomes: report it to your spawner. The no-human variant —
  write the assumption into the spec Notes and keep going, an assumption in
  writing is reviewable and a silence is not — is kept.
- *Escalation, "work that resists slicing" bullet.* Unchanged.
- *Escalation, last bullet.* "A Mason that could not implement from the
  artifacts is a finding **against the plan**: take it back, do not patch it
  in chat." keeps its substance, reworded so the finding arrives through the
  spawner.
- *"Rule on a report" passage.* Deleted here in full — from "**Rule on a
  report.**" through "not at the pace the report arrived." It reappears in
  the Foreman profile in commit 2. Between the two commits the passage exists
  nowhere; nothing in the suite or in the criteria observes it, and the two
  commits land together.
- *Reviewer duties, Prohibitions.* Unchanged, per the plan.
- *Inputs, "The Brief" bullet.* "It comes from the Owner, always, in every
  mode; nothing here decides it." gains: and it reaches the Architect through
  its spawner.

**2. `socle/agents/profiles/mason.md`**

- *Mission, opening.* "The Mason cuts the stone." gains: and it reports to
  its spawner — the thread owner.
- *Mission, claim sentence.* Replace "and work inside the allotment their
  slice declares" with: and work from the indicative files-to-modify /
  files-to-avoid map the slice's design declares — a needed touch outside it
  is not forbidden, it is noted in the worklog and judged at review. "Claim …
  pull, never push" stays verbatim.
- *Prohibitions, last bullet.* Replace "**Never reviews its own diff**, and
  never touches files outside the slice's allotment." with "**Never reviews
  its own diff.**"
- *Escalation, first bullet.* Replace "hand it one rung up (Mason →
  Architect → Inspector → the Owner's digest)" with: report it to your
  spawner (the thread owner). "Never force a passage." stays.
- *Proposal door, opening.* "**Every such discovery goes up one rung,
  always**" becomes: goes to your spawner, always.
- *Proposal door, evaluation 2.* "is it core code? outside the allotment of
  this slice?" becomes: outside the files map of this slice?
- *Proposal door, second rule.* "The rung above rules on it" becomes: your
  spawner — the thread owner — rules on it. The three evaluations and both
  rules keep their substance, including the closing "A report is never
  permission to start."
- *Inputs, item 4.* Replace "which allotment is yours" with: which
  files-to-modify / files-to-avoid map the design declares for this slice.

**3. `socle/agents/profiles/inspector.md`**

- *Mission, opening.* "The Inspector signs off the work." gains: and it
  reports to its spawner — the thread owner.
- *Mission, new duty.* Added as a third axis-level bullet or a following
  clause: judge deviations from the system design's files-to-modify /
  files-to-avoid map a posteriori — a touched "avoid" file can be validated,
  or can reveal a bad pattern; the Inspector judges deviations, it never
  forbids them.
- *Escalation, first bullet.* Replace "the arbitration gate when there is a
  human at it, the Owner's digest when there is not" with: the arbitration
  gate when there is a human at it; where there is no human at the gate, the
  task blocks and a written report goes to the thread owner — ultimately the
  human.
- *Escalation, second bullet.* "A disagreement with the Architect that
  survives one round trip → one rung up rather than a second round." becomes:
  → to your spawner rather than a second round.
- *Inputs, item 3.* One clause added to the spec-pointer item: the spec's
  system design also carries the files map the deviations duty reads.
- *Prohibitions.* Unchanged.

**4. `socle/agents/profiles/checker.md`**

- *Mission, opening only.* "The Checker reviews the spec against reality."
  gains: and it reports to its spawner — the thread owner. Nothing else in
  the file changes.

**5. `socle/agents/profiles/README.md` — two sections only**

- *"Before spawning a role, read its profile".* Keeps its existing paragraph
  and gains the delegator side: spawning a role is the profile body pasted
  verbatim as the spawned session's instructions — it carries its own framing,
  mission, whom it reports to, what it never does — plus the per-task brief
  composed from its `Inputs` section: paths, scope, artifacts. The delegator
  invents zero doctrine at spawn time.
- *"The universal fallback".* Retitled to name the rule rather than a
  fallback ("How a role is spawned"), and reframed: inline-at-spawn — body
  verbatim, then the brief — is how every role is spawned, whatever the tool;
  the fresh-session path is the mandatory second path for typing when the
  tool cannot spawn, opened with `work on slice <file>`. The closing line
  stays: nothing about a role lives in the adapter, the adapter only knows
  how to spawn.
- The intro paragraph and "The body is the source" section are **not**
  touched in this commit — the intro still points at `.agents/foreman.md`,
  which still exists, so the pointer-integrity group stays green.

**Then run `bash test/run.sh`.** Expected: 9 scenarios, 88 assertions, 0
failures — the same count as before the commit. The render group re-derives
the expected bodies from the edited profiles, so content rewrites cannot move
it; the golden tree is untouched because the file set is.

#### Commit 2 — the file-set flip, atomic

All of the following in one commit; splitting any of it leaves either a
dangling pointer or a tree mismatch.

1. Create `socle/agents/profiles/foreman.md` (skeleton below).
2. Delete `socle/agents/foreman.md`.
3. `bin/chisel.sh` — remove the three lines that carry the deleted page: the
   source-path constant among the socle sources, the manifest line in the
   managed-files listing, and the copy in the install routine. **Gated on the
   ruling of Finding 1.**
4. `socle/agents/profiles/README.md`, intro paragraph — the role list gains
   `foreman.md` (owns the thread), and "The Foreman is deliberately **not**
   here: it is not an agent — see `.agents/foreman.md`." is replaced by its
   reversal: the Foreman is a role with a profile like the others — the owner
   of one thread of work, who spawns the rest; see `foreman.md`.
5. `socle/agents/methodology.md`, the Foreman row of "The roster" only.
   Current: tier "—", Does "Routes: what starts next, and who starts it. Not
   an agent", Contract `.agents/foreman.md`. Becomes: tier **frontier**; Does
   "Owns one thread of work — carries the context, spawns the other roles,
   collects their reports and rules on them"; Contract
   `.agents/profiles/foreman.md`. Row position unchanged; nothing else in the
   file.
6. `test/fixtures/golden-tree.txt` — remove `.agents/foreman.md`; add
   `.agents/profiles/foreman.md` after `checker.md`,
   `.claude/agents/foreman.md` after `checker.md`, and
   `.codex/agents/foreman.toml` after `checker.toml`. Net +2 lines. Verified
   against a real install: those are exactly the three paths that appear.
7. `test/installer.sh`, `group_render` only — the role loop
   `for role in architect mason inspector; do` gains `foreman`. +0 lines,
   +5 assertions.

**Then run `bash test/run.sh`.** Expected: 9 scenarios, 93 assertions, 0
failures, and the suite's own line-count assertion still reporting 588 of
the 600 it caps at. Both numbers verified in a throwaway copy before any of
this was written.

#### `socle/agents/profiles/foreman.md` — skeleton and frontmatter

Checked against the house shape the four existing profiles share:
frontmatter, then `# Role`, `## Mission`, `## Tier`, the role-specific
section or sections, `## Prohibitions`, `## Escalation`, `## Inputs — what
this role receives`. The Architect's "Reviewer duties" and the Mason's
"Speed contract" are the precedent for role-specific sections in that slot.

Frontmatter, three keys, each on one line:

- `name: foreman` — equal to the file's own name, as the README requires.
- `description:` one line, house style — a compact statement of the role
  followed by its "never" clauses: owns one thread of work, carries the
  business context, spawns the other roles with their profile body verbatim
  plus a brief composed from that profile's `Inputs` section, collects their
  reports and rules on them; decides within what it owns and blocks above it;
  never types the code, never reviews a diff itself.
- `tier: frontier`.

Body sections, in order:

- `# Foreman`
- `## Mission` — owns one thread of work, one conversation or work session;
  reports to the human (the Owner), who sits above it, full stop; carries the
  business context from Brief to close. Then the normal case said plainly:
  the invoking session itself takes this role, and in the default preset the
  human co-owns the thread — the Foreman IS the main session; the frontmatter
  exists so a tool running a whole formula in a spawned session has a
  definition to spawn it with. Then the duty list: runs the chosen formula
  step by step, each step a fresh sub-agent; spawning is exactly two parts,
  profile body verbatim plus the brief from that profile's `Inputs` section,
  reading the profile first every time; typing always goes through the Mason
  contract — spawn a Mason when the tool can, otherwise invite a fresh
  session running `work on slice <file>`; collects reports and rules on them;
  decides within what it owns and only that. Then the recognized
  two-conversation variant of default — human+Architect for the plan, then
  human+Mason for the work, the Inspector reporting to the human+Mason
  thread. Closes with the signing sentence in the shape the four other
  profiles use: acts recorded in the coordination state are signed `foreman`,
  per the tracker convention of `.agents/project.md` §B.
- `## Tier` — frontier, with the reason: ruling on reports, arbitrating
  within what it owns and composing briefs are judgement work by the socle's
  own tier definition; in default the Foreman is the main session anyway, so
  the tier binds only where a Foreman is itself run headless.
- `## Ruling on a report` — the passage moved out of `architect.md`, reworded
  for the thread owner: the reporter evaluated and decided nothing, the
  receiver decides and here that is you; small and inside what you own → rule
  now, folding it into the persisted plan or creating a task; too big or
  risky → you do not decide it either, block the task and hand it one rung up
  to the human with the reporter's evaluations and your own opinion attached,
  your ownership being the limit of your arbitration; "noted, later — the
  current task matters more, carry on" is always available and always
  legitimate, and deferring on purpose is a decision that records the report
  as candidate work; answering nothing is the only forbidden answer, keeping
  the source passage's closing rationale about what an unanswered report
  trains; and reporting up does not stop the work.
- `## Reporting to the Owner` — the two shapes ruled by the Owner on
  2026-08-27, sober by mandate. A waiting report is the step name and whom it
  waits on, nothing else. A step-delivery report carries, in order: the step
  and what landed; what the role produced in substance, short; the decisions
  taken; the questions awaiting the Owner; the Owner's actions — the last two
  as numbered lists, every action naming the artifact it acts on. The
  Foreman's own verification of a report it received is not narrated, unless
  verifying changed a conclusion, which makes it a finding rather than
  process talk.
- `## Prohibitions` — four, in the house's bolded-lead shape: never types the
  code itself; never reviews a spec or a diff itself; never invents doctrine
  at spawn time, with the reason (a framing composed on the fly is
  unversioned and model-dependent); never decides above what it owns.
- `## Escalation` — above its authority, the task blocks and a written report
  goes one rung up, and above the Foreman that is the human, full stop; the
  report's form in one clause — a dated ⚠️ line in the journal declared in
  `.agents/project.md` §A, plus a blocking `escalation` bead assigned to the
  Owner when §B keeps the coordination state in beads; a spawned role
  reporting a blocker is ruled on per "Ruling on a report" and never left
  unanswered.
- `## Inputs — what this role receives` — the Brief, which is the Owner's
  always and in every mode; the formula governing the run, chosen at
  invocation; the ambient layer any session in this repo gets
  (`.agents/discipline.md` and the reading list of `.agents/project.md` §C);
  the repo and its coordination state, where task statuses live per
  `.agents/project.md` §B. Closes as the other profiles do, with what it
  produces: a delivered thread — the artifacts of every step it spawned, plus
  its rulings recorded in the coordination state.

Two render constraints the body must respect, both already checked against
the suite: every `.agents/...` path it cites must resolve in the installed
tree — `.agents/project.md`, `.agents/discipline.md`, `.agents/profiles/` and
`.agents/formulas/` all do — and the body must carry none of the invented
numeric limits the render group greps for, which the writing rules already
forbid. A body containing three consecutive apostrophes would break the TOML
render; nothing in this skeleton comes near it.

#### Verification order

1. After commit 1: `bash test/run.sh` — expect 88 assertions, 0 failed.
2. After commit 2: `bash test/run.sh` — expect 93 assertions, 0 failed.
3. Then the named criteria, in this order:
   - **suite-green** — the run above, whole suite, all nine groups.
   - **foreman-is-a-profile** — `test -f socle/agents/profiles/foreman.md &&
     test ! -f socle/agents/foreman.md`, plus reading the new file's
     frontmatter for `name`, `description` and `tier`. The suite corroborates
     it: the two rendered definitions only appear in the installed tree if
     the frontmatter parsed.
   - **no-allotment-left** — `grep -rin "allotment" socle/`, expecting
     nothing. Confirmed today at six occurrences: two in `architect.md`, four
     in `mason.md`, and the two in the deleted page.
   - **foreman-page-unreferenced** — `grep -rn "\.agents/foreman\.md" socle/
     test/`, expecting nothing, plus reading the roster row for its tier and
     its contract pointer. Note the fixture line in `test/` is one of the
     matches this grep sees today, and it goes away with the tree update.
   - **profiles-shed-ladder-and-digest** — the case-insensitive `digest`
     grep, `Architect → Inspector`, and the wrap-tolerant `grep -rn
     "Mason →" socle/agents/profiles/` the design check ruled in (the
     criterion's own `Mason → Architect` form is defeated by a line wrap and
     proves nothing on its own), plus reading the Escalation sections of
     `mason.md`, `architect.md` and `inspector.md`.
   - **map-replaces-the-boundary** — a read-through of `architect.md`,
     `mason.md`, `foreman.md` and `inspector.md`, checking the map reads as
     indicative and motivated in each and that the Inspector judges
     deviations rather than forbidding them. No grep can judge this.
   - **profiles-carry-the-framing** — a read-through of each of the five
     bodies as if it were the entire instruction set of a fresh session,
     asking of each: does it state its mission, whom it reports to, and what
     it never does, without help? Plus a read-through of the README for the
     rule of spawning and the delegator's brief-only contribution.

### Design check

Run 2026-08-27 by an Architect who did not write this plan, against the files
as they are today. Verdict: **corrections** — three, all small; the edit list
is otherwise executable as written and satisfies the slice's named criteria.

**1. `mason.md` keeps two Architect-routed sentences the edit list does not
touch — they are in scope and must be realigned to the spawner.** The
program design's own Finding 2 raises them and then leaves them ("absent a
ruling, they stay as written"); the ruling has since been made, and they are
the same family as the "rung above" wording the parent Deliverables already
require. Add to the commit 1 edit list for `mason.md`: in *Prohibitions*,
"that is news for the Architect, not a detour to take alone" becomes news for
your spawner; in *Inputs*, the closing "it goes back to the Architect" becomes
it goes back to your spawner. Substance unchanged in both — only the addressee
moves, exactly as the Escalation and proposal-door bullets already do in this
same commit. No criterion greps them; the reason is coherence, since the file
would otherwise route a Mason to a role in two places while telling it to
report to its spawner everywhere else.

**2. The Foreman profile skeleton carries no files-map clause, and the
criterion `map-replaces-the-boundary` names it.** That criterion reads "Given
`architect.md`, `mason.md`, **the Foreman profile** and `inspector.md`, When
read, Then the … map is described as indicative and motivated, never a strict
limit" — and the parent Scope's allotment bullet lists the new Foreman profile
among the files the map touches. The skeleton's seven sections never mention
it, yet the verification order below promises a read-through of `foreman.md`
for exactly that property. As written, that step cannot pass. Add one clause to
the body — the natural home is `## Ruling on a report`, since the Foreman is
the receiver when a Mason reports a needed touch outside the map: the
files-to-modify / files-to-avoid map the system design declares is indicative
and motivated, never a strict limit; a touch outside it is a report to rule on,
not a violation to punish. **This is a finding against the plan, not against
the Mason**: the plan's own outline of the new profile omits the map too.

**3. The verification order does not name the wrap-tolerant ladder check the
Foreman ruled in.** The program design's Finding 4 is correct — `grep -rn
"Mason → Architect" socle/agents/profiles/` returns nothing today because
`mason.md` wraps between "Mason →" and "Architect" — but the verification order
then asks only for "the three greps, plus reading the Escalation sections".
State the ruled shape instead: the load-bearing mechanical checks for
`profiles-shed-ladder-and-digest` are the case-insensitive `digest` grep, the
`Architect → Inspector` grep, and a wrap-tolerant ladder check —
`grep -rn "Mason →" socle/agents/profiles/`, which has exactly one hit today
(the dying Escalation line of `mason.md`) and must have none after. Keep the
read-through of the three Escalation sections; keep the `Mason → Architect`
grep too if you like, recorded as proving nothing.

#### Verified while checking, and confirming the design

- **Finding 1 is real and its resolution is the only one.** `bin/chisel.sh`
  names the doc page three times — the source-path constant, the managed-file
  manifest line, and the copy in the install routine — and nothing else uses
  that constant. A stub page is not an escape: `foreman-is-a-profile` demands
  `test ! -f socle/agents/foreman.md`. So there is no second shape for commit 2:
  either the CLI loses those three lines, or `foreman-is-a-profile` and
  `suite-green` cannot both hold and the slice stops after commit 1. Validating
  "both ways" resolves to that, and the escalation is correct — the decision is
  the thread owner's, not the Mason's.
- **The arithmetic holds.** Baseline re-run today: 9 scenarios, 88 assertions,
  0 failures, suite at 588 lines. The `group_render` role loop performs five
  assertions per iteration (one body-identity plus four `assert_file_contains`),
  so adding `foreman` gives 93 — the design's prediction, confirmed by reading
  the loop.
- **The golden-tree deltas are right.** In C-locale order `foreman` sorts
  between `checker` and `inspector` in all three directories, and the renderer
  emits a definition for every profile carrying a `name` frontmatter key, so no
  CLI change is needed *for the new file* — only for the deleted one.
- **Nothing else points at the dying page.** Inside `socle/` and `test/` the
  inbound pointers are exactly the roster row, the README paragraph and the
  golden-tree line, all three in the commit 2 list. `test/TESTS.md` describes
  the render group generically ("every generated agent definition") and needs
  no edit.
- **No Owner ruling in the parent's 🧑 zones is contradicted** by the edit
  list, including Implementation Decisions 2, 3, 9 and 10 and the files-to-avoid
  map, whose one collision is escalated rather than decided.

### Review

Run 2026-08-27 by an Inspector who authored neither the plan nor the diff.
Fixed point `5d07cdf`, pinned before anything was read; the diff is
`git diff 5d07cdf...HEAD`, two commits (`31cebc3`, `c450029`). Uncommitted
`project-management/` edits were excluded as the thread owner's coordination
state. The two axes are reported side by side, never merged and never
re-ranked against each other: this diff passes one axis cleanly and carries
small findings on the other, which is exactly the case the separation exists
for.

**Verdict: pass on both axes, with three findings — none blocking.** Two of
them are findings against the plan, not against the typing.

#### Standards axis

Sources: `AGENTS.md` at the root, `socle/agents/discipline.md`, the house
shape of the four pre-existing profiles, the contract stated in
`socle/agents/profiles/README.md`, the writing rules of the parent spec's
Notes, and the smell baseline carried by
`socle/agents/skills/code-review/SKILL.md`.

**S1 — bare section references in the new profile (hard, small).** Standard:
`socle/agents/discipline.md`, rule 11 ("A section reference names its file and
its title") — the first mention carries both, "never a bare number".
`socle/agents/profiles/foreman.md` cites `.agents/project.md` §A and §B four
times without ever naming their titles ("A · Task workspace", "B ·
Coordination"). The rule is a documented repo standard and it binds new text,
so this counts. Scoped honestly: every pre-existing profile and
`socle/agents/methodology.md` itself use the same bare form, so the new file
conforms to a repo-wide pattern that rule 11 postdates. Fixing only
`foreman.md` would make the socle less consistent, not more. **Reported as a
sweep for the Owner, not as a fix for this slice.**

**S2 — one rewritten line breaks the file's wrap discipline (judgement
call).** No repo document states a wrap width, so this rests on the house
shape rather than on a documented standard, and is labelled as such. In
`socle/agents/profiles/mason.md`, the proposal door's second rule ("You
evaluate; you never decide") now runs one continuation line to 92 characters
where every other prose line in the five profiles stops at 78. The claim
sentence in the same file's Mission also left a ragged short line behind when
it was reflowed. Both are artefacts of commit `31cebc3`.

**S3 — the spawn contract is now stated three times (judgement call,
Duplicated Code from the baseline).** The full two-part rule appears in
`socle/agents/profiles/README.md` under "Before spawning a role, read its
profile", and again twice inside `socle/agents/profiles/foreman.md` — the
Mission bullet "Spawning a role is exactly two parts" and the Prohibitions
bullet "Never invents doctrine at spawn time", which repeat the same
"unversioned and model-dependent" clause within one file. The same shape
recurs with the files-map doctrine, now restated in four profiles. This is a
**finding against the plan**: the persisted Design asked for each of these
statements explicitly. It is also arguably the price of the
paste-the-body-verbatim rule this very slice ships — a profile body must stand
alone, so some doctrine has to be duplicated into it. Flagged as a drift risk
to watch at slice 3, not as an error to correct here.

**Clean on the Standards axis:** every `.agents/…` path cited in the new and
edited bodies resolves in the installed tree, and the suite's own integrity
group confirms it; the new profile carries `name` (equal to its filename),
`description` on one physical line as the renderer requires, and `tier`; its
section order matches the house shape; no invented numeric limit and no triple
apostrophe that would break the TOML render; English throughout, and the one
Owner quote in the parent spec stays in French in quotation marks.

**Considered and rejected as findings.** Two candidates were raised and do not
stand. *The escalation ladder still named in `socle/agents/discipline.md` rule
6, in `socle/agents/methodology.md` and in the auto/supervised formula
headers* is not a finding: the parent spec's Implementation Decisions, point 9,
rules the intermediate inconsistency accepted, and those carriers belong to
slice 3. *The render loop in `test/installer.sh` still skipping `checker`* is
not a finding either: the persisted Design states adding it is not this
slice's business. Both are recorded so the next reviewer does not re-raise
them.

#### Spec axis

Requirements: the 🧑 zones of this slice — "What to build", the named
acceptance criteria, and the persisted `## Design` — plus the parent spec's
Scope, Acceptance Criteria, Architecture and Implementation Decisions, points
10 and 11 included.

**Every named criterion verified, all seven passing.** Each was run, not
assumed:

- **foreman-is-a-profile** — the profile exists, the doc page is gone, and the
  frontmatter carries all three keys.
- **no-allotment-left** — `grep -rin "allotment" socle/` returns nothing.
- **profiles-shed-ladder-and-digest** — the `digest` grep and the
  `Architect → Inspector` grep both return nothing, and so does the
  wrap-tolerant `Mason →` check the design check asked for.
- **foreman-page-unreferenced** — `grep -rn "\.agents/foreman\.md" socle/
  test/` returns nothing, and the roster row carries tier **frontier** and the
  new contract pointer.
- **map-replaces-the-boundary** — read through in all four named files. The
  map reads as indicative and motivated in `architect.md` (Spec bullet),
  `mason.md` (claim sentence), `foreman.md` (the closing paragraph of "Ruling
  on a report") and `inspector.md` (the new Mission paragraph), and the
  Inspector judges deviations rather than forbidding them.
- **profiles-carry-the-framing** — each of the five bodies was read as if it
  were the whole instruction set of a fresh session. All five state the
  mission, whom the role reports to, and what it never does, with no doctrine
  needed from a delegator; the README states paste-the-body-verbatim as the
  rule and confines the delegator to the brief.
- **suite-green** — `bash test/run.sh`: 9 scenarios, 93 assertions, 0 failed,
  test files at 588 lines. Exactly the plan's prediction.

**P1 — an edit landed outside the persisted plan's edit list, unnoted
(minor).** The persisted Design says of `socle/agents/profiles/README.md` that
the section "The body is the source; the per-tool definitions are renders" is
**unchanged**, and the program design repeats that it is "not touched in this
commit". Commit `31cebc3` changed a sentence in it anyway: "Anything with no
definition format at all uses the fallback below" became a pointer to the
retitled section. **Judged on its merits: correct and necessary.** Retitling
"The universal fallback" to "How a role is spawned" orphaned that pointer, and
leaving it would have shipped a reference to a section that no longer exists
under that name — which the integrity group does not catch, because it checks
file paths and not section titles. The replacement also names the target
section, which is what rule 11 asks for. The finding is that it went into the
diff without reaching the worklog, whose commit-1 line still says "the two
spawn-rule sections of the profiles README". Nothing to revert.

**P2 — the third correction of the design check did not land in the plan text
(minor).** The `### Design check` subsection asked the verification order to
name the wrap-tolerant ladder check in place of the `Mason → Architect` grep
that "proves nothing". The verification order still reads "the three greps".
Substantively this is satisfied — the wrap-tolerant check was run at this
review and passes — but the plan text was not brought into line. The plan
lives in a 🧑 zone, so this was never the Mason's to edit; it is the thread
owner's, and it is recorded here rather than fixed.

**No scope creep found.** The roster row in `socle/agents/methodology.md` is
the only line touched in a slice-3 file, and this slice's own criterion
**foreman-page-unreferenced** requires it. Nothing belonging to the formulas,
`chisel-light`, `discipline.md` or the AGENTS block leaked in early. Both
commits match the atomicity the plan demanded: the carrier rewrites alone in
`31cebc3`, the whole file-set flip in `c450029`.

**Noted for a later chantier, not a finding here:** the Escalation section of
`socle/agents/profiles/checker.md` still routes to "the spec's owner" and "the
Owner" rather than to the spawner. The parent spec confines the Checker to the
spawn-framing pass and says nothing else in it changes, so the diff is right
to leave it; the residual sits with the readability pass the parent defers.

#### Verdict on the files-map deviation

`bin/chisel.sh` sits on the parent spec's files-to-avoid list and was touched
— three lines removed. Judged a posteriori, on its merits, as the doctrine
this slice ships requires: **validated, no finding.**

The reasoning holds independently of the ruling. Deleting a managed socle
source obliges the installer to stop naming it: the source-path constant, the
managed-file manifest line and the install copy all refer to a file that no
longer exists, and under `set -euo pipefail` the copy aborts `chisel init`
mid-body. Verified here that nothing else in `bin/` referenced it, that the
three removed lines are the whole of the change, and that the suite is green
after it. That is the mechanical consequence of the deletion, not the CLI
evolution the Deno-port chantier owns.

The deviation was also handled the way the doctrine prescribes rather than
discovered at review: raised at design-check as Finding 1, escalated instead
of decided while typing, and ruled by the Owner in the parent spec's
Implementation Decisions, point 11 ("Retire oui").

It reveals no bad pattern in this diff, but it does expose a real coupling
worth naming: the installer hard-codes each top-level socle file in three
separate places, so every future add or delete costs three edits in a file the
map wants left alone. That belongs to the Deno-port chantier, which already
owns the orphan cleanup for stale copies of the deleted page in equipped
projects. Recorded, not raised as a finding against this slice.

### Worklog — closed 2026-08-27

Run under `chisel-default` with the human at every gate, the invoking session
taking the Foreman role: it spawned each step fresh with the step role's
profile body pasted verbatim plus a brief from that profile's `Inputs`
section — the very doctrine this slice ships, dogfooded before it was
written.

Steps, in order. **Plan** — an Architect wrote this file and persisted the
design; the Owner approved it at the gate and ruled that "The Ledger" dies
here rather than at the joins-and-minors chantier. **Design check** — a Mason
posted its program design and raised four findings, one of them the CLI
blocker; a second Architect answered CORRECTIONS on three points. **Type** —
two commits: `31cebc3` reworked the four existing profiles and the two spawn
sections of the README with the file set unchanged, then `c450029` flipped
the file set atomically once the Owner ruled "Retire oui" on the CLI's three
references. **Review** — an Inspector ran both axes, re-running every named
criterion rather than trusting the typing session, and validated the map
deviation on its merits. **Close** — this entry, the changelog, the Owner's
ruling on the rule-11 sweep recorded in the action plan, then commit and push
by the Foreman.

Three findings arrived after the profile was already committed and were ruled
by the Owner in flight, each recorded in the parent spec's Implementation
Decisions rather than left in this working zone: the CLI deviation (point
11), and the Foreman's reporting shape (point 10), extended the same day
after the first shapes proved unreadable in use — the Foreman now works
silently and every report stands on its own, landed as `73b3bb9`.

Deliberately not done, each with its home: the ragged line widths the
Inspector flagged in `mason.md` (cosmetic, no criterion, not worth a Mason
round); the repeated spawn contract across the README and the Foreman profile
(accepted as the price of the paste-verbatim rule, and asked for by the
plan); the bare `.agents/project.md` section references that contravene
discipline rule 11 (every profile predating the rule does the same — the
Owner ruled a single sweep at the normative-extraction chantier, recorded in
the action plan of `project-management/review-360-decisions.md`).
