# Methodology — the why behind the workflow

This document explains the reasoning behind the task workflow so that humans
and agents apply it with judgement, not cargo-cult. The **what/where** are
the spec and work templates declared in §A · Task workspace of
`.agents/project.md` (defaults `/project-management/000-template.spec.md`
and `/project-management/000-template.work.md`); the **vocabulary, the zone
ownership rule and the model tiers** are `.agents/reference.md`; the **order
and the gates** are `.agents/formulas/`; the **ambient invariants** are
`.agents/discipline.md`; this file is the **why**.

Provenance: fusion of the Lonestone task lifecycle (creation → work →
completion, a dated journal) with patterns from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT) and dex's
"Why Software Factories Fail" series.

---

## Glossary (uniform wording)

The words this workflow uses — task, spec document, work document, slice,
seam, reading gradient, blocking edge, frontier, expand–contract, one-shot —
are defined in "Glossary" of `.agents/reference.md`, which also says why
"ticket" is reserved for an external tracker. This file uses them and never
redefines them.

---

## A default, and two options

chisel has one default behaviour: the human holds every gate. Two things vary
from there, and they vary independently — the **human gates** (who stops the
run and reads) and the **validation sub-agents** (which fresh reviewers run: a
Checker on the spec, an Architect at `plan-review`, an Inspector on the diff).
Five presets place themselves on those two axes.

The five presets, and where each sits:

| Preset | Human gates | Validation sub-agents | Who relaunches |
|---|---|---|---|
| `chisel-default` | every gate awaits the human — the spec, the Mason's program design, the review arbitration | all three | the human, at every step |
| `chisel-light` | two — the spec, and the diff review the human holds himself | none | the human, at every step |
| `chisel-supervised` | one — the Owner approves the spec, nothing else | all three | the Foreman, spawning the next step fresh |
| `chisel-auto` | none; a doubting step blocks and reports instead | all three | the Foreman, spawning the next step fresh |
| `chisel-auto-light` | none | none | the Foreman, spawning the next step fresh |

The full reading of the two axes — what each preset buys and gives up on each
— is in the header of `.agents/formulas/chisel-default.formula.toml`, and it is
written there once. The third column is not a third axis: who relaunches
follows from whether the run is driven by the human or by the Foreman, and
nothing places a preset on it independently. `chisel-auto-light` empties both
axes: it is an instrument built to be measured against the others, not a notch
on either.

**A factory is a possible destination, not a cell of this product.** Whether
it belongs inside chisel is an open question: chisel stays light enough to fit
into any repo, and a factory implies a lot of bespoke work. Until a real need
settles that question, no factory machinery is described here — no queues, no
lanes, no asynchronous gate lists. Plain auto is one chained session and needs
none of them.

**The invocation-posture principle.** Piloting — which preset governs this
run — is chosen per invocation, never baked into the project as a permanent
setting, and the choice is the human's: a non-default preset runs when a human
asks for it in that session, never because an agent decided it. Nothing in the
versioned glue grants or withholds it. Coordination (beads) is the other axis
entirely: repo state, additive, and orthogonal to which preset is running — a
beads-equipped repo stays fully usable under the default.

