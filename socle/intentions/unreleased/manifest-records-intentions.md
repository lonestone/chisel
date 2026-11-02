---
id: unreleased/manifest-records-intentions
classification: automatic
---

# The manifest records intentions

## Goal

The repo's manifest, `.agents/.chisel.json`, records each intention the
repo applied or skipped, with the date and, for a skip, the reason.

## Why

Until this release, `chisel update` only copied files, and the judgement
an older repo needed lived in a recipe it never read. From this release
on, every change a repo must act on ships as an intention, and `update`
asks the manifest which ones are still pending: the ones that need no
judgement it closes itself, the others it stages for an agent.

## Applies When

- `.agents/.chisel.json` has no `intentions` field.

## Do Not Apply When

- The repo has no manifest: `chisel update` stages a workspace whose first
  step creates one.

## Observable Gaps

1. **The record.** Signal: no `intentions` field in the manifest.
   `chisel update` writes it on its fast path: every intention of a
   release up to the manifest's version counts as applied, and the ones
   it closes are added.
   Done when: the manifest has an `intentions` field naming this one.

## Out of Scope

- Any file other than the manifest.

## Reference Paths

- `.agents/.chisel.json` — **adapt**: written by `chisel update`, never by
  hand.

## Validation

- `chisel check` prints no `pending:` line for this intention.

## Record Result

`chisel update` records it on its fast path. By hand:
`chisel record unreleased/manifest-records-intentions --applied`.
