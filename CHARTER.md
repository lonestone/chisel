# Charter

What chisel is, what it is for, and who does the work. Set by the Owner on
2026-10-29. Where any older decision, doctrine file or task in this repo
disagrees with this page, this page wins.

## What chisel is

**Chisel processes one task.** It takes a task from its plan to its commit,
and writes or sharpens the spec first when the intent is not yet clear.
That is the whole scope.

**Chisel is not an agent orchestration library.** Chaining tasks,
scheduling them, running threads in parallel, talking to a tracker, opening
or merging a pull request: all of that belongs to the layer above. That
layer can be a human, a harness, a long-lived orchestrator thread, or a
script. Chisel gives it a task it can hand over and a commit it gets back.

**Why.** Current frontier models are good enough that heavy guidance costs
more than it returns. The second version of chisel added sub-agents, five
presets, a Foreman role and a thirteen-status ladder; no repo ever installed
it. The first version, lighter, runs in production. The field facts are at
the end of this page.

## Objectives

1. **One task, from intent to commit, with the fewest roles that hold the
   quality.** No step, role or file exists only to make chisel chain work.
2. **Less load on the human.** The Architect reads the plan and settles what
   it can. Only the key questions reach the human.
3. **Fresh eyes where they matter.** The code review runs in sub-agents that
   never saw the session that wrote the code. It is one of the few moments
   where a change of context is essential.
4. **Less context engineering.** A role is split off only when it pays: a
   different model, or a context that must stay clean.

## The roles

| Role | Who plays it | What it does |
|---|---|---|
| **Architect** | The agent the user, or an orchestrator, talks to. This is its default role. | Scopes the task, asks the questions, clarifies the spec. Launches a Crewmate, talks with it, arbitrates, reads and corrects the plan. Brings the key questions up to the human. |
| **Crewmate** | A sub-agent launched by the Architect. | Writes the plan from the template, stops for the Architect's reading, then codes. Ends by running the `code-review` skill. |
| **Typist** | Optional. A sub-agent launched by the Crewmate. | Types code from the approved plan, decides nothing. Worth it when the Typist runs on a cheaper model than the Architect and the Crewmate. By default the Crewmate types itself. |
| **Reviewers** | Sub-agents launched by the `code-review` skill. | Read the diff with no context from the coding session. |

**The Architect's thread** can be one long thread that compacts and serves
as the entry point to a project, or one thread per piece of work. Chisel
works the same either way.

**The human's part.** The human owns the intent and the decisions that
shape the task. The Architect approves the plan. A plan that departs from a
decision the human made goes back to the human, with the question stated.

## What goes away

**The Foreman.** Owning a thread of work and spawning the next step is the
orchestration layer's job, not chisel's.

## Field facts behind this page

An orchestrator thread named Apollon has run chisel's first version in its
harness since 2026-08-03. Over one milestone, worked by eleven Crewmates:

- Apollon wrote each brief. Each Crewmate wrote its plan in the slice and
  stopped. Apollon read and approved it, a gate the human had handed over.
  The Crewmate then coded.
- No Crewmate handed the typing to a Typist, though the brief allowed it.
  All eleven typed in their own session.
- Every `code-review` pass launched two fresh sub-agents in parallel, one
  for the repo's standards and one for the spec. They were the only
  independent eyes on the code.
- One retouch shipped without a `code-review` pass. That is the gap to
  watch: the review is the step a light process must not skip.
