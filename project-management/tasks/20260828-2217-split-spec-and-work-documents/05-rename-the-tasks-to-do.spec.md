# 05 — Rename the tasks to do

**Status:** 🟢 Complete (2026-09-02)
**Blocked by:** 01 — templates and installer (complete): the convention has
to be written down before files are renamed to match it. Slices 02–04 are
complete; this is the last slice of the task.

**What to build:** `git mv` on the unfinished task files so they carry the
`.spec.md` convention, every citing file repointed, and this task's own files
renamed last. Completed tasks and the archive keep their names untouched
(G14 point 6: « on laisse l'historique done tel quel, mais renomme les
taches à faire »).

## Acceptance criteria

This slice owns two parent criteria in full; full wording stays in
`project-management/tasks/20260828-2217-split-spec-and-work-documents.spec.md`,
§Acceptance Criteria (the first carries a dated amendment of 2026-09-02).

- [x] **tasks-still-to-do-are-renamed** (owned in full, as amended) — the
  parent's two commands both print nothing after the rename. The first
  command's BEFORE output IS the rename inventory: it is run before any
  rename, must list every unfinished file (this task's parent spec and this
  slice document included), and is pasted whole into this document's work
  record before the first `git mv`.
- [x] **no-task-citation-points-at-a-missing-file** (owned in full at task
  level — this slice is its last mover) — the parent's citation command
  prints exactly the two allowed fictional paths
  (`…/20260826-1200-fix-payroll-export.md` and
  `…/20260826-1512-x/01-thing.spec.md`) and nothing else, after every rename
  and repoint.
- [x] **archive-untouched** (slice criterion, from the parent's command
  block) — `git status` shows no change under `project-management/archive/`.
- [x] **suite-green** (slice share) —
  `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` passes with zero
  failures.

## System design

- The inventory is the parent's first command, run BEFORE any rename; its
  output is pasted whole into this document's work record. Every listed file
  is renamed `<name>.md` → `<name>.spec.md` with `git mv` (history
  preserved), completed files and the archive untouched.
- A sliced parent gets `.spec.md` like any spec document (G14 point 2); its
  completed slice documents (🟢) keep their plain names — the intermediate
  combined convention of parent decision 10 stays legible in the history.
- **Citers repointed**: every reference to a renamed path is updated so the
  parent's citation grep still prints exactly its two allowed fictional
  paths. The grep sweeps `project-management socle bin test AGENTS.md
  PHILOSOPHY.md README.md`; citers may therefore live outside this slice's
  files-to-modify map (e.g. `project-management/review-360-decisions.md`,
  `CHANGELOG.md`) — the map is indicative, such repoints are legitimate,
  and each outside-map repoint is logged in the work record.
- **This task's own files renamed last**, this slice document included
  (unfinished at rename time, it takes `.spec.md` itself); the resume
  instructions must stay true across the self-rename.
- No content change beyond citations: this slice renames and repoints, it
  rewrites no doctrine and splits no document.

## Files map

**Modify:** `project-management/tasks/` (renames and citation repoints), and
— citation repoints only, judged a posteriori — any file the citation grep
sweeps that cites a renamed path.

**Avoid:** `project-management/archive/`, every completed task file's name,
`socle/`, `bin/`, `test/`. The two untracked Owner files
(`project-management/review-360-notes.md`, `review-360-analysis.md`) are not
read, not renamed, not committed.

## Verification

- The parent's two rename commands (before and after), its citation command
  (must print exactly the two allowed fictional paths), `git status` on the
  archive, `git log --follow` spot-check on one renamed file (history
  preserved), `git diff --check`, and the exact suite.

## References

- Parent: `project-management/tasks/20260828-2217-split-spec-and-work-documents.spec.md`,
  §Acceptance Criteria (tasks-still-to-do-are-renamed as amended 2026-09-02,
  no-task-citation-points-at-a-missing-file), §Implementation Decisions 9–10,
  the slice-5 entry of §Slices & Dependencies.
- Owner rulings: `project-management/review-360-decisions.md`, G14 points 2
  and 6.

---

---

> 🧑 **REVIEW IF RELEVANT** — program design, persisted at plan time.

## Design — persisted at plan time

*Program design authored and persisted by `mason`, 2026-09-02 18:20. No system
design decision is taken here: the spec side above governs, and everything
below is the HOW.*

### Resume — read this first

This slice renames its own document. The resume invocation is therefore true in
two forms, and the later one wins:

```
work on slice project-management/tasks/20260828-2217-split-spec-and-work-documents/05-rename-the-tasks-to-do.spec.md
```

If that path does not exist, the self-rename has not happened yet and the file
is still at its plain name `…/05-rename-the-tasks-to-do.md`. Both names name
this file; nothing else changes about how it is resumed.

**The resume oracle is the parent's first command.** Re-run it at any point:
what it lists is exactly what is still to rename, and a file already carrying
`.spec.md` is already done — but read the precision, because it is a commit
property and not a step property. **Every numbered STEP below ends in a
commit; the lettered sub-steps inside one do not.** Between 1a and 1b, for
instance, command 1 prints exactly what it prints after the whole of step 1 —
the renames have landed and the repoints have not, and that command cannot
tell the difference. Interrupted at a commit boundary, the first command is
the whole oracle. Interrupted INSIDE a step, the discriminators are
`git status` (which renames are staged or on disk) plus the citation command
of §5 (which repoints are still missing), read together.

### 1 · The inventory — the parent's first command, run BEFORE any rename

Run 2026-09-02 18:20 by `mason`, from the repo root, on branch `review-360`,
before any `git mv`. Output pasted whole:

```
$ find project-management/tasks -name '*.md' ! -name '*.spec.md' ! -name '*.work.md' -exec grep -L '^\*\*Status:\*\* 🟢' {} +
project-management/tasks/20260826-1512-chisel-v2.spec.md
project-management/tasks/20260828-2217-split-spec-and-work-documents.spec.md
project-management/tasks/20260806-0959-chisel-v1.spec.md
project-management/tasks/20260826-2302-chisel-dogfoods-itself.spec.md
project-management/tasks/20260826-1512-chisel-v2/06-upgrade-v2-and-log-md.spec.md
project-management/tasks/20260828-2217-split-spec-and-work-documents/05-rename-the-tasks-to-do.spec.md
project-management/tasks/20260806-0959-chisel-v1/07-release.spec.md
project-management/tasks/20260806-0959-chisel-v1/06-pilot-migration.spec.md
```

