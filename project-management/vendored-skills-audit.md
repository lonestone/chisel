# Vendored skills audit — where the forks contradict the socle

Sixteen skills under `socle/agents/skills/` declare an `x-upstream` lineage on
`mattpocock/skills`: `code-review`, `codebase-design`, `diagnosing-bugs`,
`domain-modeling`, `grill-with-docs`, `grilling`, `handoff`,
`improve-codebase-architecture`, `prototype`, `research`, `retro`,
`slice-task`, `tdd`, `triage`, `wayfinder`, `writing-great-skills`. Eleven are
declared verbatim forks, five declare an adaptation. The four remaining skills
in the directory — `chisel-beads`, `chisel-setup`, `sync-upstream`,
`upgrade-v2` — are chisel's own and are outside this audit.

**Addendum, 2026-09-09 · `foreman`.** The paragraph above is the 2026-08-27
state. Chantier 3 (`project-management/archive/20260908-1149-joints-and-minors.spec.md`)
deleted `grill-with-docs` and `triage` and moved `sync-upstream` to
`socle/scripts/`: fourteen skills now declare an `x-upstream` lineage, and the
directory's own are three — `chisel-beads`, `chisel-setup`, `upgrade-v2`. The
findings below on the two deleted skills stand as a record.

Each was read in full, with its disclosed reference files, and judged against
`socle/agents/methodology.md`, `socle/agents/discipline.md`, the five profiles
and their `README.md`, the five formulas, `socle/templates/000-task-file-template.md`
and the Owner's rulings in `project-management/review-360-decisions.md`.

**Fourteen of the sixteen carry findings.** The two that do not are the two
already sentenced — `grill-with-docs`, ruled deleted, and `triage`, ruled out
of the shipped socle for now; both are noted at the end for the one or two
things in them that still matter.

What the audit found, in aggregate, is five recurring classes rather than
sixteen unrelated defects:

1. **Skills that address a human directly** in steps that the pipeline runs
   inside a spawned sub-agent — which, by the formulas' own words, cannot
   interview anyone. This hits `slice-task`, `codebase-design`, `tdd`,
   `grilling` and `diagnosing-bugs`.
2. **Numeric limits invented in prose** — report word caps, file line caps,
   session token caps, sentence caps, hypothesis counts. Eight of the sixteen
   carry at least one, against an explicit Owner ruling that none may exist
   anywhere in the socle.
3. **Dead pointers** — four skills send the reader to a section of
   `.agents/project.md` called "Tracker section", which does not exist; one
   also sends them to "Wayfinding operations" notes the Owner explicitly
   deleted.
4. **External-tracker vocabulary and machinery** — "issue", "ticket",
   "labels", "assignees", "child issues", `#42` — where this repo has spec
   files and reserves the word "ticket" for external trackers.
5. **Ownership claims that no longer match the roster** — who agrees the
   seams, who reviews against what, where refactoring work happens.

The most damaging findings are not the most visible ones. `code-review`,
`retro` and `tdd` are consumed on every single task — the first two by name in
every formula, the third by the Mason's contract — and each contradicts the
doctrine at a point that changes what the agent actually does.

---

## code-review

