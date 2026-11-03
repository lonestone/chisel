---
id: 0.2.0/one-tracker-section
classification: migration
---

# The glue has one tracker section

## Goal

The glue, `.agents/project.md`, has one "B · Tracker" section that says
where tasks live and which skill or tool reads them, and no adapter line
for `.claude/agents` or `.codex/agents`.

## Why

0.1.x split coordination into "B1 · Where task statuses live", "B2 · Link
to an external tracker" and, in some repos, "B3". 0.2.0 has one tracker
section, read by the workflow at its first step and at each status change.
A glue with the old subsections leaves the workflow without its answer,
and `chisel update` reports it as `stale:`.

## Applies When

- `.agents/project.md` has a "B1", "B2" or "B3" subsection; or
- it has an adapter line for `.claude/agents` or `.codex/agents`.

## Do Not Apply When

- The repo has no `.agents/project.md`: the baseline intention writes one.

## Observable Gaps

1. **The tracker section.** Signal: a "B1", "B2" or "B3" heading. Replace
   the subsections with one "B · Tracker" section, asking the tracker
   question of the setup skill with the old answers as the recommendation:
   statuses in the task files → the default; a committed database → beads;
   an external tracker named in "B2" → that tracker and its connector.
   Every byte outside that span stays.
   Done when: the glue has one "B · Tracker" section and no B1, B2 or B3.

2. **The retired adapter lines.** Signal: a line of the adapter inventory
   naming `.claude/agents` or `.codex/agents`. Remove it.
   Done when: no such line is left.

## Out of Scope

- The glue's other sections: their answers are the project's.
- Where the tasks live: this intention moves no task.

## Reference Paths

- `.agents/project.md` — **adapt**: compare its tracker section with the
  reference's; the project's answers win.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the tracker question.
- `.agents/skills/chisel-beads/SKILL.md` — **copy**: the beads adapter.

## Validation

- The closing `chisel update` prints no `stale:` line.

## Record Result

`chisel record 0.2.0/one-tracker-section --applied`, or
`--skipped "<reason>"` after the human's word.
