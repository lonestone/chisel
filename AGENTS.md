# Chisel — agent instructions

This repo builds and ships the Lonestone dev-workflow socle. It dogfoods the
methodology it ships.

- Work is tracked as task files in `project-management/tasks/` (templates:
  `project-management/000-template.spec.md` and
  `project-management/000-template.work.md`; completed →
  `project-management/archive/`; dated `project-management/CHANGELOG.md`).
- Task lifecycle: interview → seams agreed → spec document (reading gradient)
  → sizing check out loud → work from the spec/work pair in a fresh session
  (`work on task <spec-document>` / `work on slice <spec-document>`); plan
  approved by the human and PERSISTED into the work document before any code;
  two-axis review at completion.
- New task file names: `scripts/task-id.sh <intention>`.
- Anything worth remembering lives in the repo — task files, the decisions
  record (`project-management/review-360-decisions.md`), the doctrine — never
  in an assistant's private memory: future agents are not necessarily the
  same assistant (Owner ruling G17, 2026-09-02). Role reuse follows ruling
  G16: reviewers fresh, the Mason reused within a live thread.
- The canonical socle now lives in `socle/` (imported from the music-downloader
  pilot at slice 01).