Named by the `diff-review` step of `chisel-default`, `chisel-supervised` and
`chisel-auto` as the skill the Inspector follows, offered to the human by
`chisel-light` ("available to whoever wants its shape; nothing here spawns
it"), and named in `socle/agents/profiles/inspector.md` as the Inspector's
method. Only `chisel-auto-light` has no diff review at all. The
highest-traffic skill in the set. Declared as adapted.

### The Spec axis is reduced to four sections of the task file

> "The task file's 🧑 zones (Context, Scope, Acceptance Criteria, Seams) are
> the spec; its 🤖 agent zone is context, not requirements."

The Owner ruled the opposite in the decisions file, block B · Contradictions
de doctrine, ruling B5: the Spec axis judges the diff against the spec
document alone, **system design included** — "fin de l'énumération en dur des
4 sections dans code-review". The hardcoded list omits the Architecture
section, which `socle/templates/000-task-file-template.md` places in the
🧑 REVIEW CAREFULLY zone and which
`socle/agents/methodology.md`, "The two designs — and why they do not happen
at the same moment", makes the settled, durable half of the design. As written,
a diff that violates the agreed system design passes the Spec axis silently.

The same premise has already leaked into the formulas: the `diff-review` step
of `chisel-default`, `chisel-supervised`, `chisel-auto` and `chisel-light` all
hand over "{{spec}}, whose 🧑 zones are the requirements of the Spec axis".
That phrasing is zone-shaped rather than a four-item list, so it is closer to
the ruling, but it should move together with the skill.

### Two invented word caps

> "Under 400 words."

Twice — once in the Standards sub-agent brief, once in the Spec brief. The
Owner's ruling on numbered form limits, in block D · Code exécutable, ruling
D4 and confirmed in block G, ruling G2: "on n'a pas de limites à mettre, c'est
une fausse bonne idée", extended to "aucune limite chiffrée nulle part — ni
socle, ni template, ni suite de tests". A cap on a review report is the exact
shape the ruling forbids, and it caps the one artifact the Owner reads to
arbitrate.

### The spec source is still described as an external ticket

> "**Spec** — does the code faithfully implement the originating issue / PRD /
> spec?"

and in the frontmatter description: "does the code match what the originating
issue/PRD asked for?". The skill's own `x-upstream` block declares the
adaptation "spec source is the task file, not the originating issue/PRD" — the
declaration was made and the text was not changed. "Ticket" is reserved for
external trackers by the Glossary of `socle/agents/methodology.md`; "issue" and
"PRD" are the same borrowed vocabulary.

### A dead pointer to the glue

> "see `.agents/project.md`, Tracker section."

`socle/agents/project.md.tpl` has no "Tracker section". Its sections are
§A · Task workspace, §B · Coordination (with §B1 · Where task statuses live,
§B2 · Link to an external tracker, §B3 · Autonomous runs), §C · Reading list,
§D · Documentation reference, §E · Adapters, §F · Gate commands, §G · Glossary
& decisions, §H · Model tiers. The rename was ruled in block A · Jointures
normatives, ruling A1: the five pointers become "`.agents/project.md`,
§B · Coordination". This is one of them.

### It asks the user for what the Inspector is handed

> "Whatever the user said is the fixed point … If they didn't specify one, ask
> for it."

and, for the spec, "If nothing is found, ask the user where the spec is."
`socle/agents/profiles/inspector.md`, "Inputs — what this role receives", gives
the Inspector the fixed point "pinned by whoever hands over the work" and the
spec pointer, as a contract. A spawned Inspector has no user to ask; it reports
to its spawner. The skill's discovery ladder is a fallback the pipeline never
needs and, in an autonomous preset, cannot execute.

---

## wayfinder

A side lane, named in `socle/agents/discipline.md`, "Side lanes". Declared as
adapted — "tracker reference adapted for the local task tracker" — and the
Owner ruled in block F · Mineurs, ruling F1.1, that it is kept "absolument" and
rebuilt local-first. The body has not been adapted at all: it is the upstream
issue-tracker skill end to end.

### The declared adaptation is absent from the text

The whole skill is built on machinery this repo does not have:

> "The map is a single issue on this repo's issue tracker, labelled
> `wayfinder:map` — the canonical artifact. Its tickets are child issues of the
> map."

> "A session **claims** a ticket by assigning it to the dev driving the map,
> **first**, before any work … That assignee _is_ the claim: an open,
> unassigned ticket is unclaimed."

> "Blocking uses the tracker's **native** dependency relationship — essential
> because it renders the frontier _visually_ in the tracker's own UI"

Issues, labels, assignees, native dependency links and a tracker UI. The
Glossary of `socle/agents/methodology.md` reserves "ticket" for an external
tracker "if/when one is wired up", and none is: `socle/agents/project.md.tpl`,
§B2 · Link to an external tracker, ships unset. Ruling F1.1 names this
explicitly as work to do — "reformuler aussi les « tickets » locaux (mot
réservé aux trackers externes)".

### Two dead pointers in one sentence

> "The issue tracker is defined in `.agents/project.md`, Tracker section.
> Consult that section's "Wayfinding operations" notes for how _this_ repo
> expresses them."

"Tracker section" does not exist (see the same finding under `code-review`).
"Wayfinding operations" is worse: ruling A1 says in as many words that the
"Wayfinding operations" reference "reste supprimé". This skill is the reference
that was supposed to be deleted, and it is the only place it survives.

