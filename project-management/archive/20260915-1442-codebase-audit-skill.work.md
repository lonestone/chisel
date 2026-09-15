# The codebase-audit skill: the 360 review's protocol, distilled — work

Created by the implementing session at `plan`, 2026-09-15. Spec:
`project-management/tasks/20260915-1442-codebase-audit-skill.spec.md`.

Working under `AGENTS.md`, `socle/agents/discipline.md` (rule 11 in
particular: name by meaning, cite by file path and section title, never a line
number), the spec document above as the requirement, and
`socle/agents/skills/writing-great-skills/SKILL.md` with its `GLOSSARY.md` as
the standard the new skill's form is judged against.

## Program Design

### What is built

One file, `socle/agents/skills/codebase-audit/SKILL.md`. No sibling file — see
the information-hierarchy decision below.

Frontmatter: `name: codebase-audit`; a human-facing one-line `description`;
`disable-model-invocation: true`; no `x-upstream` block (this skill is
chisel's own, like `chisel-beads` and `chisel-setup`, whose frontmatter is the
model of form here).

### The program: six steps, each on a checkable completion criterion

An opening frame (what the audit is, that it fixes nothing, and the
diff-scale sibling it is not), then the steps in the spec's order, then the
default lens set as in-skill reference at the foot of the file.

1. **Frame** — scope as a list of paths; the lens set put to the human as a
   single decision with a recommended trim or extension; the prior-record list
   found through §A · Task workspace and §G · Glossary & decisions of
   `.agents/project.md`, then completed by asking the human. Criterion: the
   three lists written down and seen by the human before any finder starts.
2. **Finders, blind, one per lens** — spawned in one turn, sub-agents at the
   **frontier** tier resolved through "Model tiers" of `.agents/reference.md`.
   The brief carries the lens, the scope paths and the shape of a finding
   (claim / where, cited by file path and section title / severity as the
   finder sees it / how a reader verifies it). Criterion: each finder returns
   the list of files it read, and every in-scope file its lens applies to is
   on that list — the list, not a summary.
3. **Verify** — the auditor reproduces every claim that would change a
   decision or accuses the code of a behaviour; what will not reproduce
   travels as **unverified**, in that word. Criterion: every serious claim
   carries its reproduction or that word.
4. **Triage against what came before** — three classes: **new**, **a fix that
   did not take** (naming the earlier decision it failed), **already ruled**
   (listed once, never argued again). Cross-lens duplicates merge, keeping the
   strongest reproduction and naming every lens that saw it. Criterion: one
   class per finding, and every failed fix names its decision.
5. **Report** — one file in the task workspace root declared in §A of
   `.agents/project.md`, named `<YYYYMMDD>-audit-<scope>.md`; blocks by
   subject; each block and each finding named by what it says, a code riding
   beside the name at every mention; citation, class, verification status on
   every finding. Criterion: the file exists, every triaged finding is in it,
   none without a citation.
6. **Decisions, block by block** — the interview runs under the discipline of
   `.agents/skills/grilling/SKILL.md`, pointed at and never paraphrased; each
   decision written into `<YYYYMMDD>-audit-<scope>-decisions.md` beside the
   report as it lands, named by what it decided, with a plain-word state (to
   decide, decided, deferred); the record ends with the action plan. Criterion:
   every block has a decision or a dated deferral, the record ends with the
   plan, and nothing in the plan is implemented under this skill.

### Where the lens set sits on the information hierarchy, and why

**Inline in `SKILL.md`, as in-skill reference at the foot of the file, with
no disclosed sibling.**

The rule is the disclosure test of
`socle/agents/skills/writing-great-skills/SKILL.md` ("Information hierarchy":
inline what every branch needs, disclose what only some branches reach). The
lens set is reached twice by every single run — the human trims or extends it
at Frame, and every finder brief at Finders is built out of it — so there is no
branch that skips it. Putting must-have material behind a context pointer is
the variance bug the glossary names under **Context Pointer**: the pointer,
not the target, decides whether the agent reaches it, and a set of six lines
is not worth that risk.

The candidate for disclosure was the *finder brief* rather than the lens set.
It is not disclosed either, for a different reason: the brief is four bullets
naming what a finding must carry, not a pasteable page. Sending the agent to a
second file to read four bullets it needs at the moment it spawns the finders
buys nothing and costs a hop.

