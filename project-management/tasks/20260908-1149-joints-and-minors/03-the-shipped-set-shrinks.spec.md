# 03 — The shipped set shrinks

**Status:** 🟢 Complete (2026-09-09)
**Blocked by:** None — no slice gates this one technically. **Run it last.** It
removes two carriers slices 01 and 02 would otherwise rename, and it is the
only slice that may edit anything under `test/`, so keeping it last means the
fixture changes once and is reviewed once.

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** an equipped repo stops receiving three pages it should not
have. `grill-with-docs` and `triage` leave the socle entirely; the
`sync-upstream` page moves beside the script it drives, out of the set `chisel
init` copies. The installer's golden layout fixture records the smaller tree,
the two vendored entries leave the upstream lock so drift checking stops
looking up paths that no longer exist, and the discipline's side-lane table
loses the row that sent a reader to `triage`. This is the only slice that
changes *which files* an equipped repo receives; the other two only change
what those files say.

Nothing gains a function. No assertion is added, removed or rewritten; no
runner, library or scenario file is touched. The fixture changes by deletion
only.

Full criterion wording lives in the parent,
`project-management/tasks/20260908-1149-joints-and-minors.spec.md`,
§Acceptance Criteria. What follows is this slice's share, with each check
re-run against this working tree on 2026-09-08 and its count recorded.

## Acceptance criteria

**Owned in full by this slice.**

- [x] **sync-upstream-unshipped** — `socle/agents/skills/sync-upstream/` does
      not exist, the page sits beside its script under `socle/scripts/`, and
      `grep -n "sync-upstream" test/fixtures/golden-tree.txt` returns nothing.
      *Today:* the directory exists and holds one file, `SKILL.md`;
      `socle/scripts/` already holds `sync-upstream.sh` and `task-id.sh`;
      `grep -n "sync-upstream" test/fixtures/golden-tree.txt` → **2** (lines
      58 and 59, the directory and its `SKILL.md`).
      **The move touches no lock line.** `sync-upstream` is chisel-native, not
      vendored: it has no `upstream.lock.json` entry. Verified — the lock's 16
      keys are the sixteen Pocock-forked skills, and the four skill
      directories with no entry are `chisel-beads`, `chisel-setup`,
      `sync-upstream` and `upgrade-v2`.
- [x] **grill-with-docs-gone** — `grep -rn "grill-with-docs" socle/
      upstream.lock.json test/fixtures/golden-tree.txt` returns nothing.
      *Today:* **6** — `socle/agents/skills/grill-with-docs/SKILL.md:2` (its
      `name`) and `:7` (its `x-upstream` path); `upstream.lock.json:22` and
      `:24` (the entry, lines 22-26); `test/fixtures/golden-tree.txt:39` and
      `:40`. The directory holds exactly one file. Zero inbound references
      from any other socle file, as ruling F1.10 states — verified.
- [x] **triage-unshipped** — `grep -rn "triage" socle/ upstream.lock.json
      test/fixtures/golden-tree.txt` returns nothing.
      *Today:* **40**, and all forty leave with the four edits below: **33**
      inside the three files of `socle/agents/skills/triage/` (`SKILL.md`,
      `AGENT-BRIEF.md`, `OUT-OF-SCOPE.md`), **1** at
      `socle/agents/discipline.md:102` (the side-lane row), **2** in
      `upstream.lock.json` (the entry, lines 67-71), **4** in
      `test/fixtures/golden-tree.txt` (lines 64-67).
      The standing intention — `triage` is worth revisiting when a real team
      tracker exists — is recorded in the CHANGELOG entry at the task's
      `close`, not here. See Notes.
- [x] **suite-green** — `bash test/run.sh`, run with a `python3` that has
      `tomllib`, reports 0 failed, with the "integrity: no pointer into thin
      air" scenario passing.
      *Today:* `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` → **9
      scenarios, 94 assertions, 0 failed**. This criterion is load-bearing
      here in a way it is not for slices 01 and 02: this slice is the one that
      changes the installed tree, so the byte-for-byte golden comparison
      (asserted twice, brownfield and boilerplate) is the proof the removals
      landed exactly and only where intended.

