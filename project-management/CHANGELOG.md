# Changelog

Project history, newest first. Dated entries, per the methodology this repo
ships.

---

## 14. 2026-08-26 — v2 slice 08: post-audit hardening — the installer refuses, the suite is readable

Summary of the session:

1. Slice 08 of task `20260826-1512-chisel-v2` completed, from the adversarial
   audit of `b05574d` (`../factory-bench/research/audit-fable-v2.md`) and the
   Owner's round of decisions on it. Four bundles: the two installer bugs the
   audit proved live, the legibility of the test suite, the third workflow
   preset, and the proposal door in the role profiles.
2. **`chisel update` refuses a v1 layout.** A repo still holding
   `.agents/rules/` or `.agents/workflows.md` is refused, by name, with the
   `upgrade-v2` skill named as the way through — before anything is written, so
   a refused update leaves the repo byte-identical. Updating it silently used to
   leave two normative discourses side by side, with `check` reporting neither.
3. **chisel manages what chisel copied.** The manifest's `.agents/` entries now
   come from the socle source instead of a `find` over the target: a file
   another tool plants in `.agents/skills/` (initialising the status database
   does exactly that) is no longer adopted, no longer re-rendered, no longer
   reported as `DIVERGED` the day its owner edits it — and a warning says so out
   loud. Same discipline `.claude/agents/` already had through its marker.
4. **The suite reads by group.** Every group prints a `PROTECTS:` line at run
   time; the tail counts `13 scenarios, 290 assertions` (292 where python3 has
   `tomllib`); `test/TESTS.md` is the one-page review surface — group, what it
   protects, what a failure means.
   ~56 tautological assertions pruned, three scattered neutrality scans merged
   into one group with one alphabet, and the model/label scans widened to the
   whole socle for the first time.
5. **Referential integrity, mutation-tested.** A new group walks every internal
   pointer of the installed socle and fails on any target that does not exist —
   the class of bug that shipped in v2's first commits. It plants a broken
   pointer to prove it catches one.
6. **`chisel-supervised`** ships as the third preset: auto's step bodies byte
   for byte, exactly one human gate — the spec approval, sitting on the `plan`
   step — and a header stating the degraded run (stop, `awaiting approval`, a
   fresh session resumes).
7. **The proposal door** is written into `mason.md` and `architect.md`, and the
   setup's B1 option 3 is shown as deferred rather than offered.

What is worth remembering:

- **A test that counts greps is not a safety net.** The audited suite was green,
  dense and blind to both bugs in the commit it tested; "223 passed" largely
  counted files that had just been copied. The number the tail prints first is
  now SCENARIOS, and the review surface is a page of English, not 900 lines of
  shell. What the Owner cannot read does not protect him.
- **The guard belongs before the write.** Refusing a v1 layout after copying
  half the socle in would produce exactly the state the guard exists to
  prevent. The test asserts the absence of every file the refused command would
  have written.
- **Ownership by construction beats ownership by scan.** Deriving the manifest
  from the source of truth (what the installer copies) rather than from the
  target's contents removes a whole class of "chisel adopted my file" bugs, and
  makes a retired socle file stop being tracked instead of being tracked
  forever.
- **The gate is asserted by PLACE, not by count.** Three gates in the wrong
  steps would have passed the old count-based test. The suite now pairs every
  gate with the step id it hangs under: `plan type close` / `plan` / nothing.
  It is also the reading trap the chantier documented — the gate sits on the
  step that WAITS.
- **A waiver that cannot outlive its debt.** Two pointers still dangle in
  `methodology.md`, a file this slice does not own (slice 07 does). They are
  waived in one printed `KNOWN GAP` table, asserted in both directions: a new
  dangling pointer fails, and a waived one that starts resolving fails too,
  asking for its line to be deleted. Green never means "hole hidden".
