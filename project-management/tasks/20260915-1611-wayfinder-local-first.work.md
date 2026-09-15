# The wayfinder's local map: a folder, an index, one file per ticket — work

Created by the implementing session at `plan`, 2026-09-15. Spec:
`project-management/tasks/20260915-1611-wayfinder-local-first.spec.md`.

Working under `AGENTS.md`, `socle/agents/discipline.md` (rule 11 in
particular: name by meaning, cite by file and section title, never by line
number), the spec above as the requirement, and
`socle/agents/skills/writing-great-skills/SKILL.md` as the standard the
edited skill is judged against (one source of truth per meaning, no fork in
every paragraph, leading words kept).

## Program Design

Two files change, in one commit: the skill
`socle/agents/skills/wayfinder/SKILL.md` and the glossary sentence of
`socle/agents/reference.md`. Nothing else.

### The decision that shapes every edit: one skill, two supports, no fork

The skill keeps reading as one document. Each sentence that names the
tracker is reworded so it is true whichever support the map has, with the
tracker's own mechanics kept inside it as the tracker case ("in a tracker,
…"). Everything specific to the folder — the paths, the ticket file, the
correspondence of every tracker notion — is gathered in a single new
subsection, so no paragraph downstream carries an if/else. That is the
"single source of truth per meaning" rule of
`socle/agents/skills/writing-great-skills/SKILL.md` ("Pruning"), applied to
a document that now has two possible supports.

The leading words are untouched: destination, frontier, fog of war, claim,
decision ticket. The word **ticket** stays everywhere.

### Placement and outline of the new section

It goes exactly where the sentence "Where the map, its child tickets,
blocking, and frontier queries physically live is tracker-specific" stands
today: inside "The Map", after the "index, not a store" paragraph and
before "The map body". A `###` subsection, titled **Where the map lives**,
in three movements:

1. **Which support.** §B2 · Link to an external tracker of
   `.agents/project.md` — the one place that says whether this repo has a
   tracker — decides. With a tracker, the map is an issue and its tickets
   are child issues, as the rest of the skill describes.
2. **The folder, when no tracker is declared.** `maps/<slug>/` under the
   tasks root declared in §A · Task workspace of the same file (default
   `/project-management/maps/<slug>/`), `<slug>` the destination in a few
   words; `MAP.md` holds the map body the skill already gives, unchanged;
   one file per ticket, `<NN>-<title-slug>.md`, `<NN>` in creation order —
   given as a fenced block, once, the way the map body is given.
3. **The correspondence**, one line per tracker notion: the map issue →
   `MAP.md`; a child issue → a file in the folder; the `wayfinder:map` and
   `wayfinder:<type>` labels → the folder itself and the `Type` line; the
   assignee that is the claim → the `Claimed by` line, written and
   committed before any work; native blocking → the `Blocked by` line, a
   ticket unblocked when every file it names is closed; the frontier query
   → listing the folder for the files with no `Resolution`, an empty
   `Claimed by` and every blocker closed; the resolution comment and the
   close → the `Resolution` section written plus the ticket's line added to
   `MAP.md`'s Decisions so far, which is what closed means for a file (a
   closed ticket stays in the folder); the out-of-scope close → the same,
   the line landing under Out of scope. Closing line: a file's name carries
   its `<NN>` and its title's slug, and the `#` heading — the title — is
   what "Refer by name" refers by.

The ticket file, verbatim from the spec's Scope "In":

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

No `Status` line: a ticket is open or closed, claimed or not, blocked or
not — the skill's own states, as header lines. Nothing borrowed from the
task status ladder; no mention of the coordination database or its command.

### Every sentence that assumes a tracker, and what it becomes

Named by where it lives and by its first words, never by line number.

| Where | The sentence today | What it becomes |
|---|---|---|
| Frontmatter, `description` | "…as a shared map of decision tickets on your issue tracker…" | reworded to cover both: "in a folder of markdown files or on your issue tracker" |
| Frontmatter, `x-upstream.changes` | "adapted: tracker reference adapted for the local task tracker; …" | says what this adaptation is: the map lives as a folder of markdown files when no external tracker is declared |
| Opening paragraph, "A loose idea has arrived" | "charts the way as a **shared map** on the repo's issue tracker" | reworded: "as a **shared map** — a folder in the repo, or the repo's issue tracker" |
| "Refer by name", first sentence | "Every map and ticket is an issue, so it has a **name** — its title." | reworded: "Every map and ticket has a **name** — its title." |
| "Refer by name", the wall of ids | "A wall of `#42, #43, #44` is illegible" | reworded to show both shapes of bare id, so the rule bites in a folder too |
| "The Map", first sentence | "a single issue on this repo's issue tracker, labelled `wayfinder:map` … Its tickets are child issues of the map." | reworded: one issue labelled `wayfinder:map`, or one `MAP.md` in the map's own folder; tickets are child issues, or files beside `MAP.md` |
| "The Map", third paragraph | "Where the map, its child tickets, blocking, and frontier queries physically live is tracker-specific. … default to the local-markdown tracker." | **replaced** by the new "Where the map lives" subsection in its place |
| "The map body", lead-in | "they are open child issues, found by query" | reworded: found on the frontier, not from the map |
| "Tickets", first sentence | "Each ticket is a **child issue** of the map; the tracker's issue id is its identity." | reworded: a child issue of the map issue, or a file beside `MAP.md`; its identity is the issue id or the file's name |
| "Tickets", the label sentence | "Each ticket carries a `wayfinder:<type>` label" | reworded: each ticket declares its **type**, as a `wayfinder:<type>` label in a tracker; the folder's counterpart is the `Type` line, given in the new subsection |
| "Tickets", the claim sentence | "claims a ticket by assigning it to the dev driving the map … That assignee _is_ the claim" | reworded: claims **first**, before any work; the tracker's assignee kept as the tracker case; the `Claimed by` line is the folder's counterpart, in the new subsection |
| "Tickets", the blocking sentence | "Blocking uses the tracker's **native** dependency relationship … the **frontier** is the open, unblocked, unclaimed children" | kept as the tracker case ("In a tracker, blocking uses…"); the definitions of unblocked and frontier reworded off "children" onto "tickets" |
| "Tickets", the assets sentence | "linked from the issue, not pasted in" | reworded: linked from the ticket |
| "Chart the map", step 3 | "**Create the map** (label `wayfinder:map`)" | reworded: `MAP.md` in its folder, or the map issue labelled `wayfinder:map` |
| "Chart the map", step 4 | "as child issues of the map … (issues need ids before they can reference each other)" | reworded: child issues, or files in the map's folder; "tickets need their names before they can reference each other", so the create-then-wire second pass stands as written |
| "Work through the map", step 2 | "**Claim it**: assign it to yourself before any work." | reworded: claim it in your own name before any work |
| "Work through the map", step 4 | "post the answer as a **resolution comment**, **close** the issue" | reworded: write the answer as the ticket's **resolution** — a resolution comment in a tracker — and **close** the ticket |
| Closing sentence | "expect other sessions to be editing the tracker concurrently" | reworded: editing the map concurrently |

