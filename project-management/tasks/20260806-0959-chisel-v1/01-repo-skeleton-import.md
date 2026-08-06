# 01 — Repo skeleton + socle import

**Status:** 🟢 Complete
**Blocked by:** None — can start immediately

**What to build:** The chisel repo takes its target shape and becomes the
canonical source of the socle: everything methodology-related from
music-downloader's `doc/agents/` (skills, rules content, workflows.md,
methodology.md), the task template, and `task-id.sh` moved into `socle/`
under the `.agents/` shape, each forked skill carrying its `x-upstream`
frontmatter.

## Acceptance criteria

- [x] `socle/agents/{skills,rules}/`, `socle/templates/`, `socle/scripts/`
      populated; nothing methodology-related remains only in music-downloader
- [x] Every Pocock-forked skill has `x-upstream: {repo, path, sha, changes}`
      frontmatter; `upstream.lock.json` lists the same SHAs
- [x] The 3 task rules exist as tool-agnostic `socle/agents/rules/*.md`
      (content still with hardcoded paths — slice 02's job)

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-06 · planner: Fable · typist: Sonnet sub-agent)

### Decisions locked

- **COPY, never move**: music-downloader is READ-ONLY (another agent's turf).
  Its socle copies are removed later, at slice 06 (pilot migration). The AC
  "nothing remains only in music-downloader" is satisfied by the copy.
- Sources to import, all at current HEAD of music-downloader:
  `doc/agents/` · `doc/project-management/000-task-file-template.md` ·
  `.cursor/rules/task-{creation,progressing,completion}.mdc` ·
  `scripts/task-id.sh`.
- The 3 task rules land as **tool-agnostic** `socle/agents/rules/*.md`: strip
  the `---\nalwaysApply: true\n---` Cursor frontmatter, rename `.mdc` → `.md`,
  content otherwise byte-identical (hardcoded paths stay — slice 02's job).
- `issue-tracker.md` copied as-is into `socle/agents/` (slice 02 folds it into
  `project.md.tpl`). The music-downloader hub `README.md` is NOT copied
  (project-specific; chisel docs come in slice 07).
- **All 15 skills are Pocock forks** → each SKILL.md gains `x-upstream`
  frontmatter: `repo: mattpocock/skills` · `path:` upstream skill dir
  (`slice-task` maps to `skills/engineering/to-tickets`) · `sha:` current HEAD
  of the local clone `~/Documents/Projects/SDD-bench/pocock-skills`
  (`git rev-parse HEAD`) · `changes:` one line — "adapted: <what>" for
  code-review / slice-task / triage / wayfinder (task-file & tracker
  adaptations), "verbatim fork" for the others.
- `upstream.lock.json` at repo root mirrors the same data:
  `{ "<skill-name>": { "repo", "path", "sha" } }`.

### Target shape

```
chisel/
├── socle/
│   ├── agents/
│   │   ├── skills/<15 dirs>/        # each SKILL.md with x-upstream frontmatter
│   │   ├── rules/task-creation.md · task-progressing.md · task-completion.md
│   │   └── workflows.md · methodology.md · issue-tracker.md
│   ├── templates/000-task-file-template.md
│   └── scripts/task-id.sh           # executable bit preserved
└── upstream.lock.json
```

### Verification

- `find socle/agents/skills -name SKILL.md | wc -l` = 15; every one has
  `x-upstream:`; the lock lists the same 15 names/SHAs
- `socle/agents/rules/`: exactly 3 `.md`, zero `alwaysApply` remnants
- `bash -n socle/scripts/task-id.sh` passes; executable bit set
- `git -C ../music-downloader status` unchanged before/after (read-only proof)

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Worklog (2026-08-06, typist: Sonnet sub-agent)

- Read upstream SHA from the local Pocock clone: `git -C
  ~/Documents/Projects/SDD-bench/pocock-skills rev-parse HEAD` →
  `2ab958093e83e0ec752e6c1c5932da465bf23e0c` (used for all 15 skills).
- Copied `music-downloader/doc/agents/skills/` wholesale (all 15 skill dirs,
  including their supporting files — `DEEPENING.md`, `tests.md`,
  `AGENT-BRIEF.md`, etc.) into `chisel/socle/agents/skills/`. Diffed a sample
  of SKILL.md bodies and every non-SKILL.md file against source: byte-
  identical.
- Copied `workflows.md`, `methodology.md`, `issue-tracker.md` into
  `socle/agents/`; `000-task-file-template.md` into `socle/templates/`;
  `task-id.sh` into `socle/scripts/` (executable bit set with `chmod +x`,
  confirmed via `ls -la`). All five diffed byte-identical against source.
- Stripped the `---\nalwaysApply: true\n---` Cursor frontmatter from the 3
  `.mdc` rules and renamed to `.md` in `socle/agents/rules/`; diffed the
  remainder against source (`tail -n +4`) — byte-identical in all 3 cases.
- Added `x-upstream:` YAML block (repo/path/sha/changes) to each of the 15
  SKILL.md files' existing frontmatter, leaving all original frontmatter
  fields and the skill body untouched (verified via diff on samples).
  Upstream path mapping (from music-downloader's `doc/agents/README.md`
  coverage table, cross-checked against the pocock-skills clone's directory
  listing):
  - `code-review` → `skills/engineering/code-review` — adapted: spec source
    is the task file, not the originating issue/PRD
  - `codebase-design` → `skills/engineering/codebase-design` — verbatim fork
  - `diagnosing-bugs` → `skills/engineering/diagnosing-bugs` — verbatim fork
  - `domain-modeling` → `skills/engineering/domain-modeling` — verbatim fork
  - `grill-with-docs` → `skills/engineering/grill-with-docs` — verbatim fork
  - `grilling` → `skills/productivity/grilling` — verbatim fork
  - `handoff` → `skills/productivity/handoff` — verbatim fork
  - `improve-codebase-architecture` →
    `skills/engineering/improve-codebase-architecture` — verbatim fork
  - `prototype` → `skills/engineering/prototype` — verbatim fork
  - `research` → `skills/engineering/research` — verbatim fork
  - `slice-task` → `skills/engineering/to-tickets` — adapted: publishes
    slices into the task folder; 'ticket' reserved for external trackers
  - `tdd` → `skills/engineering/tdd` — verbatim fork
  - `triage` → `skills/engineering/triage` — adapted: tracker reference
    adapted; dormant until an external tracker
  - `wayfinder` → `skills/engineering/wayfinder` — adapted: tracker
    reference adapted for the local task tracker
  - `writing-great-skills` → `skills/productivity/writing-great-skills` —
    verbatim fork
- Generated `upstream.lock.json` at the chisel repo root from the same
  15-entry map (`{name: {repo, path, sha}}`); cross-checked programmatically
  that lock names == skill-dir names and every SKILL.md's `sha:` matches the
  lock.

### Verification output

- `find socle/agents/skills -name SKILL.md | wc -l` → `15`; grep confirmed
  all 15 have `x-upstream:`; Python check confirmed lock names/SHAs match
  frontmatter exactly. **PASS**
- `socle/agents/rules/`: `task-completion.md`, `task-creation.md`,
  `task-progressing.md` — exactly 3; `grep -rl alwaysApply` found nothing.
  **PASS**
- `bash -n socle/scripts/task-id.sh` → syntax OK; `ls -la` confirmed
  `-rwxr-xr-x`. **PASS**
- `git -C ../music-downloader status` before: `clean — nothing to commit`
  (rtk-compacted); after: `On branch rewrite ... nothing to commit, working
  tree clean` — unchanged. **PASS**

### Deviations from Design

None. The Design left the exact upstream `path:` for skills other than
`slice-task` unspecified beyond the one worked example; resolved
conservatively by reading it off music-downloader's own
`doc/agents/README.md` coverage table (which names each skill's upstream
category and, where forked-and-renamed, its upstream name) and confirming
the resulting path exists in the local `pocock-skills` clone. No design
decision was improvised beyond this literal cross-reference.

One pre-existing line is now stale but was left untouched as out of scope
for this slice: `chisel/AGENTS.md` says "The reference for the methodology
being packaged here lives (until slice 01 imports it) in
`music-downloader/doc/agents/`" — this sentence should be revisited (removed
or updated) in a later slice since slice 01 (this one) is now complete.
