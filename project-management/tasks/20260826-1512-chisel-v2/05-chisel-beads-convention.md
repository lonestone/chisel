# 05 — chisel-beads: neutralized install + the convention

**Status:** 🟢 Complete
**Blocked by:** 04, 08

**What to build:** The B1 = beads branch, end to end — validated in vivo by
`../factory-bench/prototypes/cohab-bd-init.md`. When the user picks beads, the
setup: requires a CLEAN working tree (bd's auto-commit is unavoidable — no
config disables it), runs `bd init`, re-owns the auto-commit under its own
message, then NEUTRALIZES the beads discourse: `bd setup claude --remove` +
`bd setup codex --remove`, strip of the BEADS block in AGENTS.md by its
BEGIN/END markers, removal of the vendored `beads` skill (one normative
discourse in the repo — Q16-b), `.beads/hooks/` kept. In its place, the
**chisel-beads convention** (normative socle text): the bead points to the
spec via `--spec-id` and never contains it (`design`/`acceptance_criteria`
EMPTY by convention; `bd lint`/validation left off or configured
accordingly); inter-task coordination (status, claim/lease, edges, priority)
lives in the bead, intra-task progression (implementation checkboxes = the
Mason resume point) stays in the MD; roles sign with `--actor`
architect/mason/inspector; `external_ref` reserved for the B2 bridge. Team
routine: `bd dolt pull` at session start, `bd dolt push` at session end;
guards in black and white: never `git push --mirror` (destroys
`refs/dolt/data`), verify the assignee after every claim while
gastownhall/beads#3575 is open. Plus the tooled **markdown→beads upgrade**:
re-run of setup §B creating beads for OPEN tasks only, `--spec-id` to their
MD files, blocking edges recreated, archive untouched.

## Acceptance criteria

- [x] Setup with B1 = beads on a dirty-tree fixture refuses and says why; on
      a clean tree it completes with: no BEADS block in AGENTS.md/CLAUDE.md,
      no SessionStart `bd prime` hook, no vendored `beads` skill, bd CLI
      still functional (`bd create`/`bd ready`), `chisel check` clean
- [x] A task created under the convention on the fixture yields a bead with
      `--spec-id` set to the MD file, empty design/ACs fields, `--actor` per
      role — asserted via `bd show`
- [x] The convention text carries the sync routine and the two guards
      verbatim (`push --mirror`, assignee-after-claim) and states when server
      mode applies (simultaneous agents on one machine only)
- [x] markdown→beads upgrade on a fixture with open + archived tasks: beads
      exist for open tasks only, edges match the files' "Blocked by", archive
      byte-intact; the MD files lose coordination state (status/who) to the
      beads

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time

**The shape of the answer: two prose pages, zero new shell.** This slice ships
one new skill — `chisel-beads` — made of a convention page read every session
and a case-change page read once, plus the wiring that sends a reader to them.
Nothing executable is added to the socle. The reasoning is under "Triage" below;
the short version is that the socle only ships shell the suite exercises, and
the suite has no room to exercise any (`test/TESTS.md`, rules 2 and 3).

### Triage of the frozen draft

The draft lives, uncommitted, in the worktree at
`/private/tmp/claude-501/-Users-pierrickbignet-Documents-Projects-SDD-bench/c114baef-c3c1-45aa-9380-efb89c03cade/scratchpad/wt-slice05`.
Read the pieces marked REUSED there and carry the prose over; it is good prose
and rewriting it from scratch would only lose it.

