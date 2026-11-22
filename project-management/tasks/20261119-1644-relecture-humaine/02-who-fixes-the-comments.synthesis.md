# Synthesis — Who fixes the comments (slice 02)

## What changed and why

Slice 01 gave the human review its own step, but it left one question open:
once the human has commented, who does the work? The workflow even leaned
the wrong way. It said a Mason is reused "within a live thread" and that "a
resumed task starts fresh", and step 7 told the Mason to "stop everything"
at the close. An Architect reading it could fairly start a new Mason on the
comments, which would mean paying to rebuild a context that already
existed.

Your ruling was « toujours le maçon qui a bossé ! Toujours. », and step 8 now
says it in a paragraph of its own, **Who fixes the comments**. A comment
that asks for a change goes to the task's Mason, the one that planned, coded
and closed the task. The Architect wakes it in its own session, however
long ago it closed. Waking it costs as much as starting a fresh one, but it
already holds the whole context. A fresh Mason is used only when that
session is lost, and it starts from the archived spec, work and synthesis
documents. When a comment changes a decision of the spec, the Architect
writes the new decision into the spec first, then wakes the same Mason on
it.

The rest of the workflow now agrees with that paragraph:
- step 7 says the close does not end the Mason's session;
- the Sub-agents section keeps a Mason for its whole task;
- the roles table, the stops table and the Mason brief list the new turn.

This repo's `AGENTS.md` follows suit: it widens ruling G16 and cites your
decision by its title. An informational intention tells updated repos.

## Critical decisions

- **The Architect writes down where to find the Mason.** At step 4 it puts
  the id the Mason's harness resumes it by on the `**Plan:**` line. Without
  it, "however long ago it closed" would fail without anyone noticing: the
  id would live only in an Architect thread that compacts. The alternative
  was to write nothing and treat any session the Architect cannot find as
  lost. That costs nothing up front, but over time it quietly brings back
  the fresh Mason you ruled out.
- **A fix of a comment runs the code review again** on the fix's diff, with
  fresh reviewers. Step 6 already says "never skip, even for a small
  retouch", and a looser rule after the human review would be a second rule
  to remember.
- **The status stays `done`** while comments are fixed. As slice 01
  settled, the review is of a pull request, not a status. Sending the task
  back to `in-progress` would reopen documents that are already archived.
- **The fix follows the same discipline as a review finding.** It goes
  through a Typist unless it is a retouch of a few lines. Each comment is
  written in the work document with its fix or its answer. The synthesis is
  amended when a critical decision moves, so that the human's first reading
  stays true.
- **A lost session is defined by its effect**, meaning the Architect cannot
  resume it, not by any harness. The socle stays harness-neutral.

## Data schema, before → after

No data schema change. One task file gains a field: the work document's
`**Plan:**` line goes from "approved by <who>, <date>" to "approved by
<who>, <date>, and the id the Mason's harness resumes it by". The work
template itself is unchanged.

## Architecture change

None.
