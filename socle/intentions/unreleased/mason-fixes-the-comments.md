---
id: unreleased/mason-fixes-the-comments
classification: informational
---

# The task's Mason fixes the human review's comments

## Goal

The human knows that the task's Mason fixes the comments of the human
review, and that its session is kept after the close.

## Why

Waking the same Mason costs as much as a fresh one, and it carries the
whole context of the task: the plan, the decisions, the findings. A team
that discards its Masons at the close, or starts a fresh one on the
comments, loses that context and pays to rebuild it from the documents.

## Applies When

- The repo is updated from a version whose `.agents/workflow.md` step 8,
  "Human review", has no "Who fixes the comments" paragraph.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in a few sentences: a comment of the human review that asks for a
   change goes to the task's Mason, woken in its own session however long
   ago it closed; the close no longer ends that session, and step 4
   writes the id the Mason's harness resumes it by on the `**Plan:**` line
   so the Architect can find it again; a fresh Mason starts from the
   spec, work and synthesis documents only when the session is lost. A
   team whose own steps say otherwise reconciles them itself.
   Done when: the human has read it.

## Out of Scope

- The project's own instructions outside the chisel markers of
  `AGENTS.md`: a project that says otherwise reconciles itself.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
