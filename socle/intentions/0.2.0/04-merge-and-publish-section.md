---
id: 0.2.0/merge-and-publish-section
classification: migration
---

# The glue says who merges and who publishes

## Goal

The glue, `.agents/project.md`, has an "I · Merge and publish" section
that says whether the agent may merge a reviewed task, or publish a
release, without asking.

## Why

0.2.0 made the stop before a merge or a publish explicit: whatever the
glue does not hand to the agent waits for the human's word on that very
action. A glue without the section means that default; writing it down
lets the project choose, and lets every agent read the choice in one
place.

## Applies When

- `.agents/project.md` has no "I · Merge and publish" section.

## Do Not Apply When

- The repo has no `.agents/project.md`: the baseline intention writes one.

## Observable Gaps

1. **The section.** Signal: no "I · Merge and publish" heading. Ask the
   merge and publish question of the setup skill, and add the section with
   the answer, at the end of the glue. Without an answer, write the
   default: both ask the human.
   Done when: the section exists and names the answer for merge and for
   publish.

## Out of Scope

- The glue's other sections.
- Merging or publishing anything.

## Reference Paths

- `.agents/project.md` — **adapt**: the section of the reference, with
  the project's answer.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the question.

## Validation

- The closing `chisel update` prints no `stale:` line.

## Record Result

`chisel record 0.2.0/merge-and-publish-section --applied`, or
`--skipped "<reason>"` after the human's word.