| Piece of the draft | Verdict | Reason |
|---|---|---|
| `chisel-beads/SKILL.md` §1 what owns what, §2 creating a bead, §3 routine, §4 the two guards, §5 one machine several agents | **REUSED**, split across two pages (below) | It is the convention the four ACs ask for, and it is written. |
| `chisel-beads/SKILL.md` §6 changing case, §7 if the database has to go | **REUSED**, moved to the case-change page | Read once, at a case change — not every session, which is what the convention page is for. |
| The `bd lint` / `validation.on-create` paragraph of §2 | **REUSED verbatim in substance** | Matches what was tested (`../factory-bench/research/skills-beads-recouvrement.md`): validation is opt-in, lint has no scoping key, so the rule is "do not wire it in". |
| `scripts/init-neutralized.sh` (241 lines) | **REJECTED as shell, REUSED as text** | Its header comments and its refusal messages become the case-change page; its command sequence becomes a numbered, copy-pasteable block. A destructive sequence that no test can run is safer as commands an agent issues one at a time, watching each output, than as a script that warns-and-continues on the three cases where it is unsure (last commit not bd's, `.beads/formulas` already real, `bd setup --remove` failing). |
| `scripts/push-verify.sh` (64 lines) | **REJECTED as shell, REUSED as a three-command routine** | Its whole value is `git ls-remote <remote> refs/dolt/data` before and after the push — three commands in the convention, transparent, typeable by a human. As a script it exits 1 on the ordinary "nothing to send" case, by its own admission; a verification that cries wolf is one nobody runs. |
| `scripts/md-to-beads.sh` (185 lines) | **REJECTED as shell, REUSED as a procedure** | AC4 is bulk but not blind: parsing `**Blocked by:** 04, 08 (both delivered)` is guesswork the draft does with token heuristics, and a wrong guess makes a silently wrong edge. An agent reading the open task files has the context to resolve them and the diff is reviewed before commit. Untested, destructive shell shipped into every user's repo is the worse trade. |
| `scripts/pre-push-mirror-guard.sh` (139 lines) + its `.beads/hooks/pre-push` block | **REJECTED outright** | No AC asks for it (AC3 asks that the rule be *written*), and the guard is heuristic by construction: it walks the process tree for a `--mirror` on a git command line, is defeated by `--no-verify`, does not exist in a fresh clone until `bd hooks install` runs, and its own comments say the only complete protection is remote-side. A guard believed absolute is worse than a written rule. The written rule stays, and it carries the remote-side `receive.denyDeletes` recommendation as the real protection. See "Reported to the Owner" below — the parent task's slice list still names this hook. |
| The `chisel-setup/SKILL.md` Step 6 rewrite | **REUSED reduced** | Its clean-tree blockquote and its closing blockquote are exactly right and are kept. The parts that inline the gestures are dropped: Step 6 hands off to the case-change page instead of restating it. |
| `test/run.sh` and `test/TESTS.md` changes (534 lines, groups 14/15/16, the `SKIP:` mechanism) | **REJECTED** | Already ruled by the Owner in the parent task. They are also the old 1580-line `run.sh`, replaced by slice 09 — dead against today's tree. |
| `project-management/CHANGELOG.md` entry | **REJECTED as written** | It describes the shipped scripts. A fresh entry is written at close. |

### Open question 1 — where the installed formulas live for bd

**Settled: single source `.agents/formulas/`; the case change creates the
relative symlink `.beads/formulas -> ../.agents/formulas`. No copy.**

This ratifies the parent task's ruling of 2026-08-26 (`Notes & Snippets`,
first bullet), which was verified live on bd 1.2.2: `bd formula list` and
`bd mol pour` both resolve through a directory symlink, and bd's documented
search order puts `.beads/formulas/` at repo scope
(`../factory-bench/research/gates-formulas-beads.md` §2). A copy is rejected
for a reason the ruling does not spell out and that matters here: `.beads/` is
not in chisel's manifest, so a copied formula is a second place `chisel update`
would have to write and `chisel check` could never watch. The symlink is the
same pattern `bin/chisel.sh` already uses for `.claude/skills ->
../.agents/skills`.

Two rules for the case-change text: the link is created only by the case
change (a repo without the database has no `.beads/`), and if `.beads/formulas`
already exists as a real directory it is left alone and reported — never
replaced.

### Open question 2 — the bd prerequisite, and bd absent

