---
id: 0.2.4/update-writes-only-what-it-installed
classification: informational
---

# Update writes only what it installed

## Goal

The human knows that `chisel update` writes the task templates and
`scripts/task-id.sh` only when the last manifest listed them and they still
exist.

## Why

Before 0.2.4, `update` wrote the two templates under `project-management/`
and `scripts/task-id.sh` at every run. A repo that had moved its templates
into its own task workspace, or deleted the script, found them back after
each update. Since 0.2.4 a file the repo removed stays removed, and the
manifest stops tracking it.

## Applies When

- The repo is updated from a version before 0.2.4.

## Do Not Apply When

- Never: it is read, and nothing changes in the repo.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it in one
   sentence: a template or task id script the repo deleted or moved is no
   longer recreated by `update`.
   Done when: the human has read it.

## Out of Scope

- Moving or deleting any file.

## Reference Paths

- None.

## Validation

- Nothing to check in the repo.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
