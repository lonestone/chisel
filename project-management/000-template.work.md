# Task Work Document Template & Standards

**Status:** 🟢 Complete
**Version:** 1 (born at the spec / work split; the coding agent's own file —
see the spec template,
[000-template.spec.md](/project-management/000-template.spec.md), and
[methodology.md](../socle/agents/methodology.md))

## Context

The work document is the coding agent's own file: its program design and
pseudo-code, its worklog, its implementation checkboxes, its Notes &
Snippets, and the findings the Inspector writes at `diff-review`. One file,
one owner — no zone marker anywhere in it, because the reading-gradient
distinction (what the human must read carefully vs skim) does not apply to
working material nobody but the agent and its reviewers read start to
finish.

**Who creates it, when, where, under what name.** The implementing session
— the Mason — creates it at its `plan` step, never earlier. It lives beside
its spec, in the spec's own directory, named by replacing the spec's
`.spec.md` suffix with `.work.md`: same time id (or slice number), same
directory, no separate id generation. A spec with no work document beside it
has never been typed.

**Lifecycle.** While work is live, the work document is deletable and
regenerable: delete it, revise the spec, and restart — nothing is lost that
the spec did not already carry. That window closes at `close`: the work
document is archived **alongside its spec**, both files moved together. This
does not follow automatically from sharing a directory — archiving is a
named step that must move both, because the diff review reads the program
design as evidence (destroyed evidence proves nothing), a retrospective may
cite the worklog, and the repo is the only memory this system has. A parent
spec of a sliced task never gets a work document of its own — only its
slices do, one each.

**The Architect validates it and never edits it.** At `plan-review`, the
Architect returns a verdict on the program design persisted here — VALIDATED
or a round of findings — and never writes into this file itself; a revision
is the Mason's own act, in response to the verdict.

**The Inspector writes into it, and does not own it.** At `diff-review`, the
Inspector reads the spec document as the requirement and this file as
evidence, then writes its findings into this file's own section below. That
this file's owner is someone else does not make the write wrong: a finding
is a report, not a decision, and the owner of this file still rules on it —
exactly as a reviewer comments on code they do not own.

## Work Document Template

All work documents MUST follow this structure:

```markdown
# <Task name> — work

Created by <implementing session> at `plan`, <date>. Spec:
`<same directory>/<same name>.spec.md`.

## Program Design

Persisted at `plan`, from the spec's approved system design. Decisions, not
descriptions: modules built/modified and their interfaces, schema changes,
API contracts, edge cases to handle. Pseudo-code belongs here when it
encodes a decision more precisely than prose can (state machine, schema,
type shape). Revised in writing whenever reality contradicts it — never
carried in the session's head alone — and re-validated where the preset
runs a `plan-review`.

## Worklog

Dated entries, one per work session: what was attempted, what landed, what
was reverted and why. A commit at every green step, not a pile-up saved for
the end.

## Implementation Checkboxes

- [ ] Step 1
- [ ] Step 2

Ticked as work lands. Not decoration: they are the resume point. A fresh
Mason picking the work back up reads this file and restarts at the first
unticked box.

## Notes & Snippets

The Mason's own working notes, code snippets, exploration findings. May be
verbose — this is agent working space, and nobody else is required to read
it start to finish.

## Diff-Review Findings

Written by the Inspector at `diff-review`, judging the diff against the
spec document's requirement and reading this file as evidence. A finding is
a report; this file's owner rules on it.
```

## When Creating a Work Document (the Mason)

1. Create it at `plan`, never before — an open question about the *what* at
   this point means the spec is unfinished; hand it back rather than guess.
2. Name it by replacing the spec's `.spec.md` suffix with `.work.md`, same
   directory.
3. Persist the program design here, step by step, in vertical slices — never
   layer by layer.
4. Tick implementation checkboxes as work lands; they are the resume point.
5. Commit at every green step. Never carry an open *how* question in your
   head — revise the design here, in writing, and re-validate it where the
   preset runs a `plan-review`.

## When Reading a Work Document (Architect, Inspector, a fresh Mason)

- The Architect reads the Program Design at `plan-review` and returns a
  verdict; it never edits this file.
- The Inspector reads the spec document as the requirement and this file as
  evidence at `diff-review`, then writes its findings into this file's own
  section.
- A fresh Mason resuming the work reads the implementation checkboxes and
  restarts at the first unticked one — never re-derives the plan from
  scratch.
