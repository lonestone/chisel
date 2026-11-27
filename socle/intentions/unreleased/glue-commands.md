---
id: unreleased/glue-commands
classification: migration
---

# The glue points to the list of the project's commands in AGENTS.md

## Goal

The glue, `.agents/project.md`, has an "M · Other commands" section that
points to a list of the commands an agent needs beyond the gates, and the
repo's `AGENTS.md` holds that list outside chisel's markers.

## Why

Regenerating a client, creating a migration, starting the dev stack: each
sub-agent otherwise looks for these commands alone, session after session.
`AGENTS.md` is the file every agent tool reads, with or without a task.
`chisel update` never writes outside the markers of that file, which is why
this is a migration and not an update: the list is written once, with the
human, and stays the project's own.

## Applies When

- `.agents/project.md` has no "M · Other commands" heading, or
- `AGENTS.md` has no commands list outside the `chisel:begin` and
  `chisel:end` markers.

## Do Not Apply When

- The repo has no `.agents/project.md`: the baseline intention writes one.
- The repo has no commands beyond its gates: write the section with the
  pointer line, and leave the list empty only after the human says so.

## Observable Gaps

1. **The section.** Signal: no "M · Other commands" heading. Add it at the
   end of the glue, with an `Other commands` line that points to the
   `AGENTS.md` section "Commands". Done when: the section exists.
2. **The list.** Signal: `AGENTS.md` has no commands list outside the
   markers. Explore as the setup skill does (`package.json` scripts,
   `deno.json` tasks, `Makefile` or `justfile` targets, docker compose, a
   `scripts/` folder), keep what is not a gate, put the list to the human
   once, and write it after `<!-- chisel:end -->` under a `## Commands`
   heading, one line per command: `` `<command>` — <what it does> ``.
   Done when: `AGENTS.md` has the list after the block, and the human has
   confirmed it.

## Out of Scope

- The glue's other sections.
- Anything inside the markers of `AGENTS.md`.
- Turning a command into a skill of the project.

## Reference Paths

- `.agents/project.md` — **adapt**: the section of the reference.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the exploration and
  the confirmation.

## Validation

- `.agents/project.md` has a `## M · Other commands` section with an
  `Other commands` line.
- `AGENTS.md` has a commands list outside the markers.

## Record Result

`chisel record unreleased/glue-commands --applied`, or
`--skipped "<reason>"` after the human's word.