- **The door is the point, and reporting is not waiting.** Without an explicit
  rule, an agent that finds a needed refactor either does it quietly (scope
  nobody approved) or drops it quietly (quality decays and nobody knows why).
  The rule, as the Owner set it during the slice: EVERY discovery goes up one
  rung, always, carrying three evaluations — size, risk (core code? out of my
  scope? broad impact?), and "can I deliver cleanly without it?". The reporter
  evaluates; the receiver decides. The work does not stop unless clean delivery
  is impossible without a decision, and "noted, later — carry on" is always an
  available verdict. Core, out-of-scope or broad-impact work is hands up, never
  own initiative. Answering nothing is the one forbidden answer.

---

## 13. 2026-08-26 — v2 slice 04: the setup chooses the case, in the user's language

Summary of the session:

1. Slice 04 of task `20260826-1512-chisel-v2` completed: the glue now records
   the CASE a repo works in, and the questionnaire asks for it in plain words.
   `§B` is recut into three decisions — **B1** where task statuses live (in the
   task files, by default; a database committed next to them; that same database
   served locally), **B2** whether tasks point back to tickets in another tool
   (none by default; GitHub; Plane — an OPEN list), **B3** whether an agent may
   run a whole task without stopping (disabled by default). Defaults are
   markdown / none / disabled, which is exactly today's behaviour.

Project management:

- Completed **Slice 04 — setup-b-and-glue-v2**. `socle/agents/project.md.tpl`:
  `## B · Coordination` keeps the letter (the formulas and `discipline.md` point
  at "§B") and carries `### B1`, `### B2`, `### B3`; `§E` finally inventories
  the generated role definitions (`.claude/agents`, `.codex/agents`), closing a
  residual slice 02 recorded; new `## H · Model tiers` — the cascade's middle
  rung, the hand-off slice 03 left.
- `socle/agents/skills/chisel-setup/SKILL.md` v2: the same pattern (silent scan,
  facts stated not asked, one section per message, surgical writes, re-runnable)
  now walks A→H, asks §B as three separate questions, poses the current dev's
  `.agents/user.md` and its ignore rule as a step that **runs on its own**, and
  branches on B1 = a database by checking `bd --version` ≥ 1.2.2 — printing the
  install command, never installing, and recording the choice without executing
  anything.
- `bin/chisel.sh`: `.agents/user.md.tpl` joins the managed files, and the two new
  §E lines are ticked only when chisel actually rendered a definition there.
- `test/run.sh` grew a group 10 (65 assertions). Suite: **297 passed, 0 failed**
  (299 with a 3.11+ interpreter, which runs the two optional TOML parses).

Key architectural and technical decisions:

- **The user's language is a testable property.** Everything the questionnaire
  puts on screen is a blockquote in the skill; the suite extracts exactly those
  lines, strips code spans, and fails on "ledger", "formula", "bead", a section
  letter or a glue path — and on any of the eight options that does not explain
  itself in one line. The rule stops being a good intention.
- **The choice and the state on disk are two facts.** Choosing a database writes
  the case AND an unticked `- [ ] initialised` line; the questionnaire says out
  loud that nothing was created. Creating it is the next slice's named step, so
  no agent can infer a database from a preference.
- **§B2 is a mechanism, not a menu.** The link back lives in one place
  (`external_ref` when statuses are in a database, a `**Ticket:**` line
  otherwise) and each tracker is described by one adapter page — including the
  two the questionnaire names, since the socle ships none. Adding GitLab later
  costs one page and zero socle change.
- **`init` installs `.agents/user.md.tpl`; it still never poses `.agents/user.md`.**
  This reverses one assertion of slice 03, deliberately: a repo equipped through
  `npx` cannot reach the socle's own template, and the second dev to clone the
  repo needs no package and no network to write their own personal file — just
  `cp .agents/user.md.tpl .agents/user.md`. The invariant that mattered (a shared
  installer never writes a personal, gitignored file) is untouched and still
  asserted on both fixtures and after `update`.
- **What is normative is visible.** The two-axis review caught the load-bearing
  rules of §B living inside HTML comments; they moved into visible prose, and the
  suite now strips the comments before asserting them — a reader of a default
  `project.md` sees the refusal, the open list and the alternatives, not three
  one-line verdicts.

---

## 12. 2026-08-26 — v2 slice 03: abstract model tiers, the vendor coupling leaves the socle

