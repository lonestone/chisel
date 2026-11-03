---
id: 0.2.0/journal-is-journal-md
classification: migration
---

# The journal is called JOURNAL.md

## Goal

The project's journal is `JOURNAL.md`, in the directory it already lives
in, and the Journal line of the glue's task workspace section names it.

## Why

0.1.x let the journal be `LOG.md` or `CHANGELOG.md`. 0.2.0 names it
`JOURNAL.md`: a changelog is generated for users, a journal is written by
hand for whoever works here next, and one name lets every skill find it.
`chisel init` and `update` leave an existing `LOG.md` or `CHANGELOG.md`
alone rather than create a second journal beside it.

## Applies When

- The Journal line of the task workspace section names `LOG.md` or
  `CHANGELOG.md`; or
- the task workspace has a `LOG.md` or `CHANGELOG.md` used as the journal,
  and no `JOURNAL.md`.

## Do Not Apply When

- The `CHANGELOG.md` is a generated changelog for users, not the journal:
  leave it, and say so.
- The human has decided, after reading this intention, to keep the name.

## Observable Gaps

1. **The file.** Signal: the journal is `LOG.md` or `CHANGELOG.md`. Rename
   it with `git mv`, in the same directory, its content untouched.
   Done when: `JOURNAL.md` exists there and the old name does not.

2. **The glue.** Signal: the Journal line names the old file. Rewrite the
   line.
   Done when: the Journal line names `JOURNAL.md`.

## Out of Scope

- The journal's content.
- Links to the old name in the archive.

## Reference Paths

- `.agents/project.md` — **adapt**: the task workspace section.

## Validation

- The file the Journal line names exists, and no `LOG.md` or
  `CHANGELOG.md` beside it is still written to as the journal.

## Record Result

`chisel record 0.2.0/journal-is-journal-md --applied`, or
`--skipped "<reason>"` after the human's word.
