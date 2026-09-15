# The setup questionnaire leaves AGENTS.md speaking with one voice — work

Created by the implementing session at `plan`, 2026-09-15. Spec:
`project-management/tasks/20260915-1701-setup-reconciles-agents-md.spec.md`.

## Program Design

One file changes: `socle/agents/skills/chisel-setup/SKILL.md`. Four edits, in
this order — the frontmatter `description`, the new bullet in "Step 1 — Silent
exploration", the new section "Step 7 — One voice in `AGENTS.md`" inserted
between "Step 6 — When §B1 is a database" and the closing summary, and the
closing summary renamed to "Step 8 — Closing summary" with one line added.

### Where the new section sits, and what it borrows

The model of a step that also runs on its own is "Step 5 — The personal file
(also runnable on its own)" of the same skill: a standalone sentence in its
first lines, then numbered moves, then the blockquote the user sees. The new
step copies that shape, including the "(also runnable on its own)" suffix in
the heading.

The write span it uses for the reading list is "Step 4 — Surgical writes to
`.agents/project.md`" of the same skill: find the `## <letter> · ...` heading,
replace to the next `## `, leave every byte outside untouched. Step 4 keeps
its number, so `socle/agents/skills/upgrade-v2/SKILL.md` ("Step 5 — Complete
the glue", which cites "its Step 4 rule for writing") keeps pointing at the
right place and stays out of this diff.

### Step 7's five moves

1. **Read the file, and find the block.** The span chisel owns is everything
   between the `chisel:begin` and `chisel:end` markers; the step never edits
   inside it, because `init` writes it and `update` rewrites it. If nothing but
   a title, or nothing at all, stands outside — one blockquote, and the step
   ends.
2. **Sort what stands outside into three piles**, paragraph by paragraph and
   bullet by bullet. Every line lands in exactly one pile (the completion
   criterion: no line left unplaced).
3. **Put each pile to the user**, one message per pile, waiting for the answer
   before the next — the walk's one-question-at-a-time discipline. A pile that
   mixes verdicts is one message per line.
4. **Write only what was agreed**: after a yes, exactly the lines named,
   outside the markers only; a pointer moving to the reading list is written
   with Step 4's span on §C of `.agents/project.md`; `AGENTS.md` is never
   rewritten whole.
5. **Say what happened** in one line: deleted, moved, kept.

Then the re-run sentence: a file that already speaks with one voice yields one
pile — the project's own — and the step changes nothing.

### The three piles

| Pile | Test | Verdict |
|---|---|---|
| **Covered** | the block, or a file it routes to (`.agents/discipline.md`, `.agents/project.md`, `.agents/reference.md`, `.agents/methodology.md`), now says this — and you can quote the replacing sentence | proposed for deletion, replacement quoted |
| **The project's own** | build and run commands, domain facts, conventions the toolkit does not carry | stays where it is; when the line points at a document, proposed as an entry of §C · Reading list of `.agents/project.md` |
| **Contradicting** | the line says the opposite of what the block or its files say | named as a contradiction, both sentences quoted, the user decides |

A line is only ever "covered" when its replacement can be quoted: that is the
guard against a step that deletes the project's own text because it looked
familiar.

### The blockquotes the user sees, as they will be written

Nothing to sort (move 1):

> **Your instructions file already speaks with one voice.** Outside the part
> chisel keeps up to date there is nothing but the title, so there is nothing
> for me to sort. I changed nothing.

The covered pile (move 3):

> **Some of what your instructions file says, the toolkit now says for you.**
> Same instruction, written twice:
>
> - your file says: "…" → now said by `.agents/discipline.md`: "…"
>
> Deleting them leaves one instruction where there were two, so nobody has to
> guess which one wins. Keeping them costs nothing today, and one silent
> contradiction the day chisel's version changes.
>
> Recommended: **delete them**. One word and they go; name any you would
> rather keep and I leave it exactly where it is.

The project's own (move 3):

> **The rest is yours, and I am leaving it alone.** These say things only this
> project knows — how to build it, how to run it, facts about the work itself
> — and chisel says none of them:
>
> - "…" — stays where it is
>
> Some of them point a reader at a document. Those work better in this
> project's reading list, which every session opens at the start: the pointer
> gets read instead of being hoped for.
>
> - "…" → moved to the reading list in `.agents/project.md`
>
> Recommended: **keep them all, move the pointers**. One word and I move
> them; say so and I move nothing instead.

The contradicting pile (move 3):

> **Here your instructions file and chisel say the opposite of each other.**
> I am not choosing for you:
>
> - your file says: "…"
> - chisel says, in `.agents/discipline.md`: "…"
>
> Only one of the two can stay: two live instructions that disagree means each
> session picks one, and you never know which.
>
> 1. **Yours wins** — I leave your line untouched. Text you wrote outside the
>    part chisel keeps up to date takes precedence for your agents, which is
>    exactly how a project bends the toolkit to itself.
> 2. **Chisel's wins** — I delete your line, and the installed instruction is
>    the only one left.
>
> Recommended: **1 — yours wins**, unless that line was written for a way of
> working you have just replaced.

What happened (move 5):

> **Your instructions file now speaks with one voice.** Deleted: … Moved to
> the reading list: … Kept as yours: … The part chisel keeps up to date was
> not touched.

No blockquote above contains "glue", "socle", "managed block" or a section
letter — the rule of "How to talk to the user here" of the skill, which the
`user-facing-blockquotes` criterion checks mechanically.

### The one-line addition to Step 1 — Silent exploration

Appended to that step's scan list, in the same form as its neighbours (bold
subject, colon, what to note, what it feeds):