Summary of the session:

1. Slice 03 of task `20260826-1512-chisel-v2` completed: the socle no longer
   names a model or a vendor anywhere. It speaks in three tiers — **frontier**
   (thinking, grilling, reviewing), **mid** (dispatch, ordinary tasks),
   **cheap** (typing from a plan that is already persisted) — the same three
   the formulas shipped by slice 01 already used, now defined. Which concrete
   model a tier means resolves through a cascade: `.agents/user.md` (personal,
   never committed) > `.agents/project.md` (the versioned team default) > the
   socle default, which carries no model id at all.

Project management:

- Completed **Slice 03 — model-tiers-user-md**. `socle/agents/methodology.md`
  gains one section, "Model tiers (and how they resolve)" — the single
  normative home of the tier table and the cascade, inheriting the role the
  retired `workflows.md §0 — Model policy` used to hold. Its vendor passages
  (the cost-gradient paragraphs, the dex phase table, the artifact ladder) are
  rewritten in tier terms; the sections themselves are untouched.
- `socle/agents/skills/code-review/SKILL.md` stops prescribing a model and a
  specific sub-agent mechanism: it asks for the **frontier** tier and points
  at the methodology section.
- New `socle/agents/user.md.tpl`: the template the setup will pose as
  `.agents/user.md`. Entirely commented out on purpose — an untouched copy
  overrides nothing and resolution falls through to the glue, then the socle
  default. Its example mapping uses placeholders, never model ids: a template
  shipped by the socle is socle text.
- `test/run.sh` grew a group 8 (socle-wide neutrality scan, the cascade, the
  `user.md` contract). Suite: **128 passed, 0 failed**.

Key architectural and technical decisions:

- **One normative place, pointers elsewhere.** The resolution rule is written
  once, in `methodology.md`; the formulas already point there, `code-review`
  now does, and the `user.md` template points there rather than restating the
  rule. A test asserts that exactly one socle file carries the section, and
  names which.
- **The socle default names no model**: *frontier* = the strongest reasoning
  model your tool offers, *mid* = its standard model, *cheap* = its fastest.
  That is what makes "a dev with no `user.md` is never blocked" true on every
  tool, and it is stated black on white: a missing `user.md` is the normal
  case, not an error.
- **`user.md` is posed by the setup, not by `init`.** A shared installer has
  no business writing a personal file, and the ignore rule belongs with the
  questionnaire that writes the glue — so slice 04 poses the file and the
  ignore line. This slice ships the template and the rule, and tests the half
  that exists today: `init` never lays a `user.md` down, `update` leaves a
  hand-written one byte-intact, `check` never flags it.
- **A tier is a property of the work, not of the tool** — which is why the
  socle can state it once and every tool honour it its own way, and why a step
  that names a tier still reads correctly when today's model names are gone.

## 11. 2026-08-26 — v2 slice 02: agent profiles + generated per-tool definitions

Summary of the session:

1. Slice 02 of task `20260826-1512-chisel-v2` completed: the roster becomes
   installable. `socle/agents/profiles/` ships the three canonical role
   contracts — `architect.md` (frontier), `mason.md` (cheap or mid),
   `inspector.md` (frontier) — each with the same five sections: mission,
   tier, prohibitions, escalation, and **Inputs — what this role receives**.
   `bin/chisel.sh` renders them into `.claude/agents/*.md` (which covers
   Cursor ≥ 2.4 for free) and `.codex/agents/*.toml` at `init`, re-renders
   them at `update`, hashes them in `.agents/.chisel.json`, and `check`
   reports them when they drift.

Project management:

- Completed **Slice 02 — agent-profiles**. `socle/agents/foreman.md` ships as
  a doc page, not a profile: the Foreman is the human in Controlled and a
  scheduled job around the tracker's ready/gate queries in Auto, and it
  becomes an agent only when routing starts needing judgement.
  `socle/agents/profiles/README.md` carries the generation contract and the
  universal fallback (profile inlined at spawn, or a fresh session on the
  profile file) for tools with no definition format.