**Settled: minimum 1.2.2; the version number and the refusal wording stay
where they already are, in `chisel-setup` Step 6 — this slice does not
duplicate them.**

Steps 6.1 and 6.2 of `socle/agents/skills/chisel-setup/SKILL.md` already carry
the ruling of 2026-08-26 (parent `Notes & Snippets`, third bullet): compare
`bd --version` against 1.2.2, never install anything, print the install command,
and offer to keep the statuses in the task files — the move being tooled, that
choice costs nothing later. Nothing there changes.

The case-change page therefore states the *check*, not the number: its
preconditions say the tool must be present at the version the setup's
coordination question names, that the setup normally checked it already, and
that a reader who arrived here another way checks it and stops if it fails —
sending the user back to that question rather than improvising an install. One
version constant in the socle, one screen that speaks about installing.

### Files touched

- `socle/agents/skills/chisel-beads/SKILL.md` — NEW. The convention, read
  before creating, claiming, closing or syncing anything. Frontmatter
  `description` as drafted (it is what makes the skill findable). Carries: what
  the bead owns versus what the task file owns; the one `bd create` shape
  (`--spec-id`, empty design/acceptance/description, `--actor` = the role,
  `external_ref` reserved for §B2); validation off and `bd lint` not wired in;
  the session routine (`bd bootstrap` on a fresh clone, `bd dolt pull` at
  start, push-then-verify-the-remote-ref at end); the two guards with their
  commands and their honest limits; when the served mode applies (several
  agents at once on ONE machine — never the answer to "we are several people").
  Points at the case-change page for leaving.
- `socle/agents/skills/chisel-beads/CHANGING-CASE.md` — NEW. The one-time
  operations, all three: entering the database case (preconditions, the
  numbered command sequence, the neutralisation, the symlink, one commit staged
  on explicit paths), converting existing open task files, and the exit plan.
  Points back at `SKILL.md` for the convention itself.
- `socle/agents/skills/chisel-setup/SKILL.md` — Step 6 only. Steps 6.1 and 6.2
  unchanged; the clean-tree announcement and the closing blockquote come from
  the draft; the gestures become "run the case-change page's *entering* section"
  plus the §B1 write and the confirmation read-back. Every other step of this
  skill stays byte-identical.
- `socle/agents/project.md.tpl` — §B1 only, inside the existing comment block
  that already describes the database case: one line naming
  `.agents/skills/chisel-beads/SKILL.md` as the convention. The default case's
  visible text does not change.
- `test/fixtures/golden-tree.txt` — the two new files and their directory.
- `project-management/CHANGELOG.md` — one dated entry at close.

### What the test suite gets, and does not

`test/TESTS.md`'s three standing rules apply here exactly as written there.
Read them before touching `test/`. Two consequences for this slice:

- **No new group, no new assertion, no new line.** The suite stands at 588
  lines of its 600-line cap, and this slice offers no group for deletion. Do
  not buy room by deleting or thinning an existing group — that is another
  slice's decision, not this one's.
- **The only test-side change is data**: `test/fixtures/golden-tree.txt` gains
  the new skill's entries, or group `init` goes red. Group `integrity` then
  walks the new pages' `.agents/...` pointers for free — every one of them must
  resolve in the installed tree.

The four ACs are verified in vivo, in step 4 below, because bd is an external
tool the suite has no way to require and no budget to exercise. AC3 is a
wording check: `test/TESTS.md` rule 1 already says where those are verified.

### Execution order

Each step ends on `bash test/run.sh` green and its own commit. Never
all-or-nothing.

1. **The convention page.** Write `socle/agents/skills/chisel-beads/SKILL.md`
   from the draft's §1–§5, minus every reference to a script: the push becomes
   the three-command routine, the claim stays the two-command routine already
   drafted, the mirror rule loses the sentence about the posed hook and keeps
   the remote-side recommendation. Add the fresh-clone `bd bootstrap` line to
   the routine — the draft has none, and a clone without it has no database to
   pull (`../factory-bench/research/sync-embedded-defaillances.md` §1). Update
   `test/fixtures/golden-tree.txt`. Green → commit.
