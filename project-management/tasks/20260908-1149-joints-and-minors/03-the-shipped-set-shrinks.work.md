# 03 — The shipped set shrinks — work

Created by `mason` at `plan`, 2026-09-09. Spec:
`project-management/tasks/20260908-1149-joints-and-minors/03-the-shipped-set-shrinks.spec.md`.

## Program Design

Persisted at `plan` by `mason`, 2026-09-09 19:49 CEST, from the spec's
approved system design. Slices 01 and 02 have landed (HEAD `5193d47`), so
every figure below was re-measured against this working tree rather than read
from the spec; the four figures that moved are listed under "Where the spec's
figures no longer match the tree".

This slice adds no function, no branch and no data structure. Three pages
leave the set `chisel init` copies — two by deletion, one by a rename out of
the copied tree — and the four files that describe that set stop describing
what is gone: one side-lane row, two lock entries, eight fixture lines. There
is no seam to test and no TDD cycle: the seams the spec names are the
installed socle text surface and the installer suite, and their observable
behaviour is the criterion greps plus `bash test/run.sh`. The design question
is therefore *which lines change, in what order, and what stays green after
each commit*.

### Rules this design works under

- **Every commit leaves the suite green.** The golden fixture is compared
  byte for byte against a real install in two scenarios. Delete a skill
  without its fixture lines and both comparisons go red; delete the fixture
  lines without the skill and they go red the other way. So each removal
  travels with its own fixture lines in one commit — three commits, three
  green trees — rather than three deletions followed by one fixture commit
  that would leave two red commits behind it. The slice's total fixture diff
  is the same eight `-` lines either way. See Open question 1.
- **No assertion moves.** `test/installer.sh`, `test/run.sh`, `test/lib.sh`
  and `test/TESTS.md` are untouched. The fixture is data read by
  `assert_files_identical`, not a test, so the run's totals do not move:
  **9 scenarios, 94 assertions, 0 failed** before and after.
- **Pins to respect, inherited from slice 02's Inspector and re-verified at
  `plan`.**
  - `test/installer.sh:404-405` asserts that
    `.agents/skills/upgrade-v2/SKILL.md ` is the *only* installed file naming
    the retired v1 layer. Re-checked: a recursive grep for
    `.agents/workflows.md` and `.agents/rules/task` over `socle/` returns
    `socle/agents/skills/upgrade-v2/SKILL.md` alone. None of the three
    removed pages cites the v1 layer, so the pin is untouched by construction.
  - The `integrity: no pointer into thin air` scenario resolves three more
    `.agents/…` pointers since slice 02. This slice removes pointer *sources*,
    never a pointer *target*: `triage/SKILL.md` is the source of two
    `.agents/project.md` pointers and four sibling links to its own two
    companion files, all four of which leave with it; `grill-with-docs/SKILL.md`
    and `sync-upstream/SKILL.md` carry no `.agents/…` pointer and no sibling
    link at all. Nothing anywhere points *at* the three pages: the only
    `.agents/skills/<name>` paths cited in the whole socle are
    `chisel-beads/` (6) and `chisel-setup/` (1).
  - `socle/agents/discipline.md:93`, the `prototype` side-lane row, carries
    clause 2 of slice 01's `prototype-capture-aligned` and must survive intact.
    The row this slice deletes is line **97**, four lines below it, and it is
    the last row of the table. Nothing else in that file is touched.
  - `README.md:66` names `sync-upstream` as maintainer tooling and claims no
    path, so it stays true after the move and needs no edit. It is slice 02's
    file and stays on this slice's files-to-avoid map.
- **Pointers in shipped socle text are written in installed form
  (`.agents/…`), never `socle/…`.** This slice writes no new pointer at all.
  It does move the one shipped page that carries repo-side `socle/…` paths —
  see Edit 3, which is where that is judged rather than assumed.
- **No sweep.** Parent Implementation Decision 2: the bare `§B` the removed
  row carries leaves because the row leaves. Every other bare section
  reference in `discipline.md` is chantier 5's and is not touched.
- **No ruling id, no `G16`-style label, no decisions-record file name is
  written into shipped socle text.** This slice writes no shipped prose at all
  — every edit is a deletion or a rename — so the rule binds only this
  document, which is not shipped.
- **English, direct prose** (parent Implementation Decisions 11 and 12).

### Edit 1 — `grill-with-docs` leaves, with its lock and fixture lines

Ruling F1.10. Three files change and one directory goes.

