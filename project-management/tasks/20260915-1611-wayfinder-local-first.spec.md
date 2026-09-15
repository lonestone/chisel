# The wayfinder's local map: a folder, an index, one file per ticket

**Status:** ready

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** the `wayfinder` skill (`socle/agents/skills/wayfinder/SKILL.md`)
says "If no tracker has been provided, default to the local-markdown
tracker" — and no such thing exists anywhere in the socle. This chantier
gives it existence, inside the skill, and changes nothing else about the
skill: a map is a folder under the task workspace root, `maps/<slug>/`,
holding `MAP.md` (the map body the skill already defines) and one file per
ticket; the sentences of the skill that assume a tracker (child issues,
labels, assignee, native blocking, resolution comment, close) say what each
becomes in that folder, with the external tracker kept as the option it
already is through §B2 of `.agents/project.md`. The word **ticket** stays.
Nothing links the map to beads, to the task status ladder, or to the task
pipeline: the wayfinder is a skill of its own with a folder of its own, and
turning a finished map's conclusions into tasks is the human's act.

**Rulings applied** (from `project-management/review-360-decisions.md`,
"Addendum 11 (2026-09-15) — chantier 6, le wayfinder local-first", and
"F1 — Mineurs" point 1; each named by what it says, the code beside it):

- **F1.1, the wayfinder is kept and adapted local-first**: the tracker
  becomes an option, not the default. Its last sentence (rename local
  "tickets") is struck by W6.3.
- **W6.1, the map respects the original skill; map and tasks are two
  entities.** The map is not a task and does not live among tasks.
- **W6.2, a map is a folder outside `tasks/`, with an index and one file
  per ticket.**
- **W6.3, the word "ticket" stays** in the skill; the glossary's sentence
  that reserves it for external trackers states the exception.
- **W6.4, tickets keep the original skill's states** — open or closed,
  claimed or not, blocked or not — as header lines; no borrowing from the
  task status ladder.
- **W6.5, the Owner closed the interview**: "Wayfinder c'est un skill
  spécifique avec un dossier spécifique, c'est à l'utilisateur de
  transformer les conclusions en tache (on peut proposer un skill pour ça
  mais pas urgent)." No beads case, no hand-off step, no status
  vocabulary; the smallest change that makes the skill's default true.

Transverse: G3 (English), rule 11 of `socle/agents/discipline.md` (name by
meaning, cite by file and section title), no ruling code, no "chantier",
no decisions-record file name in shipped text; pointers in shipped text use
the installed form `.agents/…`.

**Process, ruled by the Owner** (Addendum 6 of the decisions record, the
fast track, as for chantiers 4, 5, 7 and 8): the Foreman wrote this spec;
one agent plans in the work document, then types all of it and keeps the
work document; the Foreman reviews on both axes. The Foreman moves this
spec's status.

## Scope

In:

- **The local map, defined in the skill.** A new section of
  `socle/agents/skills/wayfinder/SKILL.md`, placed where "Where the map, its
  child tickets, blocking, and frontier queries physically live is
  tracker-specific" now stands, says: when §B2 · Link to an external
  tracker of `.agents/project.md` declares no tracker, the map is the
  folder `maps/<slug>/` under the tasks root declared in §A · Task
  workspace of the same file (default `/project-management/maps/<slug>/`),
  `<slug>` being the destination in a few words; `MAP.md` in it is the map
  body the skill already gives (Destination, Notes, Decisions so far, Not
  yet specified, Out of scope), unchanged; each ticket is one file
  `<NN>-<title-slug>.md` in the same folder, `<NN>` in creation order.
- **The ticket file**, given once, as the skill gives the map body:

  ```markdown
  # <NN> — <Ticket title>

  **Type:** grilling | research | prototype | task
  **Blocked by:** <NN — title, …> or "None"
  **Claimed by:** <who> or "—"

  ## Question

  <the decision or investigation this ticket resolves>

  ## Resolution

  <written when the ticket closes, never before>
  ```

  and the correspondence, one line each, for every tracker notion the skill
  uses: the map issue → `MAP.md`; a child issue → a file in the folder; the
  `wayfinder:map` and `wayfinder:<type>` labels → the folder itself and the
  `Type` line; the assignee that is the claim → the `Claimed by` line,
  written and committed before any work; native blocking → the `Blocked by`
  line, so a ticket is unblocked when every file it names is closed; the
  frontier query → the files with no `Resolution` written, an empty
  `Claimed by` and every blocker closed, read by listing the folder; the
  resolution comment and the close → the `Resolution` section written and
  the ticket's line added to `MAP.md`'s Decisions so far, which is what
  "closed" means for a file (a closed ticket stays in the folder: the map is
  an index and the tickets are its detail); the out-of-scope close → the
  same, with the line under Out of scope instead. "Issues need ids before
  they can reference each other" becomes "files need names", so the
  create-then-wire second pass stays as written.