**The Brief-stays-human invariant.** Whichever preset is running, the
decision to start the work at all — the Brief, what to build and why — is
always the human's. No preset decides that upstream question; each only
changes what happens once the Brief exists. See [Zone
ownership](#zone-ownership) below for what each preset makes the human's, and
what it leaves to the roles.

The roster that fills these presets follows.

## The roster

| Role | Tier | Does | Contract |
|---|---|---|---|
| **Owner** | — | Holds the Brief, always; approves whatever a preset gates; arbitrates escalations | not an agent |
| **Architect** | frontier | Writes the spec, answers the `plan-review` | `.agents/profiles/architect.md` |
| **Checker** | frontier | Reviews the spec before it is planned — never its author | `.agents/profiles/checker.md` |
| **Mason** | cheap or mid | Authors its own program design, then types it | `.agents/profiles/mason.md` |
| **Inspector** | frontier | Reviews the diff on two axes — never its author | `.agents/profiles/inspector.md` |
| **Foreman** | frontier | Owns one thread of work — carries the context, **leads the interview**, spawns the other roles, collects their reports and rules on them | `.agents/profiles/foreman.md` |

The table names roles and points; the contract — what a role may never do,
when it escalates, exactly what it receives — lives in the profile.

## Zone ownership

Who owns a 🧑 zone under each preset, and why the work document has no zone
marker at all, is stated in "Zone ownership" of `.agents/reference.md`. The
rule there rests on one idea, developed below: a zone belongs to whoever
answered for it, so the reader always knows whose decision a section
carries.

## Escalation, and the blocked-task report

There is no chain of roles. A role that cannot decide reports to its
**spawner** — the owner of the thread it was spawned into. The thread owner
decides within what it owns and hands anything above that one rung up; above
the Foreman sits the human, full stop. Which rung a question goes to depends on
who spawned whom, not on a hierarchy between roles: there is none.

Whoever cannot decide **blocks the task** and leaves a written trace of the
block **in the task's own documents** — never in an artifact of its own, and
never only in the conversation. Each role writes in the document it works:
an implementation blocker goes into the active work document; a blocker met
before `plan`, while no work document exists yet, goes into the spec
document's Notes. Implementation blocker detail never lands in the spec
document.

Every such entry is **signed with its author's role plus the date and the
time** — that signature is what makes the trace traceable months later. And
whoever rules on the block — the Owner, or the Foreman in auto within what it
owns — records the ruling **in the same place, signed the same way**. A
ruling given out loud is written down like any other: oral availability
waives no record, in any mode.

How a blocked task is then discovered follows the coordination state declared
in §B1 · Where task statuses live of `.agents/project.md`. Where it is kept
in beads, the task's own bead takes beads' native blocked status; in auto
without beads, the session reports the block directly to the human when the
run stops. There is no mandatory dated ⚠️ journal line and no separate
blocking `escalation` item. Ruled by the Owner on 2026-09-02: "c'est pas dans
le journal du projet, c'est dans les documents de travail" — which retires
the report form an earlier ruling had let survive.

## The pipeline is nine steps

Nine is the FULL pipeline, and `chisel-default`, `chisel-supervised` and
`chisel-auto` run all nine. What varies is the validation sub-agents:
`chisel-light` drops `spec-review` and `plan-review`; `chisel-auto-light` drops
those two and `diff-review` as well. Nothing else leaves, and the count is not
maintained here twice — `.agents/formulas/` owns the order and the steps of
every preset.

The two reviews light drops are doctrine, not afterthought: `spec-review` is a
Checker in a fresh session, never the spec's author, two rounds max;
`plan-review` is an Architect answering VALIDATED or corrections on the program
design the implementing session posted, two rounds max, then a finding against
the spec. Where the gates sit is the formulas' business, named per preset — see
[A default, and two options](#a-default-and-two-options) above; this file does
not restate it step by step.

---

## Why a reading gradient (and not shorter files)

Models cannot be trusted to maintain codebase quality over time without human
steering, so the human must review — and review is only cheap when the human
knows **what** to read and **how carefully**. The gradient answers that
directly: the spec document is the decision surface and is read according to
its two 🧑 zones before any code; the separate work document is Mason-owned
working space and is read for implementation context and review evidence.

This reconciles detail vs brevity: we don't cut detail, we order the spec
document by review criticality. Only its top decision surface must stay short
— prefer a mockup or diagram over three paragraphs. Every decision NOT made
explicit in a 🧑 zone is a decision the human would otherwise make implicitly
during code review — the most expensive possible moment to change one's mind.

The spec document's 🧑 zones are their owner's property — see [Zone
ownership](#zone-ownership) above. An agent that discovers a conflict with one
must stop and surface it, never silently override. The work document is wholly
owned by its Mason and carries no zone marker.

## Why seams are agreed before implementation

A seam is a human-agreed system-design boundary. Agreeing seams up front means
testing effort lands on critical paths instead of every edge case, and the tests
survive refactors because they observe public behavior, not internals. It is
also the cheapest moment to catch a bad boundary — before code exists on both
sides of it.

## Why slicing is conditional (the sizing check)

The sizing check runs for EVERY task; slice documents are only created when
the answer demands them. Rationale:

- A slice is defined as "fits in a single fresh context window, demoable in
  one pass". A small task already satisfies both — slicing it would produce a
  folder with one slice that duplicates the spec document. Pure ceremony.
- What slicing adds is **decomposition**: blocking edges, the frontier, the
  order. That only has value when there are actually multiple pieces.
- Real-world distribution (dex): ~40% of work is one-shot, medium work gets a
  single spec/work pair, only large work gets the full breakdown. Rigor must adapt
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

There are two designs, and conflating them is the classic failure. The spec
and work templates separate them, and the pipeline separates them in time:

**System design** — how the pieces talk: services, contracts, schemas, data
models — is in the spec document's Architecture section, 🧑 REVIEW CAREFULLY.
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
stale guesses — file paths rot, learning is ignored. At `plan`, the Mason
creates the matching work document and **persists its draft program design**
with the real code in view; at `plan-review`, the Architect validates that
persisted design before any typing. There is no post-validation persistence
cycle. Three reasons to persist the draft:

1. **The completion review reads the pair.** `code-review`'s Spec axis treats
   the whole spec document as requirements and the work document as evidence;
   a design that lives only in chat is invisible to it.
2. **Dependent slices read the artifacts.** Slice 04 can build on decisions
   made in slice 01's work document; the committed pair is the channel between
   fresh contexts.
3. **Re-runs and crashes.** The pair must stay self-contained (context
   hygiene) — a session must be resumable from the spec and work documents.

So the lifecycle of a slice pair is: the spec document is born with intent
and its system design settled → the Mason creates the work document and
persists its draft program design at `plan`, which the Architect validates at
`plan-review` → worklog and implementation checkboxes live in the work
document → both are archived at completion.

**Corollary — the cost gradient.** Persisting the program design makes the
spec/work pair a complete brief, which unlocks a division of labor: the thread
owner runs the interview, the **Architect** does the upstream thinking that
follows it — the exploration, the spec and the system design — and answers the
`plan-review`; the **Mason** designs the how for itself at its `plan` step and
types it. Typing always goes through the Mason contract, by one of two
mandatory paths: a Mason sub-agent where the tool can spawn one, otherwise a
fresh session running `work on slice <spec-document>`. It is not a choice
offered to the user, and no agent elides it. The delegation boundary is the
**system design**: above it the *what* — architecture, scope, and the seams
the work is tested through — settled at creation time and approved at the
gate; below it the *how*, designed and typed by the session that implements.
A Mason asked to "figure out" something the *what* left open is a
specification failure, not an execution one — and it goes back to the spec.
An open *how* is not a hole: it is what the `plan` step is for.

That gradient is a **tier** gradient, not a licence to spend: the upstream
thinking and the reviews run at the frontier tier, and a slice whose system
design is settled runs at the cheap tier — mid when the slice is delicate or
the codebase unfamiliar. Which concrete model each tier means is resolved per
dev and per project — see [Model
tiers](#model-tiers-and-how-they-resolve) below.

The economics apply at the *session* level, not at the model-family level:
the sessions that type consume most of the tokens, so keeping the Architect's
context clean enough to review matters more than upgrading everything. Few
moments in a large task genuinely require frontier intelligence — the
original decomposition, the design decisions, a handful of trade-offs. Those
moments stay with the Architect and the human, and they are exactly what the
frontier tier is reserved for. Everything below the system design is the how,
and writing the how and typing it do not need the same tier.

The Mason's brief is **artifacts only, never the planning conversation**: the
spec document, its matching work document when present, and the artifacts it
explicitly references (parent 🧑 zones, `CONTEXT.md`/ADRs, prior art) + the
repo's ambient layer. Two disciplines follow (both from observed swarm
failure modes):

- **Explicit references beat shared memory.** The work document's program
  design must link what it relies on — the "compile-checked references"
  answer to split-brain; our version is: the Mason follows links, not vibes.
- **The Architect never implements** — its context stays clean for the
  `plan-review` verdict it answers on the program design; the diff is the
  Inspector's. All completion gates still run; the two-axis review is a
  decorrelated lens by construction (at the frontier tier).

It doubles as a quality measure (dex): a Mason that could not implement the
slice from the artifacts is a finding **against the spec** — the design was not
factored well enough, so fix the file, not the Mason's context.

## Model tiers (and how they resolve)

What the three tiers are for, and the order in which a tier resolves to a
concrete model, are in "Model tiers" of `.agents/reference.md`. The reason the
socle names tiers and never models: a tier is a property of the work — how
much judgement the step needs — so a step that declares one is still readable
in five years, when today's model names are gone, and every tool can honour it
its own way.

## Where dex's phases live (and who owns each)

| dex phase | Our artifact | Produced by | Delegable? |
|---|---|---|---|
| **Product** (why/what/success) | Parent task spec document 🧑 REVIEW CAREFULLY: Context, Scope, Acceptance Criteria | Architect + human (grilling); frontier tier | never |
| **System Architecture** (how the pieces talk) | Parent task spec document **Architecture** section (🧑, medium/large; diagrams > prose) | Architect + human; frontier tier | never |
| **Program Design** (types, signatures, layout, call stacks) | Matching work document, persisted at plan time | The session that implements, at its `plan` step — at that session's tier, not the frontier; an Architect validates it at `plan-review` | ✅ always — it is the implementing session's own work |
| **Vertical Slices** (implementation) | The code, cycle by cycle | Mason, cheap tier — mid when the slice is delicate, or in a codebase it does not know | ✅ always — through the Mason contract |

Upstream note: Pocock does NOT persist per-ticket program design — his
capture points are `CONTEXT.md`/ADRs (during grilling) and the feature-level
spec (`to-spec`); the design made inside `/implement` dies with the session.
Persist-the-plan is our addition, aligned with dex's "program design is a
human-owned, reviewable artifact".

## Why the time-id prefix

`scripts/task-id.sh` generates `YYYYMMDD-HHmm`. Prefixing spec documents and slice
folders with it gives automatic chronological sorting in the tree while the
rest of the name carries the intention. Incremental numbers are banned: they
collide across branches and carry no meaning.

## Why the interview comes first (and is a separate skill)

Writing a spec document before shared understanding produces confident nonsense.
The `grilling` skill interviews one question at a time with a recommended
answer per question — facts are looked up, decisions are put to the human. The
spec document is only written once the human confirms shared understanding.

## Why a two-axis review at completion

A change can follow every standard and implement the wrong thing, or do
exactly what the task asked while breaking conventions. The `code-review`
skill runs **Standards** (documented repo standards + a fixed baseline of
Fowler smells, always judgement calls) and **Spec** (the whole spec document,
including its system design, as requirements; the work document is evidence:
anything missing? any scope creep?) as separate axes so one cannot mask the
other.

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

Only program-design Mermaid diagrams and work material start in work documents
(and in whatever scratch plan surface the tool offers). System-design and
architecture diagrams remain in the spec document. At completion, working
material and program-design diagrams must be **promoted** into evergreen
product docs under the documentation reference declared in
`.agents/project.md` (default `doc/**`) **except** the task workspace declared
there (default `/project-management/`: tasks, the journal, temporary
baselines, archive). Promote system-design and architecture diagrams from the
spec document's source, and promote program-design diagrams from the work
document. Prefer `doc/architecture/` for as-built seams and integration
diagrams; add `doc/domain/` when the glossary needs a home. The task workspace
is narrative and planning — not the living architecture.

**Keep temporary rewrite labels out of the promoted pages.** A temporary
rewrite label is the name a migration gives itself while it runs — "v2", "the
new pipeline", "phase 3". It means nothing to a reader who arrives after the
migration has ended. An evergreen page says what the system does; the label
belongs to the task documents that carry the migration, and it leaves the page
with them.

## The bridge rule (default behaviour)

No task artifact is created for casual conversations. But every conversation runs
under the work rules (context preamble, plan-first, verify-before-done), and
when a conversation turns into real, multi-step, scoped work, the agent must
recognize it and PROPOSE a task — inform, never force. Formality is opt-in,
detection is not.
