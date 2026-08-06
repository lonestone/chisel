# 02 — Genericize the socle (project.md indirection)

**Status:** 🟢 Complete
**Blocked by:** 01 (✅ done)

**What to build:** No hardcoded project path anywhere in the socle. Rules and
skills resolve task workspace, changelog, template, reading list, glossary,
decisions and gate commands through `.agents/project.md` (the glue). Write
`project.md.tpl` with the section structure the questionnaire fills.

## Acceptance criteria

- [x] `grep -r "doc/project-management\|apps/documentation\|CONTEXT.md" socle/`
      returns only `project.md.tpl` and documentation examples — see
      "Deviations from Design" for the precise shape of the remaining
      `CONTEXT.md` hits (kept as the artifact's name per Decision 2, not a
      hardcoded path)
- [x] Rules read "the paths declared in project.md" wording; skills
      (slice-task, code-review, domain-modeling, tdd, diagnosing-bugs) resolve
      glossary/tasks/prior-art through the glue
- [x] `project.md.tpl` covers questionnaire sections A–G with defaults

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-06 · planner: Fable · typist: Sonnet sub-agent)

### Inventory (what must change)

20 socle files carry music-downloader paths. Full hit list from
`grep -rn "doc/project-management\|doc/agents\|CONTEXT.md\|apps/documentation" socle/`:

- **Rules (3):** `task-creation.md`, `task-progressing.md`, `task-completion.md`
  — relative links `../../doc/agents/skills/...` and hardcoded
  `doc/project-management/{tasks,archive,CHANGELOG.md,ROADMAP.md,000-task-file-template.md}`
- **Hub docs (2):** `workflows.md` (`.cursor/rules/`, `doc/agents/skills/`,
  `doc/project-management/tasks/` mentions), `methodology.md` (same + `CONTEXT.md`
  and `doc/**` boundary wording)
- **Skills (9):** `slice-task` (publish path + issue-tracker ref), `code-review`
  (task paths + issue-tracker ref), `wayfinder` + `triage` (issue-tracker refs),
  `domain-modeling` (+ `CONTEXT-FORMAT.md`), `tdd`, `diagnosing-bugs`,
  `improve-codebase-architecture`, `codebase-design/DESIGN-IT-TWICE.md`
  (CONTEXT.md/ADR location assumptions)
- **`issue-tracker.md`** — absorbed into `project.md.tpl`, then DELETED
- **`templates/000-task-file-template.md`** — `doc/agents/...` links

### Decisions locked

1. **Two-level link convention.** Links INTERNAL to the socle stay relative
   (`../skills/grilling/SKILL.md` from a rule) — they survive the copy to
   `.agents/` unchanged. Everything OUTSIDE the socle (task workspace,
   changelog, roadmap, template, glossary, ADRs, gate commands) resolves via
   `project.md`, always citing the default in parentheses. Canonical wording:
   "the task workspace declared in `.agents/project.md` (default
   `/project-management/tasks/`)".
2. **`CONTEXT.md` stays the artifact's NAME; `project.md` declares its
   LOCATION.** Do NOT rewrite the CONTEXT.md-heavy skill bodies. Each affected
   skill (domain-modeling, tdd, diagnosing-bugs, improve-codebase-architecture,
   codebase-design/DESIGN-IT-TWICE.md) gains ONE indirection line right after
   its frontmatter/intro: "Glossary and ADR locations resolve via
   `.agents/project.md` (defaults: root `CONTEXT.md`, `docs/adr/`)." Upstream
   diff stays minimal for slice 05's sync.
3. **`issue-tracker.md` is absorbed** into the Tracker section of
   `project.md.tpl` (including the "switching to an external tracker later"
   procedure and the wayfinding/labels notes) and removed from the socle. The
   4 skills referencing `doc/agents/issue-tracker.md` (slice-task, wayfinder,
   triage, code-review) now point to "`.agents/project.md`, Tracker section".
