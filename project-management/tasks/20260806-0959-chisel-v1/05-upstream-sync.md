# 05 — Upstream sync (Pocock forks)

**Status:** 🟢 Complete
**Blocked by:** 01 (✅ done)

**What to build:** The `sync-upstream` skill + supporting script. `--check`
lists which forked skills drifted upstream (SHA compare) without writing. Full
run: fetch upstream, diff each skill since its recorded SHA, present per-skill
proposed merges preserving our documented adaptations — agent proposes, human
validates, nothing auto-applied. Updates frontmatter SHAs + lock + CHANGELOG.

## Acceptance criteria

- [x] `--check` output lists drifted skills with commit counts, zero writes
- [x] A full run on a deliberately outdated SHA produces a reviewable diff and
      applies ONLY after explicit approval, preserving `changes:` adaptations
- [x] A skill marked `upstream: none` is skipped and reported as unplugged

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-06 · planner: Fable · typist: Sonnet sub-agent)

### Architecture: mechanical script + protocol skill

Raw git operations are scripted; judgment (reading diffs, proposing merges)
belongs to the agent; validation belongs to the human. Nothing is ever
auto-applied.

### Decisions locked

1. **`socle/scripts/sync-upstream.sh`** — same style as `task-id.sh`
   (`#!/usr/bin/env bash`, `set -euo pipefail`, no other bashisms). Purely
   mechanical, three modes:
   - **Cache clone.** Upstream repos are cloned once into
     `${XDG_CACHE_HOME:-$HOME/.cache}/chisel/<owner>-<repo>/` (full clone —
     history is needed for commit counts), then `git fetch origin` on every
     run. GitHub URL built as `https://github.com/<repo>.git` from the lock's
     `repo:` field. No dependency on any local clone elsewhere.
   - **`--check` (default mode).** For each lock entry: entries whose value is
     the string `"none"` are listed in a separate "unplugged" section and
     skipped. Otherwise run
     `git -C <cache> log --oneline <recorded-sha>..origin/main -- <path>`;
     report a table `skill · commits-behind · latest subjects (max 3)`. Also
     cross-check each skill's frontmatter `sha:` against the lock and print a
     `WARN mismatch` line when they differ. **Zero writes anywhere.** Exit 0
     if no drift, exit 1 if any skill drifted (usable in CI later).
   - **`--diff <skill-name>`.** Print
     `git -C <cache> diff <recorded-sha>..origin/main -- <path>` for that one
     skill — the raw material the agent reads. Errors clearly if the skill is
     unknown or unplugged.
   - **Lock parsing via `python3`** (single, explicit dependency; fail with a
     clear message if absent). The lock (`upstream.lock.json`, repo root) is
     the machine-readable source; per-skill frontmatter is the per-file
     source; the script only ever verifies their coherence, never edits.
   - Flags: `--lock <path>` (default `./upstream.lock.json`) and
     `--skills-dir <path>` (default `socle/agents/skills`, falling back to
     `.agents/skills` when the former is absent) so the same script works in
     the chisel repo and in equipped projects.
