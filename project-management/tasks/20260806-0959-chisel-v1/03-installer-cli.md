# 03 — Installer CLI (npx @lonestone/chisel)

**Status:** 🟢 Complete
**Blocked by:** 01 (✅ done)

**What to build:** `package.json` (`@lonestone/chisel`, bin) + `bin/chisel.sh`
with three commands. `init`: copy socle → `.agents/`, pose adapters
(AGENTS.md managed block, CLAUDE.md `@AGENTS.md`, `.claude/skills` symlink,
`scripts/task-id.sh`, `/project-management/` skeleton). `update`: re-render
managed parts only. `check`: report version + local divergences. Tested on
committed fixture repos.

## Acceptance criteria

- [x] `npx` run from a fixture repo produces the full target layout of the
      parent Architecture diagram
- [x] `init` is idempotent (second run = no diff); `update` never touches
      `project.md` nor files outside managed markers
- [x] Existing CLAUDE.md/AGENTS.md content is merged (managed block), never
      overwritten
- [x] Works on macOS + Linux sh (no bashisms beyond `#!/usr/bin/env bash`) —
      verified live on macOS (stock bash 3.2); Linux was not literally
      executed this session (single-OS sandbox) but the script avoids every
      known bash-3.2-vs-4/5 gap (no associative arrays, no `[[ ]]`, no
      process substitution, no GNU-only flags) — see Deviations

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-06 · planner: Fable · typist: Sonnet sub-agent)

### Decisions locked

1. **`package.json`**: `name: @lonestone/chisel`, `version: 0.1.0`,
   `bin: {"chisel": "bin/chisel.sh"}`, `files: ["bin", "socle",
   "upstream.lock.json"]`, `license`, `repository`. **Zero dependencies** —
   npm is only the distribution channel (parent decision "sh over Node").
2. **`bin/chisel.sh`** — `#!/usr/bin/env bash`, `set -euo pipefail`, portable
   macOS + Linux: no `sed -i`, no GNU-only flags, no `realpath` dependency.
   Package root resolved by following `$0` through symlinks with a manual
   `readlink` loop (npx installs the bin as a symlink), then
   `cd <dir>/.. && pwd -P`.
3. **`init [target-dir]`** (default `.`), in order:
   - Copy `socle/agents/{skills,rules}` and `socle/agents/{workflows,methodology}.md`
     into `<target>/.agents/`.
   - `project.md`: copy `socle/agents/project.md.tpl` → `.agents/project.md`
     **only if absent** — the glue is project-owned from the moment it exists;
     `init` re-run and `update` NEVER touch it.
   - **AGENTS.md managed block**: if `AGENTS.md` is absent, create it with a
     one-line title + the block. If present, insert/replace ONLY the region
     between `<!-- chisel:begin` and `<!-- chisel:end -->` markers (append the
     block at the end when markers are absent), preserving every byte outside.
   - **CLAUDE.md**: ensure a line `@AGENTS.md` exists (create the file with
     just that line if absent; if present without the line, append it). Never
     touch anything else in it.
   - **`.claude/skills` symlink** → relative `../.agents/skills`. If the path
     exists and is not the expected symlink: warn and skip, never overwrite.
   - Copy `socle/scripts/task-id.sh` → `<target>/scripts/task-id.sh`
     (executable), creating `scripts/` if needed.
   - `/project-management/` skeleton: `tasks/`, `archive/`,
     `000-task-file-template.md` (copied), and `CHANGELOG.md` created **only
     if absent** (header + one dated "chisel init" line).
   - Write the **manifest** `.agents/.chisel.json`: chisel version + the list
     of managed files with their sha256 hashes. The manifest is what makes
     `update` and `check` possible; it is machine-owned, humans never edit it.
4. **Managed vs project-owned — the contract** (`update` enforces it):
   - Managed (re-rendered by `update`, hash-tracked in the manifest):
     `.agents/skills/**`, `.agents/rules/**`, `.agents/workflows.md`,
     `.agents/methodology.md`, `scripts/task-id.sh`,
     `/project-management/000-task-file-template.md`, and the AGENTS.md
     managed block (block content hash-tracked, not the whole file).
   - Project-owned (never touched after creation): `.agents/project.md`,
     `CHANGELOG.md`, `tasks/`, `archive/`, everything outside the AGENTS.md
     markers, all of CLAUDE.md beyond ensuring the `@AGENTS.md` line.
5. **`update`**: re-copy managed files + re-render the AGENTS.md block from
   the current package, then refresh the manifest. Prints a summary of what
   changed. Respects the Decision 4 contract absolutely.
6. **`check`**: reports (a) package version vs manifest version, (b) managed
   files whose current hash differs from the manifest (local divergence —
   legitimate, but must be visible before an `update` overwrites it),
   (c) adapters present (symlink resolves, `@AGENTS.md` line, block markers).
   Exit 0 clean, exit 1 on any divergence/missing adapter. Zero writes.