**1a · the page.** `socle/agents/skills/grill-with-docs/` holds exactly one
file, `SKILL.md` (verified: `ls` shows one entry). Deleted whole, not parked —
git history and the upstream repo hold the text (parent Implementation
Decision 4).

```
git rm -r socle/agents/skills/grill-with-docs
```

**1b · the lock entry.** `upstream.lock.json` lines 22-26 are the five-line
entry, opening `  "grill-with-docs": {` and closing `  },`. Removed whole;
the entry above it (`domain-modeling`) already ends with `  },` at line 21, so
the JSON stays valid. Reason (parent Implementation Decision 4): an entry
whose skill directory no longer exists makes `sync-upstream --check` look up a
missing path.

```
sed -i '' '/^  "grill-with-docs": {$/,/^  },$/d' upstream.lock.json
```

**1c · the fixture.** `test/fixtures/golden-tree.txt` lines 39-40, the
directory and its `SKILL.md`. Removed by pattern rather than by line number,
because every later edit shifts the numbers:

```
sed -i '' '\#^\.agents/skills/grill-with-docs#d' test/fixtures/golden-tree.txt
```

**Verify before committing:** `grep -rn "grill-with-docs" socle/
upstream.lock.json test/fixtures/golden-tree.txt` → empty (6 → 0); the lock
parses with 15 entries; `wc -l test/fixtures/golden-tree.txt` → 96; suite
green. One commit.

### Edit 2 — `triage` leaves, with its row, its lock and its fixture lines

Ruling F1.11. Four files change and one directory of three files goes.

**2a · the pages.** `socle/agents/skills/triage/` holds `SKILL.md`,
`AGENT-BRIEF.md` and `OUT-OF-SCOPE.md` (33 of the 40 `triage` matches live
there: 19 + 10 + 4). Deleted whole. The standing intention — `triage` is worth
revisiting when a real team tracker exists — belongs to the task-closing
CHANGELOG entry, not to this slice (see Notes).

```
git rm -r socle/agents/skills/triage
```

**2b · the side-lane row.** `socle/agents/discipline.md`, line **97** — the
last row of the Side lanes table:

```
| Raw issues coming from an external tracker | `triage` — dormant until one is wired up in `.agents/project.md` §B | → normal flow |
```

Deleted whole, and nothing else in that file. The table keeps its header, its
separator and five rows; line 98 is already the blank line that closes it, so
the paragraph below ("Skills live in `.agents/skills/`…") is untouched. The
row's bare `§B` leaves with it, which is a by-product and not a licence to
touch the others.

```
sed -i '' '/^| Raw issues coming from an external tracker |/d' socle/agents/discipline.md
```

**2c · the lock entry.** `upstream.lock.json` lines 67-71, same five-line
shape, between `tdd` and `wayfinder`.

```
sed -i '' '/^  "triage": {$/,/^  },$/d' upstream.lock.json
```

**2d · the fixture.** Lines 64-67 as measured today: the directory and its
three files.

```
sed -i '' '\#^\.agents/skills/triage#d' test/fixtures/golden-tree.txt
```

**Verify before committing:** `grep -rn "triage" socle/ upstream.lock.json
test/fixtures/golden-tree.txt` → empty (40 → 0); `grep -rn "Tracker section"
socle/` → empty (1 → 0, its last carrier); the `prototype` row still reads
as slice 01 left it and the table has five rows; the lock parses with **14**
entries and every remaining key still has its directory; `wc -l` → 92; suite
green. One commit.

### Edit 3 — `sync-upstream` moves beside its script, and two fixture lines go

Ruling A3 (2), parent Implementation Decision 3. One rename and one fixture
edit.

**3a · the move.** `git mv`, keeping the directory shape, the `SKILL.md` name
and its frontmatter verbatim. Not flattened to
`socle/scripts/sync-upstream.md`: that costs a content rewrite for nothing and
turns a rename into a delete-plus-add in the diff.

```
git mv socle/agents/skills/sync-upstream socle/scripts/sync-upstream
```

Verified at `plan` that the move alone unships the page:
`managed_relative_files` (`bin/chisel.sh:160-179`) finds files under
`agents/skills`, `agents/formulas` and `agents/profiles` only, and the sole
script it names is `scripts/task-id.sh`, copied from `$SOCLE/scripts/task-id.sh`
by one explicit `cp` at `bin/chisel.sh:279-281`. Nothing copies
`socle/scripts/` as a tree, so a directory added there is not installed and no
CLI change is needed.

