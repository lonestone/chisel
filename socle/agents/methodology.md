# Methodology — the why behind the workflow

This document explains the reasoning behind the task workflow so that humans
and agents apply it with judgement, not cargo-cult. The **what/where** is the
task file template declared in §A · Task workspace of `.agents/project.md`
(default `/project-management/000-task-file-template.md`); the **order and
the gates**
are `.agents/formulas/`; the **ambient invariants** are
`.agents/discipline.md`; this file is the **why**.

Provenance: fusion of the Lonestone task lifecycle (creation → work →
completion, a dated journal) with patterns from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT) and dex's
"Why Software Factories Fail" series. Full analysis: `SDD-bench/fusion-pierrick-pocock.md`.

---

## Glossary (uniform wording)

| Term | Meaning |
|---|---|
| **Task** | The unit of work AND its artifact: one markdown file in the task workspace declared in `.agents/project.md` (default `/project-management/tasks/`), named `<time-id>-<intention>.md`. Self-contained, review-gradient structured. |
| **Slice** | A child task produced by decomposing a large task: a tracer-bullet vertical cut through every layer, demoable on its own, sized for a single fresh context window. Lives as `tasks/<time-id>-<feature>/<NN>-<slug>.md`. A small task IS its own single slice — no slice files are created for it. |
| **Seam** | The public boundary where a feature is tested — agreed with the human BEFORE implementation. Tests live at seams, never against internals. Fewer is better (ideal: one). |
| **Reading gradient** | The ordering of a task file by review criticality: 🧑 REVIEW CAREFULLY (short, decision-rich) → 🧑 REVIEW IF RELEVANT (program design) → 🤖 AGENT ZONE (verbose working space). Detail is never cut, it is ordered. |
| **Blocking edge** | A dependency between slices: "slice 3 is blocked by slice 1". A slice with no blockers can start immediately. |
| **Frontier** | The set of slices whose blockers are all done — what can be worked on right now. |
| **Expand–contract** | The sequencing for wide mechanical refactors (rename a column, retype a shared symbol): add the new form beside the old → migrate call sites in batches → delete the old form. The exception to vertical slicing. |
| **One-shot** | Work done without a task file. The work rules (context preamble, plan-first, vertical discipline) still apply; only the file bookkeeping is skipped. |

We do NOT use the word "ticket" for local work. It is reserved for items in an
external tracker (Linear, GitHub Issues), if/when one is wired up — see
`.agents/project.md`, Tracker section.

---

## A default, and two options

chisel has one default behaviour: the human holds every gate. Two options add
to it, and neither changes the other — **beads** (the status database, repo
state, additive) and **auto** (permission not to wait, an invocation
posture — §B3 · Autonomous runs of `.agents/project.md`).

Three presets combine them:

| Preset | Gates | Coordination |
|---|---|---|
| `chisel-default` | every gate awaits the human | markdown task files (or beads, additively) |
| `chisel-supervised` | one asynchronous gate — the Owner approves the spec, nothing else | markdown or beads |
| `chisel-auto` | no gates; a doubting step escalates instead | markdown or beads |

**Factory = auto × beads** — the only combination that requires beads,
because only it needs queues, lanes and asynchronous gate lists. Plain auto
is one chained session and needs none.

**The invocation-posture principle.** Piloting — which preset governs this
run — is chosen per invocation, never baked into the project as a permanent
setting: a non-default posture runs only when a human explicitly asks for it
in that session AND the glue's `.agents/project.md` §B3 permits it — never
chosen by an agent on its own. Coordination (beads) is the other axis
entirely: repo state, additive, and orthogonal to which posture is running —
a beads-equipped repo stays fully usable under the default.