### A tracker that does not exist is offered as the default

> "If no tracker has been provided, default to the local-markdown tracker."

There is no "local-markdown tracker" anywhere in the socle. The two
coordination options `socle/agents/project.md.tpl`, §B1 · Where task statuses
live, offers are the markdown task files and a committed beads database. An
agent following this sentence has nothing to follow.

### A token budget invented in prose

> "Its body is the question, sized to one 100K token agent session"

Ruling G2 again — no numeric limit anywhere. Note that
`socle/agents/discipline.md`, rule 7 (Session hygiene), carries a comparable
number ("past roughly 120k tokens"), so the socle is not clean on this point
either; that one is the Owner's to keep or drop, but the vendored copy of the
same idea, with a different number, is drift on top of it.

### Naked ids, correctly forbidden — and then required anyway

The skill's "Refer by name" section is good doctrine and agrees with the
decisions file, block C · Lisibilité des tâches, rulings C1 and C2: refer by
name, "never by a bare id, number, or slug". But the machinery underneath
contradicts it — "the tracker's issue id is its identity", "User invokes with a
map (URL or number)" — because the identity of every artifact in the skill *is*
a number.

### A one-per-session limit stated as a rule

> "**never resolve more than one ticket per session** — with the exception of
> research tickets."

Weaker than the others, and defensible as discipline rather than as a size cap.
Flagged for completeness; I would not rewrite it on the strength of ruling G2
alone.

---

## tdd

Named in `socle/agents/profiles/mason.md`, mission — "Test-driven at the seams
the spec agreed (`tdd` skill)". Not named by any formula step, so it reaches
the pipeline through the Mason's contract, on every typing step. Declared a
verbatim fork.

### It moves the seam decision to the wrong moment and the wrong owner

> "**Test only at pre-agreed seams.** Before writing any test, write down the
> seams under test and confirm them with the user. No test is written at an
> unconfirmed seam."

> "Ask: "What's the public interface, and which seams should we test?""

Three separate contradictions in one paragraph:

- **The moment.** `socle/agents/methodology.md`, "Why seams are agreed before
  implementation", puts seam agreement at creation time, and the task template
  gives Seams its own section in the 🧑 REVIEW CAREFULLY zone. The formulas'
  `interview` step names them as an output: "the seams the work will be tested
  through". By the time TDD runs, at `type`, they are settled.
- **The owner.** `socle/agents/profiles/mason.md`, "Prohibitions", says the
  Mason "Never decides the system design … the architecture, the scope, and the
  seams the work is tested through". A missing seam is listed there as an open
  *what* — "hand it back", a finding against the spec.
- **The interlocutor.** A Mason reports to its spawner, not to a user. The
  skill's instruction to "confirm them with the user" cannot be executed by the
  role that runs it.

The consequence is not cosmetic: a Mason following this skill literally will
either re-open a settled 🧑 zone or stall waiting for a human who is not there.

### Refactoring is assigned to the review stage

> "**Refactoring is not part of the loop.** It belongs to the review stage (see
> the `code-review` skill), not the red → green implementation cycle."

The review stage in this socle produces findings and decides nothing:
`socle/agents/profiles/inspector.md`, "Prohibitions", forbids the Inspector to
rewrite; the `diff-review` gate hands findings to the Owner; the `close` step
of every formula says the arbitrated findings that "must be typed goes through
the Mason contract". And a refactor the Mason spots while typing has its own
route — `socle/agents/profiles/mason.md`, "The proposal door", where it is
reported with three evaluations and never acted on quietly. Pointing at
`code-review` as the home of refactoring names a stage that, here, cannot do it.

### Seam is defined a third time