**3b · the page's own `socle/…` paths stay as they are, and that is a
judgement, not an omission.** The page names `socle/agents/skills/` once
(line 9) and `socle/scripts/sync-upstream.sh` three times (lines 11, 25, 41).
They are **repo-side** paths, and correct: the page's own third paragraph says
"Run this from the chisel repo, not from an equipped project", the script it
drives really is at `socle/scripts/sync-upstream.sh`, and after the move the
page is maintainer tooling for this repo that no equipped project receives. So
the installed-form rule does not bind it any more. It bound it *before* the
move, and was being broken: this is the socle's only shipped page carrying
repo-side paths, which resolve nowhere in an equipped repo. The move retires
that defect by construction. After this slice `grep -rln "socle/"
socle/agents/` is empty; the only remaining carrier inside `socle/` is
`socle/templates/AGENTS-block.md:10`, which is slice 02's file and correct as
written (it tells a reader of an equipped repo where to edit the block *in the
chisel repo*).

**3c · the fixture.** Lines 58-59 as measured today.

```
sed -i '' '\#^\.agents/skills/sync-upstream#d' test/fixtures/golden-tree.txt
```

**The move touches no lock line.** `sync-upstream` is chisel-native: it has no
`upstream.lock.json` entry. Re-verified at `plan` — the lock's sixteen keys
are the sixteen Pocock-forked skills, and the four skill directories with no
entry are `chisel-beads`, `chisel-setup`, `sync-upstream` and `upgrade-v2`.

**Verify before committing:** `git status` / `git diff -M --stat` show the page
as a rename (`R`), not a delete plus an add; `grep -n "sync-upstream"
test/fixtures/golden-tree.txt` → empty (2 → 0); `wc -l` → **90**; suite
green. One commit.

### Edit 4 — verification and the after-count roll-call

No file changes beyond this work document. Run every criterion command, record
each after-count beside its before-count in the Worklog, and run the spec's
five extra checks: the rename shape, `wc -l` = 90, the lock parsing to 14, the
lock-to-directory consistency printing `[]`, and `git diff --check`. Then one
commit for this document.

### Order of operations

Ordered smallest-first, each step self-contained and each ending green. The
rename lands last so it is the final, isolated commit and reads as one `R` line
in the slice's diff.

1. **Edit 1 — `grill-with-docs`** (page + lock entry + 2 fixture lines). One
   commit. Verify the three greps, the lock parse (15), `wc -l` 96, suite.
2. **Edit 2 — `triage`** (3 pages + discipline row + lock entry + 4 fixture
   lines). One commit. Verify the `triage` grep, the `Tracker section` grep,
   the discipline table, the lock parse (14) and its directory consistency,
   `wc -l` 92, suite.
3. **Edit 3 — `sync-upstream`** (`git mv` + 2 fixture lines). One commit.
   Verify the rename shape, the fixture grep, `wc -l` 90, suite.
4. **Edit 4 — verification.** Full run
   `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` expecting 9 scenarios, 94
   assertions, 0 failed with the formula parse check reporting PASS and not
   SKIP; `git diff --check`; `git diff -M --stat` over the slice's range; the
   after-count table written into the Worklog. One commit for this document.

Every fixture edit is by pattern, never by line number, because each edit
shifts the numbers of the ones after it. All three fixture edits are pure
deletions: `git diff test/fixtures/golden-tree.txt` must contain only `-`
lines.

The suite runs after every step, not only at the end: it is cheap (a few
seconds) and it is the only thing that proves a removal landed exactly and
only where intended.

### Where the spec's figures no longer match the tree

Re-measured 2026-09-09 by `mason`. The slice spec's figures were taken on
2026-09-08, before slices 01 and 02 landed. Four have moved; none changes the
work, and the spec is not edited (`mason` may not).

| The spec says | Measured today | Why it moved |
|---|---|---|
| the `triage` side-lane row is at `socle/agents/discipline.md:102` | line **97** | slice 01 deleted rule 11 of the discipline and renumbered rule 12 (commit `65c505e`), which is five lines shorter above the table |
| "do not touch the prototype row (line 98)" | the `prototype` row is at line **93** | same deletion |
| `grep -rn "Tracker section" socle/` → **5** across 5 files | **1** — `socle/agents/skills/triage/SKILL.md:48` only | slice 01 repointed `methodology.md:35`; slice 02 repointed `wayfinder:30`, `slice-task:17` and `code-review:18` |
| "`README.md:60` names the `sync-upstream` skill" | `README.md:**66**` | slice 02 rewrote the README's front-door paragraphs |