**Shared — this slice removes the last carrier but cannot close it alone.**

- [x] **tracker-pointer-resolves** (its fifth and last carrier) —
      `socle/agents/skills/triage/SKILL.md:48` leaves with its file under
      ruling F1.11, so no rename is needed there. Per parent Implementation
      Decision 1 that carrier is "moot".
      *Today:* `grep -rn "Tracker section" socle/` → **5** across 5 files.
      This slice takes it from whatever slices 01 and 02 leave to **0**.
      **The criterion has two halves and this slice owns only the first.** Its
      second half — "every surviving citer names a section that exists" — is
      the four renames held by slice 01 (`methodology.md:35`) and slice 02
      (`wayfinder`, `slice-task`, `code-review`). The parent lists the
      criterion under this slice's "Criteria it closes" because this is where
      the grep finally goes empty; a `diff-review` of this slice alone must
      not read the four renames as missing work. See Notes.

## Files map

Indicative, motivated by the parent's Architecture, never a strict limit. The
reviewer judges deviations a posteriori.

**Modify:**

- **Delete `socle/agents/skills/grill-with-docs/`** — one file, `SKILL.md`.
  Deleted, not parked: git history and the upstream repo hold the text (parent
  Implementation Decision 4).
- **Delete `socle/agents/skills/triage/`** — three files, `SKILL.md`,
  `AGENT-BRIEF.md`, `OUT-OF-SCOPE.md`.
- **Move `socle/agents/skills/sync-upstream/` to
  `socle/scripts/sync-upstream/`** — `git mv`, keeping the `SKILL.md` name and
  its frontmatter, per parent Implementation Decision 3. The move alone
  unships the page: `managed_relative_files` in `bin/chisel.sh` finds only
  `agents/skills`, `agents/formulas` and `agents/profiles`, and names
  `scripts/task-id.sh` as its single explicit script — `socle/scripts/` is
  otherwise outside the copied set. **Do not flatten it** to
  `socle/scripts/sync-upstream.md`; that costs a content rewrite for nothing
  and turns a rename into a delete-plus-add in the diff.
- `socle/agents/discipline.md` — remove the `triage` side-lane row at line
  102, and nothing else in that file. The row is one line of the Side lanes
  table; the table stays valid with five rows.
- `upstream.lock.json` — remove the `grill-with-docs` entry (lines 22-26) and
  the `triage` entry (lines 67-71). 16 entries become 14. Reason (parent
  Implementation Decision 4): an entry whose skill directory no longer exists
  makes `sync-upstream --check` look up a missing path.
- `test/fixtures/golden-tree.txt` — remove eight lines: 39-40
  (`grill-with-docs`), 58-59 (`sync-upstream`), 64-67 (`triage`). 98 lines
  become 90. Deletion only.

**Avoid:** `test/installer.sh`, `test/run.sh`, `test/lib.sh`,
`test/TESTS.md`, `bin/chisel.sh`, and every file slices 01 and 02 own —
`socle/agents/discipline.md` excepted, for that one row. In particular do not
touch the prototype row (line 98) or the numbered rules, which are slice 01's.

`README.md:60` names the `sync-upstream` skill but claims no path for it, so
it needs no edit for this move (parent Implementation Decision 3). It is
slice 02's file in any case.

`test/installer.sh` needs no edit, verified rather than assumed: the only
skill names it hardcodes are `beads` (a planted foreign directory),
`code-review`, `tdd` and `upgrade-v2`. None of the three removed pages is
named anywhere in the suite except the golden fixture.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Verification

- Re-run each criterion command above and record the after-count beside the
  before-count. All four owned criteria expect **0**.
- `git status` / `git diff -M --stat` must show the `sync-upstream` page as a
  **rename** (`R`), not a delete plus an add. That is what `git mv` buys, and
  it is what makes the diff readable.
- `wc -l test/fixtures/golden-tree.txt` must read **90**, and
  `git diff test/fixtures/golden-tree.txt` must contain only `-` lines.