The skill's "Seams — where tests go" restates a definition that
`socle/agents/methodology.md` already carries in its Glossary and that
`socle/agents/skills/codebase-design/SKILL.md` carries again. This is the
duplication the Owner ruled on in block E · Dette déclarative, ruling E4.1
("« Seam » est défini 3× … une définition dans la référence, les skills gardent
une ligne de rappel + pointeur"). Recorded here as confirmation that the
duplication is real and where it sits, not as a new finding.

---

## retro

Invoked by the `close` step of all five formulas, and the only vendored skill
whose frontmatter says so. Declared as adapted, extensively.

### Its first step is impossible by the socle's own rules

> "1. Call the Skill tool with `writing-great-skills` for the writing style
> guide"

`socle/agents/skills/writing-great-skills/SKILL.md` carries
`disable-model-invocation: true`. That skill's own glossary, under
"User-Invoked", states the consequence: "Because it has no description, nothing
but the human can reach it: no other skill can fire it." So a step run at every
task close instructs the agent to do something the skill it points at declares
impossible. Either the target loses `disable-model-invocation`, or the pointer
becomes a file read rather than an invocation. I am confident about the two
texts; which of the two fixes the Owner wants is his call.

### A line-count limit on a standards file

> "Add navigation pointers to docs folders if a standards file grows past
> roughly 1,000 lines."

Ruling D4 / G2, no numeric limits anywhere. This one is doubly awkward: the
retro is where proposals to change the working rules are generated, so a
numeric limit here propagates into the rules of every equipped project.

### A false claim about the AGENTS block

> "`.agents/discipline.md`: the ambient core, rendered into the AGENTS block."

`socle/templates/AGENTS-block.md` does not render the discipline; it points at
it — "**Always** — follow `.agents/discipline.md`". The Owner ruled this in
block F, ruling F1.6: "le bloc POINTE vers discipline.md (vérifié), il ne la
rend pas". The correction was ruled and not applied.

### An out-of-date use of the word "plan"

> "The implementation session (Architect planning, Mason typing)"

Since the Owner's Addendum ruling G6, the `plan` step is the Mason's own
program design, written by the session that implements — and the Architect's
role at that point is `plan-review`, a verdict. "Architect planning, Mason
typing" describes the pipeline as it was before the rename and the resequencing.

---

## slice-task

Invoked by the `spec` step of all five formulas whenever the sizing check
answers "this needs slicing". Declared as adapted, from upstream's `to-tickets`.

### It requires a conversation with a user inside a spawned step

> "### 4. Quiz the user … Ask the user: Does the granularity feel right? …
> Iterate until the user approves the breakdown."

The `spec` step of every formula assigns this work to a spawned Architect, and
both the formulas and `socle/agents/profiles/foreman.md`, "Mission", state the
constraint plainly: "a spawned role cannot interview the human". The Architect
profile's own escalation section resolves the equivalent case differently —
"where there is no one to ask, write the blocker into the spec file and report
it to your spawner". An iterate-until-approved loop is not executable inside
the step that invokes it, and under `chisel-auto` there is no approver at all.

### The same dead pointer

> "Where slices are published is defined in `.agents/project.md`, Tracker
> section."

Ruling A1 again — the section is §B · Coordination. And in this case the
sentence is also inaccurate on its own terms: where slices are published is
declared in §A · Task workspace, which the skill itself resolves correctly two
sections later.

### The slice template has no top zone marker

The `<slice-template>` block marks 🧑 REVIEW IF RELEVANT and 🤖 AGENT ZONE, but
nothing marks the top — Status, "What to build", Acceptance criteria — which is
the decision surface. `socle/templates/000-task-file-template.md`, "The three
zones", makes 🧑 REVIEW CAREFULLY the first zone and the reason the gradient
exists; `socle/agents/methodology.md`, "Why a reading gradient (and not shorter
files)", calls it "the decision surface (read it entirely, before any code)". A
slice file produced from this template gives the human no marker telling him
where careful reading starts.

### Numbered acceptance criteria

> "- [ ] Criterion 1 (machine-verifiable)"

