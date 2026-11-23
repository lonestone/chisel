---
id: 0.5.0/visual-proof
classification: informational
---

# A screen touched is proved, and the proof is shown

## Goal

The human knows how a task that touches a screen is now proved. It gets
captures, before → after, from the capture command that ships with the
`visual-proof` skill. The agent checks the screen itself, and never reads
a capture in its own thread. The spec's depth line can ask for proofs.
The close records the depth chosen and the floor, and `retro` compares
them.

## Why

A human review that shows only code never shows the screen a user will
see. And an agent that reads its own captures pays for every image again
at each call: one session read 22 of them for about ten dollars. The
capture command compares at the pixel and answers in text; when an image
must be looked at, a fresh sub-agent does it, and the human sees the images
himself. Recording the depth against the floor shows an Architect who
always asks for more than the diff needs.

## Applies When

- The repo is updated from a version with no `visual-proof` skill.

## Do Not Apply When

- Never: there is nothing to apply. The skill, its capture command, the
  workflow and the templates are managed files, and the copy that
  `chisel update` makes carries the change. The session only reads it to
  the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in a few sentences:
   - The capture command is
     `node .agents/skills/visual-proof/scripts/captures.ts`. It needs Node
     24.2 or later, and Playwright in the project's own dependencies.
     `CHISEL_PLAYWRIGHT_WS` can name a remote Playwright server.
   - A screen touched always brings captures. The spec's
     `**Review depth:**` line can ask for more after a `+`: `captures`,
     `recording`, `e2e`.
   - The proofs are files in the folder §J names, linked from the pull
     request's description.
   - The work document's `**Depth:**` line records the depth chosen
     against the floor, and `retro` reads it.

   Done when: the human has read it.

## Out of Scope

- The commands of §J, which the migration intention on the review's
  commands asks for.
- A page that shows the proofs; for now they are files.

## Reference Paths

- `.agents/skills/visual-proof/SKILL.md` — **copy**, by the update.
- `.agents/skills/visual-proof/scripts/captures.ts` — **copy**, by the
  update.
- `.agents/workflow.md` — **copy**, by the update.
- `.agents/skills/retro/SKILL.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
