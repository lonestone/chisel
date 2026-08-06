# Chisel — agent instructions

This repo builds and ships the Lonestone dev-workflow socle. It dogfoods the
methodology it ships.

- Work is tracked as task files in `project-management/tasks/` (template:
  `project-management/000-task-file-template.md`; completed →
  `project-management/archive/`; dated `project-management/CHANGELOG.md`).
- Task lifecycle: interview → seams agreed → task file (reading gradient) →
  sizing check out loud → work from the file in a fresh session
  (`work on task <file>` / `work on slice <file>`); plan approved by the human
  and PERSISTED into the file before any code; two-axis review at completion.
- New task file names: `scripts/task-id.sh <intention>`.
- The canonical socle now lives in `socle/` (imported from the music-downloader
  pilot at slice 01).