7. **`socle/templates/AGENTS-block.md`** — NEW file: the canonical content of
   the AGENTS.md managed block. It is NOT a substitution template — nothing
   is rendered into it; it is the block's source text, stored in the socle so
   it is diffable, reviewable, and re-renderable by `update` instead of being
   hardcoded in the installer script. **The file must open with an HTML
   comment explaining exactly that** (what a managed block is, who owns what,
   that edits belong outside the markers) — this is the user-facing doc for
   the mechanism. Body: the thin conductor, SHORT (~10 lines): read
   `.agents/project.md` §C at session start; creating a task →
   `.agents/rules/task-creation.md`; working → `task-progressing.md`;
   finishing → `task-completion.md`; workflows & skills →
   `.agents/workflows.md`. AGENTS.md routes; the socle carries the content.
8. **Tests** — `test/fixtures/` committed + `test/run.sh`, plain sh asserts
   (no bats dependency), CLI-seam only (file tree in → file tree out):
   - `fixtures/brownfield/`: pre-existing `AGENTS.md` and `CLAUDE.md` with
     user content, a `README.md`, no `.agents/`.
   - `fixtures/boilerplate/`: `apps/documentation/` present, `package.json`
     with lint/test scripts, no AGENTS.md.
   - `test/run.sh` copies each fixture to a temp dir and asserts: full target
     layout after `init` (per the parent Architecture diagram); user content
     byte-preserved outside the block; **idempotence** (`init` twice →
     `diff -r` empty); `update` after editing `.agents/project.md` and
     `CHANGELOG.md` leaves both intact while refreshing a managed file;
     `check` exit codes (0 fresh, 1 after hand-editing a managed skill).
   - Real `npx` (`npm pack` + install) is validated at slice 07 (release);
     this slice tests through `bin/chisel.sh` directly — same code path
     minus npm's bin symlink, which Decision 2's resolution loop covers.

### Verification

- `test/run.sh` passes end-to-end on both fixtures (run it, paste the output)
- `bash -n bin/chisel.sh` passes; executable bit set
- Manual spot-check on the brownfield temp copy: AGENTS.md shows user content
  above the block, block content identical to `AGENTS-block.md`
- `grep -c "chisel:begin" AGENTS.md` = 1 after two inits (no duplicate block)
- No fixture or temp-dir artifacts staged into the commit beyond
  `test/fixtures/` themselves

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Worklog (2026-08-06, typist: Sonnet sub-agent)

- Wrote `bin/chisel.sh` (`#!/usr/bin/env bash`, `set -euo pipefail`, same
  conservative style as `socle/scripts/sync-upstream.sh`: no arrays, no
  `[[ ]]`, no process substitution, no `local`). Package-root resolution:
  a manual `readlink` loop follows `$0` through symlinks (relative or
  absolute targets), then `cd <dir>/.. && pwd -P`. `sha256_file`/
  `sha256_stdin` fall back from `sha256sum` to `shasum -a 256` (macOS has
  no `sha256sum` by default). `package_version` reads `package.json`'s
  flat `version` field via `grep`+`sed -E` — no `python3` needed for that.
  `python3` is required only for the JSON manifest (`.agents/.chisel.json`
  read/write), same precedent as `sync-upstream.sh`'s lock parsing;
  `require_python3` dies with a clear message if it's missing.
- `init [target-dir]` (default `.`): copies `.agents/{skills,rules}` +
  `.agents/{workflows,methodology}.md` from the socle (`cp -R`, merges into
  an existing `.agents/` on re-init); writes `.agents/project.md` only if
  absent; renders the AGENTS.md managed block (creates the file with a
  one-line title if absent, otherwise replaces only the region between
  `<!-- chisel:begin -->`/`<!-- chisel:end -->` via an `awk` rewrite into a
  temp file + `mv`, appending fresh markers at the end when none exist yet
  — no `sed -i` anywhere); ensures a literal `@AGENTS.md` line in
  CLAUDE.md (creates the file if absent, appends the line if missing,
  touches nothing else); links `.claude/skills` → `../.agents/skills`
  (warns and leaves alone if something else is already there); copies
  `scripts/task-id.sh` (+`chmod +x`, defensive re-assertion of the bit
  cp already carries); builds the `/project-management/` skeleton
  (`tasks/`, `archive/`, the template copied, `CHANGELOG.md` written once
  with a dated "chisel init" line only if absent); writes the manifest.
