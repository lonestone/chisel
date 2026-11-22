---
name: visual-proof
description: Prove a change to a screen without ever reading a capture in your own thread. Covers the proofs the depth line and the diff demand, the captures taken and compared by the command this skill ships, a fresh sub-agent when an image must be looked at, and the proof files the human review links. Use when a task touches a screen (a page, a component, a stylesheet, a template, a displayed string, an image), at the plan, code and close steps of `.agents/workflow.md`, or whenever you are about to take or look at a screenshot.
---

# Visual proof

A capture read in your own thread stays in its context and is read again at
every later call. One session read 22 captures, about 10 MB, and cost about
ten dollars. This skill does the mechanical work without a model, and
leaves the looking to a sub-agent and to the human.

## The project's commands

They are in §J · Review of `.agents/project.md`:

- **E2E command**: runs the end-to-end tests.
- **Recording command**: runs them and keeps a video.
- **Screenshot command**: captures pages and compares them before → after.
  The project usually names the command this skill ships,
  `node .agents/skills/visual-proof/scripts/captures.ts`.
- **Proofs folder**: where the proof files go, committed with the work.

A line left at _(none …)_ means the project has no command of that kind.
Then the task has no proof of that kind, and the review says so. Never
invent a command. The app the commands run against is started as the
Browser check line of §F · Gate commands says.

## Which proofs: the depth line and the floor

1. **Read the depth line.** The spec's `**Review depth:**` line is
   `full` or `strategic`, followed by each proof the Architect asks for
   after a `+`: `captures`, `recording`, `e2e`. For example,
   `strategic + captures`. When the spec has no such line, the depth is
   the default of §J and the only proofs are the floor's.
2. **Compute the floor from the diff.** Use the plan at the plan step and
   the real diff at the close. The diff touches a screen when it changes
   what a user sees: a page, a component, a stylesheet, a template, a
   displayed string, an image or a font. Judge from the diff, not from path
   patterns. A screen touched makes the floor `captures`. Otherwise the
   floor is none.
3. **The proofs to produce** are the line's plus the floor's. A screen
   touched gets captures even when the line left them out. Never produce
   fewer proofs than the floor. Capture only the screens the diff touches,
   at the widths they need (`--largeurs`): the captures are committed, and
   every image weighs in the repo's history.
4. **No floor and no proof asked: no capture.** Take no capture and start
   no browser. Write it in the depth record and stop here.

## When: before, during, after

- **Plan step.** The plan names the screens touched, with their paths and
  widths, and the proofs to produce.
- **Before the first code change.** Take the before captures of the
  screens that already exist, from the base:
  `<screenshot command> <base url> <path,path…> --out <proofs folder>/before`.
  A new screen has no before.
- **Once the work is typed.** Check the screen yourself: run the E2E
  command, through the Recording command when the depth asks for a
  recording. When the project has no e2e, the capture command's report is
  the least you check. This check is for you. It joins the proofs only
  when the depth line asks for `e2e` or `recording`.
- **At the close.** Take the after captures, compared with the before:
  `<screenshot command> <base url> <path,path…> --out <proofs folder>/after --avant <proofs folder>/before`.

## Mechanical first

The capture command writes the captures to disk and prints a text report,
in French. Widths default to 390 and 1280 (`--largeurs 390,1280`).
`--avant <folder>` compares each capture with the one of the same name in
that folder, at the pixel. Each screen gets one of these verdicts:

- `identique`: nothing changed;
- a share of pixels changed, with the zone and a `.diff.png` map;
- `pas de capture avant`: a new screen;
- `la taille change`: the size changed.

The report also gives:

- an overflow at each width (`DÉBORDE`);
- console errors;
- requests that leave the site;
- content hidden below the fold of a scrolling container (`SOUS LE PLI`).
  Run again with `--plein` to capture it.

Other options:

- `--sombre` captures the dark colour scheme;
- `--clic <selector>`, repeated, clicks before the capture: a menu, a tab,
  an accordion;
- `--json` prints the same facts as JSON.

Often the text is enough. `identique` where nothing should change is
verified. An overflow at 390 px is a bug: fix it before anyone looks.

The command needs these, run from the project's root:

- Node 24.2 or later. An older Node silently does nothing.
- Playwright in the project's `node_modules`: `playwright`,
  `playwright-core` or `@playwright/test`.
- A Chromium that Playwright installed.

When `CHISEL_PLAYWRIGHT_WS` is set, it names a remote Playwright server,
and the command uses that server's browser instead of a local one.

The script is TypeScript for Node, not for the project's own build. A
project whose linter or type checker reaches `.agents/` excludes the
script, `.agents/skills/visual-proof/scripts/captures.ts`.

## Looking: a sub-agent, never you

Never open a capture with your own Read tool, not even one. When the text
is not enough, launch a fresh sub-agent on the mid tier of
`.agents/reference.md`, and give it:

- the paths of the captures, the `.diff.png` maps and the text report;
- the precise question;
- the list of what it must find on each capture;
- the rule that what it cannot see is « not verified », never « absent »;
- the form of its report: for each capture, compliant or not, and where
  each defect sits; no general description;
- the order to change nothing.

Use a fresh sub-agent for each round. A sub-agent that saw the old version
sees what it expects.

## The proofs at the review

The proof files stay in the proofs folder, committed with the work. The
pull request's description links each one: for a changed screen, the
before and the after side by side, with the `.diff.png`. The human looks at
them himself. You write the paths without having looked at the images. A
kind of proof the depth asks for, which the project has no command for, is
named there as missing.

## The depth record

At the close, write the work document's `**Depth:**` line. It gives the
depth chosen, the floor the diff computed, and, when the task went above
the floor, what it added and why. The `retro` skill compares the two.
