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

## Implementation Checkboxes

- [ ] Frontmatter `description` names the reconciliation in a few words
- [ ] Step 1 — Silent exploration gains the `AGENTS.md` bullet
- [ ] Step 7 — One voice in `AGENTS.md` written: five moves, three piles, five blockquotes
- [ ] Closing summary renumbered to Step 8 and given its `AGENTS.md` line
- [ ] Cross-references checked against the headings that exist
- [ ] Criterion commands re-run, after-values beside before-values
- [ ] End-to-end reread, Step 0 to Step 8, as a user would read it

## Criteria — before-values, at HEAD `fb2ca02`

`S` is `socle/agents/skills/chisel-setup/SKILL.md`. "Within the step" means
the text from the `## Step 7 — ` heading to the `## Step 8 — ` heading, which
does not exist yet; every such before-value is therefore 0 by absence.

| Criterion | Command | Before |
|---|---|---|
| step-exists | `grep -c "^## Step 7 — " S` | 1 (the closing summary) |
| step-exists | `grep -c "^## Step 8 — Closing summary" S` | 0 |
| step-exists | `grep -c "^## Step 7 — Closing summary" S` | 1 |
| markers-named | `grep -c "chisel:begin" S` | 0 |
| markers-named | `grep -c "chisel:end" S` | 0 |
| markers-named | `grep -ci "never"` within the step | 0 (no step) |
| three-piles | `grep -ci "covered"` within the step | 0 (no step) |
| three-piles | `grep -ci "the project's own"` within the step | 0 (no step) |
| three-piles | `grep -ci "contradict"` within the step | 0 (no step) |
| user-facing-blockquotes | `grep -c "^> "` within the step | 0 (no step) |
| reading-list-route | `grep -c "Reading list" S` | 0 |
| reading-list-route | `grep -c "Step 4" S` | 2 — see findings |
| standalone-and-rerun | `grep -ci "on its own\|alone"` within the step | 0 (no step) |
| standalone-and-rerun | `grep -ci "re-run"` within the step | 0 (no step) |
| step1-notes-it | `grep -c "AGENTS.md"` between the Step 1 and Step 2 headings | 0 |
| no-code-in-shipped-text | `grep -n "G[0-9]\+\b\|review-360\|chantier\|socle/" S` | nothing |
| cross-references-intact | `grep -on "Step [0-9]" S` vs `grep -n "^## Step" S` | 15 mentions, Steps 0–7, all resolved |
| suite-green | `deno task test` | 25 passed, 0 failed |
| suite-green | `deno task check` | clean |
| suite-green | `git diff --check` | clean |
| suite-green | `wc -l < test/fixtures/golden-tree.txt` | 93 |

## Notes & Snippets

_Filled as the work lands._

## Findings

- **`reading-list-route`'s parenthetical "today 1" for `grep -c "Step 4"` is
  2.** At `fb2ca02` the skill already has two: the heading of "Step 4 —
  Surgical writes to `.agents/project.md`" and the citation in Step 6's §B1
  write ("Use Step 4's sub-section write span"). The threshold ≥ 2 is
  therefore already met before any edit, which makes that half of the
  criterion unable to fail. The step will still name Step 4's write span, as
  the spec's Scope "In" requires; what is wrong is the before-value in the
  parenthetical, not the requirement. Recorded, not amended — the spec is the
  Foreman's.

## Diff-Review Findings

_Written by the Foreman at review._