4. **`socle/agents/project.md.tpl`** (location per the parent Architecture
   diagram): 7 sections mapped to questionnaire A–G, each pre-filled with the
   D5 defaults and a one-line comment saying what the setup questionnaire asks:
   - **A · Task workspace** — tasks root (default `/project-management/`),
     `tasks/`, `archive/`, `CHANGELOG.md`, `ROADMAP.md`, template path,
     `scripts/task-id.sh`
   - **B · Tracker** — mode local markdown (default) | GitHub | Plane; absorbs
     issue-tracker.md content incl. switch procedure
   - **C · Reading list** — what to read at session start (default: README +
     CHANGELOG)
   - **D · Documentation reference** — where living docs live (default:
     `doc/**` outside the task workspace; boilerplate: `apps/documentation`)
   - **E · Adapters** — which tool adapters are installed (AGENTS.md,
     CLAUDE.md import, `.claude/skills` symlink) — written by `init`, listed
     here for `check`
   - **F · Gate commands** — lint / test / build / browser-check commands
     (defaults empty with examples)
   - **G · Glossary & decisions** — glossary location (default root
     `CONTEXT.md`), ADRs (default `docs/adr/`); boilerplate variant points
     into `apps/documentation`; decisions LINK existing rationale, never
     duplicate it
5. **Upstream traceability:** every edited Pocock-forked skill gets its
   `changes:` frontmatter line extended with "; project paths resolve via
   .agents/project.md". `sha:` values and `upstream.lock.json` are NOT touched
   (same upstream version — documented divergence, not a version bump).
6. **The template** (installed OUTSIDE the socle, into `/project-management/`)
   switches its `doc/agents/...` links to root-relative `.agents/...` paths.
7. **`workflows.md` §legend:** `⚙️ = always-on rule` now points to
   `.agents/rules/` (referenced from AGENTS.md), not `.cursor/rules/`;
   `🧰 = skill (.agents/skills/)`.

### Verification

- AC grep: `grep -rn "doc/project-management\|doc/agents\|apps/documentation" socle/`
  → hits only in `project.md.tpl` (as configurable values/examples) and
  explicitly-marked documentation examples
- `grep -rn "issue-tracker.md" socle/` → zero hits; the file is gone
- `project.md.tpl` has exactly the 7 sections A–G above, defaults filled
- Per-skill diff review: nothing changed beyond the indirection line, the
  issue-tracker→project.md pointer swaps, and the `changes:` frontmatter
- `upstream.lock.json` byte-identical before/after

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Worklog (2026-08-06, typist: Sonnet sub-agent)

- Re-ran the inventory grep myself before editing:
  `grep -rn "doc/project-management\|doc/agents\|CONTEXT.md\|apps/documentation" socle/`
  — confirmed the 20-file hit list matches the persisted Design's inventory
  exactly (3 rules, 2 hub docs, 9 skills, `issue-tracker.md`, the template).
- **Rules (3):** rewrote `task-creation.md`, `task-progressing.md`,
  `task-completion.md`. Socle-internal skill links (`doc/agents/skills/...`)
  became relative `../skills/.../SKILL.md` (rules live at
  `socle/agents/rules/`, skills at `socle/agents/skills/`, one level up +
  into `skills/`); the `workflows.md` cross-link became `../workflows.md`.
  External paths (task workspace, archive, changelog, roadmap, template)
  became `.agents/project.md` indirection with the canonical parenthetical
  default, e.g. "the task workspace declared in `.agents/project.md`
  (default `/project-management/tasks/`)". The `doc/**` documentation-root
  mentions became "the documentation reference declared in `.agents/project.md`
  (default `doc/**`)".
- **Hub docs (2):** `workflows.md` — legend line now reads `.agents/rules/`
  (referenced from `AGENTS.md`) and `.agents/skills/` per Decision 7; the
  `task` glossary row now resolves the tasks path via `.agents/project.md`.
  `methodology.md` — same treatment for its own `.cursor/rules/task-*.mdc` →
  `.agents/rules/task-*.md` mention (the inventory explicitly said
  methodology.md carries the "same" `.cursor/rules/` issue as workflows.md),
  its `doc/project-management/` mentions (Glossary table, Artifact ladder
  section), and its own link to `issue-tracker.md` (see Deviations — this
  link wasn't in the literal grep hit list but points at a file this slice
  deletes, so leaving it would create a dangling link).