- `test/run.sh` grew a group 8 (contract shape, tier agreement with the
  formulas, the roles named in either formula resolving to a profile,
  verbatim-body rendering, the foreign-file guard, the Codex TOML parse)
  plus layout and drift assertions. Suite: 198 passed, 0 failed on a bare
  `python3`; 200 with a 3.11+ interpreter.
- The two-axis review (fixed point `a7ce105`) caught a real installer bug:
  `find` over a directory that may not exist aborted the manifest builder
  mid-body under `set -euo pipefail`, silently truncating the managed list.
  Fixed and regression-probed, along with a provenance pointer built from
  the wrong field and an unquoted YAML scalar.

Key architectural and technical decisions:

- **The profile body IS the contract; the per-tool definitions are thin
  renders** — asserted byte-for-byte by the suite, so a render can never
  become a paraphrase. No tool can import a shared definition, so chisel
  generates rather than references.
- **A definition chisel did not write is never overwritten.**
  `.claude/agents/` is a namespace shared with the user's own sub-agents: a
  file without the `chisel:generated` marker earns a warning and is left
  alone, and chisel claims as managed only what it wrote.
- **No `model:` key and no tool name in prose** — the tier travels as prose
  (frontier / mid / cheap) and the tier → model cascade stays slice 03's;
  the per-tool render table speaks in adapter paths, so the socle names a
  directory, never a vendor. The suite greps both, sources and renders, with
  code spans stripped.
- **The delegation contract lives with the role that consumes it**: the
  Mason's brief is the spec file, the artifacts it references and the ambient
  layer — never the planning conversation; the Inspector's is the diff, the
  pinned fixed point and the spec pointer. Whoever delegates reads the target
  profile first.

## 10. 2026-08-26 — v2 slice 01: discipline core + formulas, the three rules retired

Summary of the session:

1. Slice 01 of task `20260826-1512-chisel-v2` completed: the normative prose
   of the socle is recomposed into layers. `socle/agents/discipline.md` (the
   ambient invariant core — read first, plan first, 🧑 zones are law, verify
   before "done", the bridge rule, escalate rather than improvise, session
   hygiene, side lanes) plus `socle/agents/formulas/chisel-controlled.formula.toml`
   and `chisel-auto.formula.toml` (the same seven steps — interview, spec,
   plan, type, verify, review, close — differing by exactly three human gates
   and the escalation wording). `socle/agents/rules/` and
   `socle/agents/workflows.md` are deleted; `socle/templates/AGENTS-block.md`
   is now the v2 router.

Project management:

- Completed **Slice 01 — recomposition-discipline-formulas**. The slice's
  Notes carry the v1 → v2 mapping table: 51 obligations of the three rules
  and of `workflows.md`, each traced to its new home (a discipline rule, a
  formula step, a skill, the task template, or `methodology.md`) — nothing
  dropped silently, residuals owned by later slices listed explicitly.
- `bin/chisel.sh` installs `discipline.md` + `formulas/` in place of
  `rules/` + `workflows.md`; `test/run.sh` grew a group 7 for the formula
  invariants and the neutrality greps. Suite: 103 passed, 0 failed.
- Parity re-checked without any ledger tooling: a context-free agent session
  on a freshly equipped fixture routed `AGENTS.md` → `discipline.md` →
  reading list → bridge rule → the Controlled formula, walked the seven
  steps in order and stopped at exactly the three gates — same sequence,
  same artifacts, same verification as the v1 rules.

Key architectural and technical decisions:

- **Persist-the-plan know-how lives in the formula's `plan` step**, not in a
  new file (the sub-point the parent deferred to this slice's plan gate).
  One source per concept: the *why* is already `methodology.md`, the
  *where-in-the-file* is already the task and slice templates, so the
  remaining *when/what* belongs to the step that triggers it — and a stray
  markdown file next to the TOMLs would end up inside the ledger tool's
  formula directory in beads mode.
- **The two formulas are one pipeline in two modes, enforced by a test**:
  every Auto step body is the Controlled body with escalation lines appended
  and none removed, so the diff between the files can only ever be gates plus
  escalation wording.
- **The step wording is ledger- and vendor-neutral**: roles are roster names
  (Architect, Mason, Inspector, Owner), tiers are abstract (frontier / mid /
  cheap), and every write resolves through the glue `.agents/project.md`. No
  backend and no model name appears in a step — asserted by the suite.
- The retired `workflows.md` §6 ("where things live") moved into
  `socle/templates/000-task-file-template.md`, per the one-source rule that
  gives structure to the templates.

## 9. 2026-08-26 — Chisel v2 task created ("un repo, des modes")

Distilled the finished factory-bench design chantier (decision map `fb-3kk`,
14 tickets closed) into task `20260826-1512-chisel-v2` + 7 slices: piloting ×
coordination matrix, recomposition of the 3 rules + workflows.md into
discipline.md + 2 formulas + skills, agent profiles with generated per-tool
definitions, abstract model tiers with user.md cascade, setup §B1–B3,
chisel-beads convention (neutralized bd init), upgrade-v2 skill +
CHANGELOG→LOG rename, docs rewrite + one-source-per-concept dedup. Decisions
link the factory-bench artifacts — nothing re-decided.

## 8. 2026-08-25 — PHILOSOPHY.md

Added the "why" document at the repo root (task
`20260825-1046-philosophy-doc`): the original problem (review is the
bottleneck; our three frustrations with existing SDD frameworks), the six
alternatives studied/tested with sources and outcomes, the outside references
(dex's phase model, Cursor's agent-swarm economics), our conclusions as
belief statements, and the methodology in brief. README links to it.
Written for the team announcement and future evaluators.

## 7. 2026-08-10 — Field-test fixes (first real-world dry-run)

First full install dry-run on a real untouched pnpm monorepo (gcs-monorepo):
`init` → `check` → `chisel-setup` questionnaire worked end-to-end. Two chisel
defects found and fixed (task `20260810-1037-field-test-fixes`):

- `AGENTS-block.md`'s self-doc comment leaked socle-meta wording into
  equipped projects' AGENTS.md — rewritten context-neutral.
- `init` never filled the §E adapter inventory it poses — it now ticks the
  adapters actually in place, only when it CREATES `project.md` (a
  pre-existing glue stays untouched; new ownership test proves it).
- Test-harness fix found on the way: `grep -qF` without `--` swallowed
  needles starting with `-`. Suite now at 79 asserts.

Open decision reopened by the field test: GitLab Issues as a wired §B
tracker option (gcs is GitLab-hosted; D5-B offered local | GitHub | Plane).

## 6. 2026-08-06

Summary of the session:

1. Slice 04 (setup questionnaire) completed: `chisel-setup`, the prompt-driven
   skill that turns `.agents/project.md.tpl`'s defaults into a repo's actual
   glue — silent exploration, sections A–G walked one at a time with a
   recommendation first, surgical section-scoped writes that never touch
   anything outside their own heading's span.

Project management:

- Completed **Slice 04 — setup-questionnaire** of Task
  20260806-0959-chisel-v1: added `socle/agents/skills/chisel-setup/SKILL.md`
  (pure protocol, no script, no `x-upstream` block — this is OUR skill).
- Verified by execution on temp copies of both committed fixtures (real
  `bin/chisel.sh init`, then the protocol walked by hand in
  accept-every-recommendation mode): boilerplate → §D/§G point into
  `apps/documentation`, §F filled from the fixture's `package.json` scripts,
  §A/§B left at the scan-confirmed defaults; brownfield → §C became a
  scan-derived draft (README-only, explicitly refined with the user), §F
  picked up a real fact from `CLAUDE.md` (`bundle exec rspec`) instead of
  staying blank. AC-3 surgical-write proof: a hand-added `## H · Local
  notes` section and a hand-added line above §A both came back
  byte-identical (`sha256` match, `diff` exit 0) after re-running only §A's
  write.

Key architectural and technical decisions:

- §E (Adapters) is read-back-only in the questionnaire — it is `init`-written
  inventory, never asked; a missing adapter is flagged as a `chisel check`
  matter, not fixed by this skill.
- The surgical write is scoped strictly to one section's heading span
  (`## <letter> · ...` up to the next `## ` heading or EOF) — the skill never
  rewrites the whole file, so hand-added sections and content above §A/below
  §G survive every re-run untouched.

## 5. 2026-08-06

Summary of the session:

1. Slice 03 (installer CLI) completed: `npx @lonestone/chisel init|update|
   check` now exists as `bin/chisel.sh` behind a zero-dependency
   `package.json`, tested end-to-end against two committed fixture repos.

Project management:

- Completed **Slice 03 — installer-cli** of Task 20260806-0959-chisel-v1:
  added `package.json` (`@lonestone/chisel`, `bin.chisel`), `bin/chisel.sh`
  (`init [target-dir]` / `update` / `check`, portable macOS bash 3.2 +
  Linux bash 4/5), `socle/templates/AGENTS-block.md` (the canonical,
  self-documenting source text of the AGENTS.md managed block), and
  `test/fixtures/{brownfield,boilerplate}/` + `test/run.sh` (71 plain-sh
  assertions, no bats).
- `test/run.sh` real run: 71 passed, 0 failed — full target layout on both
  fixtures, idempotent `init`, `update` refreshing a hand-edited managed
  skill while leaving `.agents/project.md` and `CHANGELOG.md`
  byte-identical, `check` exit 0→1 across a hand-edit, and package-root
  resolution through a symlink (Decision 2's `readlink` loop).

Key architectural and technical decisions:

- The AGENTS.md managed block is delimited by `<!-- chisel:begin -->` /
  `<!-- chisel:end -->` markers, rewritten via an `awk`-into-temp-file +
  `mv` (no `sed -i` anywhere — not portable across BSD/GNU); its content
  lives in `socle/templates/AGENTS-block.md`, diffable and reviewed like
  any other source, not hardcoded in the installer script.
- `update` re-renders managed files and the AGENTS.md block, then diffs
  the manifest before vs. after the run to report what the socle itself
  changed — it never touches `.agents/project.md`, `CHANGELOG.md`,
  `tasks/`, `archive/`, or CLAUDE.md/the skills symlink beyond their
  one-time creation. `check` is the only command that detects *local*
  divergence from the manifest, and performs zero writes.
- `bin/chisel.sh` has one dependency beyond a POSIX toolchain: `python3`,
  used solely for the `.agents/.chisel.json` manifest's JSON, mirroring
  `sync-upstream.sh`'s existing precedent; `sha256sum`/`shasum` are
  tried in that order for file hashing.

## 4. 2026-08-06

Summary of the session:

1. Slice 05 (upstream sync) completed: a mechanical `sync-upstream.sh` script
   plus a `sync-upstream` skill give this repo a controlled path back to
   `mattpocock/skills` — drift detection and per-skill diffs are scripted;
   reading diffs and proposing merges is the agent's job; approving them is
   always the human's.

Project management:

- Completed **Slice 05 — upstream-sync** of Task 20260806-0959-chisel-v1:
  added `socle/scripts/sync-upstream.sh` (`--check` reports drifted skills
  with commit counts and frontmatter/lock SHA mismatches, zero writes beyond
  the upstream cache; `--diff <skill>` prints the raw upstream diff for one
  skill) and `socle/agents/skills/sync-upstream/SKILL.md` (the
  agent-proposes/human-validates loop, one skill at a time, with a
  heavy-divergence clause that proposes `x-upstream: none` instead of forcing
  a merge).

Key architectural and technical decisions:

- The script never applies anything, in either mode — its only side effect,
  ever, is cloning/fetching the upstream cache under
  `~/.cache/chisel/<owner>-<repo>/`. Reading a diff, proposing a merge that
  preserves a fork's documented `changes:`, and deciding to unplug a skill
  (`x-upstream: none`) all live in the skill's protocol, validated by the
  human skill by skill; an unanswered proposal counts as rejected.
- Real `--check` run against the live `upstream.lock.json` found 9 of the 15
  forked skills already drifted from the SHA recorded at slice 01 — none
  synced yet by design; this slice ships the tool, not the sync itself.

## 3. 2026-08-06

Summary of the session:

1. Slice 02 (genericize the socle) completed: no hardcoded music-downloader
   path remains in the socle — rules and skills resolve the task workspace,
   changelog, template, tracker, reading list, and glossary/ADR locations
   through `.agents/project.md` (the glue), written this slice as
   `socle/agents/project.md.tpl` with its 7 questionnaire sections (A–G).

Project management:

- Completed **Slice 02 — genericize-socle** of Task 20260806-0959-chisel-v1:
  rewrote the 3 task rules, `workflows.md`, `methodology.md`, and the task
  file template to resolve external paths via `.agents/project.md` instead of
  hardcoding `doc/project-management/...`; socle-internal skill links became
  relative (`../skills/...`); added the one-line glossary/ADR indirection to
  the 5 CONTEXT.md-heavy skills; swapped the 4 issue-tracker.md references to
  point at `.agents/project.md`'s Tracker section.

Key architectural and technical decisions:

- `socle/agents/issue-tracker.md` deleted — its content (mode, task paths,
  format, the "switch to an external tracker" procedure) is now absorbed into
  `project.md.tpl`'s Section B, the single place the tracker is configured.
- `CONTEXT.md` stays the artifact's *name* everywhere it's mentioned in skill
  bodies (untouched, per design); only its *location* now resolves through
  `.agents/project.md` where a path was previously hardcoded.
- Every edited Pocock-forked skill (9 of them) got its frontmatter `changes:`
  line extended with "; project paths resolve via .agents/project.md";
  `sha:` values and `upstream.lock.json` untouched — same upstream version,
  documented divergence.

## 2. 2026-08-06

Summary of the session:

1. Slice 01 (repo skeleton + socle import) completed: `socle/` now holds the
   canonical methodology content, copied (not moved) from music-downloader's
   `doc/agents/` at current HEAD.

Project management:

- Completed **Slice 01 — repo-skeleton-import** of Task
  20260806-0959-chisel-v1: populated `socle/agents/{skills,rules}/`,
  `socle/templates/`, `socle/scripts/`; added `upstream.lock.json` at the
  repo root.

Key architectural and technical decisions:

- All 15 Pocock-forked skills copied into `socle/agents/skills/`, each
  gaining `x-upstream: {repo, path, sha, changes}` frontmatter (SHA
  `2ab958093e83e0ec752e6c1c5932da465bf23e0c`, current HEAD of the local
  `pocock-skills` clone); `upstream.lock.json` mirrors the same 15
  names/SHAs.
- The 3 Cursor task rules (`task-creation`, `task-progressing`,
  `task-completion`) ported to tool-agnostic `socle/agents/rules/*.md`: the
  `alwaysApply` Cursor frontmatter stripped, `.mdc` → `.md`, content
  otherwise byte-identical (hardcoded paths stay for slice 02).
- music-downloader was only ever read from (copy, never move) — verified via
  unchanged `git status` before/after.

## 1. 2026-08-06

Summary of the session:

1. Chisel is born: decisions D1–D7 grilled and locked (name, channel, layout,
   upstream sync, questionnaire, bundle content, versioning) — full log in the
   parent task's Notes.

Project management:

- Created **Task 20260806-0959-chisel-v1**: installable dev-workflow socle —
  parent task (product + architecture) + 7 slices (skeleton/import,
  genericize, installer CLI, setup questionnaire, upstream sync, pilot
  migration, release). Slices 01 → then 02/03/05 can run in parallel.

Key architectural and technical decisions:

- Unified `.agents/` layout (Codex + Cursor ≥2.4 native; Claude via one
  symlink); `AGENTS.md` source of truth, `CLAUDE.md` = `@AGENTS.md` import
- Editable-copy installer (sh behind npm bin), managed blocks, glue
  (`project.md`) as runtime indirection — rules stay byte-identical across
  projects
- Vendored Pocock forks with per-skill `x-upstream` frontmatter +
  `upstream.lock.json`; sync = agent proposes / human validates, ~2–6×/year