Everything else holds exactly: `grill-with-docs` 6 matches at the same six
lines, `triage` 40 matches, the fixture's three blocks still at lines 39-40,
58-59 and 64-67, the fixture 98 lines, the lock 16 entries, the suite 9
scenarios / 94 assertions / 0 failed, `bin/chisel.sh`'s
`managed_relative_files` still at line 160, and `test/installer.sh`'s
integrity scenario still at line 347.

### Expected suite figures after the slice

**9 scenarios, 94 assertions, 0 failed**, unchanged. The fixture is data, not
assertions: the two byte-for-byte comparisons stay one assertion each
(`init: installed tree matches the golden layout`,
`boilerplate: installs the same tree as the golden layout`), and each must
pass against the 90-line fixture — one passing while the other fails would
mean the removal is uneven, not that the fixture is wrong. The
`tree_size > 40` floor guard, asserted in both scenarios
(`test/installer.sh:18` and `:96`), reads 90 instead of 98 and holds with
room. The `integrity` scenario keeps its five assertions and stays green: this
slice deletes pointer sources, never targets. The 600-line cap line stays
**592**: `test/run.sh` sums `lib.sh` (90) + `installer.sh` (437) +
`run.sh` (65) only, and the fixture is not counted — an unchanged 592 is not a
fixture edit that failed to land.

### Criteria this slice closes, and the one it shares

- `sync-upstream-unshipped`, `grill-with-docs-gone`, `triage-unshipped` —
  owned in full, all three expect 0.
- `suite-green` — for this slice's own run, and load-bearing here in a way it
  was not for slices 01 and 02, because this is the slice that changes the
  installed tree.
- `tracker-pointer-resolves` — **shared, and it closes here.** Its first half
  goes empty when `triage/SKILL.md` leaves. Its second half — "every surviving
  citer names a section that exists" — was already met by slices 01 and 02,
  and this Mason verified all four surviving citers at `plan` rather than
  assuming them: `methodology.md:35` → `§B2 · Link to an external tracker`,
  `wayfinder/SKILL.md:30` → `§B2 · Link to an external tracker`,
  `slice-task/SKILL.md:17` → `§B · Coordination`, and
  `code-review/SKILL.md:18` → `§A · Task workspace`, the amended target
  (parent Implementation Decision 1, amended 2026-09-09). All four sections
  exist in `socle/agents/project.md.tpl` — `## A · Task workspace` line 14,
  `## B · Coordination` line 43, `### B2 · Link to an external tracker` line
  103. So the criterion is green in both halves once this slice lands. Slice
  02's escalation E-1 is already resolved in the parent and needs no work here:
  `code-review/SKILL.md:18` reads `§A · Task workspace` on this tree, so this
  slice does **not** inherit that one-line fix, and
  `socle/agents/skills/code-review/` stays on its files-to-avoid map.

### What this slice does NOT do

- No edit to `test/installer.sh`, `test/run.sh`, `test/lib.sh`,
  `test/TESTS.md` or `bin/chisel.sh`.
- No edit to any file slices 01 and 02 own — `socle/agents/discipline.md`
  excepted, for the one `triage` row, and nothing else in it.
