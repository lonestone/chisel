---
id: unreleased/captures-comment-names-no-private-setup
classification: automatic
---

# The captures script names no private setup

## Goal

The header comment of `.agents/skills/visual-proof/scripts/captures.ts`
credits no private tool and no agent: it says the script was copied from
an earlier internal tool, under chisel's licence.

## Why

The socle ships to other teams, and a comment naming a private setup
tells a reader nothing they can use. The copy `chisel update` makes
carries the reworded comment; the script itself does not change.

## Applies When

- The repo's copy of `captures.ts` still has the former header comment.

## Do Not Apply When

- The repo has no `.agents/skills/visual-proof/scripts/captures.ts`.

## Observable Gaps

1. **The header comment.** Signal: the copy's first lines name the former
   origin. `chisel update` overwrites the file when the repo has not
   edited it.
   Done when: the copy's header comment names no private setup.

## Out of Scope

- The behaviour of the script, which is unchanged.

## Reference Paths

- `.agents/skills/visual-proof/scripts/captures.ts` — **copy**, by the
  update.

## Validation

- `chisel check` prints no `pending:` line for this intention.

## Record Result

`chisel update` records it on its fast path. By hand:
`chisel record unreleased/captures-comment-names-no-private-setup --applied`.