2. **The case-change page.** Write
   `socle/agents/skills/chisel-beads/CHANGING-CASE.md` from the draft's §6, §7
   and the header comments of `init-neutralized.sh`. Entering: preconditions
   (bd present at the version the setup names; clean tree, because `bd init`
   commits the whole repository and no setting disables it; `.agents/` present);
   `bd init --prefix`; re-own the auto-commit with `git reset --soft HEAD~1`
   **only** when the last commit is bd's own, and leave it alone when it is the
   repo's first; `bd setup claude --remove` and `bd setup codex --remove`;
   strip the BEGIN/END BEADS block from `AGENTS.md`; remove
   `.agents/skills/beads/` if the removals left it; the formulas symlink; then
   one commit staged on the exact paths bd touches (`.beads`, `AGENTS.md`,
   `CLAUDE.md`, `.claude`, `.codex`, `.agents`) — **never `git add -A` at the
   repo root**, a rule that is stated in the page, not just obeyed by it.
   Converting: one bead per OPEN task file with `--spec-id` back to it, the
   blocking edges from the files' own `**Blocked by:**` lines (`bd dep add X
   --blocked-by Y`, never `--deps blocks:` — it means the inverse), the archive
   never opened, the `**Status:**` line of each open file handed over to name
   its bead, nothing committed until the diff has been read. Leaving: the
   draft's §7, unchanged in substance. Update the golden tree. Green → commit.
3. **The wiring.** Step 6 of `chisel-setup` as described above, and the §B1
   comment line in `socle/agents/project.md.tpl`. Green → commit.
4. **In vivo, then close.** Run the whole branch against real bd on a scratch
   fixture — **never on this repo** (chisel adopts beads only after v2, Owner's
   ruling in the parent task). Build it outside the repo from
   `test/fixtures/brownfield`: `git init`, one commit, `bin/chisel.sh init`.
   Then, following the pages as a reader would, not as their author:
   - **AC1** — dirty tree: touch a file, start the entering sequence, confirm
     it stops and says why, and that no `.beads/` was created. Then commit and
     re-run clean: no BEADS block in `AGENTS.md` or `CLAUDE.md`, no SessionStart
     `bd prime` in `.claude/settings.json`, no `.agents/skills/beads/`,
     `bd create` and `bd ready` still answer, `bin/chisel.sh check` clean, one
     chisel-owned commit in `git log`, and `bd formula list` resolving through
     the symlink.
   - **AC2** — create a task file on the fixture, create its bead by the
     convention, run `bd show`. **Paste what bd actually prints** into the Notes
     and correct the sample block in `SKILL.md` if it differs: the draft's
     sample (`Spec:`, `(none)`, `Owner: … · Assignee: …`) came from a session
     that crashed, and normative text must not show output nobody re-read.
   - **AC4** — give the fixture two or three open task files with a
     `**Blocked by:**` between them plus an archive holding one, run the
     conversion, then check: beads for the open files only, the edge present in
     `bd show`, the archive byte-identical (checksum before and after), and the
     open files' status lines naming their beads.
   - **AC3** — the wording check, at review.
   Correct whatever reality contradicts, tick the ACs with what was observed,
   write the worklog and the dated CHANGELOG entry, set the status. Green →
   commit. Remove the scratch fixture.

### Out of scope

- Any shell shipped in the socle for this branch — the four scripts above and
  any successor. If the Mason concludes mid-slice that a gesture cannot be
  written as prose, that is an escalation, not a script.
- The `.beads/hooks/pre-push` guard block and the hook composition around it.
- New test groups, new assertions, and any thinning of an existing group to
  make room for them.
- The served mode (B1 option 3): shown as "not supported yet", never offered.
- The §B2 external-tracker bridge. `external_ref` is named as reserved and
  nothing else is done with it.
- `socle/agents/profiles/*.md`, `socle/agents/formulas/*.toml`,
  `socle/agents/discipline.md`, `socle/agents/methodology.md` — no beads
  vocabulary enters them. The convention is reached through §B1 and through the
  skill's own description; slice 07 owns any further routing.
- This repo adopting beads for its own tasks.

### Reported to the Owner, not decided here

The parent task's slice list (line for slice 05) names an "anti-`--mirror`
pre-push hook" among the audit's enforcement items, while this slice's approved
"What to build" asks for the guards "in black and white" and AC3 asks only that
the convention carry them verbatim. This plan follows the slice's own perimeter
and ships the written rule without the hook, for the reasons in the triage
table. If the Owner wants the hook, it is a slice of its own — with the test
budget that shipping executable enforcement requires.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

**Worklog.** Four commits, one per green step of the plan's execution order
(`bash test/run.sh` green before each, 88 assertions passed throughout, no
new assertion, no new group — the suite stayed at 588/600 lines).
(1) `socle/agents/skills/chisel-beads/SKILL.md` written from the draft's
§1–§5, minus every script reference (the routine's push became the
three-command `git ls-remote` / `bd dolt push` / `git ls-remote` sequence; the
mirror guard lost the posed-hook paragraph and kept the remote-side
`receive.denyDeletes` recommendation); `--actor` corrected to the roster's
actual four roles (`architect`, `checker`, `inspector`, `mason` — the draft
still said `owner`, stale against slice 02/11's `checker.md`); the
fresh-clone `bd bootstrap` line added ahead of `bd dolt pull`. Golden tree
gained the file. (2) `CHANGING-CASE.md` written from the draft's §6–§7 and
`init-neutralized.sh`'s header comments and command sequence, converted to
numbered prose; `SKILL.md` gained its three pointers to this page (deferred
out of commit 1 so each commit stays independently green — the page did not
exist yet when 1 landed). (3) The wiring: `chisel-setup/SKILL.md` Step 6 now
actually creates the database (clean-tree blockquote and closing blockquote
from the draft, gestures replaced by "follow CHANGING-CASE.md's entering/
converting sections") instead of only recording the choice; `project.md.tpl`
§B1's existing comment gained one line naming the convention page. (4) In
vivo verification below, plus this section, the ACs, and the status line.

**In vivo (step 4), against real `bd 1.2.2`, on a scratch fixture built
outside this repo** (`test/fixtures/brownfield` → `git init` → one commit →
`bin/chisel.sh init` → `chisel-beads` skill present per the golden tree),
**removed after**:

- **AC1.** Dirty tree: `git status --porcelain` non-empty → per
  `CHANGING-CASE.md`'s stated precondition, stopped before running `bd init`;
  `.beads/` absent. Clean tree: ran the entering sequence by hand, command by
  command. Confirmed live: `bd setup claude --remove` strips the
  `SessionStart` hook and the `CLAUDE.md` section but **never** touches
  `AGENTS.md`; `bd setup codex --remove` strips the vendored
  `.agents/skills/beads/`, the Codex hooks/config, and its own `AGENTS.md`
  block, but **also** leaves the Claude one behind — exactly one
  `<!-- BEGIN BEADS INTEGRATION -->` … `<!-- END BEADS INTEGRATION -->` pair
  survives both `--remove` commands and needs the manual strip step, matching
  what the draft's script comments said and validating why that step exists.
  After the full sequence: `AGENTS.md`/`CLAUDE.md` carry no BEADS block (in
  fact `AGENTS.md` came back byte-identical to its pre-`bd-init` state — the
  append-then-strip round-trips cleanly), `.claude/settings.json` is
  `{"hooks": {}}` (no `SessionStart`), no `.agents/skills/beads/`, one
  chisel-owned commit (`chore: coordination database, without its
  discourse`), `bin/chisel.sh check` clean, `bd create`/`bd ready` both
  answer, and `bd formula list` resolves the three chisel formulas through
  `.beads/formulas -> ../.agents/formulas` — Open Question 1's ruling
  confirmed live, not just read in the research note.
- **AC2.** Created `project-management/tasks/20260826-1200-fix-payroll-
  export.md`, then `bd create "Fix payroll export" --type task --priority 2
  --spec-id "project-management/tasks/20260826-1200-fix-payroll-export.md"
  --actor architect --silent`. Real `bd show <id>` output, pasted verbatim
  (this run and a second one on the AC4 fixture agreed byte-for-byte except
  the id/title/spec):

  ```
  ○ slice05-fixture-94o · Fix payroll export   [● P2 · OPEN]
  Owner: architect · Type: task
  Created: 2026-08-26 · Updated: 2026-08-26
  Spec: project-management/tasks/20260826-1200-fix-payroll-export.md

  DESCRIPTION
    (none)
  ```

  The draft's sample was close but missing the `Created:`/`Updated:` line and
  the closing "💡 Tip: Install the beads plugin…" that `bd show` sometimes
  prints; `SKILL.md` §2's sample was corrected to the real block, with a
  sentence telling the reader to ignore the tip rather than trying to keep an
  incidental, possibly-version-dependent line byte-exact forever.
- **AC4.** Fixture: `tasks/20260826-1500-feature-x/{01-foundation,02-ui}.md`
  (both 🔴, `02` carrying `**Blocked by:** 01 (schema must land first)`) plus
  `archive/20260101-0000-old-done-task.md` (🟢). Ran the three passes by
  hand. Pass 1: two beads, one per open file, none for the archived one —
  never opened, checksum identical before/after
  (`5856888dc684ca6f01144fe0290a16244e0109dc095c8f13cf1d75518f7262ac`). Pass
  2: the `01 (schema must land first)` token resolved against the sibling
  file starting with `01-` (never against the parenthetical prose), and
  `bd dep add <02's bead> --blocked-by <01's bead>` landed — confirmed via
  `bd show <02's bead>`: `DEPENDS ON → ○ <01's bead>: Slice 01 — Foundation`.
  Pass 3: both files' `**Status:**` lines now read
  `tracked as \`<id>\` — \`bd show <id>\``. Diff read before staging; only
  the two task files were staged (never `git add -A`) and committed.

**Note without stopping — an unrelated in-flight change.** Partway through
step 3, `git status` showed
`project-management/tasks/20260826-2302-chisel-dogfoods-itself.md` modified
by what is evidently a parallel session (an Owner ruling on that task's own
question, unrelated to this slice). Left untouched and unstaged throughout,
per the standing rule against `git add -A`/`git add .` in this repo.

**Note without stopping — a simpler entering sequence exists but was not
substituted.** `bd init` accepts `--skip-agents` and `--skip-hooks`, which
would skip generating the managed blocks, the `SessionStart` hook and the
vendored skill in the first place — avoiding the removal steps entirely
rather than creating-then-neutralizing. Not adopted here: the plan's
execution order specifies the create-then-neutralize sequence explicitly
(reusing `init-neutralized.sh`'s validated command order), and swapping the
mechanism would be replanning rather than executing. Left for the Owner to
decide whether it is worth a follow-up — both variants are prose, neither is
shell, so the "no new shell" constraint is unaffected either way.

**Open questions from the plan gate, resolved during planning, executed as
ruled:** formulas live at `.agents/formulas/`, symlinked (never copied) as
`.beads/formulas -> ../.agents/formulas` — confirmed live via `bd formula
list` in AC1. The bd version prerequisite (1.2.2) and the bd-absent message
stay solely in `chisel-setup` Steps 6.1–6.2, unrepeated in
`CHANGING-CASE.md`, which instead tells a reader who arrived another way to
check `bd --version` themselves and go back to that question on failure.
