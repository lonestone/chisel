# 01 — Update reads intentions

**Status:** ready
**Blocked by:** None — can start immediately

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** a release of chisel ships its intentions, and a repo
records which ones it has applied. Running `update` on a repo exactly as
chisel installed it, with only `automatic` intentions pending, refreshes it
as today and records them. Any other case writes nothing in the project's
files: `update` stages a disposable workspace — the pending intentions, the
reference socle, a session checklist — prints the checklist and the skill
to run, and exits with a code that says an agent has work to do. An agent
skill then applies the checklist one intention at a time, takes initiative
when the project keeps things elsewhere, shows each move, and records each
result with `chisel record`. The human validates the diff.

## Acceptance criteria

- [ ] **intentions-ship** — the package carries intentions per release and
  an `unreleased` folder, each with the sections of the current
  `chisel-upgrade` intentions plus an id and a classification
  (`automatic`, `migration`, `breaking-manual`, `informational`).
- [ ] **baseline-recorded** — `init` records every shipped intention up to
  its own version as applied, in the manifest.
- [ ] **fast-path** — `update` on an untouched install with only
  `automatic` intentions pending exits 0, refreshes the managed files and
  records those intentions as applied.
- [ ] **stage-otherwise** — `update` with a `migration` or
  `breaking-manual` intention pending, or on a repo the 0.2.4 refusals
  catch, writes nothing outside the workspace, prints the checklist and
  the skill's path, and exits with its own code.
- [ ] **workspace-kept** — `update` refuses to overwrite an existing
  workspace, and the workspace is ignored by git.
- [ ] **record** — `chisel record <id> --applied` and
  `chisel record <id> --skipped "<reason>"` write the result into the
  manifest; an unknown id is refused.
- [ ] **update-skill** — a skill applies a staged checklist: re-checks each
  intention's applicability, closes its gaps wherever the project keeps
  its method, stops on `breaking-manual` for the human, records each
  result, and deletes the workspace at the end.
- [ ] **check-knows** — `chisel check` reports pending intentions.
- [ ] **suite-green** — `deno task test` and `deno task check` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- The 0.2.4 refusals stay: they now lead to a staged workspace instead of
  a bare refusal, where the agent can take over.
- One placeholder intention in `unreleased/` is enough to prove the
  mechanism; the real intentions of past releases are slice 03.
