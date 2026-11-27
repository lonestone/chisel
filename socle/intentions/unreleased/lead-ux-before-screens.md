---
id: unreleased/lead-ux-before-screens
classification: automatic
---

# UX research runs before any screen is coded

## Goal

The repo has the `lead-ux` skill in `.agents/skills/lead-ux/`, and its
`.agents/workflow.md` and `.agents/discipline.md` call it: step 2 starts
from usage when a task touches what a person sees or does and names its
size, the Architect stops for the human after each round, and a brief for
an analysis states the usage first and cites the chosen direction by path.

## Why

A page coded straight from a spec, with no research, came out naive and
thin; the same page after three short rounds of research — the human's
words restated, real data, a survey, directions side by side, an eye that
was not the builder's — was accepted at once. The skill carries its own
researcher's brief, capture script and page template, so it needs nothing
beyond Deno and Playwright, and it runs one quick round on a small request
and none on a light change. A repo without it keeps coding screens from
the technique up.

## Applies When

- `.agents/skills/lead-ux/SKILL.md` is missing.

## Do Not Apply When

- Never: the copy `chisel update` makes is the whole change; the skill,
  `workflow.md` and `discipline.md` are managed files.

## Observable Gaps

1. **The skill.** Signal: `.agents/skills/lead-ux/SKILL.md` is missing.
   Compare against the reference tree. Done when: the folder is there with
   its six files.
2. **The workflow lines.** Signal: `.agents/workflow.md` does not name
   `lead-ux`. Done when: step 2, "Where the work stops" and "Sub-agents"
   carry the reference's lines.
3. **The discipline row.** Signal: the "Side lanes" table of
   `.agents/discipline.md` has no `lead-ux` row. Done when: it has it.

## Out of Scope

- The browser: Playwright's browser is installed on the machine the first
  time the skill runs, by the command the script prints.

## Reference Paths

- `.agents/skills/lead-ux/` — **copy**, by the update.
- `.agents/workflow.md` — **copy**, by the update.
- `.agents/discipline.md` — **copy**, by the update.

## Validation

- `.agents/skills/lead-ux/SKILL.md` exists.
- `.agents/workflow.md` names `lead-ux` in step 2.

## Record Result

The closing `chisel update` records it, with the other automatic
intentions.
