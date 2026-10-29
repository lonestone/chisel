# Charter

What chisel is, what it is for, and who does the work. Set by the Owner on
2026-10-29. Where any older decision, doctrine file or task in this repo
disagrees with this page, this page wins.

## What chisel is

**Chisel processes one task.** It takes a task from its plan to its commit,
and writes or sharpens the spec first when the intent is not yet clear.
Along the way it reads and updates the task where it lives, and it can open
the pull request. Merging and publishing wait for the human's explicit
word on that very action.

**Chisel works with any tracker.** A task can be an issue in Plane, a line
in beads, or a file in the repo. The agent needs one skill or tool that
reads and updates the task in that tracker. Once it has the task, it
follows chisel's method to ship it.

**Chisel does not orchestrate.** Watching a tracker to launch agents,
scheduling tasks, deciding which task runs next: that belongs to the layer
above. That layer can be a human, a harness, a long-lived orchestrator
thread, or a script.

**The workflow is prose.** One page describes the steps of a task, who does
each, and where it stops for a reading. No workflow engine and no machine
format: the first version ran in production on prose alone.

**Why.** Current frontier models are good enough that heavy guidance costs
more than it returns. The second version of chisel added sub-agents, five
presets, a Foreman role and a thirteen-status ladder. It costs more to run
than the first version, and the extra context engineering did not pay. The
field facts are at the end of this page.

## Objectives

1. **One task, from intent to commit, with the fewest roles that hold the
   quality.** No step, role or file exists only to make chisel chain work.
2. **Less load on the human.** The Architect reads the plan and settles what
   it can. Only the key questions reach the human.
3. **No sub-agent without a reason.** Each one costs tokens and a brief to
   engineer. A sub-agent is launched only for a context that must stay
   clean, for work that runs in parallel, or for a cheaper model. Anthropic
   makes the same case in "When to fold subagents into your main agent
   loop":
   https://claude.com/resources/articles/building-agents-when-to-fold-subagents-into-your-main-agent-loop
4. **Fresh eyes where they matter.** The code review runs in sub-agents that
   never saw the session that wrote the code. It is one of the few moments
   where a change of context is essential.

## The roles

| Role | Who plays it | What it does |
|---|---|---|
| **Architect** | The agent the user, or an orchestrator, talks to. This is its default role. | Scopes the task, asks the questions, clarifies the spec. Launches a Crewmate, talks with it, arbitrates, reads and corrects the plan. Brings the key questions up to the human. |
| **Crewmate** | A sub-agent launched by the Architect. | Writes the plan from the template, stops for the Architect's reading, then codes. Ends by running the `code-review` skill. |
| **Typist** | Optional. A sub-agent launched by the Crewmate. | Types code from the approved plan, decides nothing. Worth it when the Typist runs on a cheaper model than the Architect and the Crewmate. By default the Crewmate types itself. |
| **Reviewers** | Sub-agents launched by the `code-review` skill. | Read the diff with no context from the coding session. |

**The Architect's thread** can be one long thread that compacts and serves
as the entry point to a project, or one thread per piece of work. In a long
thread the Architect can run several Crewmates, one per task or slice.

**A role is a paragraph of the workflow, not a file.** The Architect writes
each brief from the workflow page. Chisel ships no role contract files and
generates no agent definitions.

**The human's part.** The human owns the intent and the decisions that
shape the task. The Architect approves the plan. A plan that departs from a
decision the human made goes back to the human, with the question stated.

## What goes away

- **The Foreman.** Spawning the next step is the Architect's job inside a
  task, and the layer above's job between tasks.
- **The formulas and their five presets.** The prose workflow replaces
  them.
- **The role profiles**, and with them the Checker and the Inspector. The
  Architect reads the spec and the plan; `code-review` reads the diff.
- **The thirteen-status ladder.** A task keeps the few statuses it needs
  for itself. Anything finer belongs to the tracker.
- **Beads as a coordination layer.** Beads stays, as one tracker among
  others.

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