The cost accepted is length in `SKILL.md`. It is the **sprawl** the ladder
would cure, and the ladder is declined here because the file stays short: six
one-line lenses, and steps that hold no reference the run can skip.

### Leading words carrying the skill

**lens** (what one finder hunts, the unit the set is parameterized in),
**blind** (the finder's access: its lens and the material, nothing else),
**claim** (a finding's assertion, the thing Verify reproduces), **triage**
(the classing against the prior records), **block** (the report's unit of
subject and therefore the decision's unit). Each is bolded at its first use
and then used as a token, never restated as a sentence.

Two more carry a step each: **unverified**, the word a claim that would not
reproduce must travel in — a binary observable state, not a hedge; and
**action plan**, the artifact the skill stops on.

### Disclosed to a sibling file

Nothing. The skill is one file.

### Registration plan

`src/socle-files.ts`, one line added to `SOCLE_FILES` in the list's existing
order — between `agents/skills/code-review/SKILL.md` and
`agents/skills/codebase-design/DEEPENING.md`:

```
  "agents/skills/codebase-audit/SKILL.md",
```

`test/fixtures/golden-tree.txt`, two lines added in the tree's existing order
— after `.agents/skills/code-review/SKILL.md` and before
`.agents/skills/codebase-design`:

```
.agents/skills/codebase-audit
.agents/skills/codebase-audit/SKILL.md
```

Order check: the tree and the file list are byte-sorted, where `-` (0x2D)
precedes `b` (0x62) — which is why `code-review` sits before `codebase-design`
today, and why `codebase-audit` sits between them.

Line count after: 91 + 1 directory + 1 file = 93, which is what the
`registered` criterion predicts.

`test/TESTS.md`: untouched. No group's one-line description stops being true —
the `init` and `boilerplate` groups already say the installed tree must match
`test/fixtures/golden-tree.txt`, the `integrity` group already says every
pointer of the installed socle must resolve, and one more skill in the golden
tree changes neither sentence.

### Criterion before-values

"Before" is HEAD `5ca0eee`. Commands run from the repo root, with
`socle/agents/skills/codebase-audit/` as `<S>`.

| Criterion | Command | Before |
|---|---|---|
| skill-exists | `ls <S>/SKILL.md`; `grep -c x-upstream` | no such file; n/a |
| protocol-ordered | headings Frame…Decisions, each with "Criterion" | no file |
| triage-classes | `grep -c new`; `grep -ci "did not take"`; `grep -ci "already ruled"` | 0; 0; 0 |
| lenses-named | `grep -rci` each of joints, contradictions, over-claims, sediment, behaviour, cold reader | 0 each |
| siblings-pointed | `grep -c grilling`; `grep -c code-review`; `grep -rn "one question at a time"` | 0; 0; 0 lines |
| names-not-codes | `grep -rci beside`; `grep -rn "S7\.\|G4\|G17\|G19\|review-360\|chantier"` | 0; 0 lines |
| repo-is-memory | `grep -c "audit-"`; `grep -c project.md` | 0; 0 |
| registered | `grep -c codebase-audit src/socle-files.ts`; same on the golden tree; `wc -l` golden tree | 0; 0; 91 |
| wgs-pass-recorded | section present in this work document | absent |
| suite-green | `deno task test`; `deno task check`; `git diff --check` | 25 passed, 0 failed; not yet run; clean |
| nothing-else-moved | `git diff --stat 5ca0eee..HEAD` | empty |

### Criterion after-values

Same commands, run at `f976179`. Every criterion is met; the spec's own
checkboxes are the Foreman's to tick.

| Criterion | Before | After | Met |
|---|---|---|---|
| skill-exists | no such file | `SKILL.md` present, frontmatter carries `name: codebase-audit`, a description and `disable-model-invocation: true`; `grep -c x-upstream` → 0 | yes |
| protocol-ordered | no file | headings `1 · Frame`, `2 · Finders, blind, one per lens`, `3 · Verify`, `4 · Triage against what came before`, `5 · Report`, `6 · Decisions, block by block`, in that order; `grep -c Criterion` → 6, one per step | yes |
| triage-classes | 0; 0; 0 | `new` → 2; `did not take` → 2; `already ruled` → 1 | yes |
| lenses-named | 0 each | joints 1, contradictions 1, over-claims 1, sediment 1, behaviour 4, cold reader 1 | yes |
| siblings-pointed | 0; 0; 0 lines | grilling 1; code-review 1; `one question at a time` → 0 lines | yes |
| names-not-codes | 0; 0 lines | `beside` → 2; the forbidden-token grep → 0 lines | yes |
| repo-is-memory | 0; 0 | `audit-` → 2 lines (the report name and the decisions-record name); `project.md` → 2 | yes |
| registered | 0; 0; 91 | one file in the folder, named in `src/socle-files.ts` (1 line) and in the golden tree (2 lines: the directory and the file); `wc -l` → 93 = 91 + 1 + 1 | yes |
| wgs-pass-recorded | absent | the section below, one entry per failure mode | yes |
| suite-green | 25 passed, 0 failed | 25 passed, 0 failed; `deno task check` exit 0; `git diff --check` exit 0 | yes |
| nothing-else-moved | empty | `git diff --stat 5ca0eee..HEAD` touches this task's work document, `socle/agents/skills/codebase-audit/SKILL.md`, `src/socle-files.ts`, `test/fixtures/golden-tree.txt` — nothing else | yes |

`test/TESTS.md` was not touched, and nothing in it stopped being true: the
`init` and `boilerplate` groups already promise the installed tree matches
`test/fixtures/golden-tree.txt`, and the `integrity` group already promises
every pointer of the installed socle resolves and that the shipped file list
names exactly the files that are there. One more skill under the golden tree
changes neither sentence.

### The `writing-great-skills` pass

One entry per failure mode of
`socle/agents/skills/writing-great-skills/SKILL.md` ("Failure modes").

- **Premature completion.** Every step ends on a criterion that is checkable,
  and exhaustive where the work can be skimped: Finders demands "the list
  itself, not a count and not a summary of it", Triage demands "exactly one of
  the three classes" plus a named earlier decision behind every fix that did
  not take, Report demands that no finding be in the file without a citation.
  One criterion was rewritten for this: Verify first read "every serious claim
  in the report", which left the agent to decide what counted as serious —
  replaced by the operational test the step's own first sentence already uses,
  "every claim that would change a decision or accuses the code of a
  behaviour". No sequence split: the glossary's order is sharpen the bound
  first and hide the later steps only when a rush is actually observed, and no
  rush can be observed on a skill that has not been run.
- **Duplication.** The rule that a finding is named by what it says, with a
  code riding beside the name, is stated once in Report and only *applied* in
  Decisions ("named by what it decided"). The interview discipline is pointed
  at `.agents/skills/grilling/SKILL.md` and never restated — the step names
  the two rules it leans on and leaves the rest to the pointer. The model-tier
  cascade is pointed at "Model tiers" of `.agents/reference.md`, not
  summarized. The prior-record list is built once, in Frame, and Triage reads
  it by reference to that step. What is *not* duplication: "behaviour" on four
  lines and "lens" throughout are one token repeated, which is the leading-word
  mechanism, not one meaning written twice.
- **Sediment.** Nothing to clear — the file is new. Two layers that would have
  settled were kept out: a closing "what this is not" section restating the
  `code-review` distinction the opening already draws (the distinction is
  stated in one place, the opening), and a second pass over the lens set inside
  step 2's brief instructions (the brief sends the finder to the set's own
  words instead).
- **Sprawl.** One file, six steps and six lines of reference; no sibling. The
  ladder was considered and declined for the reason recorded under the
  information-hierarchy decision above: the lens set and the finder brief are
  both on every run's path, and disclosing must-have material is the variance
  bug the glossary names under **Context Pointer**.
- **No-op.** Two lines earn their place against the default and were kept:
  "Blind is the mechanism, not a precaution" plus its enumeration of what a
  finder does not receive — an agent spawning parallel sub-agents tends to hand
  each one the whole context — and "Convergence is evidence of where to look,
  not proof: two finders can share one wrong reading of the same sentence",
  against the default of treating agreement as corroboration. Lines that would
  have failed the test were never written: be thorough, read carefully, be
  rigorous, take your time.
- **Negation.** Two prohibitions were turned into their positive. "One finding
  per line of argument, never a digest of several" became "One finding per line
  of argument: a finding that bundles three arguments can be neither reproduced
  nor decided." "Write each decision as it lands, never at the end from memory"
  became "Writing as you go is what makes the record match what was said; a
  record written at the end is written from memory." Two prohibitions stay,
  each a hard guardrail paired with its positive: "The audit ends on an action
  plan and repairs none of it", immediately followed by what does happen to
  each piece; and the list of what a blind finder does not receive, which has
  to be enumerable to be checkable and arrives after the positive statement of
  what blind is for.

### The cold-reader pass

The finished skill read once as someone who never saw the audit it distils.
Three places stopped that reader, and what changed for each:

1. **`lens` was used three times in the opening before anything said what a
   lens is.** The word carried the whole skill and was left to the reader's
   guess until the foot of the file. The opening now glosses it at first use —
   "a lens being one class of problem to hunt, one line of text, and one
   finder's whole brief" — which also tells the reader at step 1 what size of
   thing they are agreeing to when they trim the set.
2. **Step 1 sent the reader to "the default set at the foot of this page"
   without naming the section, and without saying to read it now.** A reader
   framing an audit does not know whether to jump. It now names the section by
   its title, "The default lens set", and says to read it before putting the
   set to the human.
3. **"decisions records" in step 1 read as a typo, because nothing had yet
   produced one.** The phrase is the socle's, but a cold reader meets it before
   step 6 writes one. Step 1 now ties the two together — "their decisions
   records — the kind of record step 6 of this skill writes" — so the audit's
   own output and what its triage reads against are visibly the same artifact,
   one audit apart.

### Findings

- **The skill and its registration are one atomic commit, not two.** The
  spec's Verification asks for commits in small steps — the skill, then the
  registration — and also for `deno task test` before each commit. Both cannot
  hold: the `integrity` group asserts the shipped file list names *exactly*
  the files under `socle/`, in both directions, so a commit adding the skill
  without its registration is red (measured: 24 passed, 1 failed, on
  `integrity: the shipped socle list matches the socle tree`), and the reverse
  order is red for the mirror reason. The gate won: the skill and its two
  registration lines shipped as one green commit. The rule worth keeping is
  general — a new socle file is atomic with its registration — and the spec's
  sequence is right for every other step boundary.
- **A sentence the socle may owe the new skill, proposed and not written.**
  Nothing in the socle tells a reader this skill exists, and a user-invoked
  skill has no other way to be found: the human is the index. The natural home
  is the "Side lanes" table of `socle/agents/discipline.md`, which lists the
  situations that do not start as a feature idea — a whole repo to judge is one
  of them and is missing. Proposed row, for the Foreman to rule on:
  `| A whole repo to judge, rather than one change | `codebase-audit` — blind
  finders one per lens, every claim reproduced, findings triaged against what
  was already decided | decisions and an action plan → each becomes a task by
  the normal path |`. Not written here: `discipline.md` is outside this task's
  touch list, and the spec puts any such mention out of scope pending the
  Foreman's ruling. `methodology.md` and `reference.md` owe the skill nothing
  by my reading — the first explains why the method is shaped as it is and the
  second resolves tiers and vocabulary, and the skill consumes both rather than
  extending either.
- **Two of the spec's criterion commands do not test what their criterion
  means.** `triage-classes` uses `grep -c "new"` — case-sensitive but
  unanchored — which any page of English prose satisfies by accident; here it
  answers 2, of which one hit is "a new lens" in step 1 and only the other is
  the class named **new** in step 4. `names-not-codes` leans on
  `grep -ci "beside"`, which the word satisfies in any sense. Both criteria are
  met on the merits, and both were checked by reading the text, not by trusting
  the count. Flagged so a later pass over the criteria knows these two commands
  are weak evidence.
- **The `registered` criterion's line-count formula assumes one new directory.**
  "91 + 1 + the number of files" holds here because the skill is one flat
  folder. A skill shipping a subfolder — as `diagnosing-bugs` does with
  `scripts/` — adds a second directory line and would fail the arithmetic while
  being correctly registered. Worth generalising to "one line per directory
  plus one per file" if the formula is ever reused.
- **The skill points at `grilling` by file path rather than invoking it.**
  `grilling` is model-invoked, so another skill could in principle fire it, but
  every skill in this socle reaches its siblings by naming the installed path —
  `code-review` does exactly this with `.agents/reference.md`. House style
  followed deliberately, and it is also what keeps the text tool-agnostic.

### Sequence of commits

1. This work document alone, at `plan`.
2. `socle/agents/skills/codebase-audit/SKILL.md` together with its
   registration in `src/socle-files.ts` and `test/fixtures/golden-tree.txt` —
   one commit, because the `integrity` group makes the three inseparable; see
   the first entry of Findings.
3. This work document's close.

After each of the last two: `deno task test`, `deno task check`,
`git diff --check`.

## Worklog

**2026-09-15 — plan.** Read `AGENTS.md`, `socle/agents/discipline.md`, the
spec in full, `project-management/000-template.work.md`,
`writing-great-skills` and its `GLOSSARY.md`, `chisel-beads` and
`chisel-setup` as models of frontmatter and form, `grilling` and `code-review`
as the two siblings the new skill points at, `src/socle-files.ts`,
`test/fixtures/golden-tree.txt`, `test/TESTS.md`, "Model tiers" of
`socle/agents/reference.md`, §A · Task workspace and §G · Glossary &
decisions of `socle/agents/project.md.tpl`, and in the decisions record the
ruling that orders this skill, the preamble that shows how the decisions were
taken one block at a time, and the addendum ruling that a code never travels
alone. Also read `test/integrity.test.ts` and the render test that forbids an
invented numeric limit, to know what the suite will check on the new text.
Ran every criterion command for its before-value. Program design above.

**2026-09-15 — type and close.** Wrote `SKILL.md` in one pass from the program
design, then read it as a cold reader and made the three changes recorded under
"The cold-reader pass". Attempted the spec's skill-then-registration commit
split and reverted to a single commit when the gate came back red on the
`integrity` group — the reasoning and the measurement are the first entry of
Findings. Registration landed in each list's existing order, and the golden
tree went from 91 lines to 93, which is what the `registered` criterion
predicts. Suite 25 passed and 0 failed, `deno task check` exit 0,
`git diff --check` clean, both before the commit and after it. Nothing outside
the four allowed paths moved; `test/TESTS.md` untouched, and nothing in it
stopped being true.

## Implementation Checkboxes

- [x] Program design persisted and committed (this file, alone)
- [x] `socle/agents/skills/codebase-audit/SKILL.md` written
- [x] Registration: `src/socle-files.ts` and `test/fixtures/golden-tree.txt`
- [x] Suite green, `check` clean, `git diff --check` clean after each commit
- [x] Criterion after-values recorded beside the before-values
- [x] `writing-great-skills` pass recorded, one entry per failure mode
- [x] Cold-reader pass recorded: three places that made a cold reader stop
- [x] Findings section written

## Notes & Snippets

Suite facts worth holding while typing the new text:

- `test/integrity.test.ts` treats **any** `.agents/…` path in the text as a
  pointer that must resolve in the installed tree, and a markdown link to a
  sibling file likewise; deep relative links are deliberately not pointers.
  The four pointers the new skill carries — `.agents/project.md`,
  `.agents/reference.md`, `.agents/skills/grilling/SKILL.md`,
  `.agents/skills/code-review/SKILL.md` — all resolve.
- `test/render.test.ts`, the test named for a retired name and an invented
  limit, greps the whole installed tree for a set of numeric limits. No number
  bounds anything in the new skill, so nothing there to trip.

## Diff-Review Findings

**Review, 2026-09-15 · `foreman`**, on both axes, fast track: no Inspector.
Every criterion command re-run; all met. The skill read in full as a cold
reader: six steps, each ending on a checkable criterion, the lens set inline
for the reason the Program Design gives, the two siblings pointed at and not
paraphrased, no code travelling alone.

**Fix — the Side lanes row, written.** Ruled yes on the agent's proposal:
the "Side lanes" table of `.agents/discipline.md` is the one index a reader
has for the situations that do not start as a feature idea, and a
user-invoked skill has no description to be found by. Row added by the
foreman (`a23a57b`), in the agent's wording with one change: "each piece
becomes a task by the normal path" for the Then column, matching the
skill's own closing sentence.

**Rulings on the other findings.** Skill and registration atomic: right, and
the spec's Verification is amended to say so for the next skill. `grep -c
"new"` and `grep -ci "beside"` weaker than their criteria: true; both
criteria checked by reading and met; the lesson for the next spec is to grep
the bold class name. The line-count formula assuming one directory: true
for this task, noted. `methodology.md` and `reference.md` owe nothing: agreed.

Verdict: PASS on Standards, PASS on Spec.
