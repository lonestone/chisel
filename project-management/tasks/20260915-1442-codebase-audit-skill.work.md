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

### Sequence of commits

1. This work document alone, at `plan`.
2. `socle/agents/skills/codebase-audit/SKILL.md`.
3. The registration: `src/socle-files.ts` and `test/fixtures/golden-tree.txt`.
4. This work document's close.

After each of the last three: `deno task test`, `deno task check`,
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

## Implementation Checkboxes

- [x] Program design persisted and committed (this file, alone)
- [ ] `socle/agents/skills/codebase-audit/SKILL.md` written
- [ ] Registration: `src/socle-files.ts` and `test/fixtures/golden-tree.txt`
- [ ] Suite green, `check` clean, `git diff --check` clean after each commit
- [ ] Criterion after-values recorded beside the before-values
- [ ] `writing-great-skills` pass recorded, one entry per failure mode
- [ ] Cold-reader pass recorded: three places that made a cold reader stop
- [ ] Findings section written

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

_(the Foreman's two-axis review at close)_