- **`AGENTS.md`**: does anything stand outside the `chisel:begin` /
  `chisel:end` markers besides a title? Note it either way — Step 7 needs to
  know before it starts whether it has anything to sort.

### The renumbering, and the closing summary's new line

`## Step 7 — Closing summary` becomes `## Step 8 — Closing summary`. Its
paragraph gains one line for `AGENTS.md`, beside the line for the personal
file: what was deleted, moved or kept, or that the file already spoke with one
voice.

### Every "Step N" cross-reference in the file, and its target heading

Enumerated at HEAD `fb2ca02` with `grep -on "Step [0-9]"` and
`grep -n "^## Step"`. "Heading" is a mention that is itself a heading; "ref"
is a mention in prose.

| Mention | Kind | Target heading | Changes? |
|---|---|---|---|
| Step 0 | heading | `## Step 0 — Precondition` | no |
| Step 1 | heading | `## Step 1 — Silent exploration` | no — gains a bullet |
| Step 1, in Step 2's walk ("facts from Step 1's scan") | ref | Step 1 — Silent exploration | no |
| Step 1, in Step 6 ("what `bd --version` printed in Step 1") | ref | Step 1 — Silent exploration | no |
| Step 2 | heading | `## Step 2 — Walk sections A through H, one at a time` | no |
| Step 2, in Step 4 ("what you present … in Step 2") | ref | Step 2 — Walk sections A through H | no |
| Step 3 | heading | `## Step 3 — §E is read-back only, never asked` | no |
| Step 3, in Step 2 ("Skip §E entirely here — see Step 3") | ref | Step 3 — §E is read-back only | no |
| Step 4 | heading | `## Step 4 — Surgical writes to \`.agents/project.md\`` | no |
| Step 4, in Step 6 ("Use Step 4's sub-section write span") | ref | Step 4 — Surgical writes | no |
| Step 5 | heading | `## Step 5 — The personal file (also runnable on its own)` | no |
| Step 5, in Step 1 ("`.agents/user.md`: … Step 5 reports it") | ref | Step 5 — The personal file | no |
| Step 6 | heading | `## Step 6 — When §B1 is a database` | no |
| Step 6, in §B1 ("run **Step 6** before moving on to §B2") | ref | Step 6 — When §B1 is a database | no |
| Step 7 | heading | `## Step 7 — Closing summary` | **yes — renamed Step 8** |

Fifteen mentions today, Steps 0 to 7, every one resolved; none points at a
Step 7 other than the closing summary's own heading, so the renumbering breaks
no reference. The edit adds three mentions: the new `## Step 7 — ` heading, a
citation of Step 4's write span inside it, and a forward reference to Step 7 in
Step 1's new bullet.

### Out, deliberately

No file under `src/`, `test/` or `socle/templates/` is touched: the step reads
`AGENTS.md` at run time and needs no new installed file, so `SOCLE_FILES` and
`test/fixtures/golden-tree.txt` (93 lines) stay as they are. `README.md`, the
journal and the upgrade skill stay out per the spec's Scope "Out".

## Worklog

