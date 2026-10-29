# Note: review the docs, not only the code (from music-downloader)

**From:** music-downloader, crit review of the regression-guard task (2026-10-12).
**Status:** idea to triage. Owner's leaning (2026-10-12): option 2, a dedicated Docs sub-agent.

## What happened

The two-axis review, run by the `code-review` skill, passed the task without
flagging the docs. Then the human found in crit what it had missed:

- **The same explanation in two or three places.** It appeared in the
  README, `integrations-beets.md` and `testing.md`, with the same wording.
  Every change would have to be made in each copy.
- **Walls of text.** Long paragraphs that chain several facts, with no line
  break when the topic changes.
- **Useless lines.** An intro that says nothing, a heading that reads oddly
  ("What is real"), and long "Claude-style" code comments.

music-downloader now has these rules in its `AGENTS.md` (section "Writing"):

- One fact, one place. The README gives a short version and links to the
  detail.
- Short paragraphs, with a new line when the topic changes. A list rather
  than a chained sentence.
- Comments say *why*, in one or two lines. No comment that repeats the code.

## The gap in chisel

The Standards axis reviews **code** against the repo's coding standards and
the Fowler baseline. Prose in the diff gets no review against writing rules:
docs, READMEs, comments, task documents.

`discipline.md` rule 11 covers naming and citations. It says nothing about
duplication across documents or paragraph form.

## Options

1. **Fold it into the Standards axis.** Add a "prose baseline"
   next to the smell baseline: duplicated explanation across files, walls of
   text, comments that restate the code, empty intros. It has the same status
   as the smell baseline: the repo overrides, and each finding is a
   judgement call. This needs no new sub-agent.
2. **A third axis, "Docs" (Owner's leaning).** It would read only the prose hunks. Its context
   stays clean, but it costs one more sub-agent, and it breaks the
   "two axes" story.
3. **A Checker duty at completion.** It would sit beside the docs update
   that `task-completion` already asks for. But that happens too late to
   shape the writing.

The writing rules themselves would sit next to `discipline.md` rule 11, as
the BEHAVIOUR side of the 360 review's G1 ruling ("Les règles de
rédaction"). The review baseline would be its CONTROL side.