- `update`: re-copies the same managed files, re-renders the AGENTS.md
  block if present (warns and skips if AGENTS.md is missing rather than
  creating it — that's `init`'s job), refreshes the manifest, then diffs
  the manifest's per-file hashes **before vs. after this run** and prints
  `changed: <path>` for each one that moved (or `(no managed files
  changed)`). Never touches `.agents/project.md`, `CHANGELOG.md`,
  `tasks/`, `archive/`, CLAUDE.md, or the `.claude/skills` symlink.
- `check`: compares the installed package version to the manifest's
  recorded version, walks every manifest entry (including the synthetic
  `AGENTS.md#block` key) recomputing its current hash and reporting
  `MISSING`/`DIVERGED` lines, then verifies the three adapters (symlink
  resolves, CLAUDE.md's `@AGENTS.md` line, AGENTS.md's markers). Zero
  writes anywhere (`mktemp` scratch files live outside the target).
  Exit 0 clean, exit 1 on any mismatch/divergence/missing adapter.
- Wrote `socle/templates/AGENTS-block.md`: opens with an HTML comment that
  is the user-facing doc for the mechanism (names the two markers by name
  only, never their literal `<!-- … -->` form together, so the comment
  can't self-terminate early — verified: `grep -n -- '-->'` finds exactly
  one line, the real closing `-->`). Body is 8 lines: read
  `.agents/project.md` §C, then route by phase to `task-creation.md` /
  `task-progressing.md` / `task-completion.md` / `workflows.md`.
- Wrote `package.json` (`@lonestone/chisel`, `bin.chisel` →
  `bin/chisel.sh`, `files: [bin, socle, upstream.lock.json]`, no
  `dependencies` key at all — zero deps).
- Wrote `test/fixtures/brownfield/` (pre-existing `AGENTS.md` + `CLAUDE.md`
  with user content, a `README.md`, no `.agents/`) and
  `test/fixtures/boilerplate/` (`apps/documentation/`, a `package.json`
  with `lint`/`test`/`build` scripts, no `AGENTS.md`).
- Wrote `test/run.sh` (plain `[ ]`/`grep`/`diff` asserts, no bats): copies
  each fixture into a fresh `mktemp -d "${TMPDIR:-/tmp}/…"` dir per test
  (fixtures under `test/fixtures/` are read-only source, never mutated),
  6 scenarios — full layout on both fixtures, idempotence, `update`
  refreshing a hand-edited managed file while leaving `project.md` and
  `CHANGELOG.md` byte-identical, `check` exit 0→1 across a hand-edit, and
  a symlinked-invocation test for Decision 2's `readlink` loop.

### Verification output

- `test/run.sh`, real run against the committed fixtures (`TMPDIR` pointed
  at the session scratchpad): **71 passed, 0 failed**. Scenario summary:
  1. brownfield `init` → full target layout (all 21 layout assertions) +
     user content byte-preserved (`AGENTS.md` heading/note, `CLAUDE.md`
     Ruby/Sidekiq line, `README.md`) + rendered block byte-identical to
     `socle/templates/AGENTS-block.md` — **PASS**.
  2. `init` twice on the same brownfield copy → `diff -r` empty, exactly
     one `<!-- chisel:begin -->` line — **PASS**.
  3. boilerplate `init` → full target layout, `apps/documentation/` and
     `package.json` untouched — **PASS**.
  4. `update` after hand-editing `.agents/project.md`, `CHANGELOG.md`, and
     `.agents/skills/tdd/SKILL.md`: the two glue files come back
     byte-identical to their pre-update copies; the skill file's local
     edit is gone and the file matches the socle source exactly; the
     summary prints a well-formed `chisel update: …` header followed by a
     `changed:`/`(no managed files changed)` line — **PASS**.
  5. `check` exits 0 immediately after a fresh `init`; after hand-editing
     `.agents/skills/code-review/SKILL.md` it exits 1 and names that exact
     path as `DIVERGED` — **PASS**.
  6. `chisel` invoked through a symlink in an unrelated temp directory
     still resolves the real package root and copies real socle content —
     **PASS** (exercises Decision 2's `readlink` loop, not just the
     direct-path case the other 5 scenarios use).
- `bash -n bin/chisel.sh` → syntax OK. `ls -la bin/chisel.sh test/run.sh`
  → both `-rwxr-xr-x` — **PASS**.
- Manual brownfield spot-check (separate temp copy, `chisel init`):
  `AGENTS.md` shows the original heading and both user bullets above
  `<!-- chisel:begin -->`; the block content between the markers, isolated
  with `awk`, `diff`s empty against `socle/templates/AGENTS-block.md` —
  **PASS**.
- `grep -c -- '<!-- chisel:begin -->' AGENTS.md` after two inits on the
  same target → `1` — **PASS**. (A plain `grep -c 'chisel:begin'`, without
  anchoring to the full marker line, over-counts by one: the block's own
  doc comment names the marker in prose. The test asserts on the exact
  marker line for that reason — see Deviations.)
