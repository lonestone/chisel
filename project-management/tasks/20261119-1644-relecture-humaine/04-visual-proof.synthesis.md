# Synthesis — Visual proof (slice 04)

## What changed and why

Until now, a task that touched a screen reached your review with no image
of it: the agent might have opened a browser, or might not have, and you
read the diff of a stylesheet blind. This slice gives Chisel the second
reading of the human review. When the diff touches a screen, the agent
checks it itself and the review links captures, before and after when the
screen already existed.

Two pieces ship in the socle. The **capture command**,
`node .agents/skills/visual-proof/scripts/captures.ts`, is the Harness's
`captures.ts` copied as is, with Olympe's agreement, at vault commit
a05b1092. It writes the captures to disk at the widths asked, compares
before and after at the pixel with a `.diff.png` and a verdict per screen,
and returns a text report: overflow, console errors, off-site requests,
content below the fold. Playwright comes from the project. The
**`visual-proof` skill** carries the method of `verification-visuelle`:
mechanical first, through that report; an agent never reads a capture in
its own thread; when an image must be looked at, a fresh sub-agent gets the
paths, the report and a precise question, and says « not verified » for
what it cannot see. You look at the images yourself.

§J · Review gains the E2E, Recording and Screenshot commands, each
optional, and the proofs folder. `chisel-setup` asks for them. The spec
template's `**Review depth:**` line can now ask for proofs
(`strategic + captures`), and the diff adds a floor: a screen touched means
captures, even when the line left them out. The work document's new
`**Depth:**` line records the depth chosen and the floor at the close, and
`retro` compares them, so an agent that always asks more than the floor
shows.

## Critical decisions

- **The script lives inside the skill folder**, not in a new
  `scripts/` at the root. `update` writes everything under `.agents/`, so
  every repo already equipped receives it with no installer change. A
  root `scripts/captures.ts` would have reached fresh installs only. It is
  the first Node file in the socle; Deno never compiles it, and the tests
  run it with `node` as a subprocess.
- **A copy, not a rewrite, and the French stays.** You asked for the copy.
  It carries Olympe's three changes (no search in `~/projects/*`,
  `CHISEL_PLAYWRIGHT_WS`, no « harness captures »), an MIT header with the
  attribution, and the review's retouch that removed the private names and
  topics from its comments. Translating or refactoring it would have made a
  second program to maintain for no change in behaviour.
- **The floor is judged from the diff, not matched on paths.** The skill
  says what touching a screen means (a page, a component, a stylesheet, a
  template, a displayed string, an image, a font); the Mason judges. Path
  patterns would differ in every stack.
- **The proofs are committed files**, in a `<name>.proofs/` folder beside
  the spec, until group B's page shows them. Since PNGs weigh in git, the
  skill captures only the screens and widths the floor asks.
- **A Screenshot command left at none means no captures**, even though
  Chisel ships one. The project chooses; the review says the proof is
  missing.
- **The music-downloader dry run has not happened.** No checkout exists on
  this machine, so the slice was built from the Harness's skill, not from
  `review-videos`, which is in no history here. The no-screen dry run is
  this slice's own close: no screen touched, no capture taken. The browser
  test ran for real against a `playwright-core` on this machine. The dry
  run on a repo with screens is left open for you.

## Data schema, before → after

No data schema change. Before, §J held one line, `**Default depth:**`.
After, it also holds `**E2E command:**`, `**Recording command:**`,
`**Screenshot command:**` (each `_(none …)_` by default) and
`**Proofs folder:**`. The spec's `**Review depth:**` line accepts
`[+ captures] [+ recording] [+ e2e]`, and the work document gains a
`**Depth:**` line. The migration intention `unreleased/review-proofs`
adds the §J lines to updated repos.

## Architecture change

The socle ships its first Node script, run from the project's root with the
project's own Playwright and Node 24.2 or later. Nothing in Chisel's own
code calls it.
