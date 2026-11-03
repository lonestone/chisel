---
id: 0.2.4/no-write-through-links
classification: informational
---

# Init and update never write through a symbolic link

## Goal

The human knows that `chisel init` and `chisel update` stop on a symbolic
link where they would write, and what to do when they do.

## Why

A plain file write follows a link. Before 0.2.4, a skill the project kept
elsewhere and linked into `.agents/skills/` under a name chisel ships was
overwritten in its own tree at each update. Since 0.2.4, a link on a path
chisel writes, or on a directory above one, stops both commands before
anything is written: `init` refuses and names the link, `update` stages a
session whose skill closes it with the human.

## Applies When

- The repo is updated from a version before 0.2.4.

## Do Not Apply When

- Never: it is read, and nothing changes in the repo.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it in one
   sentence: a link where chisel writes now stops `init` and `update`,
   and a skill of the project's own, under a name chisel does not ship,
   may stay linked.
   Done when: the human has read it.

## Out of Scope

- Any link in the repo: if one stands where chisel writes, the update has
  already staged for it.

## Reference Paths

- None.

## Validation

- Nothing to check in the repo.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