The Owner ruled in block C, ruling C4, that acceptance criteria are named, not
numbered — his example: "`- [ ] **plus-de-labels-w** — le grep W0/W1/W2 ne
retourne rien`". Stated honestly: `socle/templates/000-task-file-template.md`
still says "Criterion 1" too, so this skill is mirroring an un-updated socle
template rather than importing a foreign idea. It should be fixed with the
template, not against it.

### A hardcoded script path where the glue declares one

> "`<time-id>` comes from `scripts/task-id.sh`"

`socle/agents/project.md.tpl`, §A · Task workspace, declares a "Task id script"
field, and the `spec` step of the formulas says "named with the task id script
declared there". The default value happens to match, so nothing breaks today; a
project that moves the script breaks silently. Low severity.

---

**Post-audit addendum (2026-09-08, foreman)** — two findings from the
skill's first real use under the two-document convention (slicing the
joints-and-minors task):

- Its slicing-time rule "avoid specific file paths in What to build and the
  criteria — they go stale" contradicts a text-repair task whose criteria
  ARE path-naming greps with recorded counts. The parent spec won on the
  spot; the skill needs a carve-out for text-surface tasks or the rule
  softened to a default.
- Its emitted slice template is narrower than the Architect profile requires:
  no files-to-modify/files-to-avoid map, no Verification, no References. All
  three slices added them by hand to match the house style; the emitted
  template should carry them.

## codebase-design (with DEEPENING.md and DESIGN-IT-TWICE.md)

Named in `socle/agents/profiles/checker.md`, mission — the Checker proposes
alternative designs "Via the `codebase-design` skill and its
`DESIGN-IT-TWICE.md` practice". Declared a verbatim fork.

### It licenses tests against internals

> "A module can have **internal seams** (private to its implementation, used by
> its own tests) as well as the **external seam** at its interface."

and, in `DEEPENING.md` under "Seam discipline", the same sentence again, plus
under "Local-substitutable": "The seam is internal; no port at the module's
external interface."

The Glossary of `socle/agents/methodology.md` defines a seam as "The public
boundary where a feature is tested" and states flatly: "Tests live at seams,
never against internals." `socle/agents/profiles/mason.md` repeats it — "tests
go through public interfaces, never internals" — and the vendored `tdd` skill
lists the opposite as its first anti-pattern ("Implementation-coupled — mocks
internal collaborators, tests private methods"). Two vendored skills disagree
with each other and one of them disagrees with the methodology.

### DESIGN-IT-TWICE presents to a user the Checker does not have

> "Show this to the user, then immediately proceed to Step 2. The user reads
> and thinks while the sub-agents work in parallel."

> "Present designs sequentially so the user can absorb each one"

The Checker is a spawned sub-agent that "reports to its spawner"
(`socle/agents/profiles/checker.md`, "Mission") and whose alternatives are "put
to the author and argued" — the author of the spec, not a user. Same class as
`slice-task` and `tdd`: a human-facing step embedded in a role that has no
human.

### Numeric design constraints

> "Agent 1: "Minimize the interface — aim for 1–3 entry points max.""

and "Spawn 3+ sub-agents in parallel". Ruling G2. I flag these with less
conviction than `code-review`'s word caps: the first is a deliberately arbitrary
constraint handed to a design agent to force divergence, the second a fan-out
count, and neither caps an artifact a human reads. Worth a decision, not
necessarily a rewrite.

---

## diagnosing-bugs

A side lane, named in `socle/agents/discipline.md`, "Side lanes". Declared a
verbatim fork with paths adapted.

### A broken pointer to its own script

> "**HITL bash script.** Last resort. If a human must click, drive _them_ with
> `scripts/hitl-loop.template.sh`"

The file exists at
`socle/agents/skills/diagnosing-bugs/scripts/hitl-loop.template.sh`, which the
installer copies to `.agents/skills/diagnosing-bugs/scripts/`. The path as
written resolves against the repo root, where the installer creates a different
`scripts/` directory containing `task-id.sh`. Cited twice in the skill —
"a human in the loop only via `scripts/hitl-loop.template.sh`" — and wrong both
times. `socle/agents/discipline.md`, rule 11, requires a reference to be
followable without searching.

### It tells the agent to delete prototypes the doctrine says to keep

> "- [ ] Throwaway prototypes deleted (or moved to a clearly-marked debug
> location)"

`socle/agents/skills/prototype/SKILL.md`, rule 6, says the opposite: "capture
the prototype itself as a **primary source**: commit it to a throwaway branch,
out of main". The Owner arbitrated exactly this in block F, ruling F1.5:
"la règle 6 du skill est la référence, la discipline s'aligne (« delete the
code » disparaît)". The prototype skill won that arbitration; this checklist
item is the losing side, restated in another skill.

### A prescribed hypothesis count and a cluster of numbers

> "Generate **3–5 ranked hypotheses** before testing any of them."

Plus "run 1000 random inputs", "Loop the trigger 100×", "A 50%-flake bug is
debuggable; 1% is not", "A 30-second flaky loop is barely better than no loop;
a 2-second deterministic one is tight" and "the bug is 90% fixed". Ruling G2
covers the first squarely — a required count. The rest are rhetorical or
illustrative and I would not treat them all alike; the Owner should decide how
far the rule reaches into figures of speech.

### It hands off to a skill it cannot invoke

> "hand off to the `/improve-codebase-architecture` skill with the specifics."

That skill carries `disable-model-invocation: true` — the same impossibility as
`retro`'s first step, and the same slash-prefixed naming the socle does not use
anywhere else (`socle/agents/discipline.md`, "Side lanes", and the formulas name
skills in backticks, without a slash).

---

## domain-modeling (with CONTEXT-FORMAT.md and ADR-FORMAT.md)

Named by the `interview` step of all five formulas, "with `domain-modeling`
underneath". Declared a verbatim fork with paths adapted.

### Sequential ADR numbering

> "ADRs live in `docs/adr/` and use sequential numbering: `0001-slug.md`,
> `0002-slug.md`, etc."

> "Scan `docs/adr/` for the highest existing number and increment by one."

`socle/agents/methodology.md`, "Why the time-id prefix", bans exactly this
mechanism and gives the reason: "Incremental numbers are banned: they collide
across branches and carry no meaning." The ban is stated there for task files,
and ADRs are not task files — but the failure mode is identical, since ADRs are
created on feature branches in the same way, and the socle's own answer
(`scripts/task-id.sh`) is right there. Related: "superseded by ADR-NNNN" and
the citation style it implies run against ruling C1, which forbids naked codes.

### A sentence cap on glossary definitions

> "**Keep definitions tight.** One or two sentences max."

Ruling G2 — the form rules stay qualitative and the Checker judges. "Tight" is
the qualitative rule; "two sentences max" is the numeric one bolted to it.

### Hardcoded paths under a glue-resolution header

The skill opens with "Glossary and ADR locations resolve via
`.agents/project.md`", then hardcodes `CONTEXT.md` and `docs/adr/` in its file
tree, in "Update CONTEXT.md inline", and throughout `ADR-FORMAT.md` and
`CONTEXT-FORMAT.md`. The defaults are correct — `socle/agents/project.md.tpl`,
§G · Glossary & decisions, ships root `CONTEXT.md` and `docs/adr/` — so nothing
breaks in a default install; a project that answers §G differently gets a skill
that ignores the answer.

---

## handoff

Named in `socle/agents/discipline.md`, rule 7 (Session hygiene), as the way out
of a long session. Declared a verbatim fork.

### It writes the handoff outside the repo

> "Save to the temporary directory of the user's OS - not the current
> workspace."

`socle/agents/discipline.md`, rule 8, reads: "**The repo is the only memory.**
Never store project knowledge in a harness memory (auto-memory or any
equivalent outside the repo); it goes in the repo's files, visible to review
and git." A handoff document is project knowledge — what was decided, what is
left, what the next session should do — and the OS temp directory is an
equivalent outside the repo. `socle/agents/methodology.md`, "The two designs",
gives the same reasoning for persisting the plan: "a session must be resumable
from the file alone."

Said plainly: I am less sure of this one than of the others. Rule 8 was written
against harness memories, and a handoff is deliberately transient. But the rule
as worded covers it, and rule 7 makes `handoff` a load-bearing part of the
socle's session hygiene rather than a scratch convenience — which is what makes
it worth putting to the Owner instead of ignoring.

---

## improve-codebase-architecture

A side lane, named in `socle/agents/discipline.md`, "Side lanes". Declared a
verbatim fork with paths adapted.

### The report is written outside the repo

> "Write a self-contained HTML file to the OS temp directory so nothing lands
> in the repo."

Same tension as `handoff` with rule 8 of `socle/agents/discipline.md`, and
weaker: a rendered report is a presentation, the durable output is the idea that
becomes a task, and the discipline's own side-lane table says this skill
"produces an idea → normal flow". I record it as a judgement call for the
Owner, not as a defect.

### Slash-prefixed skill names

> "Run the `/codebase-design` skill for the architecture vocabulary"

Three times in the skill (`/codebase-design`, `/grilling`, `/domain-modeling`)
and twice more in `HTML-REPORT.md`. Nothing in the socle names a skill that way
— the formulas, the profiles and `socle/agents/discipline.md` all use backticks
and the bare name — and no slash command by those names exists.

### A word cap and a naked code

> "**Wins** — bullets, ≤6 words each."

Ruling G2. And:

> "contradicts ADR-0007 — but worth reopening because…"

A naked code in a human-facing artifact, against ruling C1 ("les codes sont à
éviter « au max du max du max »"). Both minor; both in the same file.

---

## prototype (with LOGIC.md and UI.md)

Named by the `interview` step of all five formulas and in
`socle/agents/discipline.md`, "Side lanes". Declared a verbatim fork.

### External-tracker vocabulary in its capture rule

> "leave a context pointer to that branch on the implementation issue. Capture
> the answer too — the verdict and the question it settled — in the issue or a
> commit."

There is no "implementation issue" here; there is a spec file. The Glossary of
`socle/agents/methodology.md` reserves that vocabulary for an external tracker,
and `socle/agents/profiles/mason.md`, "Inputs", makes the spec file the channel
between sessions. The pointer should land in the spec file that consumed the
decision.

Everything else in this skill is aligned, and rule 6 is doctrine the Owner has
already ruled in its favour (block F, ruling F1.5). Two consequences of that
ruling are still open on the socle's side, not the skill's: `socle/agents/discipline.md`,
"Side lanes", still says "keep the answer, delete the code", and no formula's
`close` step carries the prototype-branch cleanup habit the Owner asked for.

---

## grilling

Named by the `interview` step of all five formulas and by
`socle/agents/profiles/foreman.md` ("**Leads the interview itself**, following
the `grilling` skill"). Declared a verbatim fork. A handful of sentences long, and
almost entirely aligned — the one-question-at-a-time rule, the recommended
answer per question and the look-up-facts/ask-decisions split are the exact
behaviour `socle/agents/methodology.md`, "Why the interview comes first (and is
a separate skill)", describes.

### An unconditional human gate

> "Do not act on it until I confirm we have reached a shared understanding."

Under `chisel-auto` and `chisel-auto-light` there is no human to confirm. Both
formulas patch this in the body of their own `interview` step — "There is no
human to interview here: derive all of it from the Brief and the ambient layer"
— so the contradiction is contained today. It is worth naming because the patch
lives in the caller rather than the skill, which is the drift risk ruling E3
was about.

---

## research

A side lane, named in `socle/agents/discipline.md`, "Side lanes", and used by
`wayfinder`. Declared a verbatim fork.

### It guesses where to write instead of resolving the glue

> "Save it where the repo already keeps such notes; match the existing
> convention, and if there is none, put it somewhere sensible and say where."

Every other path in the socle resolves through `.agents/project.md` — §A for
the task workspace, §D for the documentation reference, §G for the glossary and
decisions — and `socle/agents/methodology.md`, "Artifact ladder (plans →
evergreen)", is explicit that the task workspace is not the living
documentation. "Somewhere sensible" is the one place in the vendored set where
an artifact's home is left to the agent's taste.

A second, smaller thing: `wayfinder` tells its research sub-agents to capture
findings "on a throwaway `research/<name>` branch", while this skill says to
write a markdown file into the repo. The two callers disagree about where
research output lives.

---

## writing-great-skills (with GLOSSARY.md)

Reached only by `retro`, which cannot in fact reach it (see `retro` above).
Declared a verbatim fork. As a reference on writing skills it is internally
excellent and carries no numeric limits, no tracker vocabulary and no dead
pointers.

### Its guidance on prohibitions is the opposite of how the socle writes roles

> "**Negation** — steering by prohibition backfires: _don't think of an
> elephant_ names the elephant and makes it more available, not less. Prompt the
> **positive** … keep a prohibition only as a hard guardrail you can't phrase
> positively"

Every profile in `socle/agents/profiles/` is built around a "Prohibitions"
section written entirely in the negative — "Never types the code itself",
"Never reviews its own spec", "Never decides the system design" — and the Owner
required that shape in the decisions file, Addendum ruling G5: the profile body
carries "mission, à qui l'on rapporte, ce qu'on ne fait jamais". The skill's own
escape hatch ("a hard guardrail you can't phrase positively") arguably covers
the profiles, so this is a tension rather than a flat contradiction. I raise it
because the two documents give opposite default advice to anyone writing a new
role or skill, and the socle currently ships both.

---

## The two already sentenced

**`grill-with-docs`** — ruled deleted from the shipped socle in block F, ruling
F1.10. Nothing in it needs a finding; its entire body is one line, "Run a
`/grilling` session, using the `/domain-modeling` skill", which is the
slash-prefixed naming noted elsewhere and a duplicate of what the `interview`
step of every formula already says.

**`triage`** — ruled out of the shipped socle for now in block F, ruling F1.11.
Two things in it are worth carrying into whatever brings it back: it uses the
word **role** for tracker labels (`bug`, `needs-triage`, `ready-for-agent`),
which collides head-on with the roster meaning of "role" in
`socle/agents/methodology.md` and `socle/agents/profiles/README.md`; and it
carries the same dead "`.agents/project.md`, Tracker section" pointer as the
other three, plus naked issue ids (`#42`) against ruling C2 and a
"Descriptions under 1024 chars" limit in its `AGENT-BRIEF.md` against ruling G2.

