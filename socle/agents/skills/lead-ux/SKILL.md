---
name: lead-ux
description: Lead a UX research in short rounds before any code, when a task touches what a person sees or does — a new screen, a new flow, a redesign, a small request on a screen. Not for a light change — a colour, a label, a value. Use at step 2 of `.agents/workflow.md` ("Write or sharpen the spec"), or when the user asks what a screen should look like or wants UX directions.
---

# lead-ux — usage before technique

The Architect runs it at step 2 of `.agents/workflow.md` ("Write or sharpen
the spec"), before the spec leaves `draft`. It leaves its deliverables beside the spec, and those files
are the memory: a round restarts from them, never from the session.

When `.agents/project.md` declares a screenshot command, it replaces the
capture script; when it declares how to show a page to the human, that
replaces giving the path. What the declared command does not capture or
report — a local page, a direction on its own, the keyboard — the skill's
script still does.

## Size first

The Architect names the size in one line to the human, who can overrule it.

- **A light change** — a colour, a label, a spacing, an icon, one value.
  No `lead-ux`: the spec gets its journey in one line.
- **A small request** — one part of an existing screen laid out or used
  differently. This is a **quick round**:
  - one line, "I understand: …", heads the page, and the round goes on
    without a yes;
  - no survey, no researcher, no round 0;
  - the Architect builds two or three proposals itself, on the real screen
    and its data, beside "As it is", one of them preferred;
  - it runs the capture script and reads its report; the eye runs only
    when the report flags something;
  - then step 5.

  When the answer shows that the request is bigger, the next round is a
  full one.
- **A new screen, a new flow, a redesign** — the full rounds, steps 1 to 6.

**In one shot** (`.agents/workflow.md`, "The one shot"), the skill runs when
the task needs it and stops for no one. The restatement goes into the
spec's Context without waiting. Round 0 is skipped, and *To keep* is filled
from the audit, marked as the agent's reading. The preferred direction of
the first round counts as chosen and is cited as step 6 says. The page
stays for the human to read afterwards.

## The deliverables

They live in a folder beside the spec: `<Tasks>/<task-id>/ux/`, where
`<Tasks>` is the task workspace of `.agents/project.md` and `<task-id>` is
the spec's file name without `.spec.md`.

```
<Tasks>/<task-id>/ux/
  survey.md                    the survey
  survey-captures/             the screen as it is, at scale 2
  round-0/directions.html      the state of the place, for an existing screen
  round-<n>/directions.html    the directions page of round n
  round-<n>/feedback.md        the verbatim feedback of round n
  round-<n>/captures/          what the page shows
  round-<n>/eye/               the eye's set
  scripts/                     the generators and the capture runs
  data/                        the real data
  data/private/                the personal records
```

| Deliverable | What it holds |
|---|---|
| **The survey** — `survey.md` | what the real data says, the screen as it is, *Asked for or placed*, *To keep*, what other products do; written before any direction is drawn, completed between rounds |
| **The directions page** — `round-<n>/directions.html` | two to six directions side by side on the same real data, each with its idea and what it sacrifices, a field under each and one for the whole page, a copy button |
| **The verbatim feedback** — `round-<n>/feedback.md` | the human's words as said, the agent's reading beside each, then what the next round changes |

The formats of the survey and the feedback are in
[SURVEY.md](./SURVEY.md).

In git:

- in: the survey, each feedback, each directions page, the generators, the
  anonymised data, `survey-captures/` and `round-<n>/captures/`;
- out: `data/private/`, a record that names a person or holds a client's
  data, and `round-<n>/eye/`. Each of those two folders holds a
  `.gitignore` with `*`. Steps 2 and 4 write those two files and touch no
  other ignore file.

## Who does what

- **The Architect** runs steps 1, 4, 5 and 6 at its own tier.
- **A researcher sub-agent** runs steps 2 and 3, at the Architect's tier,
  from [BRIEF.md](./BRIEF.md). It keeps the research out of the Architect's
  context. When its context grows, the drawing runs in a fresh session that
  reads the files.
- **The eye** is a fresh sub-agent at *mid* (`.agents/reference.md`, "Model
  tiers"), launched from [EYE.md](./EYE.md).
- The Architect sends fixes back to the researcher that built the
  directions, while it lives. When it is gone, a fresh one starts from the
  files and the next-round brief.

## Taste

Taste comes from the project: read what it keeps, such as its design
notes, and every earlier `feedback.md`, before drawing.

## The steps

### 1. Restate and frame — Architect

Five lines to the human: "I understand: … It is not: …". With them:

- the **scope**: which screens — these, the flow, the whole section;
- the **kinds of question** the human will answer: a quick choice, a
  visual comparison, free text;
- when it matters, the **usage**: the keyboard, the phone, touch, the
  mouse. Only a screen whose usage says so is built and checked for the
  keyboard.

A quote attributed to the human is checked at its source before it is
written. No research before the yes.

For an existing screen, **round 0** follows the yes. The Architect captures
the screen as it is (`.agents/skills/lead-ux/scripts/capture.ts`, scale 2,
into `ux/survey-captures/`) and fills the template's round-0 form into
`round-0/directions.html`. That page has one column, "As it is":

- the captures;
- its content block by block, as a table;
- the usage problems, ranked blocking, major, minor;
- the question *what must not move*.

The page goes to the human as step 5 says, and the answer goes verbatim
into `round-0/feedback.md`, per [SURVEY.md](./SURVEY.md).

*Done when:*

- the human said yes to a restatement that names the scope, the kinds of
  question and, when it matters, the usage;
- the spec's Context quotes the human's words as said, with a "What it is
  not" line;
- for an existing screen, `round-0/feedback.md` is committed with the *To
  keep* answer;
- no direction exists yet.

### 2. Real data and the survey — researcher

The Architect launches the researcher with the first-round brief of
[BRIEF.md](./BRIEF.md). The researcher:

- gathers the real records the screen will show, from a demo or an
  anonymised copy, never written to production;
- writes `ux/data/private/.gitignore` with `*` before any record goes
  there;
- finds prior art the way `.agents/skills/research/SKILL.md` says;
- writes `survey.md` from [SURVEY.md](./SURVEY.md), *To keep* carried over
  from round 0.

*Done when:*

- `ux/data/` holds the real records, the personal ones under
  `ux/data/private/`;
- `survey.md` has every section that applies — the data table, the screen
  as it is, *Asked for or placed*, *To keep*, the prior-art table — and is
  committed before any direction file exists.

### 3. Directions — researcher

- Two to six directions that differ on named axes — the grouping, the
  density, how the supporting content shows, how one acts — never in colour
  alone.
- Each is named in two or three words, never a letter. Under each go its
  idea, what it sacrifices, and "answers: …", the human's request it
  answers and the gesture that follows it, or the mark "proposal" when no
  request names it.
- *Asked for or placed* is re-read for each direction before it removes,
  lightens or moves anything.
- For an existing screen, "As it is" is the first column.
- One direction is **preferred**, with its reason in one line.
- The page says what it shows and what it does not show yet.
- The directions are built by generators in `ux/scripts/`, on the real
  data, and one command rebuilds every page.
- When the screen lives in a running app, the directions are built on the
  real route with the UI branch of the `prototype` skill
  (`.agents/skills/prototype/UI.md`).
- The page starts from
  `.agents/skills/lead-ux/templates/directions.html`.
- The directions are keyboard-driven only when step 1's usage says so.

*Done when:*

- one command, written at the top of `ux/scripts/`, rebuilds every
  direction and `round-<n>/directions.html`;
- every direction shows the real data and has its name, its idea, what it
  sacrifices, and its "answers:" line or its "proposal" mark;
- exactly one direction is marked preferred, with its reason;
- the page has a field under each direction, one for the whole page, and
  the copy button.

### 4. The eye — Architect

- The free check comes first: run the capture script with `--for-eye` and
  `--each "[data-direction]"`, adding `--keyboard` when the usage says so,
  into `round-<n>/eye/`, after writing its `.gitignore` with `*`, and read `report.md`, which is text.
- Then one fresh eye at *mid* for every direction at once, briefed from
  [EYE.md](./EYE.md). In a quick round, the eye runs only when the report
  flags something.
- The rule of `.agents/skills/visual-proof/SKILL.md`, "Looking: a fresh
  sub-agent", holds: the agent that builds never opens a capture.
- Fixes go to the researcher. Then only the fixed directions are captured
  again (`--only`), and a fresh eye looks at those alone, once per round.

*Done when:*

- the last `report.md` shows no overflow, no console error and, with
  `--keyboard`, no control the Tab key misses — or each one is written on
  the page, in what it does not show yet;
- the last eye marked every checklist item on every capture as clean, a
  defect with its position, or unverified;
- every defect is fixed or written on the page as unverified.

### 5. Show, then write the feedback — Architect

- Capture the page at scale 2 into `round-<n>/captures/` (the capture
  script, without `--for-eye`).
- Give the human the **absolute path** of `round-<n>/directions.html`, and
  open it when the session can: a browser tool of the host, or the
  system's `open` on the human's own machine.
- Name the preferred direction and its reason.
- Put the blocking questions first, each with its link into the page.
- Say what the eye left unverified.
- The round stops there ("Where the work stops", `.agents/workflow.md`),
  except in one shot.
- The human's answer — the markdown the page's button copied, or their own
  words — goes into `round-<n>/feedback.md` per
  [SURVEY.md](./SURVEY.md): verbatim, the agent's reading beside each word,
  then what the next round changes.
- Ask the human to correct the reading.

*Done when:* `feedback.md` is committed and holds:

- every word of the answer, unedited, with a reading beside each;
- the list of changes for the next round.

### 6. Next round or done — Architect

- A new round starts from the files — the survey, every `feedback.md`, the
  generators — with the next-round brief of [BRIEF.md](./BRIEF.md).
- It completes the survey first when the feedback taught something about
  the data or the usage.
- It may merge what the human kept from several directions into two or
  three combinations.
- It says in one line, on the page, whatever the human did not understand
  last time.
- After the third round without a chosen direction, the Architect asks the
  human whether to go on, then again at each round after.
- A choice that contradicts a decision already written in the spec is
  asked, not chosen.

*Done when:* either a next round has started at step 3 from the files, or
a direction is chosen — by the human, or, in one shot, the preferred one —
and the spec carries it:

- in Context, the choice and its reasons in the human's words;
- in Architecture, the chosen direction cited by path: the
  `round-<n>/directions.html` path, the direction's name, its captures in
  `round-<n>/captures/`. A brief for the code cites its chosen direction by
  path;
- the workflow resumes at step 2's seams.
