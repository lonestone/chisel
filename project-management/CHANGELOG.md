# Changelog

Project history, newest first. Dated entries, per the methodology this repo
ships.

---

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