- `python3 -c 'import json; d=json.load(open("upstream.lock.json")); print(len(d))'`
  must parse and print **14** — a hand-edited JSON file that no longer parses
  breaks `sync-upstream.sh` silently.
- Every remaining lock entry must still have its directory:
  `python3 -c 'import json,os; d=json.load(open("upstream.lock.json"));
  print([k for k in d if not os.path.isdir("socle/agents/skills/"+k)])'`
  must print `[]`. It prints `[]` today, and this check is the point of
  removing the two entries.
- `PATH=/opt/homebrew/bin:$PATH bash test/run.sh` — expect 9 scenarios, 94
  assertions, 0 failed. Three assertions deserve a look by name:
  - **`init: installed tree matches the golden layout`** and **`boilerplate:
    installs the same tree as the golden layout`** — the byte-for-byte
    comparisons. Both must pass with the 90-line fixture. If one passes and
    the other fails, the removal is uneven, not the fixture.
  - **`init: the compared tree is a real install, not an empty listing`** —
    a floor guard, `tree_size > 40`. 98 becomes 90; the floor holds with
    room. Recorded so a reviewer does not have to re-derive it.
  - **`integrity: every pointer of the installed socle resolves`** — the guard
    on the three removals. It passes today and must still pass: verified in
    advance that no socle text points at `triage`, `grill-with-docs` or
    `sync-upstream` by an `.agents/skills/<name>` path. The only such paths
    cited anywhere in `socle/` are `chisel-beads/` (6) and `chisel-setup/`
    (1).
- **The 600-line cap assertion does not move.** `test/run.sh` sums
  `lib.sh` + `installer.sh` + `run.sh` only; the fixture is not counted, so
  the reported figure stays **592 lines**. Do not read an unchanged number as
  a fixture edit that failed to land.
- Below python 3.11 the formula parse check reports SKIP and the run announces
  a green it has not earned. Use the `PATH` prefix above.
- `git diff --check`.

## References

- Parent spec:
  `project-management/tasks/20260908-1149-joints-and-minors.spec.md` —
  §Scope (rows A3 (2), F1.10, F1.11), §Acceptance Criteria (full wording),
  §Seams ("Does a criterion need a suite change?" — the eight lines, and why
  this is the only slice allowed under `test/`), §Implementation Decisions 3
  and 4, and the slice-03 entry of §Slices & Dependencies.
- `project-management/review-360-decisions.md` — rulings A1 (1) (whose fifth
  carrier leaves here), A3 (2), F1.10, F1.11, and G18 (direct prose).
- `bin/chisel.sh`, function `managed_relative_files` (line 160) — the exact
  set `chisel init` copies, which is why moving a page into `socle/scripts/`
  unships it and why no CLI change is needed.
- `test/installer.sh`, scenario "integrity: no pointer into thin air" (line
  347) — what counts as a pointer for the guard on these removals, and its
  waiver list, which none of the three removals joins.
- `test/TESTS.md` — the suite's own contract, including the 600-line cap and
  what the golden tree fixture is for. Read it; do not edit it.
- `socle/scripts/sync-upstream.sh` — the script the moved page drives. Its
  own text already names itself at `socle/scripts/sync-upstream.sh`, so the
  page's three references to that path stay correct after the move.

## Notes

Only material written into this file before a work document exists. The
Mason's notes, snippets and worklog belong in
`03-the-shipped-set-shrinks.work.md`, created at `plan`.

**Architect note, 2026-09-08 · `architect`.** Every count and every line
number above was produced by running its command against this working tree on
branch `review-360`. All of them agree with the parent's "Verified counts"
table. The suite baseline was re-run the same day: 9 scenarios, 94 assertions,
0 failed.

**`tracker-pointer-resolves` is shared, and the parent credits its closure
here.** The parent lists it under this slice's "Criteria it closes" and under
slices 01 and 02 as "contributed to". Reading applied: this slice removes the
fifth carrier, which is the last one, so the grep goes empty here — but the
criterion's second half is the four renames those two slices hold, and it is
green only once all three have landed. Whichever ordering is used, a
`diff-review` of this slice alone must not read a non-empty
`grep -rn "Tracker section" socle/` as this slice's failure. Recorded rather
than resolved against the parent, which this slice may not edit.

