# Chisel — agent instructions

This repo builds and ships the Lonestone dev-workflow socle. It dogfoods the
methodology it ships.

- **Read `CHARTER.md` first.** It says what chisel is, what it is for and
  who does the work. It wins over any older decision, doctrine file or task
  in this repo.

- Anything worth remembering lives in the repo — task files, the decisions
  record (`project-management/review-360-decisions.md`), the doctrine — never
  in an assistant's private memory: future agents are not necessarily the
  same assistant (Owner ruling G17, 2026-09-02). Role reuse follows ruling
  G16: reviewers fresh, the Crewmate reused within a live thread.
- The canonical socle now lives in `socle/` (imported from the music-downloader
  pilot at slice 01).

<!-- chisel:begin -->
<!--
  chisel managed block. Everything between the `chisel:begin` and
  `chisel:end` markers is written by `chisel init` and rewritten by every
  `chisel update` — hand edits made inside are lost at the next update.
  Everything outside the markers is yours; chisel never touches it.

  To adjust the workflow for THIS project only: write your instructions
  outside the markers (they take precedence for your agents, the block
  stays as-is). To change what the block says for every equipped project:
  edit `socle/templates/AGENTS-block.md` in the chisel repo — this text is
  copied verbatim from that file.
-->

**Always** — follow `.agents/discipline.md`. It is the ambient core: it
applies to every conversation, with or without a task artifact, and its first
rule tells you what to read before acting.

**For real, scoped, multi-step work** — follow `.agents/workflow.md`. It
takes one task from its intent to its commit and pull request, in prose:
the roles, the steps, where the work stops, the tracker and the statuses.

- By default you are the **Architect**: you read the task, write or sharpen
  the spec, launch a Crewmate, read its plan, and bring the key questions to
  the human.
- Launched as a **Crewmate** or a **Typist**, follow the brief you were
  given and the matching steps of `.agents/workflow.md`.
- Merging and publishing follow the merge and publish section of
  `.agents/project.md`. By default they wait for the human's explicit word
  on that very action.

Paths (task workspace, templates, journal, tracker, gate commands) resolve
through `.agents/project.md`. The vocabulary and the model tiers are
`.agents/reference.md`; the reasoning is `.agents/methodology.md`. This block
only routes; the socle at `.agents/` carries the content.
<!-- chisel:end -->