---

## Read and cleared

No skill in the sixteen came through with nothing at all, so this list is not a
clean bill for any of them — it records what was read so the reader can see the
audit was complete rather than partial.

Read in full, with their disclosed reference files:

- `code-review` — SKILL.md
- `codebase-design` — SKILL.md, DEEPENING.md, DESIGN-IT-TWICE.md
- `diagnosing-bugs` — SKILL.md, and the presence and location of
  `scripts/hitl-loop.template.sh`
- `domain-modeling` — SKILL.md, CONTEXT-FORMAT.md, ADR-FORMAT.md
- `grill-with-docs` — SKILL.md
- `grilling` — SKILL.md
- `handoff` — SKILL.md
- `improve-codebase-architecture` — SKILL.md, HTML-REPORT.md
- `prototype` — SKILL.md, LOGIC.md, UI.md
- `research` — SKILL.md
- `retro` — SKILL.md
- `slice-task` — SKILL.md
- `tdd` — SKILL.md, tests.md, mocking.md
- `triage` — SKILL.md, AGENT-BRIEF.md, OUT-OF-SCOPE.md scanned
- `wayfinder` — SKILL.md
- `writing-great-skills` — SKILL.md, GLOSSARY.md

Carrying no findings of their own: **none**. The two sentenced skills carry
notes rather than findings. `prototype`, `grilling` and `writing-great-skills`
came closest to clean — one contained finding each, and in `prototype`'s case
the Owner has already ruled the skill right and the socle wrong.

