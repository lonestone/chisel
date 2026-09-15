# The setup questionnaire leaves AGENTS.md speaking with one voice

**Status:** done (2026-09-15)

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** one new step in the `chisel-setup` skill
(`socle/agents/skills/chisel-setup/SKILL.md`). Today `chisel init` appends
its managed block to the end of an existing `AGENTS.md` and reads nothing
above it; the questionnaire never mentions `AGENTS.md`; only the v1 → v2
migration skill cares, and only for a rule left in the retired rules
directory. A repo that had its own `AGENTS.md` before chisel — the common
case — ends up with a file that speaks with two voices: the project's
earlier text, often describing its own way of working, and chisel's block,
describing another. The new step reads what stands above the block and
sorts it with the human, line by line, in the questionnaire's own manner:
what the block now covers is proposed for deletion; what is the project's
own stays, or moves to the glue's reading list when it names a document;
what contradicts the block is named as a contradiction and the human
decides. Nothing is deleted without a yes; the managed block itself is never
edited by hand. The step also runs on its own, like the personal-file step.

**Why now** (Owner, 2026-09-15): asked whether the hand-written text of
this repo's `AGENTS.md` would be handled by the post-install questionnaire
before chisel is installed on itself, and told it was not — "OK ben ça c'est
un problème, c'est couvert par le questionnaire post-install ?" — the Owner
said "ok" to this step. The dogfooding task waiting in `tasks/` ("Chisel
equips itself with the socle it ships") has "`AGENTS.md` rewritten" among
its criteria; this step is how that criterion gets met, here and in every
consumer repo.

**Rulings that bind the text**: G3 (English), rule 11 of
`socle/agents/discipline.md` (name by meaning, cite by file and section
title, never a line number), "How to talk to the user here" of the skill
itself (everything shown to the user is a blockquote, in the user's
language, no toolkit words on screen), no ruling code, no "chantier", no
decisions-record file name in shipped text; pointers use `.agents/…`.

**Process, ruled by the Owner** (Addendum 6 of the decisions record, the
fast track): the Foreman wrote this spec; one agent plans in the work
document, then types all of it and keeps the work document; the Foreman
reviews on both axes. The Foreman moves this spec's status.

## Scope

In:

- **A new "Step 7 — One voice in `AGENTS.md`"**, placed after "Step 6 —
  When §B1 is a database" and before the closing summary, which becomes
  "Step 8 — Closing summary" (the only renumbering; check every "Step N"
  cross-reference in the file — today they point at Steps 1 to 6 and none
  at 7, so none changes). The step:
  1. Reads `AGENTS.md`. The managed block is everything between the
     `chisel:begin` and `chisel:end` markers; the step never edits inside
     them (`init` and `update` own that span). If nothing but a title, or
     nothing at all, stands outside the block, it says so in one line and
     ends.
  2. Otherwise sorts what stands outside the block into three piles,
     paragraph by paragraph or bullet by bullet: **covered** — the block, or
     a file it routes to (`.agents/discipline.md`, `.agents/project.md`,
     `.agents/reference.md`, `.agents/methodology.md`), now says it, so the
     line is proposed for deletion with the sentence that replaces it
     quoted; **the project's own** — build and run commands, domain facts,
     conventions the socle does not carry — kept where it is, or, when the
     line points at a document, proposed as an entry of §C · Reading list
     of `.agents/project.md` (written with Step 4's surgical span) so the
     pointer lives in the file made for pointers; **contradicting** — the
     line says the opposite of what the block or its files say, named as
     such, with both sentences quoted, and the human decides which stands.
  3. Puts each pile to the human in the questionnaire's manner: a
     blockquote, the user's language, one question per pile (or per line
     when a pile mixes verdicts), the recommended answer inside it,
     accept-in-one-word. The blockquotes the user sees are written in the
     skill, verbatim, as the other steps do.
  4. Writes only after a yes, only outside the markers, deleting or moving
     exactly the lines agreed and nothing else; a full-file rewrite is
     forbidden here for the same reason Step 4 forbids it.
  5. Ends with one line saying what was deleted, what moved to the reading
     list, what stayed.
  Re-run safe: on a repo whose `AGENTS.md` already speaks with one voice,
  the step reports it and changes nothing. Standalone: "reconcile my
  `AGENTS.md`" runs this step alone, as "set up my personal file" runs
  Step 5 alone — the step says so in its first lines.
- **The closing summary** (now Step 8) gains one line for this step, beside
  the line for the personal file.
- **Step 1 — Silent exploration** gains one bullet: note whether `AGENTS.md`
  carries text outside the managed block, so Step 7 knows before it starts
  whether it has anything to do (today Step 1 already lists what it scans;
  add to that list in the same form).
- **The `description`** of the skill's frontmatter, if it enumerates what
  the skill does, names this too in a few words; otherwise untouched.

Out:

- `src/` and `test/`: `init` keeps appending the block and reading nothing;
  no code moves. The golden tree and `SOCLE_FILES` are untouched (no new
  file).
- `socle/templates/AGENTS-block.md` (the block's content), the upgrade-v2
  skill, the glue template.
- Running the step on this repo: that is the dogfooding task's.
- `README.md`, `CHANGELOG.md` (the Foreman writes the entry), the two Owner
  files under `project-management/`.

## Acceptance criteria

Each is command-verifiable; record the before-value and the after-value in
the work document. "Before" is HEAD at the start of the chantier.

- [x] **step-exists** — `grep -c "^## Step 7 — " socle/agents/skills/chisel-setup/SKILL.md`
      = 1 and that heading contains `AGENTS.md`; `grep -c "^## Step 8 —
      Closing summary"` = 1; `grep -c "^## Step 7 — Closing summary"` = 0
      (today 1).
- [x] **markers-named** — the step names both markers: `grep -c
      "chisel:begin"` ≥ 1 and `grep -c "chisel:end"` ≥ 1 on the skill (today
      0 each), and a sentence says the span between them is never edited by
      this step (`grep -ci "never" ` on the step's text ≥ 1, checked by
      reading).
- [x] **three-piles** — the step's text contains "covered", "the project's
      own" and "contradict" (`grep -ci` ≥ 1 each within the step, checked by
      reading the section).
- [x] **user-facing-blockquotes** — the step contains at least two lines
      beginning with `> ` (what the user is shown), and none of them contains
      "glue", "socle", "managed block" or a section letter (`grep "^> "` on
      the step's text piped through `grep -ci "glue\|socle\|managed block\|§"`
      → 0).
- [x] **reading-list-route** — the step names `§C · Reading list` and
      Step 4's write span: `grep -c "Reading list"` on the skill ≥ 1 (today
      0 in the skill body outside §C's own walk — record the exact count),
      `grep -c "Step 4"` ≥ 2 (~~today 1~~ today 2, the heading and Step 6's pointer — the threshold was met before the edit; the requirement is the mention inside the new step, 4 after, two of them in Step 7 — amended 2026-09-15 by the foreman at review, after the agent's first finding).
- [x] **standalone-and-rerun** — the step's text says it runs alone and that
      a re-run on a one-voice file changes nothing (`grep -ci "on its own\|alone"`
      and `grep -ci "re-run"` within the step ≥ 1 each).
- [x] **step1-notes-it** — Step 1's list gains a line mentioning `AGENTS.md`
      (`grep -c "AGENTS.md"` between the "Step 1" and "Step 2" headings ≥ 1,
      today 0).
- [x] **cross-references-intact** — every "Step N" mentioned in the file
      points at a heading that exists: list them (`grep -on "Step [0-9]"`) and
      the headings (`grep -n "^## Step"`), and show in the work document that
      each N has its heading.
- [x] **no-code-in-shipped-text** — `grep -n "G[0-9]\+\b\|review-360\|chantier\|socle/"
      socle/agents/skills/chisel-setup/SKILL.md` → nothing.
- [x] **suite-green** — `deno task test` → every test passes (25 today);
      `deno task check` → clean; `git diff --check` clean;
      `test/fixtures/golden-tree.txt` unchanged (93 lines).
- [x] **nothing-else-moved** — `git diff --stat <start>..HEAD` touches only
      `socle/agents/skills/chisel-setup/SKILL.md` and this task's pair.

## Files map (indicative; judged after the fact)

Modify: `socle/agents/skills/chisel-setup/SKILL.md`.
Avoid: everything else.

## Verification

Run the criterion commands before and after; write after beside before.
`deno task test`, `deno task check`, `git diff --check` before each commit.
Then read the whole skill once as its user would, Step 0 to Step 8, and
record in the work document any sentence the new step makes false or
redundant elsewhere in the file. One commit for the skill, one for the work
document's close.

## Notes

Written by the Foreman on 2026-09-15 after a dry run of `chisel init` on a
copy of this repo showed the installed block appended under the repo's
hand-written text, with nothing in the flow to reconcile the two. Deno is at
`~/.deno/bin/deno`. Every amendment to this file: strike the original, date
the new version below it.

**Closed, 2026-09-15 · `foreman`.** Fast track per Addendum 6. One agent
planned (`453d177`), typed the skill (`8085b75`) and closed its work
document (`5c489d4`). The foreman re-ran every criterion command, read the
new step in full and checked its one factual claim against the block's
template (text outside the markers takes precedence for the project's
agents: true, the template says so): PASS on Standards, PASS on Spec. One
cosmetic fix by the foreman, a line of the introduction reflowed. One
before-value amended above, struck and dated. Suite: 25 tests, 0 failed;
`deno task check` clean; golden tree unchanged at 93 lines.