Untouched, as the spec's Scope "Out" requires: "Plan, don't do", "Ticket
Types", "Fog of war", "Out of scope" (no sentence in them names the
tracker), the map body template, and every leading word.

### The glossary sentence, exactly

In `socle/agents/reference.md`, below the glossary table, the sentence that
reserves "ticket" gains the exception in the same breath:

> We do NOT use the word "ticket" for local work. It is reserved for items
> in an external tracker (Linear, GitHub Issues), if/when one is wired up —
> see §B2 · Link to an external tracker of `.agents/project.md` — and for
> the decision tickets of a wayfinder map, which keep the skill's own name
> whether they live in a tracker or in the map's own folder:
> `.agents/skills/wayfinder/SKILL.md` charts a foggy effort as a map of
> decision tickets and resolves them one at a time.

### Criteria: before-values, measured at HEAD `ad06aae`

`$S` is `socle/agents/skills/wayfinder/SKILL.md`.

| Criterion | Command | Before |
|---|---|---|
| local-map-exists | `grep -c 'maps/' $S` / `grep -c 'MAP.md' $S` / `grep -c 'local-markdown tracker' $S` | 0 / 0 / 1 |
| ticket-file-given | `grep -c` on `**Type:**` / `**Blocked by:**` / `**Claimed by:**` / `## Question` / `## Resolution` | 0 / 0 / 0 / 1 / 0 |
| notions-mapped | `grep -ci frontier $S` / `grep -c 'Decisions so far' $S` | 10 / 3 |
| ticket-kept | `grep -c ticket $S` / `grep -c waypoint $S` | 36 / 0 |
| no-status-ladder | `grep -n "Status:\|ready\b\|in-progress\|beads\|bd " $S` | 4 lines, every one the word "already" |
| tracker-still-optional | `grep -c B2 $S` / `grep -c project.md $S` | 1 / 2 |
| glossary-exception | `grep -c wayfinder socle/agents/reference.md` | 0 |
| upstream-line | `grep -n 'changes:' $S \| grep -c map` | 0 |
| no-code-in-shipped-text | `grep -rn "W6\.\|F1\.1\|review-360\|chantier\|socle/"` on the skill folder and the glossary | nothing (exit 1) |
| suite-green | `deno task test` / `deno task check` / `git diff --check` / `wc -l test/fixtures/golden-tree.txt` | recorded at the close step; golden tree 93 lines |
| nothing-else-moved | `git diff --stat ad06aae..HEAD` | recorded at the close step |

Two before-values do not match the spec's parenthetical guesses; both are
recorded in Findings rather than fixed in the spec, which is the Foreman's
file.

## Worklog

- **2026-09-15, plan.** Read `AGENTS.md`, `socle/agents/discipline.md`, the
  spec in full, the work template, the wayfinder skill in full, the
  glossary, `socle/agents/skills/writing-great-skills/SKILL.md`, §A · Task
  workspace and §B2 · Link to an external tracker of
  `socle/agents/project.md.tpl`, and the reasoning recorded for this
  effort. Ran every criterion command at HEAD `ad06aae` and recorded the
  before-values above. Plan written; committed alone.

## Implementation Checkboxes

- [ ] Step 1 — the skill and the glossary, one commit: the frontmatter
      (`description`, `x-upstream.changes`), the new "Where the map lives"
      subsection in place of the tracker-specific sentence, the seventeen
      reworded sentences of the table above, and the glossary's exception.
- [ ] Step 2 — gates after the commit: `deno task test`, `deno task check`,
      `git diff --check`.
- [ ] Step 3 — criteria re-run, after-values written beside before-values.
- [ ] Step 4 — the end-to-end reread the spec's Verification asks for:
      every sentence that still reads as tracker-only when the map is a
      folder, fixed or justified in writing.
- [ ] Step 5 — Findings written; the work document's close committed.

## Notes & Snippets

Deno is at `~/.deno/bin/deno`.

Pointer discipline for the `integrity` test: every `.agents/…` pointer in
the new text must resolve in the installed tree. The two used —
`.agents/project.md` and `.agents/skills/wayfinder/SKILL.md` — both appear
in `test/fixtures/golden-tree.txt`, so neither dangles. No pointer in
shipped text uses the source-tree form.

## Findings

Written at the close step.

## Diff-Review Findings

Written by the reviewer.