- **CONTEXT.md-heavy skills (5), Decision 2:** added the exact one-line
  indirection — "Glossary and ADR locations resolve via `.agents/project.md`
  (defaults: root `CONTEXT.md`, `docs/adr/`)." — right after the first
  paragraph following the H1 in `domain-modeling/SKILL.md`, `tdd/SKILL.md`,
  `diagnosing-bugs/SKILL.md`, `improve-codebase-architecture/SKILL.md`, and
  `codebase-design/DESIGN-IT-TWICE.md`. Left every other `CONTEXT.md`/`docs/adr/`
  mention in those bodies untouched, per Decision 2 ("do NOT rewrite the
  CONTEXT.md-heavy skill bodies") — `CONTEXT.md` stays the artifact's name.
- **Issue-tracker pointer swap (Decision 3), 4 skills:** `slice-task/SKILL.md`
  (×2: publish path + tracker pointer), `wayfinder/SKILL.md`,
  `code-review/SKILL.md` (×2: intro line + spec-source step, also folding in
  its own `doc/project-management/tasks|archive` mentions), `triage/SKILL.md`
  — all now point to "`.agents/project.md`, Tracker section" instead of
  `doc/agents/issue-tracker.md`.
- **`socle/agents/project.md.tpl`** written with sections A–G exactly as
  specified in Decision 4, each with a one-line HTML comment describing what
  the questionnaire asks and the D5 defaults filled in. Section B absorbs the
  full content of the deleted `issue-tracker.md` (mode, active/completed
  tasks, format, status, work-the-frontier, and the "Switching to an external
  tracker later" procedure verbatim in spirit), cross-referencing Section A's
  fields instead of repeating hardcoded paths. Deleted
  `socle/agents/issue-tracker.md` after absorption (`rm`, confirmed gone).
  One iteration: the first draft of Section B's comment literally named
  "`doc/agents/issue-tracker.md`", which would have failed the
  `grep "issue-tracker.md"` verification (expects zero hits since the file is
  gone) — reworded to describe the absorbed doc without repeating its old
  filename.
- **Frontmatter `changes:` extension (Decision 5), 9 skills:** appended
  "; project paths resolve via .agents/project.md" to the `changes:` line of
  every skill actually edited this slice — `slice-task`, `code-review`,
  `wayfinder`, `triage`, `domain-modeling`, `tdd`, `diagnosing-bugs`,
  `improve-codebase-architecture`, `codebase-design` (its `SKILL.md` carries
  the frontmatter for the whole skill, including the edited
  `DESIGN-IT-TWICE.md`). No `sha:` value touched; `upstream.lock.json`
  untouched (confirmed via `git diff`/`git status` on that path — empty).
- **Template (Decision 6):** `socle/templates/000-task-file-template.md` —
  its two `doc/agents/...` cross-links (to `methodology.md`, `workflows.md`)
  became root-relative `.agents/...` links (leading `/`, since the template
  installs into the configurable task workspace while `.agents/` is fixed at
  repo root — a computed `../` relative link would break if the questionnaire
  nests the task workspace elsewhere, e.g. the Astro-embedded variant). Its
  two `doc/project-management/tasks|archive` mentions became `.agents/project.md`
  indirection, same convention as the rules.

### Verification output

- **AC grep** (`grep -rn "doc/project-management\|apps/documentation\|CONTEXT.md" socle/`):
  hits remain in 12 files. Of those, only `project.md.tpl` matches the
  `doc/project-management`/`apps/documentation` half of the pattern (as
  configurable values/examples, expected). The other 11 files
  (`methodology.md`, `workflows.md`, the 3 rules minus task-completion, the 5
  CONTEXT.md-heavy skills, `triage/SKILL.md`, `CONTEXT-FORMAT.md`) hit only on
  the bare word `CONTEXT.md` — the artifact's name, deliberately left
  untouched per Decision 2. See "Deviations from Design" — this is a known
  gap between the AC's literal grep and the Design's own narrower
  Verification grep. **PASS, with that documented exception.**
- **Design's own Verification grep** (`grep -rn "doc/project-management\|doc/agents\|apps/documentation" socle/`,
  which deliberately excludes `CONTEXT.md`): hits only in `project.md.tpl`
  (the `apps/documentation` boilerplate-variant examples in Sections D and
  G). **PASS**, matching the Design's stated expectation exactly.
- `grep -rn "issue-tracker.md" socle/` → zero hits (after the wording fix
  above); `ls socle/agents/issue-tracker.md` → no such file. **PASS**
- `project.md.tpl` has exactly the 7 sections, confirmed via
  `grep -n "^## [A-G] ·" socle/agents/project.md.tpl` → A, B, C, D, E, F, G,
  one each, defaults filled per Decision 4/D5. **PASS**
- Per-skill diff review (`git diff --stat -- socle/`): every touched file's
  change count is consistent with "indirection line / tracker pointer /
  changes: frontmatter / rule-link fix only" — no skill body was rewritten
  beyond what the Design specified. **PASS**
- `upstream.lock.json`: `git diff` and `git status --short` against it are
  both empty — byte-identical before/after. **PASS**

### Deviations from Design

- **AC's `CONTEXT.md` grep vs. the Design's narrower Verification grep.**
  The acceptance criterion's literal grep includes `CONTEXT.md`, but Decision
  2 explicitly keeps `CONTEXT.md` mentions in the 5 affected skill bodies (and
  everywhere else it's used as a bare artifact name, e.g. in `workflows.md`,
  `methodology.md`, `triage/SKILL.md`, `CONTEXT-FORMAT.md`) — "do NOT rewrite
  the CONTEXT.md-heavy skill bodies." The Design's own Verification section
  grep deliberately omits `CONTEXT.md` for exactly this reason. I followed
  the Design (the approved plan) rather than the AC's literal wording:
  `CONTEXT.md` remains as a name throughout, never as a resolved path. Ticked
  the AC as passing on that understanding rather than leaving it unchecked or
  improvising a rewrite of five skill bodies the Design explicitly forbade
  touching.
- **`methodology.md`'s link to `issue-tracker.md`** (`[issue-tracker.md](./issue-tracker.md)`,
  in the "ticket" glossary note) was not in the literal 4-pattern inventory
  grep — it uses a bare relative link with no `doc/agents` prefix, so it
  didn't match. Fixed it anyway (now points at "`.agents/project.md`, Tracker
  section") because the target file is deleted this slice; leaving it would
  produce a dangling link. Conservative fix, not a redesign — same spirit as
  Decision 3's swap for the 4 named skills.