**The `discipline.md` overlap is the parent's accepted one.** Slice 01 holds
the prototype row (line 98) and the numbered rules; this slice holds the
`triage` row (line 102). Two different rows of one table: low conflict risk,
recorded in the parent rather than engineered away. If both slices are in
flight at once, expect a trivial merge on that file and nothing more.

**The removed row carries a bare `§B` that leaves with it.** Line 102 reads
"`.agents/project.md` §B" — one of the bare section references chantier 5 owns
by name. It disappears because the row disappears, which is a by-product and
not a licence to touch the others. Parent Implementation Decision 2: a session
that helpfully sweeps has taken another chantier's work and made its diff
unreviewable.

**The CHANGELOG entry is not this slice's, and it is not slices 01 or 02's
either.** The parent's Deliverables ask for "a dated CHANGELOG entry recording
the pass, the three removals and the standing intention on `triage`". No
slice's files-to-modify map contains `project-management/CHANGELOG.md`: slices
01 and 02 exclude it and point here, and this slice's map is the shipped set
plus the fixture. The honest reading is that the entry is **task-closing**,
written at the parent's `close` step alongside the retrospective, once all
three slices have landed — one entry for the whole pass rather than three
partial ones. Ruling F1.11's standing intention on `triage`, and rule 8 of the
discipline which that entry satisfies, both belong to that single entry.
Flagged to the spawner: if the Owner would rather one slice own it, this is
the slice that performs the removals the entry has to describe, and it is the
one that runs last.

**Why this slice runs last, restated as a cost.** Nothing blocks it. Running
it first would still leave a green tree — but slices 01 and 02 would then be
renaming pointers inside `triage/SKILL.md`, a file that no longer exists, or
discovering mid-edit that it went. Running it last also means the fixture is
touched once. The parent's Ordering paragraph is the ruling; this is only the
reason.

- 2026-09-08 — **foreman** — Confirmed: the CHANGELOG entry the parent's
  Deliverables require is task-closing work, written by the thread owner at
  the parent's `close`, not a slice deliverable. Same handling as the
  previous chantier (CHANGELOG entry 24 was written at its close).

- 2026-09-09 — **foreman** — Plan-review round 1 APPROVED (program design at
  `9ae6743`; four non-blocking findings on the work document, applied at
  typing). Four spec figures had moved since 2026-09-08 because slices 01 and
  02 landed: the `triage` side-lane row is at `discipline.md:97` (not 102),
  the `prototype` row to protect at 93 (not 98), `grep -rn "Tracker section"
  socle/` is at 1 (not 5), the README carrier at `README.md:66` (not 60). The
  criteria and their after-counts are unchanged. Two Architect answers kept:
  three green commits, each removal carrying its own fixture lines (the
  spec's "touched once" is about slice order, not commit count); the moved
  page's new path is written nowhere, per parent Implementation Decision 3.
  Two escalations ruled by the thread owner under the Owner's standing go:
  E-1, the page's path stays unwritten (it sits beside the script it drives;
  `README.md` is closed slice 02's file); E-2, the present-tense skill count
  in `project-management/vendored-skills-audit.md` gets a dated one-line
  addendum from the foreman at the parent's `close`, alongside the CHANGELOG
  entry. Both reported to the Owner as reversible.
- 2026-09-09 — **foreman** — Closed. Typed in three content commits
  (`6a8a457`, `3f85960`, `beb397f`) plus the work document (`232e016`) from
  the design at `9ae6743`; fixed point `ce5beef`; Inspector at `4828bca`:
  Standards PASS, Spec PASS, every commit checked out green in a scratch
  worktree. Fixture 98 → 90, lock 16 → 14, suite 9 scenarios, 94 assertions,
  0 failed. `tracker-pointer-resolves` closes in both halves. Findings: S1, a
  diffstat in the worklog labelled with the range up to HEAD while its figures
  are those of the code range — left standing, the figures themselves are
  right; Sp1, the audit addendum of E-2 must cover the two listed skills and
  `sync-upstream` as well as the count — applied in the addendum written at
  the parent's `close`.
