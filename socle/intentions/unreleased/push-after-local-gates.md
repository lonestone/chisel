---
id: unreleased/push-after-local-gates
classification: informational
---

# The push waits for the local gates

## Goal

The human knows that "After the close" of `.agents/workflow.md` now says
the Architect pushes only once the gate commands of `.agents/project.md`
pass locally: CI confirms, it does not discover.

## Why

Agents pushed to let CI find what the local gates would have found,
loading the CI with runs that were bound to fail and making the wait for a
green build the slowest part of a task.

## Applies When

- The repo is updated from a version whose "After the close" in
  `.agents/workflow.md` says nothing of the gates before the push.

## Do Not Apply When

- Never: there is nothing to apply. `workflow.md` is a managed file and
  the copy `chisel update` makes carries the change; the session only
  reads it to the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in one sentence: an agent pushes only once the gate commands of
   `.agents/project.md` pass locally; CI confirms, it is not where errors
   are found. A project whose gate section is empty runs what it has and
   says so.
   Done when: the human has read it.

## Out of Scope

- The CI configuration itself.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