The parts of `tdd`, `prototype`, `codebase-design` and `writing-great-skills`
that were checked and found **aligned** are worth naming too, so a corrective
pass does not disturb them: `tdd`'s anti-patterns and rules of the loop;
`prototype`'s six rules and both its branches; `codebase-design`'s vocabulary,
deletion test and rejected framings; and all of `writing-great-skills` except
the passage above.

---

## Two things outside the vendored set, noticed while verifying

Neither is a vendored-skill finding; both would confuse a corrective pass if
left unsaid.

- `socle/agents/profiles/inspector.md`, "Mission", still says the Inspector
  "runs the `review` step of the pipeline". The Owner's Addendum ruling G6
  renamed it `diff-review`, and all five formulas already use the new name.
- `socle/agents/methodology.md` still carries a section titled "Escalation, and
  the Owner's digest" and the sentence "The chain climbs one rung at a time …
  Mason → Architect → Inspector → the Owner's digest", and
  `socle/agents/discipline.md`, rule 6, repeats the chain. Ruling B3 killed both
  the word "digest" and the fixed ladder. The profiles have already been
  rewritten; these two files have not.

## Where I was unsure

- **`handoff` writing to the OS temp directory.** Rule 8's wording covers it;
  its intent may not. Put to the Owner rather than fixed on my reading.
- **How far the no-numeric-limits ruling reaches.** A word cap on a review
  report is plainly in scope. "Run 1000 random inputs", "3+ sub-agents",
  "1–3 entry points" and "the bug is 90% fixed" are heuristics and figures of
  speech, and I did not assume the ruling swallows them all.
- **Numbered acceptance criteria in `slice-task`.** The socle's own task
  template has the same defect, so this is one correction across two files, not
  a vendored import to reverse.
- **`writing-great-skills` on negation.** Its own escape hatch may already
  license the profiles' prohibition sections. Raised as a tension, not asserted
  as a contradiction.