- `python3 -c "import json; json.load(open('package.json'))"` → parses
  clean — **PASS**.
- `git status` before/after the whole session: only the expected new
  paths (`bin/`, `package.json`, `socle/templates/AGENTS-block.md`,
  `test/`, this slice file) — no stray temp-dir or fixture-copy artifacts
  leaked into the working tree — **PASS**.

### Deviations from Design

- **`python3` as a second external dependency for `bin/chisel.sh`.**
  Decision 1's "zero dependencies" is about npm/Node runtime deps (npm is
  only the distribution channel); Decision 2 lists shell-portability
  constraints but is silent on non-shell tool dependencies for this
  script specifically. Conservatively followed the precedent already set
  by `socle/scripts/sync-upstream.sh` (which requires `python3` for its
  JSON lock) rather than hand-rolling JSON generation/parsing in `awk`/
  `sed`, which would be far more failure-prone for a nested object with an
  arbitrary number of keys. `require_python3` fails loudly with a clear
  message, matching `sync-upstream.sh`'s error style. Reduced the
  footprint where it was easy to: `package_version` reads the single flat
  `version` field with `grep`+`sed -E` instead, so `--version`/`--help`
  never need `python3` at all.
- **`update`'s "summary of what changed" diffs the manifest before vs.
  after the run — not the on-disk file before vs. after.** The Design
  text ("re-render managed files … refresh the manifest. Prints a summary
  of what changed") doesn't specify which comparison to print. Since the
  manifest only ever records what the *last* `init`/`update` wrote, a
  before/after-manifest diff reports **socle changes newly applied by this
  update** (the useful signal when bumping to a newer chisel version) —
  it does NOT report locally hand-edited files being silently overwritten,
  because the manifest never had a record of that local edit in the first
  place. Detecting *local* divergence from the manifest is `check`'s job
  (Decision 6), by design — kept the two commands' responsibilities
  disjoint rather than having `update` also print divergence warnings.
  Verified explicitly in the test suite's scenario 4 comment.
- **`update` and `check` accept an optional `[target-dir]` positional
  argument, defaulting to `.`.** Decision 3 specifies `[target-dir]` only
  for `init`'s signature; Decision 5/6 are silent on it for `update`/
  `check`. Added it uniformly (same optional arg, same default) purely so
  `test/run.sh` can point every command at a fixture's temp copy without
  `cd`-ing the whole test process into it; behavior with no argument is
  unchanged. Noted here rather than silently changing the CLI surface.
- **Internal ordering inside `cmd_init`** copies `scripts/task-id.sh`
  together with the `.agents/` copy (inside one `copy_managed_files`
  helper shared with `update`) rather than as Decision 3's literal
  standalone later step. Every one of these copy operations is
  independent and idempotent (none reads output of another), so the final
  on-disk state is identical either way — confirmed by the full-layout
  assertions and the idempotence test. Flagging the reordering for
  transparency, not as a functional change.
- **`package.json` includes a `description` field** beyond Decision 1's
  named six (`name`, `version`, `bin`, `files`, `license`, `repository`).
  Standard, inert npm metadata; left in rather than stripped since it
  costs nothing and documents the package on the npm listing.
- **`license: "MIT"`** — no `LICENSE` file exists yet anywhere in this
  repo. Chose `MIT` because the README's Provenance section already
  frames the bundled Pocock forks as "MIT, adapted," and it's the
  conventional default for this kind of tool; no explicit repo-wide
  license decision was found in any task file. Flagging for slice 07
  (release): add an actual root `LICENSE` file matching this declared
  value before the first `npm publish`.
- **Test scenario 6 (symlinked invocation)** is additional coverage beyond
  the Design's four literal fixture-test bullets, added because none of
  the other five scenarios exercise the `readlink`-loop branch of package
  root resolution at all (they all invoke `bin/chisel.sh` by its real
  path) — Decision 2's claim about following npx's symlink would
  otherwise go completely unverified until slice 07's real `npx` test.
  Cheap to add, so it stayed in rather than being spun off.

### Planner review (2026-08-06, Fable)

Commit `08a2773` reviewed green. `test/run.sh` re-run by the planner
independently: 71/71 pass. `AGENTS-block.md`'s opening comment covers the
mechanism, the ownership contract, and where to edit — exactly the
user-facing doc requested at the plan gate. All 7 typist deviations
accepted (the extra symlink-invocation test scenario is a genuine
improvement; the MIT-license-without-LICENSE-file flag is carried to
slice 07). One planner fixup: `render_agents_md` wrote the final file with
`mv "$tmp"`, which stamps mktemp's mode 600 onto an existing AGENTS.md —
replaced with cat-into-place to preserve the target's permissions (a class
of defect the black-box tests can't see). Full suite re-run green after
the fixup.