- **The sentences that assumed a tracker**, reread one by one and made true
  for both supports without a fork in every paragraph: the description
  ("on your issue tracker" → on the map's folder or tracker), "Refer by
  name" (a file's name is its title's slug; the title is what the human
  reads), "The Map" (the single issue → `MAP.md` or the tracker's map
  issue), "Tickets", the two Invocation lists (claim, resolve, close,
  create-then-wire). The tracker case keeps every sentence it has today; the
  file case gains its own where the two differ, in the local-map section
  above rather than inline, so the skill reads once.
- **The glossary sentence**, `socle/agents/reference.md`, "We do NOT use
  the word "ticket" for local work. It is reserved for items in an external
  tracker.": gains the exception in the same breath — and for the tickets
  of a wayfinder map, which keep the skill's own name whether they live in
  a tracker or in the map's folder.
- **The `x-upstream.changes` line** of the skill's frontmatter says what
  this adaptation is, in the existing style ("adapted: …").
- **Nothing installed changes shape**: no new file, no golden-tree change,
  no `src/` change. The `integrity` test still passes (every `.agents/…`
  pointer in the new text resolves).

Out:

- Any relation to beads (§B1), to the task status ladder of the spec
  template, to the formulas or the profiles. The map's tickets have no
  `Status` line.
- A step or skill that turns a finished map into tasks or slices: the human
  does it; a skill for it is noted as possible and not urgent (W6.5), not
  written.
- The glue template `socle/agents/project.md.tpl`: no new line; the folder
  is derived from the tasks root already declared in §A.
- The other sections of the wayfinder skill (Plan don't do, Ticket Types,
  Fog of war, Out of scope): untouched except where a sentence names the
  tracker.
- `README.md`, `PHILOSOPHY.md`, `CHANGELOG.md` (the Foreman writes the
  entry), the templates, `test/`, `src/`, the two Owner files under
  `project-management/`.

## Acceptance criteria

Each is command-verifiable; record the before-value and the after-value in
the work document. "Before" is HEAD at the start of the chantier.

- [ ] **local-map-exists** — `socle/agents/skills/wayfinder/SKILL.md`
      contains `maps/` and `MAP.md` (`grep -c` ≥ 1 each), and `grep -c
      "local-markdown tracker"` on it → 0 (today 1).
- [ ] **ticket-file-given** — the skill contains a fenced block whose lines
      include `**Type:**`, `**Blocked by:**`, `**Claimed by:**`, `## Question`
      and `## Resolution` (`grep -c` ≥ 1 each).
- [ ] **notions-mapped** — the skill names, for the file case, the claim
      (`Claimed by`), the blocking (`Blocked by`), the frontier, the
      resolution and the close: `grep -ci "frontier"` ≥ 1 and `grep -c
      "Decisions so far"` ≥ 2 (today 2: the body template and the resolve
      step; the local section adds at least one).
- [ ] **ticket-kept** — `grep -c "ticket" socle/agents/skills/wayfinder/SKILL.md`
      ≥ 20 (today ~30; the word is kept, not renamed), and `grep -c
      "waypoint"` → 0.
- [ ] **no-status-ladder** — `grep -n "Status:\|ready\b\|in-progress\|beads\|bd "
      socle/agents/skills/wayfinder/SKILL.md` → nothing (today 0).
- [ ] **tracker-still-optional** — `grep -c "B2" socle/agents/skills/wayfinder/SKILL.md`
      ≥ 1 and `grep -c "project.md"` ≥ 2.
- [ ] **glossary-exception** — `grep -c "wayfinder" socle/agents/reference.md`
      ≥ 1 (today 0), on the line or lines that reserve "ticket".
- [ ] **upstream-line** — the skill's `x-upstream.changes` mentions the
      local map (`grep -c "map" ` on the frontmatter's `changes:` line ≥ 1).
- [ ] **no-code-in-shipped-text** — `grep -rn "W6\.\|F1\.1\|review-360\|chantier\|socle/"
      socle/agents/skills/wayfinder/ socle/agents/reference.md` → nothing.
- [ ] **suite-green** — `deno task test` → every test passes (25 today);
      `deno task check` → clean; `git diff --check` clean;
      `test/fixtures/golden-tree.txt` unchanged (93 lines).
- [ ] **nothing-else-moved** — `git diff --stat <start>..HEAD` touches only
      `socle/agents/skills/wayfinder/SKILL.md`, `socle/agents/reference.md`
      and this task's pair.

## Files map (indicative; judged after the fact)

Modify: `socle/agents/skills/wayfinder/SKILL.md`, `socle/agents/reference.md`.
Avoid: everything else.

## Verification

Run the criterion commands before and after; write after beside before.
`deno task test`, `deno task check`, `git diff --check` before each commit.
Read the finished skill once end to end and record in the work document
every sentence that still reads as tracker-only when the map is a folder;
fix each or say why it stands. One commit for the skill and the glossary
together (one meaning, one edit), one for the work document's close.

## Notes

Written by the Foreman on 2026-09-15 after the Owner closed the interview
at its fifth decision (Addendum 11 of the decisions record). The Owner's
framing, which bounds this spec: the wayfinder is a specific skill with a
specific folder, unrelated to the rest of the socle; the human turns a
finished map's conclusions into tasks. Deno is at `~/.deno/bin/deno`.
Every amendment to this file: strike the original, date the new version
below it.