**The Brief-stays-human invariant.** Whichever preset is running, the
decision to start the work at all — the Brief, what to build and why — is
always the human's. No preset decides that upstream question; each only
changes what happens once the Brief exists. See [Zone
ownership](#zone-ownership) below for what each preset makes the human's, and
what it makes the Architect's.

The roster that fills these presets follows.

## The roster

| Role | Tier | Does | Contract |
|---|---|---|---|
| **Owner** | — | Holds the Brief, always; approves whatever a preset gates; arbitrates escalations | not an agent |
| **Architect** | frontier | Writes the spec, answers the `plan-review` | `.agents/profiles/architect.md` |
| **Checker** | frontier | Reviews the spec before it is planned — never its author | `.agents/profiles/checker.md` |
| **Mason** | cheap or mid | Authors its own program design, then types it | `.agents/profiles/mason.md` |
| **Inspector** | frontier | Reviews the diff on two axes — never its author | `.agents/profiles/inspector.md` |
| **Foreman** | frontier | Owns one thread of work — carries the context, spawns the other roles, collects their reports and rules on them | `.agents/profiles/foreman.md` |

The table names roles and points; the contract — what a role may never do,
when it escalates, exactly what it receives — lives in the profile.

## Zone ownership

🧑 marks the zone's **owner**, not simply "the human" — ownership follows
authorship of the approval:

- In the **default**, the human approved both the spec and the plan, so both
  are his.
- In **auto**, the Architect authored both (no human gate), so both are the
  Architect's — a Mason's escalation on either terminates there, and the
  human never hears of it.
- In **supervised**, the spec is the human's (the one asynchronous gate); the
  plan is the Architect's.

**The Brief is always the human's, in every mode.** A 🧑 zone is never
overridden silently, in any mode — a conflict with one is contested upward,
never edited sideways.

## Escalation, and the Owner's digest

The chain climbs one rung at a time, to the owner of the contested zone:
Mason → Architect → Inspector → the Owner's digest.

The digest is named across the profiles and the formulas and defined here,
once. It creates **no new artifact**: a dated ⚠️ line in the journal declared
in §A, plus — when §B1 · Where task statuses live of `.agents/project.md`
keeps the coordination state in beads — a blocking `escalation` item
assigned to the Owner, per the §B convention. That is the whole mechanic.

## The pipeline is nine steps

Not seven. `spec-review` (a Checker, fresh session, never the spec's author,
two rounds max) and `plan-review` (the Mason posts its own program design; an
Architect answers VALIDATED or corrections, two rounds max, then a finding
against the spec) are part of the doctrine now, not an afterthought.
Where the gates sit is the formulas' business, named per preset — see [A
default, and two options](#a-default-and-two-options) above; this file does
not restate it step by step.

---

## Why a reading gradient (and not shorter files)

Models cannot be trusted to maintain codebase quality over time without human
steering, so the human must review — and review is only cheap when the human
knows **what** to read and **how carefully**. The gradient answers that
directly: the top of a task file is the decision surface (read it entirely,
before any code); the bottom is agent working space (skim or skip).

This reconciles detail vs brevity: we don't cut detail, we order it by review
criticality. Only the top must stay short — prefer a mockup or diagram over
three paragraphs. Every decision NOT made explicit in a 🧑 zone is a decision
the human would otherwise make implicitly during code review — the most
expensive possible moment to change one's mind.

The 🧑 zones are their owner's property — see [Zone
ownership](#zone-ownership) above. An agent that discovers a conflict with one
must stop and surface it, never silently override.

## Why seams are agreed before implementation

A seam is program design the human owns. Agreeing seams up front means testing
effort lands on critical paths instead of every edge case, and the tests
survive refactors because they observe public behavior, not internals. It is
also the cheapest moment to catch a bad boundary — before code exists on both
sides of it.

## Why slicing is conditional (the sizing check)

The sizing check runs for EVERY task; the slice files are only created when
the answer demands them. Rationale:

- A slice is defined as "fits in a single fresh context window, demoable in
  one pass". A small task already satisfies both — slicing it would produce a
  folder with one slice that duplicates the task file. Pure ceremony.
- What slicing adds is **decomposition**: blocking edges, the frontier, the
  order. That only has value when there are actually multiple pieces.
- Real-world distribution (dex): ~40% of work is one-shot, medium work gets a
  single document, only large work gets the full breakdown. Rigor must adapt
  to the work, not the other way around.

What IS unconditional: the check itself, stated out loud — and it asks two
things, not one. Does this fit in one pass? The agent announces "this fits in
one pass" or "this needs slicing, here is the breakdown". And does this run
**light or full**? Light drops the validation sub-agents and leaves the spec
approval and the diff review to the human
(`.agents/formulas/chisel-light.formula.toml`); full keeps the Checker, the
`plan-review` and the Inspector. The human answers both, and a silent answer
to either is a review hole.

Note the distinction: **vertical-slice discipline during implementation**
(never layer-by-layer, something demoable at each step) applies to ALL work,
sliced or not. Only the decomposition artifact is conditional.

## The two designs — and why they do not happen at the same moment

There are two designs, and conflating them is the classic failure. The task
file template separates them by zone, and the pipeline separates them in
time:

**System design** — how the pieces talk: services, contracts, schemas, data
models — is the Architecture section of the template, 🧑 REVIEW CAREFULLY.
It is settled **at creation time**: the interview grills its owner, the
`spec-review` loop challenges it, and the spec gate (where the mode has one)
approves it. This is sometimes a lot of work and several rounds, synchronous
or asynchronous — and that is the point: **a task or slice is ready to be
produced when its system design is settled, not before.** A slice can be big
at birth; what makes it ready is that the expensive-to-reverse decisions are
made, not that it is small.

**Program design** — the target shape inside the agreed architecture: files,
seam signatures, test order — is deliberately NOT written at creation time.
Designing slice 6's files before slices 1–3 have taught anything produces
stale guesses — file paths rot, learning is ignored. The implementing
session designs it **just-in-time at its plan step**, with the real code in
view, and the `plan-review` loop validates it before any typing.

That program design must not die with the conversation. Once validated, the
implementing session **persists it into the slice file's Design section** —
the `plan` step of the formulas says so. Three reasons:

1. **The completion review reads the file.** `code-review`'s Spec axis treats
   the task file as the requirements; a design that lives only in chat is
   invisible to it — the review would check 4 criteria instead of the design.
2. **Dependent slices read the file.** Slice 04 builds on decisions made in
   slice 01's plan; the file is the only channel between fresh contexts.
3. **Re-runs and crashes.** The artifact must stay self-contained (context
   hygiene) — a session must be resumable from the file alone.

So the lifecycle of a slice file is: born with intent and its system design
settled → program design persisted at plan validation → worklog during
implementation → checked off at completion.

**Corollary — the cost gradient (opt-in delegation).** Persisting the plan
makes the slice file a complete brief, which unlocks a division of labor: the
**Architect** does the thinking (interview, design, plan) with the human; an
optional **Mason** does only the typing from that file. The agent OFFERS this
choice once the plan is saved (recommending it for large diffs); the user
decides — never a silent default. The delegation boundary is the **system
design**: above it the *what* — architecture, scope, and the seams the work is
tested through — settled at creation time and approved at the gate; below it
the *how*, designed and typed by the session that implements. A Mason asked to
"figure out" something the *what* left open is a specification failure, not an
execution one — and it goes back to the spec. An open *how* is not a hole: it
is what the `plan` step is for.

That gradient is a **tier** gradient, not a licence to spend: the thinking
runs at the frontier tier, the typing from an already-persisted plan runs at
the cheap tier, and which concrete model each tier means is resolved per dev
and per project — see [Model tiers](#model-tiers-and-how-they-resolve) below.

The economics apply at the *session* level, not at the model-family level:
the sessions that type consume most of the tokens, so keeping the Architect's
context clean enough to review matters more than upgrading everything. Few
moments in a large task genuinely require frontier intelligence — the
original decomposition, the design decisions, a handful of trade-offs. Those
moments stay with the Architect and the human, and they are exactly what the
frontier tier is reserved for. Everything below the system design is the how,
and writing the how and typing it do not need the same tier.

The Mason's brief is **artifacts only, never the planning conversation**: the
slice file + the artifacts it explicitly references (parent 🧑 zones,
`CONTEXT.md`/ADRs, prior art) + the repo's ambient layer. Two disciplines
follow (both from observed swarm failure modes):

- **Explicit references beat shared memory.** The Design section must link
  what it relies on — the "compile-checked references" answer to split-brain;
  our version is: the Mason follows links, not vibes.
- **The Architect never implements** — its context stays clean for reviewing
  the Mason's diff against the plan. All completion gates still run; the
  two-axis review is a decorrelated lens by construction (at the frontier
  tier).

It doubles as a quality measure (dex): if a Mason cannot implement the slice
from the persisted design and its references, the design was not factored
well enough — fix the file, not the Mason's context.

## Model tiers (and how they resolve)

Nothing in this socle names a model or a vendor. It speaks in three **tiers**,
the same three the roster uses:

| Tier | What it is for | Roles |
|---|---|---|
| **frontier** | Thinking, grilling, reviewing — where a wrong judgement is expensive and only caught much later | Architect (interview, design, plan); Checker (spec review); Inspector (the two-axis review) |
| **mid** | Ordinary tasks and dispatch — work that needs competence but not judgement | A Mason on a slice that is not purely mechanical |
| **cheap** | Typing from a plan that is already persisted | A Mason as typist |

(Not to be confused with **Frontier** in the glossary above — the set of
slices whose blockers are all done. Same word, two unrelated meanings: here a
model tier, there a position in the dependency graph.)

A tier is a property of the **work**, not of the tool: it says how much
judgement the step needs. That is why the socle can state it once and let
every tool honour it its own way — and why a step that names a tier is still
readable in five years, when today's model names are gone.

### The cascade

Which concrete model a tier means is resolved in this order, and the first
level that answers for a tier wins that tier:

1. **`.agents/user.md`** — the dev's personal file: their tool, their account,
   their model ids. It is **never committed** — the setup poses it from the
   socle template and adds it to the project's ignore rules, so each dev
   writes their own at their first session and nobody inherits anyone else's.
2. **`.agents/project.md`, §H · Model tiers** — the versioned glue's team
   default mapping for this repo, if the team has agreed on one and written
   it there. Most repos have not, and skip straight to the next level.
3. **The socle default**, which contains no model id at all: *frontier* is the
   strongest reasoning model your tool offers you, *mid* its standard everyday
   model, *cheap* its fastest and least expensive one.

**A dev with no `user.md` is never blocked.** Resolution falls through to the
team default, and then to the socle default — which every tool can satisfy.
A missing `user.md` is the normal case, not an error: no rule, skill, formula
step or command may require its presence, and none may read it as the only
source of a fact that matters to anyone else.

This is the only place the resolution rule is written. Everywhere else —
formula steps, skills — names a tier and points here.

## Where dex's phases live (and who owns each)

| dex phase | Our artifact | Produced by | Delegable? |
|---|---|---|---|
| **Product** (why/what/success) | Parent task 🧑 REVIEW CAREFULLY: Context, Scope, Acceptance Criteria | Architect + human (grilling); frontier tier | never |
| **System Architecture** (how the pieces talk) | Parent task **Architecture** section (🧑, medium/large; diagrams > prose) | Architect + human; frontier tier | never |
| **Program Design** (types, signatures, layout, call stacks) | Unsliced task: Implementation Decisions. Sliced task: each slice's **Design** section, persisted at plan time | Architect at the plan gate, human approves; frontier tier | never |
| **Vertical Slices** (implementation) | The code, cycle by cycle | Mason, cheap tier (mid when the slice is not purely mechanical) — the only delegable phase | ✅ opt-in |

Upstream note: Pocock does NOT persist per-ticket program design — his
capture points are `CONTEXT.md`/ADRs (during grilling) and the feature-level
spec (`to-spec`); the design made inside `/implement` dies with the session.
Persist-the-plan is our addition, aligned with dex's "program design is a
human-owned, reviewable artifact".

## Why the time-id prefix

`scripts/task-id.sh` generates `YYYYMMDD-HHmm`. Prefixing task files and slice
folders with it gives automatic chronological sorting in the tree while the
rest of the name carries the intention. Incremental numbers are banned: they
collide across branches and carry no meaning.

## Why the interview comes first (and is a separate skill)

Writing a task file before shared understanding produces confident nonsense.
The `grilling` skill interviews one question at a time with a recommended
answer per question — facts are looked up, decisions are put to the human. The
task file is only written once the human confirms shared understanding.

## Why a two-axis review at completion

A change can follow every standard and implement the wrong thing, or do
exactly what the task asked while breaking conventions. The `code-review`
skill runs **Standards** (documented repo standards + a fixed baseline of
Fowler smells, always judgement calls) and **Spec** (the task file's 🧑 zones
as requirements: anything missing? any scope creep?) as separate axes so one
cannot mask the other.

## Why the journal stays

The journal declared in `.agents/project.md` §A is the project's narrative
memory: agents grep it and read the recent entries to load context cheaply at
session start. It is **written by hand** — one dated entry per task, added by
the agent at the end of the work — and **never generated**: not from a
coordination database's audit trail, not from the git history, not from
anything else. Narration nobody wrote is worth nothing to the next reader.

It complements — never replaces — the task archive (structured detail), the
living docs (current state), and the domain memory maintained by the
`domain-modeling` skill: `CONTEXT.md` (the glossary, nothing else) and
`docs/adr/` (decisions that are hard to reverse, surprising without context,
AND real trade-offs — all three or no ADR; a separate artifact from the
journal). The journal records the flow; CONTEXT.md and ADRs crystallize what
must survive it.

## Artifact ladder (plans → evergreen)

Working designs and mermaid diagrams start in task/slice files (and in
whatever scratch plan surface the tool offers). At completion they must be
**promoted** into evergreen product docs
under the documentation reference declared in `.agents/project.md` (default
`doc/**`) **except** the task workspace declared there (default
`/project-management/`: tasks, the journal, temporary baselines, archive).
Prefer `doc/architecture/` for as-built seams and integration diagrams; add
`doc/domain/` when the glossary needs a home. The task workspace is narrative
and planning — not the living architecture. Protocol wording stays generic:
do not brand temporary rewrite labels as if they were part of the work
system.

## The bridge rule (default behaviour)

No task file is created for casual conversations. But every conversation runs
under the work rules (context preamble, plan-first, verify-before-done), and
when a conversation turns into real, multi-step, scoped work, the agent must
recognize it and PROPOSE a task — inform, never force. Formality is opt-in,
detection is not.
