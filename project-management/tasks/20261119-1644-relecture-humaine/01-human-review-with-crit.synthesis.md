# Synthesis — Human review with crit (slice 01)

## What changed and why

Until now the workflow ended when the Architect opened the pull request.
After that, the human's reading was left to chance: no order, no stopping
point, and the diff was always read whole. This slice adds that reading as
a step of its own, **step 8, Human review**, run by the Architect after the
close and before any merge.

The step puts three readings in order, from the most critical down. First
comes a **synthesis**: one page, written by the Mason at the close, saying
what changed and why for the decisions that matter. If it does not give the
human confidence, the human stops there with comments and the review goes
no further. Next come the **proofs**. Their place is reserved here and the
proofs slice fills it. Last comes the **reading guide**: the crit story
written on the pull request's diff. Its first chapter is the synthesis
itself, so even inside crit the human starts at the top. How far down the
human goes is set by a **review depth**, `full` or `strategic`. Each project
declares a default in a new §J of its glue, and a spec can set its own.

Two lessons from the Harness are now rules of the step. The diff's base is
read from the pull request, because stacked pull requests do not target
`main`. A wait that times out is resumed on the same review rather than
reported as a blocker.

## Critical decisions

- **The synthesis template lives in `.agents/`, not beside the spec and
  work templates.** `update` writes a file outside `.agents/` only if the
  previous install already listed it. A new template under
  `project-management/` would therefore reach fresh installs only, never
  repos already equipped. This template is a trial and will change, so it
  has to travel with every update. The cost: it sits apart from the other
  two templates.
- **The synthesis is a file in the task folder, committed in the pull
  request.** It sits beside the spec as `<name>.synthesis.md`. Because it is
  part of the diff, the crit story can open on it without any change to
  crit. The alternative, a separate page outside the repo, would have left
  no trace and needed a second tool.
- **The Mason writes it, on the frontier tier.** The Mason holds the whole
  task in context at the close. Pierrick's "not Sonnet" rules out the mid
  tier as well as the light one.
- **The base is always read and passed explicitly**
  (`gh pr view --json baseRefName`, then `--base-branch`), rather than
  trusting crit's pull-request mode to find it. This also covers a branch
  with no pull request on a forge.
- **The spec template's depth line reads `full | strategic`.** The writer
  keeps one value, or deletes the line to take the project's default. The
  review caught that a pre-filled `full` would silently override a project
  set to `strategic`.
- **When crit is missing, the step stops for the human.** It says where to
  get crit (https://crit.md) rather than falling back to a review without
  it.

## Data schema, before → after

No data schema change. Two project files change shape:

- **The glue:** sections A–I → A–J. A new `## J · Review` section holds one
  item, `- **Default depth:** full | strategic`. The migration intention
  `unreleased/review-section` adds it to repos already equipped. The setup
  skill now asks about it.
- **The spec header:** `**Status:**` → `**Status:**` followed by
  `**Review depth:** full | strategic`, which the writer may delete.

## Architecture change

None. The installer copies one more file (`.agents/synthesis.md.tpl`), the
same way it copies `user.md.tpl`.
