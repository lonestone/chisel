# Workflow — one task, from intent to commit

This page is the whole workflow, in prose. It says the steps of a task, who
does each, where the work stops for a reading, and where the tracker is
read and updated. The rules that apply to every session are
`.agents/discipline.md`; the reasons behind this page are
`.agents/methodology.md`; the words it uses are defined in
`.agents/reference.md`.

**Chisel processes one task.** It takes a task from its intent to its
commit, and to its pull request when one is wanted. It writes or sharpens
the spec first when the intent is not yet clear. It does not orchestrate:
watching a tracker, scheduling tasks, deciding which task runs next belong
to the layer above — a human, a harness, a long-lived orchestrator thread,
or a script.

## The roles

| Role | Who plays it | What it does |
|---|---|---|
| **Architect** | The agent a human, or an orchestrator, talks to. This is its default role. | Reads the task, writes or sharpens the spec, launches a Mason and talks with it, reads and corrects the plan, rules on what the Mason reports, brings the key questions to the human. |
| **Mason** | A sub-agent launched by the Architect. | Writes the plan in the work document and stops for the Architect's reading. Then launches a Typist to code it, runs `code-review`, and closes the task. Woken again after the close, it fixes the human review's comments. |
| **Typist** | A sub-agent launched by the Mason once the plan is approved. | Types code from the approved plan and decides nothing, at a cheaper tier than the Mason's (`.agents/reference.md`, "Model tiers"). |
| **Reviewers** | Sub-agents launched by the `code-review` skill. | Read the diff with no context from the session that wrote it. |

**The human** owns the intent and the decisions that shape the task. The
Architect approves the plan. A plan that departs from a decision the human
made goes back to the human, with the question stated, except in one shot
("The one shot", below).

The Architect's thread can be one long thread that compacts and serves as
the entry point to a project, or one thread per piece of work. In a long
thread the Architect can run several Masons, one per task or slice.

## The steps

**1. Read the task — Architect.** Read it where it lives, through the
skill or tool the tracker section of `.agents/project.md` names: an issue
in a tracker, a line in beads, a spec document in the task workspace, or
simply the message in the prompt.

**2. Write or sharpen the spec — Architect.** When the task arrives clear — a
well-written issue, a clear request — write the spec document from it, with no
interview: from the spec template declared in `.agents/project.md`, named with
the task id script, short, linking the issue rather than copying it. When the
intent is unclear, interview the human first with the `grilling` skill, one
question at a time, a recommended answer with each, with `domain-modeling`
underneath: new domain terms land in the glossary and hard-to-reverse decisions
in an ADR, where the glossary and decisions section of `.agents/project.md` puts
them. When the interview tangles — each answer opens more questions than it
settles — switch to the `wayfinder` skill: a map of decision tickets, resolved
one at a time, whose destination is the spec. Either way the seams are named,
and the sizing check is said out loud: the task fits one pass, or it is cut into
slices with the `slice-task` skill. The spec carries a `**Review depth:**` line
when the task departs from the default of §J · Review of `.agents/project.md`.
The line gives `full` or `strategic`, then each proof the Architect asks for
after a `+` (`captures`, `recording`, `e2e`), as in `strategic + captures`. The
spec also carries a `**One shot:**` line when the Architect takes the one shot
("The one shot", below). The human approves the spec when it carries decisions
the task did not state, unless the task runs in one shot. In every other case
the Architect moves it to `ready` itself. Commit the spec. Status: `draft`, then
`ready`.

**3. Plan — Mason.** The Architect launches a Mason with the brief below. The
Mason reads the spec document and what it links to, creates the work document
beside it from the work template, and persists its program design there: files,
seam signatures, test order, the decisions the spec left to the implementation,
and, when the task touches a screen, the screens and the proofs the
`visual-proof` skill asks for. Then it stops and reports. No code before the
plan is approved. Status: `in-progress`, written by the Architect at launch.

**4. Read the plan — Architect.** Read the spec and the work document,
nothing else. Correct the plan with the Mason, then approve it: the
approval is written on the work document's `**Plan:**` line, with who and
when, and the id the Mason's harness resumes it by. A plan that departs
from a decision the human made goes to the human first, except in one
shot.

