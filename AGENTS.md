# Chisel — agent instructions

This repo builds and ships the Lonestone dev-workflow socle. It dogfoods the
methodology it ships.

- **Read `CHARTER.md` first.** It says what chisel is, what it is for and
  who does the work. It wins over any older decision, doctrine file or task
  in this repo.

- Work is tracked as task files in `project-management/tasks/` (templates:
  `project-management/000-template.spec.md` and
  `project-management/000-template.work.md`; completed →
  `project-management/archive/`; dated `project-management/CHANGELOG.md`).
- Task lifecycle, per `socle/agents/workflow.md`: the Architect writes or
  sharpens the spec document (reading gradient, seams named, sizing check
  out loud) — with an interview only when the intent is unclear — then
  launches a Crewmate. The Crewmate PERSISTS its plan into the work document
  and stops; the Architect reads and approves it before any code. The
  Crewmate codes (or hands the typing to an optional Typist on a cheaper
  model), runs the two-axis `code-review` with fresh reviewers, and closes.
  Without sub-agents, a fresh session opened with `work on task
  <spec-document>` / `work on slice <spec-document>` plays the Crewmate.
- New task file names: `scripts/task-id.sh <intention>`.
- Anything worth remembering lives in the repo — task files, the decisions
  record (`project-management/review-360-decisions.md`), the doctrine — never
  in an assistant's private memory: future agents are not necessarily the
  same assistant (Owner ruling G17, 2026-09-02). Role reuse follows ruling
  G16: reviewers fresh, the Crewmate reused within a live thread.
- The canonical socle now lives in `socle/` (imported from the music-downloader
  pilot at slice 01).