*Paths above are shown at their post-rename names.* The rename of step 1 and
step 2 made the eight lines as printed stop resolving, and the criterion this
slice owns — **no-task-citation-points-at-a-missing-file** — reads any plain
`project-management/tasks/….md` string in this repo as a citation, this
document's own command output included (edge case (g)). They are therefore
repointed here exactly as the parent's identical inventory list was, and
**the verbatim pre-rename output is preserved unaltered in commit `0c9ee19`
"Persist the rename plan"**, which is why step 0 was a commit of its own.

**The same eight lines as they printed BEFORE the rename**, with the
`project-management/tasks/` prefix elided to `…/` so they stay visible here
without being read as citations (the rename table below uses the same
device):

```
…/20260826-1512-chisel-v2.md
…/20260828-2217-split-spec-and-work-documents.md
…/20260806-0959-chisel-v1.md
…/20260826-2302-chisel-dogfoods-itself.md
…/20260826-1512-chisel-v2/06-upgrade-v2-and-log-md.md
…/20260828-2217-split-spec-and-work-documents/05-rename-the-tasks-to-do.md
…/20260806-0959-chisel-v1/07-release.md
…/20260806-0959-chisel-v1/06-pilot-migration.md
```

Eight files, and the list already contains this slice document (🔴) and its
parent spec (🔴), so the rename set is the list itself — nothing is added to
it. The parent's Notes inventory of 2026-08-28 named six; the amendment of
2026-09-02 anticipated exactly this: the two files of this task joined the set
once this task's own spec and slice 05 became unfinished files under
`tasks/`. Of the 29 files under `tasks/`, the other 21 are 🟢 and keep their
plain names, including the four completed slices of this task (01–04) — a
completed slice document stays plain per **G14 point 6** (« on laisse
l'historique done tel quel »), so the intermediate combined convention stays
legible in the history. G14 point 2 is the other rule and is cited below for
what it actually says: a sliced parent never gets a `.work.md`.

The second command was run at the same moment and printed nothing (no
`.spec.md` file exists yet, so it cannot).

**Rename set — current path → target path** (`git mv`, history preserved):

Paths are elided to `…/` on purpose — see edge case (g): a plain
`project-management/tasks/….md` written here would be read as a citation by
the very command this slice must keep clean. The un-elided list is the fenced
paste above.

| # | Current (`tasks/` prefix elided) | Target |
|---|---|---|
| 1 | `…/20260806-0959-chisel-v1.md` | `…/20260806-0959-chisel-v1.spec.md` |
| 2 | `…/20260806-0959-chisel-v1/06-pilot-migration.md` | `…/06-pilot-migration.spec.md` |
| 3 | `…/20260806-0959-chisel-v1/07-release.md` | `…/07-release.spec.md` |
| 4 | `…/20260826-1512-chisel-v2.md` | `…/20260826-1512-chisel-v2.spec.md` |
| 5 | `…/20260826-1512-chisel-v2/06-upgrade-v2-and-log-md.md` | `…/06-upgrade-v2-and-log-md.spec.md` |
| 6 | `…/20260826-2302-chisel-dogfoods-itself.md` | `…/20260826-2302-chisel-dogfoods-itself.spec.md` |
| 7 | `…/20260828-2217-split-spec-and-work-documents.md` | `…/20260828-2217-split-spec-and-work-documents.spec.md` |
| 8 | `…/20260828-2217-split-spec-and-work-documents/05-rename-the-tasks-to-do.md` | `…/05-rename-the-tasks-to-do.spec.md` |

The two slice FOLDERS keep their names: a folder carries no suffix. No
`.work.md` is created by this slice — a sliced parent never has one (**G14
point 2**), and this slice document stays the combined plain artifact that
serves as its own work record (parent decision 10: the intermediate state is
accepted, no shim).

### 2 · The citer map — verified 2026-09-02 18:20

Swept surface: exactly the one the parent's citation command sweeps —
`project-management socle bin test AGENTS.md PHILOSOPHY.md README.md` — for
both the prefixed form (`project-management/tasks/…md`) and the bare-filename
form the parent's §Deliverables note 6 warns is invisible to that command.
The two untracked Owner files were excluded from every sweep and are not read.

**Result, stated up front: there are ZERO outside-map citers.** Every citing
file lives under `project-management/tasks/`, so this slice's files-to-modify
map holds as written and no outside-map repoint has to be justified.
`project-management/review-360-decisions.md`, `project-management/CHANGELOG.md`,
`AGENTS.md`, `PHILOSOPHY.md` and `README.md` were each checked: the changelog
and the decisions file name tasks by time id (`task 20260826-1512-chisel-v2`),
never by filename, and the three root documents cite the `tasks/` directory,
never a file in it. Nothing outside `project-management/tasks/` is touched.

| Renamed file | Citations | Citing files (`file:line`) |
|---|---|---|
| 1 `20260806-0959-chisel-v1.md` | 2 | parent spec `…split-spec-and-work-documents.md:716`, `:741` |
| 2 `…chisel-v1/06-pilot-migration.md` | 1 | parent spec `:717` |
| 3 `…chisel-v1/07-release.md` | 1 | parent spec `:718` |
| 4 `20260826-1512-chisel-v2.md` | 6 | parent spec `:719`, `:743` · `20260826-2302-chisel-dogfoods-itself.md:158` (prefixed), `:4`, `:115` (bare) · 🟢 `20260826-1512-chisel-v2/07-docs-and-dedup.md:69` (bare, **with line anchor** `:366-374`) |
| 5 `…chisel-v2/06-upgrade-v2-and-log-md.md` | 1 | parent spec `:720` |
| 6 `20260826-2302-chisel-dogfoods-itself.md` | 8 | parent spec `:721`, `:732`, `:968` · 🟢 `…split-spec…/01-templates-and-installer.md:916`, `:1011` · 🟢 `20260826-1512-chisel-v2/05-chisel-beads-convention.md:345` · 🟢 `…chisel-v2/07-docs-and-dedup.md:162`, `:465` (bare) |
| 7 `20260828-2217-split-spec-and-work-documents.md` | 10 | 🟢 `01-templates-and-installer.md:21` · 🟢 `02-doctrine-follows.md:17`, `:87` · 🟢 `03-formulas-follow.md:19`, `:105` · 🟢 `04-skills-follow.md:19`, `:117`, `:172` · this document `:17`, `:80` |
| 8 `…/05-rename-the-tasks-to-do.md` | **0 external + 1 self** | none — no other file in the repo names this document; it cites itself once, in the eight-line §1 paste, repointed at **step 3b** (edge case (g)) |

Nine distinct citing files, 29 external citations, plus this document's one
self-citation in the §1 paste (row 8). All in-map. 🟢 marks a completed file
whose **citation** is repointed while its **name** is left alone. The
`file:line` coordinates are valid against the tree of 2026-09-02 18:20 only —
see the anchoring rule at the head of §3, which overrides them.

Two forms of citation the repoint must NOT change, ruled here:

- **Bare slugs without an extension** — `20260806-0959-chisel-v1.md:146`
  (`06-pilot-migration`), `:148` (`07-release`), and
  `20260826-1512-chisel-v2.md:242` (`06-upgrade-v2-and-log-md`). The parent's
  Notes say these "should be made consistent"; **ruled: left unchanged.** They
  sit in §Slices & Dependencies numbered lists that name every slice of the
  task by bare slug — completed ones included, and those keep plain names.
  Appending `.spec` to three entries of a uniformly bare list would create the
  inconsistency the note wants removed. A bare slug names a slice, not a file,
  and nothing resolves it as a path. Recorded, declined with the reason, and
  reported to the spawner rather than acted on silently.
- **The parent's own migration inventory** at `:716`–`:721` is repointed like
  any other citation, and that is deliberate: the pre-rename snapshot is not
  lost, because the amendment of 2026-09-02 moved it here, into §1 above.

### 3 · Order of operations

Four commits. Renames use `git mv` so `--follow` keeps the history. Staging is
always explicit, path by path — never `git add -A` / `git add .` (standing rule
in this repo). Repoints are anchored on the full old string and applied only to
the nine citing files named in §2; no recursive sed over `project-management/`,
which would reach the two untracked Owner files.

**The full-old-string anchoring rule overrides every line number in this
document.** The `file:line` coordinates of §2 and §6 were read against the tree
of 2026-09-02 18:20 and are navigation aids, not addresses: any earlier repoint
in the same file shifts them, and one path in the swept surface is split across
a line break and so cannot be matched line-wise at all (edge case (b), the
hyphen-wrapped payroll path — fictional, needing no repoint, but proof that a
line-and-fragment approach misreads this surface).
So a repoint is always located by searching the full old path string in the
named file and is applied to every occurrence found there — the line numbers
are used to CHECK the count, never to drive the edit. A count that disagrees
with §2 is a stop-and-re-read, not a number to overwrite.

**Step 0 — persist and commit the plan.** This document (currently untracked)
is committed as it stands, design included. Two reasons, both load-bearing:
`git mv` refuses a file that is not under version control, and a plan that is
not committed is a plan an interruption loses.

**Step 1 — the six other files, renamed and repointed.** `git mv` on rename-set
entries 1–6, then every citation of those six repointed in the five files that
carry them (parent spec, `20260826-2302-chisel-dogfoods-itself.md`, 🟢
`07-docs-and-dedup.md`, 🟢 `05-chisel-beads-convention.md`, 🟢
`01-templates-and-installer.md`). Commit.
*State after:* the parent's first command lists exactly two files — the parent
spec and this document. Second command: nothing. Citation command: exactly the
two allowed MISSING lines.

**Step 2 — the parent spec, renamed and repointed.** `git mv` on entry 7, then
its 10 citations repointed in the four completed slice documents 01–04 and in
this document (lines 17 and 80). Commit.
*State after:* the first command lists exactly this document. This document now
cites its parent at the new name, so it is self-consistent BEFORE it moves.

**Step 3 — the self-rename, last.** `git mv` on entry 8. Row 8 of §2 reads
**zero EXTERNAL citers and one self-citation**, and the distinction is the
whole point: no other file in the repo names this document, so no other file
is edited — but this document names itself, in the eight lines of the §1
fenced BEFORE paste, and those lines stop resolving the moment step 1 renames
their targets. **Step 3b is therefore not optional and not cosmetic: without
it the citation command prints eight extra MISSING lines and the criterion is
red.** So step 3 is two acts in one commit: 3a the `git mv`, 3b the paste
treatment of edge case (g). Commit.
*State after:* both commands print nothing, and the citation command prints
exactly its two allowed lines.

**Why this sequencing survives an interruption.** The self-rename is last, its
commit carries only its own two acts (3a, 3b), and it is preceded (step 2) by
the repoint that makes this document's own parent citation true at the new
name. So at every boundary the file is complete and consistent, under one of
two names, and the Resume block at the top of this section names both. Any
fresh session re-runs the parent's first command, reads what is left, and
restarts at the first unticked box in §6.

### 4 · Edge cases, ruled in writing

**(a) A completed file cites a renamed path — repoint the citation, never the
name.** Yes, six of them: 🟢 `20260826-1512-chisel-v2/05-chisel-beads-convention.md`,
🟢 `20260826-1512-chisel-v2/07-docs-and-dedup.md`, and 🟢
`…split-spec…/01-templates-and-installer.md`, `02-doctrine-follows.md`,
`03-formulas-follow.md`, `04-skills-follow.md` (six files). Their citations are
repointed; their filenames are untouched, per G14 point 6. This is the whole
reason the criterion is "every cited path resolves" and not "every citing file
is renamed".

**(b) The two allowed fictional paths do not interact with any rename.**
Verified. `project-management/tasks/20260826-1200-fix-payroll-export.md` lives
only in 🟢 `05-chisel-beads-convention.md:309` and `:318`; its `20260826-1200`
id matches no real task and its name collides with nothing in the rename set.
`project-management/tasks/20260826-1512-x/01-thing.spec.md` lives only in
`socle/agents/skills/chisel-beads/SKILL.md:78`; its folder `20260826-1512-x`
is a different folder from `20260826-1512-chisel-v2`, and it already carries
its post-slice-04 `.spec.md` form. **Neither is touched.** The trap this rules
out: `05-chisel-beads-convention.md` carries BOTH a fictional path and a real
citation of a renamed file (`:345`), so its repoint is done on the full
`20260826-2302-chisel-dogfoods-itself.md` string only — never by a broad
`s/\.md/\.spec\.md/` over that file, which would break both fictional
citations and add MISSING lines the criterion does not allow.

**A third payroll occurrence, hyphen-wrapped and invisible to the command.**
`05-chisel-beads-convention.md` carries the payroll path three times, not
twice: `:309` and `:318` are whole, and `:307`–`:308` is split across the line
break as `project-management/tasks/20260826-1200-fix-payroll-` / `export.md`.
The criterion's own regex cannot see it, and neither can a line-anchored edit.
It needs nothing done to it — it is fictional and stays — but it is the
concrete proof of the anchoring rule at the head of §3: locate a repoint by
searching the full old string, never by trusting a line number, and never by a
pattern loose enough to catch a fragment.

**Baseline, corrected.** An earlier draft of this ruling claimed the citation
command already printed exactly the two allowed lines. **That is false and
edge case (g) is the true statement:** measured 2026-09-02 18:20, the command
prints FOUR lines — the two allowed fictional paths, plus the two
forward-looking `.spec.md` paths this document itself introduces (the resume
invocation of the Resume block, and the `git log --follow` spot-check of §5
command 6). Those two are located by section and name rather than by line
number, deliberately: the earlier drafts of this ruling pointed at `:388` and
then at `:492`, and both rotted as the file grew — the third correction is the
one that removes the coordinate instead of updating it, which is what §3's
anchoring rule says to do. Those two paths are transient and self-healing:
they name files that step 1 and step 3 create, so they resolve before
verification. What must be byte-identical BEFORE and AFTER is the pair
of FICTIONAL lines, not the command's whole output.

**(c) Line anchors and code fences — one anchor, no fences.** One citation
carries a line anchor: 🟢 `07-docs-and-dedup.md:69` reads
``(parent, `20260826-1512-chisel-v2.md:366-374`)``. The repoint preserves the
anchor exactly — `20260826-1512-chisel-v2.spec.md:366-374` — and the anchor
stays valid because `20260826-1512-chisel-v2.md` cites no renamed path (its
only reference is the bare slug at `:242`, left unchanged by (2) above), so
that file's content and line numbering do not move. A second anchor on the
same line, `(parent `:277`)` at `:162`, names no filename and is unaffected.
Code fences: a fence-aware sweep of every citing file found task-path
citations inside a fence in exactly two places, and both are the fictional
paths of (b) — `05-chisel-beads-convention.md:318` and
`chisel-beads/SKILL.md:78`. **No renamed path is cited inside a code fence.**

**(d) Nothing under `socle/` cites a real task path.** Verified against
`socle/ bin/ test/ AGENTS.md PHILOSOPHY.md README.md`: the only
`project-management/tasks/<file>.md` citation anywhere in that surface is the
fictional worked example of `chisel-beads/SKILL.md:78`, which is the
fixture-only allowance and stays. Every other occurrence is the *directory*
`project-management/tasks/` or a `<time-id>-<intention>.spec.md` naming
pattern — `socle/agents/project.md.tpl:35`, `socle/agents/methodology.md:22`,
`socle/agents/skills/slice-task/SKILL.md:85`,
`socle/agents/skills/code-review/SKILL.md:18` and `:36`,
`test/fixtures/brownfield-v1/.agents/project.md:5`, `AGENTS.md:6`. None is a
file citation, none needs a repoint, and `socle/`, `bin/` and `test/` stay in
files-to-avoid as the spec side declares.

**(e) The second command is a migration check, not a standing invariant — so
the order of verification matters.** Ruled here because it is a trap for the
`verify` step. `find … -name '*.spec.md' -exec grep -l '🟢' {} +` prints
nothing only while no completed file carries `.spec.md`. That holds throughout
this slice: at verification time both this document and its parent are still
🔴/🟡. **Two files will legitimately trip that command later, and both are
named here so neither is mistaken for a regression:**

1. `…/05-rename-the-tasks-to-do.spec.md` — the moment this slice is marked
   🟢, at the close of this slice.
2. `…/20260828-2217-split-spec-and-work-documents.spec.md` — the parent spec,
   the moment the whole task is marked 🟢 at its `close` (before `close`
   archives it, which takes it out of the command's `tasks/` scope
   altogether).

Neither is a regression: it is the new convention working. A task is born
`.spec.md` and keeps that name through completion; only pre-convention history
keeps plain names, which is exactly what G14 point 6 froze. So: **run the two
commands, and record their output, BEFORE the status line of this document is
flipped to 🟢.** The criterion is scoped to the migration, and this reading is
reported to the spawner rather than assumed.

**(f) The foreign hunk existed at first reading and is now gone — the tree is
clean.** Recorded because it shaped the plan and then stopped applying. At
18:20 `git status` showed `04-skills-follow.md` modified by another session,
and since that file is a citer of the parent spec (row 7), step 2's repoint
would have landed on top of a hunk this slice does not own. The thread owner
resolved it by committing that bookkeeping separately as **`5b0eb82` "Close
the skills slice bookkeeping"**, so the dependency is discharged: there is no
dirty-tree problem left to design around.

**Re-confirmed against the clean tree** — the parent's first command was
re-run after `5b0eb82` and printed the same eight lines, in the same order, as
the §1 paste. The inventory therefore holds unchanged, and the §1 paste is
still the BEFORE record. `git status` now shows only the three untracked files:
this document, and the two Owner files.

What survives from the ruling, because it was never about that one hunk:
**staging stays explicit, path by path**, never `git add -A` / `git add .`.
`project-management/review-360-notes.md` and
`project-management/review-360-analysis.md` are untracked, are not read by this
slice, are not renamed, and **are never staged** — a single `git add .` from
the repo root would commit both, which is the reason the rule is written here
and not left to habit.

**(g) This document is itself a citer, and its own inventory paste is the
sharpest edge of the slice.** Found by running the citation command against
this design as soon as it was persisted, 2026-09-02 18:20. The command sweeps
`project-management`, so every plain `project-management/tasks/….md` string
written *inside this file* is a citation in its eyes — including the eight
lines of the verbatim BEFORE paste in §1, which stop resolving the instant
step 1 renames them. Three rulings follow:

- **The fenced BEFORE paste stays verbatim now and is treated at step 3b**,
  and the treatment has two halves so that the finished document still SHOWS
  the before state rather than only pointing at it:
  **(i)** the eight paste lines are repointed to their `.spec.md` targets —
  the same treatment given to the parent's identical inventory list at
  `:716`–`:721`, uniform, and already licensed by parent decision 8 ("a rename
  repoints its own citers"); **(ii)** immediately beneath, the same eight lines
  are reproduced as they read BEFORE the rename with the
  `project-management/tasks/` prefix elided to `…/`, under a one-line heading
  saying so — the rename table's own precedent, and grep-invisible, so the
  criterion stays clean while a reader still sees the pre-rename list without
  opening git. Nothing is lost either way, because **the un-elided verbatim
  output is preserved forever in the step-0 commit** — the second load-bearing
  reason step 0 is a commit of its own, and how the amendment's "pasted whole
  before the first `git mv`" is honoured in full.
- **The rename table's Current column is elided to `…/` from the start**, so it
  stays historically true without ever being a resolvable-looking citation.
  The precedent is the parent spec's own use of `…/` for the two fictional
  paths, adopted there for this exact reason.
- **Forward-looking `.spec.md` full paths are left un-elided and are
  self-healing** — the resume invocation at the top of this section and command
  6 of §5 name files that do not exist yet, so the citation command reports
  them MISSING between now and the rename. That is expected and transient:
  both resolve once their step lands, and verification happens after step 3.
  The resume invocation in particular MUST stay a complete, copy-pasteable
  path, which forbids eliding it.

Consequence for the `type` step: the citation command is **red between step 0
and the end of step 3** and that is by design; it is a verification command,
not a gate to run mid-flight. Only the final run of §5 command 3 counts.

### 5 · Verification sequence

Run in this order, from the repo root, with this document still not 🟢 (see
edge case (e)):

1. `find project-management/tasks -name '*.md' ! -name '*.spec.md' ! -name '*.work.md' -exec grep -L '^\*\*Status:\*\* 🟢' {} +` → **prints nothing**.
2. `find project-management/tasks -name '*.spec.md' -exec grep -l '^\*\*Status:\*\* 🟢' {} +` → **prints nothing**.
3. The citation command — run only after step 3 and after the §1 paste has
   been repointed (edge case (g)) → **exactly two lines**:
   `MISSING project-management/tasks/20260826-1200-fix-payroll-export.md` and
   `MISSING project-management/tasks/20260826-1512-x/01-thing.spec.md`.
4. Bare-name sweep — this slice's own extra net, since command 3's pattern
   needs the `project-management/tasks/` prefix and so cannot see a citation
   by bare filename (the parent's §Deliverables note 6 says as much). **The
   sweep must exclude THIS document, under both its names**, and the reason is
   arithmetic, not convenience: measured against the tree of 2026-09-02 18:52,
   the sweep returns **65 hits, of which 38 are inside this document itself** —
   the resume block's plain-name sentence, the rename table's Current column,
   every row of the §2 citer map, the bare-slug declination, the prose of these
   rulings, and the command's own lines, which list the eight names they grep
   for. (An earlier draft measured 61/34; restating the command as the wrapped
   block below added **four** internal hits, all of them the block's own
   lines — the oracle counting itself, which is precisely the defect the
   exclusion fixes.) Those 38 are this slice's historical record and are
   *supposed* to survive step 3b; an oracle that demanded they disappear could
   never go green. The **27** hits outside this document — unchanged by any of
   this — are exactly the 29 external citations of §2 minus the two that live
   on this document's own spec side, i.e. precisely the set the repoints must
   move.

   ```sh
   grep -rn --exclude=review-360-notes.md --exclude=review-360-analysis.md \
     --exclude=05-rename-the-tasks-to-do.md \
     --exclude=05-rename-the-tasks-to-do.spec.md \
     -e '20260826-1512-chisel-v2.md' -e '20260826-2302-chisel-dogfoods-itself.md' \
     -e '20260806-0959-chisel-v1.md' -e '20260828-2217-split-spec-and-work-documents.md' \
     -e '06-pilot-migration.md' -e '07-release.md' \
     -e '06-upgrade-v2-and-log-md.md' -e '05-rename-the-tasks-to-do.md' \
     project-management socle bin test AGENTS.md PHILOSOPHY.md README.md
   ```

   **Pass condition: no hit outside this document** — every one of the 27 has
   become a `.spec.md` path, so none of the eight bare old names matches any
   more. Both `--exclude` names are passed because the document answers to the
   plain one before step 3 and the `.spec.md` one after it, and the sweep
   should read the same on either side. (Equivalent formulation, if the
   exclusions are ever dropped: *every hit is either a `.spec.md` path or
   inside this document's own historical record.* The intent is identical —
   catch the bare-name citers command 3 misses.)
5. `git status --porcelain project-management/archive/` → **empty**
   (archive-untouched).
6. `git log --follow --oneline -- project-management/tasks/20260826-2302-chisel-dogfoods-itself.spec.md | tail -3` → shows commits predating the rename (history preserved).
7. `git diff --check` → **prints nothing**.
8. `PATH="/opt/homebrew/bin:$PATH" bash test/run.sh` → **9 scenarios, 94
   assertions passed, 0 failed** (the `PATH` prefix is mandatory: without it
   the formula parse check SKIPs and the suite announces a green it did not
   check).

### 6 · Implementation

Line numbers below are checks, not addresses — locate every repoint by
searching the full old path string in the named file (anchoring rule, head of
§3).

- [x] **Step 0** — this design persisted, Architect round-1 revisions folded
      in; `git add` this document only; commit ("plan for slice 05
      persisted"). Two effects: the file becomes tracked so `git mv` can move
      it at step 3, and the commit is the evidentiary snapshot holding the
      verbatim BEFORE paste (edge case (g)).
- [x] **Step 1a** — `git mv` rename-set entries 1–6 to their `.spec.md` targets.
- [x] **Step 1b** — repoint the citations of entries 1–6: parent spec `:716`–`:721`, `:732`, `:741`, `:743`, `:968`; `20260826-2302-chisel-dogfoods-itself.spec.md:4`, `:115`, `:158`; 🟢 `07-docs-and-dedup.md:69` (anchor preserved), `:162`, `:465`; 🟢 `05-chisel-beads-convention.md:345`; 🟢 `01-templates-and-installer.md:916`, `:1011`.
- [x] **Step 1c** — commands 1–4 of §5 read; diff read line by line; explicit `git add` of the renamed and repointed paths; commit.
- [x] **Step 2a** — `git mv` the parent spec (entry 7) to `…split-spec-and-work-documents.spec.md`.
- [x] **Step 2b** — repoint its 10 citations: 🟢 `01:21`, 🟢 `02:17`, `:87`, 🟢 `03:19`, `:105`, 🟢 `04:19`, `:117`, `:172`, and this document `:17`, `:80`.
- [x] **Step 2c** — commands 1–4 of §5 read; explicit `git add`; commit.
- [x] **Step 3a** — `git mv` this document to `05-rename-the-tasks-to-do.spec.md`. Zero EXTERNAL citers, so no other file is edited (§2 row 8).
- [x] **Step 3b** — **required, not cosmetic** (§3 step 3, edge case (g)): the
      eight lines of the §1 fenced BEFORE paste repointed to their `.spec.md`
      targets, AND the same eight lines reproduced immediately beneath with the
      `project-management/tasks/` prefix elided to `…/`, under a heading saying
      they are the pre-rename form, plus the one-line note that the verbatim
      output is preserved in the step-0 commit. Without 3b the citation command
      prints eight extra MISSING lines.
- [x] **Step 3c** — explicit `git add` of the renamed document only; commit. Last mutation of the slice.
- [x] **Verify** — the full §5 sequence, commands 1–8, outputs pasted into the worklog below.
- [x] **Report** — the bare-slug declination of §2, the edge-case (e) reading
      of the second command (both files it will later trip), and the edge-case
      (g) treatment of this document's own inventory paste, reported to the
      spawner.

### 7 · Worklog

*One entry per commit at the `type` step. Plan-step revisions are logged here
too, since the design is the deliverable of `plan`.*

- **2026-09-02 18:20 — `mason` — design persisted.** Inventory run before any
  rename (8 files), citer map swept (9 files, 29 external citations, zero
  outside-map), sequencing and edge cases (a)–(g) ruled. Nothing renamed,
  nothing committed.
- **2026-09-02 18:41 — `mason` — Architect round 1 folded in, NOT VALIDATED →
  revised.** One blocking defect was mine and is fixed; one was dissolved by
  the thread owner; seven adjustments applied. Still `plan` only: no rename, no
  commit.
  - *Blocking (mine) — §5 command 4's oracle was unsatisfiable.* The Architect
    ran it: 61 hits, 34 of them inside this document, most of which
    legitimately survive step 3b — including the command's own line, which
    greps for the eight names it lists. Restated with `--exclude` on both of
    this document's names and the pass condition "no hit outside this
    document", intent unchanged. Counts re-measured after the restatement:
    **65 total / 38 self / 27 external** — the +4 are the wrapped command
    block's own lines, the oracle counting itself; the 27 external match §2's
    29 minus this document's own 2 exactly, and are what the repoints move.
  - *Blocking (dissolved) — the foreign hunk in `04-skills-follow.md`* was the
    thread owner's slice-04 close bookkeeping, now committed as `5b0eb82`.
    Edge (f) rewritten: the dirty-tree problem is gone, the parent's first
    command was re-run against the clean tree and printed the same eight lines,
    and what survives is the explicit-staging rule and the never-stage rule for
    the two untracked Owner files.
  - *Adjustments.* Count corrected to 21 remaining 🟢 files (29 total minus 8);
    the plain-name-for-done ruling re-attributed to **G14 point 6** (point 2 is
    the never-a-`.work.md`-for-a-parent rule, now cited only where it applies);
    citer-map row 8 restated as "0 external + 1 self" with step 3b made
    explicitly load-bearing in §3; the full-old-string anchoring rule promoted
    to the head of §3 and declared to override every line number in this
    document; the resume claim corrected from "every step is its own commit" to
    the commit/sub-step distinction, with `git status` + the citation command
    named as the mid-step discriminators; edge (b)'s false baseline replaced —
    the command prints four lines, not two, and edge (g) is the true statement —
    with the third, hyphen-wrapped payroll occurrence at
    `05-chisel-beads-convention.md:307`–`:308` recorded as the proof of the
    anchoring rule; step 3b extended to reproduce the eight BEFORE lines in
    elided form so the finished document still shows the pre-rename state; edge
    (e) extended to name both files that will legitimately trip the second
    command once 🟢 — this document at slice close, the parent spec at task
    close.
  - *Endorsed by the Architect and left untouched at round 1:* the inventory
    (byte-identical), the citer map (every count and line exact), the
    four-commit sequencing, rulings (a)–(e) and (g), the bare-slug declination,
    and the suite's insensitivity to the rename (9/94/0).
- **2026-09-02 18:52 — `mason` — Architect round 2: VALIDATED. Three
  design-record fixes folded in, then typing opened.** No design decision
  moved; all three were stale or self-contradicting text.
  - *The sweep measurement was stale.* Restating §5 command 4 as a wrapped
    `sh` block added four internal hits — the block's own lines listing the
    eight names it greps for. Corrected everywhere from 61/34 to **65/38**;
    the 27 external hits are unchanged, and still match §2's 29 minus this
    document's own 2.
  - *A pointer had drifted.* Edge (b) named §5 command 6 at `:388`; the
    round-1 rewrite of command 4 pushed it to `:492`. Fixed — and it is the
    second live demonstration of §3's anchoring rule, which is why line
    numbers in this document are checks and never addresses.
  - *Two sentences contradicted each other about step 3.* §3 said the
    self-rename is "alone in its commit" three lines after saying that commit
    carries 3a and 3b. Reworded to "its commit carries only its own two acts
    (3a, 3b)" — the intended meaning throughout: no OTHER step rides along,
    and 3b is never optional.
- **2026-09-02 18:52 — `mason` — Step 0 done: the evidentiary snapshot.** This
  document committed at its plain name with an explicit path — never
  `git add .` / `-A`, so `review-360-notes.md` and `review-360-analysis.md`
  stay untracked and unstaged, at this and every step. The commit freezes the
  verbatim BEFORE inventory paste of §1 (edge case (g)) and makes the file
  tracked, which is what lets step 3a move it with `git mv`. Nothing renamed
  yet. Committed as **`0c9ee19`** "Persist the rename plan".
- **2026-09-02 18:56 — `mason` — Step 1 done: the six other files renamed and
  repointed.** `git mv` on rename-set entries 1–6 (git recorded all six as
  `R`, so `--follow` will cross them), then their citations repointed in the
  five citing files of §2 rows 1–6.
  **19 citations repointed, and the per-file counts matched §2 exactly** —
  parent spec 10, `20260826-2302-chisel-dogfoods-itself.spec.md` 3,
  🟢 `07-docs-and-dedup.md` 3, 🟢 `05-chisel-beads-convention.md` 1,
  🟢 `01-templates-and-installer.md` 2 (19 = 2+1+1+6+1+8, rows 1–6). Every
  repoint was located by searching the full old path string, not by line
  number, per the anchoring rule of §3; the bare filename form was used as the
  search key because it subsumes the prefixed form, so a single pass fixed
  both shapes of citation.
  *Edge cases that fired, as designed:* the line anchor of 🟢
  `07-docs-and-dedup.md:69` survived intact as
  `20260826-1512-chisel-v2.spec.md:366-374` (edge (c)); the three fictional
  payroll occurrences in 🟢 `05-chisel-beads-convention.md` — including the
  hyphen-wrapped one at `:307`–`:308` — were left untouched while the real
  citation in the same file was repointed (edge (b)); and the citation command
  is legitimately red at this point, printing six extra MISSING lines that all
  come from this document's own §1 BEFORE paste and nothing else (verified by
  a per-path citer sweep), which is precisely what step 3b exists to close
  (edge (g)).
  *State read before committing:* command 1 lists exactly the two self files;
  command 2 prints nothing; the restated command 4 returns only the eight
  parent-spec citations that step 2 owns; `git diff --check` clean.
  Committed as **`fd1e252`** "Rename the unfinished tasks to spec documents".
- **2026-09-02 18:59 — `mason` — Step 2 done: the parent spec renamed and
  repointed.** `git mv` on rename-set entry 7, then its **10 citations
  repointed, per-file counts matching §2 row 7 exactly**: 🟢
  `01-templates-and-installer.md` 1, 🟢 `02-doctrine-follows.md` 2, 🟢
  `03-formulas-follow.md` 2, 🟢 `04-skills-follow.md` 3, and this document 2.
  *One deliberate restriction, and it is the reason step 2 could not be a
  blind full-string pass.* This document holds THREE occurrences of the
  parent's old path, not two: the citations at `:17` and `:80` on its spec
  side, which are step 2b's, and one at `:132` inside the §1 fenced BEFORE
  paste, which is step 3b's and had to stay verbatim for one more commit. So
  in this file only, the repoint was applied to the two spec-side lines and
  the paste occurrence was left alone; every other file took the full-string
  pass. Counted and asserted line by line rather than trusted.
  *State after:* command 1 lists exactly this document — the last unrenamed
  file; command 2 prints nothing; the restated command 4 **already returns
  nothing outside this document**, so every external citation in the repo is
  now correct and only this document's own self-citation remains;
  `git diff --check` clean. This document now cites its parent at the new
  name, so it is self-consistent BEFORE it moves, which was the point of
  sequencing the self-rename last.
  Committed as **`3bb0c79`** "Rename the parent spec and repoint its citers".
- **2026-09-02 19:02 — `mason` — Step 3 done: the self-rename, and the paste
  closed.** 3a: `git mv` of this document to
  `05-rename-the-tasks-to-do.spec.md` — recorded `R` by git, no other file
  edited, because row 8 of §2 is zero EXTERNAL citers. 3b: the eight lines of
  the §1 fenced BEFORE paste repointed to their `.spec.md` targets, and the
  same eight reproduced immediately beneath with the
  `project-management/tasks/` prefix elided to `…/`, under a heading naming
  them the pre-rename form, plus the note that the verbatim output survives in
  `0c9ee19`. The document therefore still SHOWS the before state without
  tripping the grep.
  *The proof that 3b was load-bearing and not cosmetic:* immediately before
  it, the citation command printed **nine** MISSING lines — the two allowed
  fictional paths, the six old plain paths of the paste, and one transient
  forward-looking `.spec.md`; immediately after it, **exactly the two allowed
  fictional lines and nothing else**. Everything closed by 3b came from this
  document's own command output, exactly as edge case (g) predicted at plan
  time. Committed as **`7233023`** "Rename the rename slice itself".
- **2026-09-02 19:05 — `mason` — Verification: all eight commands green.** Run
  from the repo root on a tree clean apart from the two untracked Owner files,
  and run **before any status line was flipped**, per edge case (e). Raw
  output:

  ```
  1. find … ! -name '*.spec.md' ! -name '*.work.md' -exec grep -L '🟢'   → (nothing)
  2. find … -name '*.spec.md' -exec grep -l '🟢'                          → (nothing)
  3. citation criterion
     MISSING project-management/tasks/20260826-1200-fix-payroll-export.md
     MISSING project-management/tasks/20260826-1512-x/01-thing.spec.md
  4. bare-name sweep, this document excluded                              → (nothing)
  5. git status --porcelain project-management/archive/                   → (nothing)
  6. git log --follow -- …/20260826-2302-chisel-dogfoods-itself.spec.md
     fd1e252 Rename the unfinished tasks to spec documents
     bfb5e2a Dogfood : l'Owner tranche pour la copie réelle installée par init
     7807bcf Task post-v2 : chisel s'équipe du socle qu'il livre
  7. git diff --check                                                     → (nothing)
  8. PATH="/opt/homebrew/bin:$PATH" bash test/run.sh
     === 9 scenarios, 94 assertions passed, 0 failed ===
  ```

  Commands 1 and 2 both print nothing, so
  **tasks-still-to-do-are-renamed** holds in both directions. Command 3 prints
  exactly the two allowed fictional paths, so
  **no-task-citation-points-at-a-missing-file** holds. Command 5 is empty, so
  **archive-untouched** holds. Command 8 matches the 2026-08-28 baseline
  assertion for assertion, so **suite-green** holds and the rename is invisible
  to the suite, as expected — nothing in the code parses a task filename.
  Command 6 shows `--follow` walking straight through the rename commit into
  the file's pre-rename history, so no history was lost.

- **2026-09-02 19:12 — `mason` — Inspector Standards findings folded in.**
  Both review axes passed; the three findings were all in this work record,
  none in the renamed or repointed files, and none touched a criterion.
  - *The `## Notes` section had gone stale.* It still said "nothing is renamed
    and nothing is committed yet", false since `0c9ee19`. Rewritten to state
    what actually happened — five commits, all eight files renamed, the four
    criteria green — and to record the Architect's round 2, which the section
    omitted entirely. Corrected in place: Notes is a status paragraph, not a
    never-erased log, and the never-erased history lives here in §7.
  - *Edge (b)'s pointer had rotted a third time.* It named §5 command 6 at
    `:492`; step 3b's insertion pushed the command to `:526`. **Fixed by
    removing the coordinate rather than updating it** — the ruling now points
    by section and name ("the `git log --follow` spot-check of §5 command 6",
    "the resume invocation of the Resume block"), which is what §3's anchoring
    rule prescribes and which cannot rot again. Two successive corrections of
    the same number were the evidence that updating it was the wrong repair.
  - *One line had run to 100 columns.* The round-2 "two acts (3a, 3b)"
    rewording did not re-wrap its paragraph. Re-wrapped to the file's ~78
    columns; no word changed.
  - *Not touched, and why:* the three Spec-axis findings are escalations to the
    Owner and are not the Mason's to act on; the parent spec and every other
    file were left alone. One pre-existing 87-column line survives in edge (a)
    — its overflow is a single 57-character inline path that cannot be broken
    without splitting the path, and it was not among the findings.

**Left alone, deliberately.** The status line of this document still reads
🔴 Not Started, and flipping it is not the Mason's act: parent decision 3 gives
the single status to the thread owner. Two consequences of edge case (e) travel
with that flip and are repeated here so they are not read as regressions —
command 2 will legitimately print `…/05-rename-the-tasks-to-do.spec.md` once
this slice is marked 🟢, and `…/20260828-2217-split-spec-and-work-documents.spec.md`
once the task is marked 🟢 at its `close`.

### Inspector findings — diff-review, and close

- 2026-09-02 19:05 — **foreman** — Slice closed at commit `65dae26` (the
  operation itself: `0c9ee19`..`9c189b4`). Both Inspector axes passed; the
  three Standards findings were fixed in `65dae26`. Per edge case (e), the
  parent's second rename command now legitimately prints this file — the
  convention working, not a regression. Three Spec-axis findings are
  **escalations awaiting the Owner at task `close`**, recorded here per G17:
  1. Parent decision 10's licence ("until the formulas slice lands") has
     expired: this slice's program design was persisted in this combined
     document while the landed formulas mandate a `.work.md` at `plan`. The
     repo ships a convention its last slice did not follow — accept as an
     archived intermediate state, or open a follow-up.
  2. Two `.spec.md` files carry pre-convention content: the parent spec's
     five 🤖 AGENT ZONE banners, and this document's combined work record.
     No criterion catches it; decisions 9–10 accept it; the Owner rules at
     `close`.
  3. In the parent spec: the 2026-08-28 dated inventory snapshot was
     repointed to post-rename names (the BEFORE state is preserved in
     `0c9ee19` and `…/`-elided in this document's §1), and the Notes'
     "should be made consistent" on bare slugs stands unamended against
     this slice's reasoned, twice-endorsed declination.

## Notes

Created 2026-09-02 at the start of slice 05. Program design persisted
2026-09-02 18:20 by `mason`, revised 18:41 after the Architect's round-1
NOT VALIDATED, and revised again 18:52 after round 2, which returned
VALIDATED with three design-record fixes.

**Typed, renamed and verified 2026-09-02** across five commits — `0c9ee19`
(the plan, and the evidentiary snapshot of the BEFORE inventory), `fd1e252`
(the six other files), `3bb0c79` (the parent spec), `7233023` (this document's
own self-rename and its paste), `9c189b4` (the verification record). All eight
files of the inventory carry `.spec.md`, all 29 external citations are
repointed, and the four acceptance criteria are green: both rename commands
silent, the citation command down to its two allowed fictional paths, the
archive untouched, the suite at 9 scenarios / 94 assertions / 0 failed. The
`Status:` line above is the thread owner's to move, not the Mason's (parent
decision 3); §4 edge case (e) says what that flip will legitimately do to the
second rename command. Step-by-step detail is in §7, the worklog.
