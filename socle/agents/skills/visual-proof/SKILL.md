---
name: visual-proof
description: Prove a change to a screen with captures compared by a command, while a fresh sub-agent does any looking. Use when a task touches a screen (a page, a component, a stylesheet, a template, a displayed string, an image), at its plan, code and close steps, or when you are about to take or look at a screenshot.
---

# Visual proof

A capture read in your own thread stays in its context and is read again at
every later call: one session read 22 captures, about 10 MB, for about ten
dollars. So the proof runs **mechanical first**: a command captures and
compares, and you read its text report. A fresh sub-agent does any looking,
and the human sees the images.

## The project's commands

§J · Review of `.agents/project.md` names them:

- **E2E command**: runs the end-to-end tests.
- **Recording command**: runs them and keeps a video.
- **Screenshot command**: captures pages and compares them before → after.
  It is usually the command this skill ships,
  `node .agents/skills/visual-proof/scripts/captures.ts`.
- **Proofs folder**: where the proof files go, committed with the work.

Use only the commands §J names. A line left at _(none …)_ means the task has
no proof of that kind, and the review says so. The app runs as the Browser
check line of §F · Gate commands says.

## Which proofs: the depth line and the floor

1. **Read the depth line.** The spec's `**Review depth:**` line is `full`
   or `strategic`, then each proof the Architect asks for after a `+`:
   `captures`, `recording`, `e2e` (for example `strategic + captures`).
   With no such line, the depth is §J's default and asks for no proof.
2. **Compute the floor from the diff**: the plan at the plan step, the real
   diff at the close. The diff touches a screen when it changes what a user
   sees: a page, a component, a stylesheet, a template, a displayed string,
   an image or a font. Judge it from the diff; path patterns miss cases. A
   screen touched makes the floor `captures`; otherwise the floor is none.
3. **List the proofs**: the line's plus the floor's, so a screen touched
   gets captures even when the line left them out. Capture only the screens
   the diff touches, each with its path and only the widths it needs
   (`--largeurs`): every committed image weighs in the repo's history.
   Done when every screen touched has its widths and every proof asked has
   a line.
4. **Empty list: stop.** No floor and no proof asked means no capture and
   no browser. Write it in the depth record.

## When: before, during, after

- **Plan step.** The plan carries the list of step 3.
- **Before the first code change.** Capture, from the base, each listed
  screen that already exists:
  `<screenshot command> <base url> <path,path…> --out <proofs folder>/before`.
  A new screen has no before.
- **Once the work is typed.** Check the screen yourself: run the E2E
  command, through the Recording command when the depth asks for a
  recording. With no e2e, check at least the capture command's report. This
  check is for you; it joins the proofs only when the depth line asks for
  `e2e` or `recording`.
- **At the close.** Capture the after, compared with the before:
  `<screenshot command> <base url> <path,path…> --out <proofs folder>/after --avant <proofs folder>/before`.
  Done when every listed screen has its after capture and its verdict.

## Mechanical first

The capture command writes the captures to disk and prints a text report,
in French. Its options:

- `--largeurs` sets the widths, 390 and 1280 by default;
- `--avant <folder>` compares each capture, at the pixel, with the one of
  the same name in that folder;
- `--clic <selector>`, repeated, clicks before the capture, to open a
  menu, a tab or an accordion;
- `--sombre` captures the dark colour scheme;
- `--plein` grows the window until a scrolling container shows everything;
- `--json` prints the same facts as JSON.

With `--avant`, each screen gets a verdict:

- `identique`: nothing changed;
- a share of pixels changed, with the zone and a `.diff.png` map;
- `pas de capture avant`: a new screen;
- `la taille change`: the size changed.

The report also gives an overflow at each width (`DÉBORDE`), console
errors, requests that leave the site, and content hidden below the fold of
a scrolling container (`SOUS LE PLI`: run again with `--plein`).

Often the text settles it. `identique` where nothing should change is
verified. An overflow at 390 px is a bug: fix it before anyone looks.

The command runs from the project's root and needs:

- Node 24.2 or later. On an older Node it silently does nothing.
- Playwright in the project's `node_modules` (`playwright`,
  `playwright-core` or `@playwright/test`) and a Chromium it installed, or
  a remote Playwright server named by `CHISEL_PLAYWRIGHT_WS`.

The script is TypeScript for Node, outside the project's own build. A
project whose linter or type checker reaches `.agents/` excludes the
script, `.agents/skills/visual-proof/scripts/captures.ts`.

## Looking: a fresh sub-agent

When the text does not settle it, a fresh sub-agent on the mid tier of
`.agents/reference.md` looks, and you read its report. Hand it:

- the paths of the captures, the `.diff.png` maps and the text report;
- the precise question, and the list of what it must find on each capture;
- the rule that what it cannot see is « not verified », never « absent »;
- the report's form: for each capture, compliant or not, and where each
  defect sits; no general description;
- the order to change nothing.

Never open a capture with your own Read tool, not even one: the paths go
to a fresh sub-agent, since one capture read stays in your context for
every later call. Launch a new sub-agent for each round, since one that saw
the old version sees what it expects.

## The proofs at the review

The proof files stay in the proofs folder. The pull request's description
links each one: for a changed screen, the before and the after side by
side, with the `.diff.png`. You write the paths unseen; the human looks. A
proof the depth asks for that the project has no command for is named
there as missing.

## The depth record

At the close, write the work document's `**Depth:**` line: the depth
chosen, the floor the diff computed and, above the floor, what the task
added and why. `retro` compares the two.