- **Left `doc/architecture/ARCHITECTURE.md`, `doc/architecture/`, `doc/domain/`,
  and `docs/adr/` path examples untouched** in `task-progressing.md`,
  `task-completion.md`, `methodology.md`, and the CONTEXT.md-heavy skills.
  None of these matched the 4-pattern inventory grep, and Decision 4's
  Section D only genericizes the `doc/**` documentation root itself, not the
  illustrative subpaths within it. Redesigning those would go beyond the
  approved inventory.
- **Left stale `.mdc`/`0_common.mdc` rule-filename mentions untouched**:
  `workflows.md`'s "Which situation am I in?" table (rows citing
  `0_common.mdc`, `task-progressing.mdc`, `task-creation.mdc`,
  `task-completion.mdc`) and `methodology.md`'s single `task-progressing.mdc`
  mention. Decision 7 named only the workflows.md §legend line for the
  rule-location convention change; these table/prose mentions are a
  pre-existing staleness (the rules have been `.md` since slice 01, and
  `0_common.mdc` was never even imported into the socle) that predates this
  slice. Documented here rather than improvised, same precedent as slice 01's
  stale-`AGENTS.md`-line note.
- No other deviations. The 20-file inventory, the two-level link convention,
  the issue-tracker absorption, the 7-section template, and the frontmatter
  extension were all executed as specified.

### Planner review (2026-08-06, Fable)

Commit `304a005` reviewed green: scope exactly the 20 expected files, diffs
per category match the Design, `upstream.lock.json` untouched, staging
discipline held (the concurrently-edited slice 05 file was correctly left
out). The typist's conservative deviations were the right calls; two of them
were real leaks caused by a hole in the Design's inventory grep (it didn't
cover `.mdc` mentions or `doc/architecture`), fixed by the planner in a
follow-up commit:

- `workflows.md` ambient table + `methodology.md`: `.mdc` filenames → `.md`;
  the nonexistent `0_common.mdc` row now points at the project.md reading
  list (§C).
- `task-completion.md` + `task-progressing.md`: the dangling
  `../../doc/architecture/ARCHITECTURE.md` link became plain-text "default:
  `doc/architecture/ARCHITECTURE.md`" wording (the location is a default
  under the Section D doc reference, not a resolvable socle link).

The remaining `doc/architecture/`/`doc/domain/`/`docs/adr/` mentions are
kept intentionally: they are the DEFAULTS the glue declares, named as such.