**5. Code — a Typist the Mason launches.** Once the plan is approved, the Mason
launches a Typist with the brief below. The Mason types itself only a retouch of
a few lines, or while the plan is not settled, and writes which exception
applies and why in the work document's worklog. The Typist executes the approved
plan in vertical steps, test-first at the agreed seams (the `tdd` skill). When
the task touches a screen, the before captures are taken before the first code
change, and the screen is checked once it is typed, as the `visual-proof` skill
says. Tick the work document's checkboxes as work lands — they are the resume
point — and commit at each green step. Run the gate commands declared in
`.agents/project.md`. Reality that contradicts the plan is fixed in the plan, in
writing; reality that contradicts the spec is reported.

**6. Review — Mason.** Run the `code-review` skill on the full diff of
the task. Its reviewers are fresh sub-agents that never saw the session
that wrote the code — never skip this step, even for a small retouch. Write
the findings in the work document; fix each one or answer it there.

**7. Close — Mason.** Tick the spec's acceptance criteria against reality. When
the task touches a screen, take the after captures into the proofs folder of §J
· Review. Write the work document's `**Depth:**` line: the depth chosen, the
floor the diff computed with the `visual-proof` skill, and why the task went
above the floor when it did. Promote evergreen material into the living docs
declared in `.agents/project.md`, the glossary and the ADRs among them, as the
rule "Docs present and point" of `.agents/discipline.md` says: what and why,
not a text version of the code. Write
the synthesis from `.agents/synthesis.md.tpl`, beside the spec and named by
replacing `.spec.md` with `.synthesis.md`: it is the first reading of the human
review (step 8), so write it on the frontier tier. Archive the spec, work and
synthesis documents together. Add the dated journal entry. Run the `retro` skill
and put its proposals in the report. Stop everything you started — Docker
containers, dev servers, background processes — each by its own identifier
(container name or id, PID), and only those: never by pattern (`pkill -f`,
`--all`), which stops the work of others. This does not end the Mason itself:
its session is kept, so that the Architect can wake it at step 8, Human review,
to fix the comments. Commit, update the tracker, and report to the Architect:
what landed, which criteria are met, what is left. Status: `done`.

**After the close — Architect.** Read the close report and rule on anything
left. Open the pull request; in one shot, its description opens with the
spec's `**One shot:**` line, copied as is. Run the human review (step 8) on
it, unless that line skips the final review. Once the review is done or
skipped, merge and publish as the merge and publish section of
`.agents/project.md` says; by default, ask the human, whose explicit word
on that very action is the only go. In one shot with the final review, the
Architect says in so many words, as it hands the review, that approving it
is the word for the merge; the approval is then that word.

**8. Human review — Architect.** The pull request is open and the
synthesis is committed in it. The human reads in three readings, in this
order, and may stop after the first.

- **Strategic: the synthesis.** One article page at most, never one
  sentence, written at step 7: what changed and why, the critical
  decisions, the data schema before and after, any large architecture
  change. The human may stop there with comments, and the review goes no
  further.
- **Proofs: what the depth and the floor demand.** The captures,
  recordings and e2e results the spec's depth line asks for, plus the
  captures the floor adds when the diff touches a screen. They are read
  after the synthesis and before the guide. They are files in the proofs
  folder of §J · Review, committed with the work. The pull request's
  description links each one, with a before → after pair for each changed
  screen. The human looks at them himself. A kind of proof the project has
  no command for is named there as missing.
- **Reading guide: the crit story.** The Architect writes it with
  `crit story --guide` and the project's guide, on the PR diff. Its first
  chapter holds only the synthesis file's hunk, and its prologue says to
  read that first and that the review may stop there. The code chapters
  come last.

How far the human goes is the spec's `**Review depth:**` line, or §J ·
Review of `.agents/project.md` when the spec has none. `strategic` is the
synthesis plus the proofs; `full` goes down to the reading guide. The diff
stays a floor: `strategic` never skips the proofs, and a screen touched
brings captures whatever the line says.

The base is read from the pull request, never assumed to be `main`:
`gh pr view <n> --json number,baseRefName`. The story is prepared and
ingested with `--pr <n> --base-branch <base>`, and the wait is
`crit --pr <n> --base-branch <base>`, run in the background. Without a
forge pull request, review the branch diff with `--base-branch <base>`,
where the base is the branch the work was cut from.

