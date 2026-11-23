---
id: unreleased/review-section
classification: migration
---

# The glue says how far the human review goes

## Goal

The glue, `.agents/project.md`, has a "J · Review" section that gives the
default depth of the human review: `full` or `strategic`.

## Why

The workflow's step 8, the human review, reads the default depth from the
glue when a spec carries no depth line of its own. A glue without the
section leaves the step without a default; writing it down lets the project
choose, and lets every agent read the choice in one place.

## Applies When

- `.agents/project.md` has no "J · Review" section.

## Do Not Apply When

- The repo has no `.agents/project.md`: the baseline intention writes one.

## Observable Gaps

1. **The section.** Signal: no "J · Review" heading. Ask the review
   question of the setup skill, and add the section with the answer, at the
   end of the glue, with a `Default depth` line. Without an answer, write
   the default: `full`.
   Done when: the section exists and its `Default depth` line is `full` or
   `strategic`.

## Out of Scope

- The glue's other sections.
- Running a review.

## Reference Paths

- `.agents/project.md` — **adapt**: the section of the reference, with
  the project's answer.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the question.

## Validation

- `.agents/project.md` has a `## J · Review` section with a
  `Default depth` line.

## Record Result

`chisel record unreleased/review-section --applied`, or
`--skipped "<reason>"` after the human's word.
