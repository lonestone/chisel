---
name: chisel-beads
description: Read this before creating, claiming, closing or syncing anything in a repo whose glue (`.agents/project.md` §B1) says the task statuses live in a committed `bd` database — and before running `git push` there.
---

# The chisel-beads convention

This page applies when `.agents/project.md` §B1 says the task statuses live in a
committed database. While §B1 says they live in the task files, nothing here
applies and there is nothing to install.

It is the ONE normative discourse for this repo's use of `bd`. The tool ships
instructions of its own — a managed block in `AGENTS.md`/`CLAUDE.md`, a
`SessionStart` hook, a vendored skill — and the setup removes all of them,
deliberately, because two discourses on the same subject is how an agent ends up
obeying the wrong one. That removal is licit by the tool's own words: its
managed block states that explicit orchestrator instructions override it. This
page is those instructions.

## 1 · What owns what

**The bead owns coordination BETWEEN tasks.** Status, claim and lease, blocking
edges, priority. Those are the facts another agent needs about work it is not
doing, and they are the facts a query has to answer without opening files.

**The task file owns everything else, including progress INSIDE the task.**
Intent, acceptance criteria, seams, the persisted Design — and the
implementation checkboxes, which are the resume point when a session dies. They
never move into the database. A bead is a coordination record, not a copy of the
spec.

The line matters in one direction in particular: if you find yourself pasting
what the work IS into a bead, stop — the bead should be pointing at the file
that already says it.

## 2 · Creating a bead

One shape, always:

```sh
bd create "<the task's title>" \
  --type task --priority <0-4> \
  --spec-id "<path to the task file, from the repo root>" \
  --actor <architect|checker|inspector|mason> \
  --silent
```

- **`--spec-id` is the whole link.** It is a native field, made for exactly
  this: pointing at the specification document.
- **`design` and `acceptance_criteria` stay EMPTY**, and so does the
  description. They live in the file `--spec-id` names. Never pass `--design`,
  `--design-file` or `--acceptance` for a chisel task.
- **`--actor` is the ROLE, not a person.** The four are
  `architect`, `checker`, `inspector`, `mason` — the roster's own roles (see
  `.agents/profiles/`) — which is what makes the audit trail readable as a
  pipeline rather than as one human's day. It lands in `created_by`.
- **`external_ref` is RESERVED** for the §B2 external-tracker bridge.
  Nothing else writes it, ever — not a note to self, not a URL, not a branch.

Read it back to check the shape:

```sh
bd show <id>
```

```
○ probe-i71 · Slice 01 — thing   [● P1 · OPEN]
Owner: architect · Type: task
Created: 2026-08-26 · Updated: 2026-08-26
Spec: project-management/tasks/20260826-1512-x/01-thing.md

DESCRIPTION
  (none)
```

`(none)` under DESCRIPTION and a `Spec:` line is what a correct bead looks like.
`bd show` may also print a `Created:`/`Updated:` line and a closing tip
suggesting the beads Claude plugin or `bd setup claude` — ignore the tip, this
convention deliberately runs `bd` CLI-only.

**Validation stays off, and `bd lint` is not part of this workflow.** Two
different things, so both are said plainly:

- **Creation-time validation is off**, and that is the default:
  `bd config get validation.on-create` answers `none`. Leave it there. If
  someone turns it on, turn it back off (`bd config set validation.on-create
  none`) rather than start filling the fields.
- **`bd lint` will warn on every bead here, by design.** It checks each issue
  for an `## Acceptance Criteria` section, and this convention keeps the
  acceptance criteria in the task file on purpose — so a correct bead reports
  `⚠ Missing: ## Acceptance Criteria` and `bd lint` exits 1. There is no config
  key to scope it. **Do not run it, and do not wire it into anything**; a lint
  whose every finding is expected teaches everyone to ignore lint. The check
  that matters here is `bd show`: a `Spec:` line and `(none)` under DESCRIPTION.

## 3 · The session routine

**Fresh clone, first session:**

```sh
bd bootstrap
```

`bd init` is only for the repo that does not have a database yet. A clone of a
repo that already has one has nothing local to read from until `bootstrap`
pulls it — running `bd dolt pull` straight away has no database to pull into.

**Start of every other session:**

```sh
bd dolt pull
```

**End of session, when the session touched the database** (created, claimed or
closed something):

```sh
git ls-remote origin refs/dolt/data
bd dolt push
git ls-remote origin refs/dolt/data
```

Compare the two `ls-remote` lines. If the second differs from the first, the
push landed. If it is identical to the first, do not assume the push failed
silently — check `bd dolt status` first: an identical ref can mean nothing was
pending. But if you know this session created, claimed or closed something and
the ref did not move, that IS the silent-push failure: the coordination state
exists on this machine only. Commit any pending working set and push again
before anyone relies on what the database says.

Do not shorten this to a bare `bd dolt push`: there is an open failure mode
where the push reports success while the remote ref never advances, and a
machine can sit on days of invisible work before anyone notices. Three
commands, typeable, is what makes the verification something people actually
run.

A session that changed nothing has nothing to verify — skip the routine.

Between the two, work normally. Nothing else is synchronised: the task files are
git's business, as they always were.

## 4 · The two guards

### Never `git push --mirror`

A mirror push from an ordinary clone **deletes `refs/dolt/data` on the remote**
— that is the entire issue history, gone, and git reports success. There is no
undo but another clone that still has it.

This is a rule to hold in your head, not a hook enforcing it: the socle ships no
executable guard here (see the parent task's slice notes if you are wondering
why — the short version is that nothing in the test suite can exercise a git
hook against a live `bd` remote, and an unproven guard is worse than a written
rule everyone actually reads). Know what the danger looks like so you recognise
it before you type it:

- A repo mirrored once as a backup, then mirrored again later after teammates
  pushed issues — the second mirror wipes them. That is the likeliest shape in
  practice, not a deliberate `--mirror` to the working remote.
- `git push --mirror` computes the refs it prunes at the transport level; it
  does not need the branches to be out of sync to still delete
  `refs/dolt/data`.

**The only complete protection is on the remote** — deny ref deletions there
(`git config receive.denyDeletes true` on a self-hosted remote, or the
equivalent ref-protection setting on your host). Set that once, on the remote,
and this guard stops depending on every clone remembering the rule.

If you need a full backup of the repository, back up the remote itself; never
mirror a working clone over it.

### Verify the assignee after every claim

Claiming is not atomic while the upstream issue is open: two agents can claim
the same bead and both believe they hold it. So a claim is two commands, never
one:

```sh
bd update <id> --claim --actor <role>
bd show <id> | grep 'Assignee:'
```

The second line must come back naming the role you just claimed as:

```
Owner: architect · Assignee: mason · Type: task
```

If the assignee that comes back is not the role you claimed as,
**you do not have the work**: leave it alone, pick the next ready bead, and
report the collision one rung up. Do not re-claim, and do not start typing while
unsure — the failure this prevents is two agents shipping the same change twice.

## 5 · One machine, several agents

The database has a served mode. It is worth it in exactly one situation:
**several agents running at the same time on ONE machine**, which the embedded
single-writer lock would otherwise serialise.
It is **not** the answer to "we are several people": several people on several
machines are served by the committed database plus the routine above.
Worktrees share one database too — the served mode is what changes that.

That case is not supported by the setup yet; ask for it when a real repo needs
it.