- No CHANGELOG entry: it is task-closing work, written at the parent's `close`
  (foreman, 2026-09-08, in the spec's Notes). The next entry number is 25;
  entry 24 was chantier 2.
- No section-reference sweep, no `README.md` edit, no flattening of the moved
  page, no rewrite of its frontmatter or its body.
- No `git add -A` and no `git add .`: every stage names explicit paths, and the
  two untracked Owner files `project-management/review-360-notes.md` and
  `project-management/review-360-analysis.md` are never read, staged or
  committed.

### Open questions

Two, both for the Architect at `plan-review`. Neither blocks: the design is
executable as written, and each question names the answer this Mason would
apply.

**1 · Three green commits, or one fixture commit?** The spec's Ordering
paragraph says keeping this slice last "means the fixture is touched once" and
"reviewed once". Read as being about the *slice*, not about the commits: the
slice's whole fixture diff is one block of eight `-` lines however it is cut.
The design therefore puts each removal's fixture lines in that removal's own
commit, so that all three commits leave the suite green — the Mason contract
asks for a commit at every green step, and the alternative ordering (three
deletions, then one fixture commit) knowingly commits two red trees. If the
Architect reads the spec as requiring a single fixture commit instead, the fix
is to reorder: deletions and lock edits first, then one commit carrying all
eight fixture lines, with the suite run only after that last one and the red
intermediate states recorded in the Worklog.

**2 · Nothing will state the moved page's new path.** After Edit 3 the only
mention of `sync-upstream` outside `socle/scripts/` is `README.md:66`, which
names it as maintainer tooling and gives no path (parent Implementation
Decision 3 says that is why the README needs no edit). So a maintainer looking
for the page finds it by knowing `socle/scripts/`, not by following a pointer.
This Mason's answer: leave it. `README.md` is slice 02's file and on this
slice's files-to-avoid map, no criterion asks for a path, and the page sits
beside the script it drives, which is where the ruling wanted it. Reported
through the proposal door rather than acted on: if the Owner wants the path
written down, it is one clause in `README.md:66` — size a few words, risk
nil, and this slice delivers cleanly without it.

## Worklog

- **2026-09-09 19:49 CEST · `mason` · `plan`.** Read the role contract
  (`socle/agents/profiles/mason.md`), `socle/agents/discipline.md`, the `plan`
  step of `socle/agents/formulas/chisel-auto.formula.toml`, the work template
  `project-management/000-template.work.md`, this repo's `AGENTS.md`, the
  slice spec in full including its Notes, the parent spec in full (§Scope,
  §Acceptance Criteria, §Seams, §Architecture, §Implementation Decisions 1-12
  with Decision 1's 2026-09-09 amendment, §Slices & Dependencies, §Notes with
  both foreman notes), slice 01's closed pair, and slice 02's Diff-Review
  Findings including its four-point heads-up for this slice. Also read,
  against the tree rather than from a summary: `test/installer.sh` (the two
  golden comparisons and their `tree_size > 40` guards, the integrity scenario
  and its definition of a pointer, the v1-citer pin at 404-405, the mutation
  test), `test/lib.sh` (`installed_tree`), `bin/chisel.sh`
  (`managed_relative_files`, the `task-id.sh` copy), `upstream.lock.json`,
  `test/fixtures/golden-tree.txt`, `socle/agents/discipline.md`'s Side lanes
  table, the three pages this slice removes, and
  `socle/scripts/sync-upstream.sh`. Persisted this program design. Measured
  **fifteen** before-count rows plus the suite baseline against this working
  tree (table in Notes & Snippets); four figures of the spec have moved since
  2026-09-08 and are recorded above, dated and signed, with the spec left
  untouched. Nothing typed in any carrier.

## Implementation Checkboxes

- [ ] Edit 1 — `grill-with-docs`: delete the directory, remove its
      `upstream.lock.json` entry, remove its two `golden-tree.txt` lines —
      one commit, suite green
- [ ] Edit 2 — `triage`: delete the directory, remove the side-lane row at
      `socle/agents/discipline.md:97`, remove its `upstream.lock.json` entry,
      remove its four `golden-tree.txt` lines — one commit, suite green
- [ ] Edit 3 — `sync-upstream`: `git mv` to `socle/scripts/sync-upstream`,
      remove its two `golden-tree.txt` lines — one commit, rename shape
      verified, suite green
- [ ] Edit 4 — verification: every criterion command re-run with its
      after-count recorded beside its before-count; `wc -l` 90; lock parses to
      14 and every key still has its directory; rename shows as `R`;
      `git diff --check` clean; full suite 9 scenarios, 94 assertions, 0
      failed, parse check PASS not SKIP

## Notes & Snippets

**Before-counts, measured by `mason` at `plan`, 2026-09-09, branch
`review-360`, HEAD `5193d47`.** Every command was run against this working
tree, not copied from the spec. Fifteen rows plus the suite baseline.

| Command | Spec says (2026-09-08) | Measured today |
|---|---|---|
| `ls socle/agents/skills/sync-upstream/` | one file, `SKILL.md` | one file, `SKILL.md` |
| `ls socle/scripts/` | `sync-upstream.sh`, `task-id.sh` | `sync-upstream.sh`, `task-id.sh` |
| `grep -n "sync-upstream" test/fixtures/golden-tree.txt` | 2 (lines 58, 59) | 2, lines 58 and 59 |
| `grep -rn "grill-with-docs" socle/ upstream.lock.json test/fixtures/golden-tree.txt` | 6 | 6 — `SKILL.md:2` and `:7`, `upstream.lock.json:22` and `:24`, fixture `:39` and `:40` |
| files in `socle/agents/skills/grill-with-docs/` | exactly 1 | exactly 1, `SKILL.md` |
| `grep -rn "triage" socle/ upstream.lock.json test/fixtures/golden-tree.txt` | 40 | 40 — 33 in the three `triage/` files (`SKILL.md` 19, `AGENT-BRIEF.md` 10, `OUT-OF-SCOPE.md` 4), 1 at `discipline.md:97`, 2 in the lock (67-71), 4 in the fixture (64-67) |
| the `triage` side-lane row | `discipline.md:102` | `discipline.md:**97**` — differs, see the table above |
| the `prototype` side-lane row (must survive) | line 98 | line **93** — differs, see the table above |
| `grep -rn "Tracker section" socle/` | 5 across 5 files | **1** — `triage/SKILL.md:48` only; differs, see the table above |
| `wc -l test/fixtures/golden-tree.txt` | 98 | 98 |
| lock entry count | 16 | 16; the four skill directories with no entry are `chisel-beads`, `chisel-setup`, `sync-upstream`, `upgrade-v2` |
| lock keys with no directory | `[]` | `[]` |
| `grep -rn "socle/" socle/agents/` | not measured | 1 file — `skills/sync-upstream/SKILL.md`, lines 9, 11, 25, 41 |
| `.agents/skills/<name>` paths cited in `socle/` | `chisel-beads/` 6, `chisel-setup/` 1 | identical — nothing points at the three removed pages |
| `grep -rln "\.agents/workflows.md\|\.agents/rules/task" socle/` | only `upgrade-v2` | only `socle/agents/skills/upgrade-v2/SKILL.md` |
| `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` | 9 / 94 / 0 | **9 scenarios, 94 assertions, 0 failed**; formula parse check PASS (python 3.13.1 with `tomllib`), integrity scenario green, 600-line cap reported at 592 |

**Four facts checked at `plan` that the spec asserts but does not command.**

- The move really is invisible to the installer: `managed_relative_files`
  (`bin/chisel.sh:160-179`) finds `agents/skills`, `agents/formulas`,
  `agents/profiles` and lists exactly one script, `scripts/task-id.sh`, which
  `bin/chisel.sh:279-281` copies with a single explicit `cp` from
  `$SOCLE/scripts/task-id.sh`. No code copies `socle/scripts/` as a tree.
- `installed_tree` (`test/lib.sh:87-90`) is `find .agents .claude .codex
  scripts project-management -print`, so the fixture lists directories as well
  as files — which is why `triage` costs four lines and each of the other two
  costs two.
- The three removed pages appear nowhere in the suite except the fixture. The
  only skill names `test/installer.sh` hardcodes are `beads` (a planted
  foreign directory), `code-review`, `tdd` and `upgrade-v2`.
- `socle/scripts/sync-upstream.sh:87-88` resolves its skills directory as
  `socle/agents/skills` when that directory exists, so the script keeps
  working from the repo root after the page beside it moves. The script is not
  edited.

**Every edit command in the design was dry-run at `plan`, on throwaway copies
outside the repo.** `upstream.lock.json`, `test/fixtures/golden-tree.txt` and
`socle/agents/discipline.md` were copied to a scratch directory and the five
`sed` commands run against the copies. Results: the lock parses with **14**
entries and neither `grill-with-docs` nor `triage` remains a key; the fixture
is **90** lines and `diff` against the current one shows **only** the eight
expected `-` lines, at 39-40, 58-59 and 64-67; the Side lanes table keeps five
rows with the `prototype` row untouched at line 93 and the closing paragraph
intact. Nothing was written in the repo. The commands in the design are
therefore the ones that were tested, not their approximations.

**The CHANGELOG entry is task-closing, and that is settled.** The parent's
Deliverables ask for a dated entry recording the pass, the three removals and
the standing intention on `triage`. No slice's files-to-modify map contains
`project-management/CHANGELOG.md`; the thread owner confirmed on 2026-09-08, in
this slice spec's Notes, that the entry is written at the parent's `close`
alongside the retrospective. Recorded here so a `diff-review` of this slice
does not read its absence as missing work. Entry 24 is chantier 2, so this
pass will be entry 25.

**What a `diff-review` of this slice must not read as missing work.** Two
things, both by design: the four Tracker-section renames (slices 01 and 02,
already landed and verified above), and the CHANGELOG entry (task-closing).

## Diff-Review Findings

Written by the Inspector at `diff-review`.