The Architect waits for the human and answers every comment. No question
goes into crit: questions go to the human, in conversation. An expired
wait is not a blocker: re-run the same crit command, or `crit --session
<id>`, and wait again. Only another failure is a blocker. If `crit` is not
installed, say where to get it (https://crit.md, then `crit install
<agent>`) and stop for the human.

**Who fixes the comments.** A comment that asks for a change goes to the
task's Mason, the one that planned, coded and closed it. The Architect
wakes it in its own session, however long ago it closed: waking it costs
as much as a fresh one, but it holds the whole context. A fresh Mason only
when that session is lost; it starts from the spec, work and synthesis
documents, where step 7 archived them. A comment that changes a decision
of the spec: the Architect writes the new decision into the spec first,
then wakes the same Mason on it. The Mason fixes as it fixes a review
finding: through a Typist unless the fix is a retouch of a few lines, the
gate commands, `code-review` on the fix's diff, each comment written in
the work document with its fix or its answer, the synthesis amended when a
critical decision moved. It commits on the pull request's branch and
reports to the Architect, who answers the comment in crit and waits again.
The status stays `done`: the review is of a pull request, not a status.

The review ends when the human approves, or when every comment is answered
and addressed. Merging then follows "After the close", above.

## The one shot

A task can run in **one shot**: the human's only possible stop is the final
review, and the spec says whether it happens. The Architect takes the one
shot at step 2 when it judges the task small, or when the human asks for
it. A human who asks for the full lane always gets it. There is no project
switch: the lane is chosen task by task.

The Architect writes the choice in one line of the spec, directly under its
`**Status:**` line, or under `**Review depth:**` when the spec has one:

    **One shot:** <why>; final review kept

`<why>` is the reason: the task is small, or the human asked for it. The
line ends in `final review skipped` when there is no final review. The
pull request repeats it.

What the one shot skips: the human's reading of the spec, which the
Architect approves itself even when it carries decisions the task did not
state, and every stop that only serves a human reading after it; "Where the
work stops" says which. What it keeps: the plan and the Architect's reading
of it, the Typist, the code review and its fresh reviewers, the gate
commands, the close and its synthesis, and the pull request. When the line
keeps the final review, it runs as step 8 says, at the spec's depth. A plan
that departs from the human's decisions is the Architect's to rule on: it
writes the ruling on the `**Plan:**` line, and the synthesis names it among
the critical decisions.

## Where the work stops

| Who stops | For whom | When | In one shot |
|---|---|---|---|
| Mason | Architect | After the plan; after the close, with its report; after fixing the human review's comments; on a blocker it cannot rule on | Kept; no comments to fix when the final review is skipped |
| Typist | Mason | After its part of the plan; on anything the plan does not answer | Kept |
| Architect | Human | On an unclear intent | Kept: the intent is settled before the lane is chosen |
| Architect | Human | On a spec that carries decisions the task did not state | Removed: the Architect approves the spec |
| Architect | Human | On a plan that departs from the human's decisions | Removed: the Architect rules, and the synthesis says so |
| Architect | Human | On a blocker above what it owns | Kept |
| Architect | Human | At the human review, waiting for the human's reading of the pull request | Only when the spec's `**One shot:**` line keeps the final review |
| Architect | Human | Before a merge or a publish, unless the project lets the agent do it | With the final review, its approval is the word for the merge; without it, kept |

Everything else runs without a stop. A question that is not one of these is
the Architect's to settle.

## The tracker

The tracker section of `.agents/project.md` says where tasks live and which
skill or tool reads and updates them. Whatever the tracker, the spec and
work documents live in the task workspace, and the tracker item points at
the spec document. The tracker is read at step 1 and updated at each status
change, by the thread doing the step.

## Statuses

A task has one status. The thread doing a step writes the status it leaves.

| Status | Meaning | Left by |
|---|---|---|
| `draft` | The spec is being written, or waits for the human's approval | step 2 |
| `ready` | The spec is approved and nothing holds the task | step 2 |
| `in-progress` | A Mason is planning, coding, reviewing or closing it | step 3 |
| `done` | Criteria ticked, documents archived | step 7 |
| `blocked` | Held by a named dependency, written after the value | whoever meets the block |
| `deferred` | Postponed on purpose | the human |
| `cancelled` | No longer wanted | the human |

Plan approval is not a status: it is the work document's `**Plan:**` line.
In a task file the value is written alone on the `**Status:**` line, free
text after it if it helps. A tracker maps the seven onto its own states, in
the skill that reads it.

## Sub-agents

Launch one only for a context that must stay clean, for work that runs in
parallel, or for a cheaper model. Each one costs tokens and a brief to
write. Three earn it:

- **The Mason** keeps the Architect's context clean for reading the plan
  and ruling on reports.
- **The Typist** types the approved plan on a cheaper tier than the
  Mason's.
- **The reviewers** bring fresh eyes to the diff.

A brief is artifacts and paths, never the conversation: whatever the
sub-agent needs must already be in the repo. Reviewers are always fresh. A
Mason is kept for its whole task: the one that wrote the plan launches its
Typist, runs the review, closes, and fixes the human review's comments.
"Who fixes the comments", in step 8, says when a fresh one replaces it.

A sub-agent does not inherit the repo's or the runtime's rules, only its
brief, so every brief below also carries these:

- a command that may run over 2 minutes (tests, CI, a build) starts in the
  background (a tool such as `run_in_background` or a monitor, whatever
  the runtime offers), never behind a `sleep` or a wait in the foreground;
- a git command that can erase work (`checkout`, `reset`, `restore`,
  `clean`, `rm`, `rebase`, a forced push) runs alone in its own call, from
  the repo's folder, never chained or behind a `cd`;
- stop what it started itself (test runners, servers, containers) before
  handing back, and never what another session started;
- reuse existing code rather than copy it;
- a request or spec that sets a threshold, an option or a check says what it
  means and which way it acts.

## The Mason brief

What the Architect writes when it launches a Mason:

- the spec document's path, and the work template's;
- the branch to work on, and how to commit (explicit paths, no push; the
  commit rule, read where §L · Commits of `.agents/project.md` points);
- the gate commands;
- the steps it owns: plan, then stop for the reading; code, through a
  Typist; `code-review`; close; then, when woken, the human review's
  comments;
- the model tiers, resolved to concrete models (`.agents/reference.md`,
  "Model tiers"): the Mason's own, which the Architect **names explicitly
  when it launches the Mason**, and the Typist's, for the Mason to name
  at launch: a sub-agent launched without a model inherits its
  launcher's;
- what it reports at each stop: the plan in a few lines and its questions;
  at the close, the commits, the criteria met or not, and what is left;
  after the comments, the commits and how each comment was fixed or
  answered;
- two reports, so the first must not be lost: the plan report is written
  in the work document before it is sent.

## The Typist brief

What the Mason writes when it launches a Typist:

- the approved work document's path, and the part of the plan to type;
- its tier: *cheap* when the plan is mechanical, *mid* otherwise
  (`.agents/reference.md`, "Model tiers", which also resolves the model).
  The launcher **names that model explicitly when it launches the
  Typist**: a sub-agent launched without one inherits its launcher's, and
  the tier is lost;
- the branch, the gate commands, the commit rule, read where §L · Commits
  of `.agents/project.md` points;
- type the plan and decide nothing: anything the plan does not answer is
  reported, not guessed;
- tick a box only for what really ran, on the real target; a dry run, or
  a run on a copy or a test base, is written in the worklog and leaves
  its box open.

## Blockers and questions

A role that cannot decide reports to whoever launched it. Blocked twice on
the same thing, or pushed outside the approved plan: stop and report. The
block leaves a written trace in the task's own documents — the work
document once it exists, the spec document's Notes before — signed with the
role, the date and the time. The ruling is recorded in the same place,
signed the same way. A ruling given out loud is written down too.

A report is answered, always: rule on it now, defer it on purpose ("noted,
later"), or hand it one rung up. A refactor met while coding is reported
with its size, its risk, and whether the task can be delivered cleanly
without it; the work goes on while the report travels.

When the Architect brings a question to the human:

- **One report, at the end of the turn.** No narration between steps.
- **Fact, problem, options.** Say what is true, what is wrong with it, and
  the ways out, one per line, with a recommendation. One hard question per
  report when the answer changes what happens next.
- **Each report stands on its own.** Never point back at "question 1" or
  "the point above"; restate an open question in place.
- **Never repeat what is settled**, and never ask again for an approval
  already given.