2. **`socle/agents/skills/sync-upstream/SKILL.md`** — OUR skill, not a fork:
   **no `x-upstream` block**. Frontmatter: `name`, `description`,
   `disable-model-invocation: true` (user-invoked, like Pocock's maintenance
   skills). Body encodes the D3 protocol:
   - Step 1: run `--check`, present the drift table to the human verbatim.
   - Step 2: for each drifted skill, **one at a time**: run `--diff`, read our
     documented adaptations in the fork's `changes:` frontmatter, propose a
     merge that explicitly preserves them ("upstream changed X; our adaptation
     Y is kept because Z"). **The human validates skill by skill** — an
     unanswered proposal is a rejected proposal.
   - Step 3, after each validated application: update that skill's
     frontmatter `sha:` to the new upstream HEAD, update the lock entry, add a
     dated CHANGELOG line naming the skill and summarizing what was absorbed.
   - **Heavy-divergence clause (D3):** if preserving our adaptations would
     mean rewriting most of the upstream diff, propose switching the skill to
     `x-upstream: none` (frontmatter literal `none`; lock value the string
     `"none"`) instead of forcing the merge. The human decides.
   - Cadence note: expected ~2–6×/year, run from the chisel repo; equipped
     projects receive the result via `chisel update` (slice 03's pipeline).
3. **AC-3 wiring:** `--check` and `--diff` implement the `upstream: none`
   skip/report behavior even though no skill is unplugged today — verified
   with a temporary lock copy containing a `"none"` entry (see Verification).

### Verification

- `sync-upstream.sh --check` on the real lock: table renders, zero writes
  (`git status` clean before/after), exit code reflects drift state
- Rewind test: copy the lock + one skill's frontmatter `sha:` to an older
  upstream commit (e.g. `2ab9580~5`) in a scratch copy → `--check` reports
  that skill drifted with a commit count; `--diff <skill>` produces a
  non-empty reviewable diff; nothing was applied
- Unplugged test: scratch lock with one entry set to `"none"` → listed as
  unplugged, skipped by `--check` and refused by `--diff`
- `bash -n socle/scripts/sync-upstream.sh` passes; executable bit set
- SKILL.md contains the agent-proposes/human-validates loop, the
  heavy-divergence clause, and has NO `x-upstream` block

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Worklog (2026-08-06, typist: Sonnet sub-agent)

- Wrote `socle/scripts/sync-upstream.sh`: `#!/usr/bin/env bash` + `set -euo
  pipefail`, POSIX-style constructs throughout (no `[[`, no arrays — a
  `mktemp -d` scratch dir with a `trap ... EXIT` cleanup stands in for the
  temp bookkeeping instead). Two modes (`--check` default, `--diff
  <skill>`), `--lock`/`--skills-dir` flags with the documented defaults and
  fallback, `python3` used solely to turn the JSON lock into TSV (fails
  loudly if `python3` is missing). Cache: full clone (needed for commit
  counts) into `${XDG_CACHE_HOME:-$HOME/.cache}/chisel/<owner>-<repo>/`,
  `git fetch origin` on subsequent runs — the script's only write, in any
  mode. `chmod +x` applied.
- `--check`: iterates the lock, skips/collects `"none"` entries into an
  "unplugged" section, runs `git log --oneline <sha>..origin/main -- <path>`
  per skill for the drift table (name / commits-behind / up to 3 latest
  subjects), and separately greps each skill's frontmatter `x-upstream.sha`
  (from the two `---` frontmatter markers) against the lock, emitting `WARN
  mismatch` lines when they differ or when a skill has no `sha:` at all
  (covers both a missing `SKILL.md` and a frontmatter already flipped to the
  literal `x-upstream: none`). Exit 0 with no drift, exit 1 if any skill
  drifted.
- `--diff <skill>`: looks the skill up in the parsed lock via `awk`, refuses
  clearly on an unknown name or a `"none"` entry, otherwise prints `git diff
  <sha>..origin/main -- <path>` from the cache.
- Wrote `socle/agents/skills/sync-upstream/SKILL.md`: `disable-model-
  invocation: true`, no `x-upstream` frontmatter block (confirmed — the four
  `grep` hits for the string are all body prose describing what to write
  into *other* skills' frontmatter, not this skill's own). Body: Step 1 run
  `--check` and show the table verbatim; Step 2 one skill at a time — run
  `--diff`, read that skill's `changes:` line, propose a merge stating each
  point as "upstream changed X; our adaptation Y is kept because Z", wait for
  the human, treat silence as rejection, never batch proposals; heavy-
  divergence clause proposing `x-upstream: none` when preserving adaptations
  would mean rewriting most of the diff; Step 3 — only after approval, update
  that skill's frontmatter `sha:` (or flip to `none`), the lock entry, and a
  dated `CHANGELOG.md` line, one skill at a time, before moving to the next.
- Confirmed network reachability first (`git ls-remote
  https://github.com/mattpocock/skills.git HEAD` succeeded) — no fallback to
  the local `SDD-bench/pocock-skills` mirror was needed.

### Verification output

- Real `--check` against the real `upstream.lock.json`: cloned
  `~/.cache/chisel/mattpocock-skills/` for the first time, then reported 9 of
  15 skills drifted (1–6 commits behind each, e.g. `grilling` 6 behind,
  `code-review` 1 behind) and 6 at 0; no `WARN mismatch` lines (every
  frontmatter `sha:` still matches the lock, as expected — nothing's been
  synced yet). Exit code `1` (drift present) — **PASS**. `git status`
  captured before and after the run, `diff`'d identical — **PASS** (zero
  writes to the repo; the only write was the cache clone under
  `~/.cache/chisel/`).
- `--diff code-review` against the real lock: printed a non-empty,
  reviewable diff (upstream's `to-prd` → `to-spec` rename hitting the fork's
  own `SKILL.md`) — **PASS**.
- `--diff nonexistent-skill`: `sync-upstream.sh: unknown skill:
  nonexistent-skill (not in ./upstream.lock.json)`, exit 1 — **PASS**.
- Rewind test (scratch copy under the session scratchpad, single-entry lock
  + copied `code-review/SKILL.md`, both rewound to
  `2ab958093e83e0ec752e6c1c5932da465bf23e0c~5` =
  `66898f60e8c744e269f8ce06c2b2b99ce7660d5f`): `--check` reported `code-review
  1 docs: finish the to-prd → to-spec rename in shipped text`, exit 1;
  cross-checked with a raw `git log` over the same range that 9 commits
  landed in the upstream repo across that span but only 1 touched
  `skills/engineering/code-review`, confirming the path-scoped count is
  correct, not a fluke of a narrow rewind. `--diff code-review` produced a
  28-line diff. The real chisel repo's `git status` was re-checked
  afterwards and is unchanged from before the whole test — **PASS**.
- Unplugged test (scratch lock with `code-review` + `"some-unplugged-
  skill": "none"`): `--check` listed `some-unplugged-skill` under "unplugged
  (x-upstream: none) — skipped" and did not run git log against it; `--diff
  some-unplugged-skill` refused with `sync-upstream.sh:
  some-unplugged-skill is unplugged (x-upstream: none) — nothing to diff`,
  exit 1 — **PASS**.
- `bash -n socle/scripts/sync-upstream.sh` → syntax OK; `stat -f "%Sp"` →
  `-rwxr-xr-x` — **PASS**.
- `grep -c x-upstream socle/agents/skills/sync-upstream/SKILL.md` → 4 hits,
  all confirmed (by reading the frontmatter block, lines 1–5) to be body
  prose about *other* skills' frontmatter, not a frontmatter block on this
  skill itself — **PASS** (no `x-upstream` frontmatter key on
  `sync-upstream`).

### Deviations from Design

- AC2 ("applies ONLY after explicit approval") is enforced by the SKILL.md
  protocol (one-skill-at-a-time proposal, silence = rejection, Step 3 gated
  on approval), not by the script — the script never applies anything in
  any mode, by design. Verification exercised the mechanical half (a real
  outdated SHA producing a genuine, non-empty, path-scoped diff) end to end;
  the human-approval gate itself was verified by inspection of the SKILL.md
  text rather than a live agent/human dialogue, since this slice has no
  drifted skill awaiting a real merge decision yet.
- The Design specifies `python3` for lock parsing but is silent on shell
  portability for the rest of the script beyond "same style as
  `task-id.sh` ... no other bashisms." Conservatively avoided arrays,
  `[[ ]]`, and process substitution throughout (using a `mktemp -d` scratch
  dir with `< file` redirection instead), even though the script runs under
  a `bash` shebang like `task-id.sh` does.
- The Design's WARN-mismatch cross-check is specified only for the case
  where lock and frontmatter SHAs differ. Extended it, conservatively, to
  also fire when a lock-listed skill's frontmatter has *no* `sha:` at all
  (missing `SKILL.md`, or frontmatter already flipped to `x-upstream: none`
  while the lock still holds a real entry) — same "WARN mismatch" line
  format, since that state is also a disagreement between the two sources
  of truth the script is meant to reconcile-by-reporting.
- Exit-code semantics: only `commits-behind > 0` drives the `--check` exit
  code (0/1); a `WARN mismatch` alone (SHAs disagreeing while commits-behind
  is 0 — not observed in this slice's real run) does not by itself flip the
  exit code, since the Design ties the exit code to "drift" specifically
  and lists the mismatch check as a separate, additional report line.
- Table format renders as fixed-width columns (`SKILL BEHIND LATEST
  SUBJECTS`) rather than literally joining fields with "·" — read the
  Design's `skill · commits-behind · latest subjects` as naming the three
  data fields, not a literal separator character to reproduce.