**2026-09-15 — plan.** Read the spec in full, the skill in full, the block
template, §C · Reading list of the glue template, the writing rules of
`socle/agents/discipline.md` (rule 11), the skill-writing reference and the
day's decisions. Ran every criterion command at HEAD `fb2ca02` and recorded
the before-values below. Plan written above and committed alone, before any
edit to the skill.

**2026-09-15 — typing, one commit on the skill (`8085b75`).** The four planned
edits landed as planned, plus one the end-to-end reread demanded: the skill's
own opening sentence, which enumerated what the skill does and stopped at the
personal file. `deno task test` 25 passed, `deno task check` exit 0,
`git diff --check` silent. Every criterion re-run; after-values below.

The five blockquotes shipped as planned above with three wording changes made
while typing, none of them changing what the user is asked: "one silent
disagreement" replaced "one silent contradiction" in the covered screen, so
the word "contradiction" names only the third pile; move 2's sentence became a
completion criterion out loud ("the sort is done when every line sits in
exactly one pile and none is left over"); and the closing summary's sentence
was recast as a semicolon list. The skill as committed is the authority, the
plan above the record of what was decided before typing.

## Implementation Checkboxes

- [x] Frontmatter `description` names the reconciliation in a few words
- [x] Step 1 — Silent exploration gains the `AGENTS.md` bullet
- [x] Step 7 — One voice in `AGENTS.md` written: five moves, three piles, five blockquotes
- [x] Closing summary renumbered to Step 8 and given its `AGENTS.md` line
- [x] Cross-references checked against the headings that exist
- [x] Criterion commands re-run, after-values beside before-values
- [x] End-to-end reread, Step 0 to Step 8, as a user would read it

## Criteria — before and after

`S` is `socle/agents/skills/chisel-setup/SKILL.md`. "Within the step" means
the text from the `## Step 7 — ` heading to the `## Step 8 — ` heading, which
did not exist before; every such before-value is therefore 0 by absence.
"Before" is HEAD `fb2ca02`, "after" is `8085b75`. Every "Met" cell was read
off the command's own output, not predicted.

| Criterion | Command | Before | After | Met |
|---|---|---|---|---|
| step-exists | `grep -c "^## Step 7 — " S` | 1 (the closing summary) | 1 (One voice in `AGENTS.md`) | yes |
| step-exists | `grep -c "^## Step 8 — Closing summary" S` | 0 | 1 | yes |
| step-exists | `grep -c "^## Step 7 — Closing summary" S` | 1 | 0 | yes |
| markers-named | `grep -c "chisel:begin" S` | 0 | 2 | yes (≥ 1) |
| markers-named | `grep -c "chisel:end" S` | 0 | 2 | yes (≥ 1) |
| markers-named | `grep -ci "never"` within the step | 0 (no step) | 3 | yes (≥ 1) |
| three-piles | `grep -ci "covered"` within the step | 0 (no step) | 3 | yes |
| three-piles | `grep -ci "the project's own"` within the step | 0 (no step) | 3 | yes |
| three-piles | `grep -ci "contradict"` within the step | 0 (no step) | 3 | yes |
| user-facing-blockquotes | `grep -c "^> "` within the step | 0 (no step) | 37 | yes (≥ 2) |
| user-facing-blockquotes | those 37 lines through `grep -ci "glue\|socle\|managed block\|§"` | — | 0 | yes |
| reading-list-route | `grep -c "Reading list" S` | 0 | 1 | yes (≥ 1) |
| reading-list-route | `grep -c "Step 4" S` | 2 — see findings | 4 | yes (≥ 2) |
| standalone-and-rerun | `grep -ci "on its own\|alone"` within the step | 0 (no step) | 3 | yes |
| standalone-and-rerun | `grep -ci "re-run"` within the step | 0 (no step) | 1 | yes |
| step1-notes-it | `grep -c "AGENTS.md"` between the Step 1 and Step 2 headings | 0 | 1 | yes |
| no-code-in-shipped-text | `grep -n "G[0-9]\+\b\|review-360\|chantier\|socle/" S` | nothing (exit 1) | nothing (exit 1) | yes |
| cross-references-intact | `grep -on "Step [0-9]" S` vs `grep -n "^## Step" S` | 15 mentions, Steps 0–7, all resolved | 19 mentions, Steps 0–8, all resolved | yes |
| suite-green | `deno task test` | 25 passed, 0 failed | 25 passed, 0 failed | yes |
| suite-green | `deno task check` | exit 0 | exit 0 | yes |
| suite-green | `git diff --check` | clean | clean | yes |
| suite-green | `wc -l < test/fixtures/golden-tree.txt` | 93 | 93 | yes |
| nothing-else-moved | `git diff --stat fb2ca02..HEAD` | — | the skill plus this task's work document, nothing else | yes |

### Cross-references, after the edit

`grep -n "^## Step"` gives nine headings, one per N from 0 to 8.
`grep -on "Step [0-9]"` gives nineteen mentions, and nothing above 8 — so
every mention resolves to a heading that exists:

| N | Mentions | Heading it resolves to |
|---|---|---|
| Step 0 | 1 — the heading | `## Step 0 — Precondition` |
| Step 1 | 3 — the heading, Step 2's walk, Step 6's version check | `## Step 1 — Silent exploration` |
| Step 2 | 2 — the heading, Step 4's re-run paragraph | `## Step 2 — Walk sections A through H, one at a time` |
| Step 3 | 2 — the heading, Step 2's "skip §E" | `## Step 3 — §E is read-back only, never asked` |
| Step 4 | 4 — the heading, Step 6's §B1 write, Step 7's §C write, Step 7's no-whole-rewrite sentence | ``## Step 4 — Surgical writes to `.agents/project.md` `` |
| Step 5 | 2 — the heading, Step 1's `.agents/user.md` bullet | `## Step 5 — The personal file (also runnable on its own)` |
| Step 6 | 2 — the heading, §B1's "run Step 6 before §B2" | `## Step 6 — When §B1 is a database` |
| Step 7 | 2 — the heading, Step 1's new `AGENTS.md` bullet | ``## Step 7 — One voice in `AGENTS.md` (also runnable on its own)`` |
| Step 8 | 1 — the heading | `## Step 8 — Closing summary` |

Nothing pointed at Step 7 before the edit other than the closing summary's own
heading, so the renumbering broke no reference. Outside this file, the one
place that cites a step of this skill by number is "Step 5 — Complete the
glue" of the v1-to-v2 upgrade skill, which cites "its Step 4 rule for
writing": Step 4 keeps its number, so that reference stays true and the
upgrade skill stays out of the diff, as the spec's Scope "Out" requires.

## Notes & Snippets

### The end-to-end reread, Step 0 to Step 8

Read the whole skill once as its user would, hunting for a sentence the new
step makes false or redundant.

- **The skill's opening sentence** said the skill turns the glue's defaults
  into this repo's glue "and pose the current dev's personal file" — an
  enumeration the new step made incomplete. **Fixed**: it now names leaving
  `AGENTS.md` speaking with one voice as the third thing. The frontmatter
  `description` got the same treatment, being the one line a human reads
  before invoking the skill.
- **"How to talk to the user here"** bans "glue", "socle", "managed block",
  section letters and field names on screen. The new step's five blockquotes
  obey it: they call chisel's span "the part chisel keeps up to date" — one
  name for one thing, in every blockquote that needs it — and no blockquote
  line carries a section letter. **Justified, unchanged.**
- **"Step 0 — Precondition"** says "this skill configures the glue, it never
  installs the socle. Do not attempt to bootstrap `.agents/` yourself." Both
  claims stay true: the new step edits a file at the repo root and installs
  nothing. The sentence's job is to fence off bootstrapping, not to enumerate
  the skill's outputs — the opening sentence does that, and it was fixed.
  **Justified, unchanged.**
- **"Step 1 — Silent exploration"**'s list ended at `.agents/user.md`; the new
  bullet sits after it in the same form. Its closing "Fact vs decision"
  paragraph still governs the addition: whether text stands outside the
  markers is a fact to state, which pile a line belongs to is the decision the
  user makes. **Unchanged, and now covers one more bullet.**
- **"Step 2 — Walk sections A through H"** says "Never present two sections in
  the same message". Still true; the new step is not a section of the glue,
  and it obeys the same one-question-at-a-time discipline in its own sentence.
  **Unchanged.**
- **"Step 4 — Surgical writes to `.agents/project.md`"** ends on "Never
  rewrite the whole file." That sentence is scoped to `.agents/project.md`, so
  the new step states the same prohibition for `AGENTS.md` in its own words
  rather than stretching Step 4's over a second file — and cites Step 4 for
  the §C write instead of restating the span rule, which is where the
  duplication would have been. **Neither false nor redundant.**
- **"Step 5 — The personal file (also runnable on its own)"** is now one of
  two standalone steps. Both still read correctly because each names its own
  trigger phrase — "set up my personal file", "reconcile my `AGENTS.md`" — so
  a user typing one gets one step. **Unchanged.**
- **"Step 6 — When §B1 is a database"** removes "the instructions the tool
  installs on its own (managed blocks, session hook, vendored skill)". Those
  are the coordination tool's managed blocks, not chisel's, and read back to
  back the two could be confused. The new text therefore says whose markers it
  means in the sentence that names them ("Chisel's own span"), and Step 1's
  new bullet says "chisel's own `chisel:begin` / `chisel:end` markers".
  **Disambiguated in the new text; Step 6 unchanged.**
- **"Step 8 — Closing summary"** listed sections A–H, the personal file and
  the database leftover. It now carries the `AGENTS.md` line too; without it
  the summary would have claimed to be one screen of everything written while
  omitting a file the run had just edited. Its sentence was also recast from
  three consecutive dashed clauses into a semicolon list, since the fourth
  item made it unreadable. **Fixed.**

No other sentence in the file became false, and none had to be deleted.

### What the step deliberately does not do

It never reads, edits or judges anything between the markers, and it never
runs `init` or `update`. It needs no new installed file — it reads `AGENTS.md`
at run time — so `SOCLE_FILES` and the golden tree stayed out of the diff, as
the spec's Scope "Out" requires.

## Findings

- **`reading-list-route`'s parenthetical "today 1" for `grep -c "Step 4"` is
  2.** At `fb2ca02` the skill already had two: the heading of "Step 4 —
  Surgical writes to `.agents/project.md`" and the citation in Step 6's §B1
  write ("Use Step 4's sub-section write span"). The threshold ≥ 2 was
  therefore already met before any edit, which makes that half of the
  criterion unable to fail. The step does name Step 4's write span as the
  spec's Scope "In" requires — the count is 4 after the edit, two of the four
  inside the new step — so the intent is satisfied; what is wrong is the
  before-value in the parenthetical, not the requirement. Recorded, not
  amended: the spec is the Foreman's.
- **`markers-named` is satisfied at two sites, on purpose.** The marker pair
  is named in Step 1's new bullet, so the scan knows what to look for, and in
  the new step's move 1, where the span is defined and fenced. A reader
  arriving at move 4 ("only outside the markers") has the definition three
  paragraphs up in the same step, so the repetition buys the scan its
  instruction without making move 4 depend on Step 1.
- **The contradiction screen recommends the project's line, not chisel's.**
  That is not a coin toss dressed as a default: the block's own preamble
  states that text outside the markers takes precedence for the project's
  agents, so keeping the project's line is the arrangement the toolkit was
  built for. The one exception is spelled out inside the same blockquote — a
  line written for a way of working the project has just replaced.
- **"Covered" is gated on quoting the replacement.** The pile's test is not
  "this sounds like something chisel says" but "here is the sentence that
  replaces it". Without that gate the step's one destructive power — proposing
  a deletion — would fire on resemblance, and the lines most at risk are
  exactly the project's own conventions that read like methodology.
- **No numeric limit appears anywhere in the new text.** Lines are sorted one
  by one with no cap on a pile's size, and the blockquotes say "some of them",
  never a count.
- **The step needs no branch for a repo without `AGENTS.md`.** Step 0 refuses
  to run without `.agents/.chisel.json`, and a repo carrying that file has an
  `AGENTS.md`, because `init` wrote the block into one. The step therefore
  carries no such branch, and its "nothing to sort" case is about a file that
  has only a title.

## Diff-Review Findings

**Review, 2026-09-15 · `foreman`**, on both axes, fast track: no Inspector.
Every criterion command re-run; all met. Step 7 read in full: five moves,
each ending on a checkable state; the covered pile gated on quoting the
replacement, which is the right guard on the step's one destructive power;
the contradiction screen recommends the project's line, and the block's
template confirms the claim it rests on. The thirty-seven blockquote lines
carry no toolkit word. Cross-references: nine headings, nineteen mentions,
all resolving.

**Fix — one line reflowed** in the introduction, left at 128 characters by
the edit; cosmetic, by the foreman.

**Rulings on the findings.** The `Step 4` before-value: true, amended in the
spec. The opening sentence and the description extended to the third thing
the skill does: right, the spec allowed it. Step 8's sentence recast as a
list: right. No branch for a repo without `AGENTS.md`: right, Step 0 makes
it unreachable.

Verdict: PASS on Standards, PASS on Spec.
