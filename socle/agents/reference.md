# Reference — vocabulary, zone ownership, model tiers

The words this workflow uses, the rule that says who owns a review zone, and
the three model tiers with the order in which they resolve. Each is written
here once and pointed at from everywhere else, so a definition has one home
and no copy to drift from. The reasoning behind the workflow is
`.agents/methodology.md`; the rules that apply to every session are
`.agents/discipline.md`; the order of the steps and the gates are
`.agents/formulas/`.

## Glossary

| Term | Meaning |
|---|---|
| **Task** | The unit of work and its spec document in the task workspace declared in `.agents/project.md` (default `/project-management/tasks/`), named `<time-id>-<intention>.spec.md`; a typed task also has a matching `<time-id>-<intention>.work.md` beside it. |
| **Spec document** | The approved review surface: intent, acceptance criteria, seams, system design, decisions, testing strategy, slices, deliverables, references, pre-plan Notes and retrospective. It carries the task's sole status and has the reading gradient's two 🧑 zones; it never carries Mason working material. |
| **Work document** | The Mason-owned companion, created at `plan` beside a spec document by replacing `.spec.md` with `.work.md`. It carries program design, pseudo-code, worklog, implementation checkboxes, Notes & Snippets and Inspector findings, and has no zone marker. |
| **Slice** | A child task produced by decomposing a large task: a tracer-bullet vertical cut through every layer, demoable on its own, sized for a single fresh context window. Lives as `tasks/<time-id>-<feature>/<NN>-<slug>.spec.md`, with its work companion created only when typed. A small task IS its own single slice — no slice documents are created for it. |
| **Seam** | The public boundary where a feature is tested — agreed with the human BEFORE implementation. Tests live at seams, never against internals. Fewer is better (ideal: one). |
| **Reading gradient** | The ordering of the spec document by review criticality: 🧑 REVIEW CAREFULLY (short, decision-rich system design and intent) → 🧑 REVIEW IF RELEVANT (remaining review surface). Detail is never cut, it is ordered. The work document has no zone and is Mason-owned working space. |
| **Blocking edge** | A dependency between slices: "slice 3 is blocked by slice 1". A slice with no blockers can start immediately. |
| **Frontier** | The set of slices whose blockers are all done — what can be worked on right now. |
| **Expand–contract** | The sequencing for wide mechanical refactors (rename a column, retype a shared symbol): add the new form beside the old → migrate call sites in batches → delete the old form. The exception to vertical slicing. |
| **One-shot** | Work done without a task artifact. The work rules (context preamble, plan-first, vertical discipline) still apply; only the file bookkeeping is skipped. |

We do NOT use the word "ticket" for local work. It is reserved for items in an
external tracker (Linear, GitHub Issues), if/when one is wired up — see
§B2 · Link to an external tracker of `.agents/project.md`.

## Zone ownership

The 🧑 mark names the owner of a review zone, not simply "the human" — and
ownership follows one rule: a zone belongs to whoever **approved** it, and
where nobody approves it, to whoever **authored** it. The marks occur only in
the spec document. The work document has no zone marker: it belongs entirely
to the Mason that creates it.

- In the **default**, the human approves the spec document; the work document
  remains Mason-owned even when the human gates its program design.
- In **light**, the human approves the spec document; the Mason owns its work
  document without a `plan-review` gate.
- In **supervised**, the human approves the spec document; the Mason owns the
  work document even though the Architect validates its program design.
- In **auto**, no human approves the spec document: it belongs to the
  Architect that authored it (the Checker reviews it, it does not author it),
  while the Mason owns the work document and the Architect validates its
  program design.
- Under **`chisel-auto-light`** the spec zones are **ignored**, not reassigned
  to their author: the preset designs, plans and types in one go. Ruled by the
  Owner on 2026-08-28: "Dans le cas d'un chisel-auto-light ces zones sont à
  ignorer : ça design + plan + code d'une traite."

**The Brief is always the human's, in every mode.** A 🧑 zone is never
overridden silently, in any mode — a conflict with one is contested upward,
never edited sideways.

## Model tiers

The normative text of this socle names no model: what a step or a role declares
is a **tier**. Tool names are not covered by that rule and appear wherever they
are useful. The three tiers are the ones the role roster in
`.agents/methodology.md` ("The roster", one line per role) assigns:

| Tier | What it is for | Roles |
|---|---|---|
| **frontier** | Thinking, grilling, reviewing — where a wrong judgement is expensive and only caught much later | Foreman (owns the thread, leads the interview, rules on reports); Architect (exploration, spec and system design, the `plan-review` verdict); Checker (spec review); Inspector (the two-axis review) |
| **mid** | Ordinary tasks and dispatch — work that needs competence but not judgement | A Mason on a slice that is delicate, or in a codebase it does not know |
| **cheap** | The how of a slice whose system design is settled, when that how is mechanical | A Mason on such a slice |

(Not to be confused with **Frontier** in the glossary above — the set of
slices whose blockers are all done. Same word, two unrelated meanings: here a
model tier, there a position in the dependency graph.)

A tier is a property of the **work**, not of the tool: it says how much
judgement the step needs. That is why the socle can state it once and let
every tool honour it its own way.

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
