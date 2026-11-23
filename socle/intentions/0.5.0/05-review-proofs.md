---
id: 0.5.0/review-proofs
classification: migration
---

# The glue names the commands that prove a screen

## Goal

The "J · Review" section of `.agents/project.md` declares the project's
e2e, recording and screenshot commands, each optional, and the folder the
proofs go in.

## Why

When a task touches a screen, the agent checks it itself, and the human
review shows the proof: at least a capture, before → after when the screen
existed. The workflow and the `visual-proof` skill read the commands in
the glue. When a command is left at none, the task has no proof of that
kind and the review says so, instead of guessing a command.

## Applies When

- `.agents/project.md` has a "J · Review" section without one of the
  lines `E2E command`, `Recording command`, `Screenshot command` or
  `Proofs folder`.

## Do Not Apply When

- The glue has no "J · Review" section. The intention that adds the
  section comes first, and this one applies after it.

## Observable Gaps

1. **The command lines.** Signal: §J lacks one of the three command
   lines. Ask the commands question of the setup skill, and write each
   answer on its line. For an answer of none, write the reference's line
   as it stands.
   Done when: §J has the three command lines.
2. **The proofs folder.** Signal: §J has no `Proofs folder` line. Write
   the reference's line, unless the human names another folder.
   Done when: the line exists.

## Out of Scope

- The `Default depth` line.
- Taking any proof.

## Reference Paths

- `.agents/project.md` — **adapt**: the section of the reference, with
  the project's answers.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the question.

## Validation

- The `## J · Review` section of `.agents/project.md` has the lines
  `E2E command`, `Recording command`, `Screenshot command` and
  `Proofs folder`.

## Record Result

`chisel record unreleased/review-proofs --applied`, or
`--skipped "<reason>"` after the human's word.
