---
id: 0.4.0/crewmate-becomes-mason
classification: migration
---

# The Crewmate becomes the Mason

## Goal

The project's own files call the sub-agent the Architect launches to plan,
have a Typist code, review and close a task the **Mason**, as the managed
files of chisel now do.

## Why

In the harness that runs chisel's own projects, "crewmate" names the
per-task session that plays chisel's Architect. Chisel used the same word for the
sub-agent that Architect launches, and one word for two roles made a plan
reading get skipped. The Owner renamed the role: Architect, Mason, Typist.
A repo whose own files still say "Crewmate" while `.agents/workflow.md`
says "Mason" hands its agents a role the workflow no longer defines.

## Applies When

- `git grep -il crewmate` lists a file outside the managed files and
  outside the project's history: its archive, its journal, its changelog.

## Do Not Apply When

- None beyond the human's decision.

## Observable Gaps

1. **The glue.** Signal: `.agents/project.md` names the Crewmate. Rename
   it in the prose; the project's answers stay as they are.
   Done when: `git grep -i crewmate -- .agents/project.md` finds nothing.
2. **Open task documents.** Signal: an open spec or work document, in the
   tasks directory the task workspace section of the glue names, names the
   Crewmate. Rename the role.
   Done when: no open task document names the Crewmate.
3. **The project's own instructions and skills.** Signal: `AGENTS.md`
   outside the chisel markers, `CLAUDE.md`, or a skill chisel does not ship
   names the Crewmate. These are the project's own files, beyond what
   `chisel-update` touches on its own: this intention names them on
   purpose, so show the human each occurrence and rename it on their word. A "crewmate" that names
   something else, such as a harness's own session, stays.
   Done when: every occurrence is renamed, or kept on the human's word.

## Out of Scope

- The journal and the changelog: history keeps its words.
- Past tracker events that carry the `crewmate` actor; new ones carry
  `mason`.
- The intention ids recorded in `.agents/.chisel.json`.

## Reference Paths

- `.agents/workflow.md` — **copy**, by the update.
- `.agents/skills/chisel-beads/SKILL.md` — **copy**, by the update.

## Validation

- `git grep -il crewmate` lists only the managed files the closing update
  will replace, the manifest `.agents/.chisel.json`, the project's
  history, and the files where the human kept an occurrence.
- `git diff --stat` on the archive is empty.

## Record Result

`chisel record unreleased/crewmate-becomes-mason --applied`, or
`--skipped "<reason>"` after the human's word.
