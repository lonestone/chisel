# 02 — Agent profiles + generated per-tool definitions

**Status:** 🟢 Complete
**Blocked by:** 01 (delivered)

**What to build:** The roster becomes installable. Canonical markdown profiles
in `.agents/profiles/` — `architect.md`, `mason.md`, `inspector.md` — each
carrying the role CONTRACT: mission, tier (frontier/mid/cheap), prohibitions
(Architect never types what it planned; Inspector never the author of the
plan nor the diff; separation of powers), escalation rules, brief format
(brief = artifacts only, never the conversation). No Foreman profile in v1: a
`foreman.md` doc page instead (human in Controlled; cron/hook around
`bd ready` / `bd gate check` in Auto × beads). Because most tools cannot
import a shared definition (state of the art:
`../factory-bench/research/sous-agents-par-outil.md`), the installer
GENERATES the per-tool definitions from the profiles — `.claude/agents/*.md`
(covers Cursor ≥2.4 for free via native cross-read), `.codex/agents/*.toml`;
universal fallback documented as profile-inlined-at-spawn or fresh session +
brief. Generated files are managed (D2/D7 pattern: re-rendered by `update`,
tracked in `.chisel.json`, drift caught by `check`). The socle prescribes the
delegation contract; the per-tool spawn gesture lives in the adapter — no
vendor wording in the profiles. Roles sign their beads acts via `--actor`
(convention text lands here, wiring in slice 05).

## Acceptance criteria

- [x] `init` on a fixture installs the 3 profiles + generates
      `.claude/agents/` and `.codex/agents/` definitions from them; `update`
      re-renders them; a hand-edit is flagged by `check` (manifest-tracked)
- [x] Each profile contains the five contract sections (mission, tier,
      prohibitions, escalation, brief format — carried as
      "Inputs — what this role receives") and no vendor/model name —
      tiers only
- [x] The formulas' role mentions (slice 01) resolve to these profiles by
      name; `foreman.md` exists as doc, not as a profile
- [x] Fixture assert: no `foreman` definition is generated for any tool

---

> 🧑 **REVIEW IF RELEVANT** — design, persisted from the approved plan (empty at slicing time).

## Design — persisted at plan time (2026-08-26 · Architect+Mason fused, delegation pre-approved by the Owner)

### D1 — Target file tree

```
socle/agents/
├── profiles/                               ★ NEW — the canonical role contracts
│   ├── README.md                           ★ NEW — what a profile is, how it
│   │                                          reaches each tool, the fallback
│   ├── architect.md                        ★ NEW (tier: frontier)
│   ├── mason.md                            ★ NEW (tier: cheap or mid)
│   └── inspector.md                        ★ NEW (tier: frontier)
├── foreman.md                              ★ NEW — doc page, NOT a profile
├── discipline.md · formulas/               (slice 01 — untouched)
├── methodology.md                          (slice 07 — untouched)
├── project.md.tpl                          (slice 04 — untouched)
└── skills/                                 (slice 03 — untouched)
bin/chisel.sh                               ✎ copy profiles + foreman.md,
                                              render the per-tool definitions
test/run.sh                                 ✎ layout asserts + new group 8
```

Equipped project (all of it managed, D2/D7 pattern — rendered by `init`,
re-rendered by `update`, hashed in `.agents/.chisel.json`, drift reported by
`check`):

```
.agents/profiles/{README,architect,mason,inspector}.md   ← the SOURCE
.agents/foreman.md                                       ← doc page
.claude/agents/{architect,mason,inspector}.md            ← rendered (covers Cursor ≥2.4)
.codex/agents/{architect,mason,inspector}.toml           ← rendered
```

### D2 — Why `foreman.md` sits in `socle/agents/`, not in `profiles/`

`profiles/` is the generator's input directory: everything in it that declares
a role is rendered for every tool. The parent's Not Included is explicit — the
Foreman is *not* an agent in v1 — so its page must be somewhere the generator
structurally cannot reach, not merely skipped by a special case. Next to
`discipline.md` and `methodology.md` it reads as what it is: a doc page about
how work gets routed. The AC "no `foreman` definition is generated for any
tool" then holds by construction, and is asserted anyway.

### D3 — Why `profiles/README.md` exists, and how the generator ignores it

The generation contract (the profile body is the source; the per-tool files
are thin renders, never hand-edited; the universal fallback for tools with no
definition format) is ONE fact. Repeating it in each of the three profiles
would be three sources; putting it in `discipline.md` or the AGENTS block
would leave this slice's allotment. It lands in the directory's own README —
the page a human opens when they wonder what `profiles/` is.

Selection rule (not a filename special case): the generator renders a file
only when its YAML frontmatter declares `name:`. The README has no
frontmatter, so it is data for humans and invisible to the renderer. Adding a
fourth profile is: drop a file with frontmatter in `profiles/`, run `update`.

### D4 — Profile format

Frontmatter, flat and vendor-neutral (parsed by `awk`, no YAML library):

```
---
name: mason
description: <one line — becomes the tool-facing description verbatim>
tier: cheap or mid
---
```

No `model:` key and no `tools:` key in the source or in any render. A model
name would break the parent's vendor AC, and the tier → model cascade is
slice 03's (`user.md` > glue > socle default); until it exists, the tier is
carried as prose in the body's `## Tier` section, where a human and an agent
both read it. `tools:` is a per-tool permission concept — it belongs to the
adapter, not to a role contract.

Body = the contract, five sections, same order in all three files:

| Section | Holds |
|---|---|
| `## Mission` | what the role is for + which formula steps it runs |
| `## Tier` | frontier / mid / cheap, and *why* that tier |
| `## Prohibitions` | the separation of powers, stated as refusals |
| `## Escalation` | when to stop, what to write down, which rung is next |
| `## Inputs — what this role receives` | the brief contract: artifacts only |

The `Inputs` section is the parent's resolution of the "petits fichiers de
step" question: the input contract lives with the role that CONSUMES it, and
the delegating agent reads the target profile before spawning. That one-line
discipline ("before spawning a role, read its profile") is stated in the
Architect's profile (the role that delegates) and in `profiles/README.md`.

Per-role content, traced to its source:

- **architect.md** (frontier) — runs `interview`, `spec`, `plan`; slicing AND
  allotment (the emprise of each lot, F4/2). Prohibitions: never types what it
  planned, never reviews its own plan or diff, never decides a 🧑 zone, never
  leaves a plan in the conversation only. Inputs: the Brief (human, always —
  F2), the ambient layer, the repo, prior specs/ADRs/glossary (§G).
- **mason.md** (cheap or mid) — runs `type`; one slice, one fresh session,
  claims ready work (pull, never push). Prohibitions: never plans or designs,
  never improvises past the persisted plan, never reviews its own diff, never
  edits a 🧑 zone. Inputs (the core of this slice): the spec file with its
  persisted Design, the artifacts that spec explicitly references (by path,
  followed as links), the ambient layer, and the workspace + acceptance it is
  verified against — **never the planning conversation**. A brief that needs
  the conversation is a finding against the plan (TP obligation 24).
- **inspector.md** (frontier) — runs `review`; two axes side by side, never
  merged, never re-ranked. Prohibitions: never the author of the plan nor of
  the diff, never re-pins the fixed point after seeing the diff, never
  rewrites scope. Inputs: **the diff, the pinned fixed point, the spec
  pointer** (its 🧑 zones are the requirements axis) + the standards sources;
  the `code-review` skill carries the how.

Ledger neutrality is kept: the "roles sign their acts" convention is written
as *the act carries the role name as its actor, per the §B tracker convention*
— the backend's flag name is slice 05's wiring, not socle vocabulary. This is
a deliberate reading of this slice's "`--actor` convention text lands here":
the CONVENTION lands, the backend's CLI surface does not.

### D5 — Rendering, per tool

State of the art (`../factory-bench/research/sous-agents-par-outil.md`): no
cross-tool standard, no import in most tools → generation, not reference.
Claude's format covers Cursor ≥2.4 for free (native cross-read, precedence
`.cursor` > `.claude` > `.codex`); Codex needs TOML.

`.claude/agents/<name>.md`:

```
---
name: <name>
description: <description>
---

<!-- chisel:generated from .agents/profiles/<name>.md — ... -->

<profile body, verbatim>
```

`.codex/agents/<name>.toml`:

```
# chisel:generated from .agents/profiles/<name>.md — ...
name = "<name>"
description = "<description>"
developer_instructions = '''
<profile body, verbatim>
'''
```

Three implementation decisions:

1. **TOML multi-line LITERAL string (`'''`)**, not a basic string. Literal
   strings have no escape processing at all, so a markdown body with
   backticks, backslashes and quotes survives byte-for-byte and the generated
   file stays readable. The only forbidden sequence is `'''` itself — the
   renderer refuses to write a profile whose body contains it (`die`, with the
   path), rather than emitting a broken TOML file. The one-line `description`
   goes into a basic `"` string with `\` and `"` escaped.
2. **No new external dependency**: rendering is `awk` + `printf`, so
   `python3` stays what the header says it is — the JSON manifest reader.
3. **A pre-existing definition that chisel did not write is never
   overwritten.** `.claude/agents/` is a namespace shared with the user's own
   subagents; a role name can collide. Rule: write when the target is absent
   or carries the `chisel:generated` marker; otherwise warn on stderr and
   leave it alone — the same conservative stance `link_claude_skills` already
   takes for a foreign `.claude/skills`. Consequence, accepted: a foreign file
   is not tracked as managed (the manifest lists only marker-carrying renders),
   so `check` cannot report drift on a file chisel does not own.

### D6 — `bin/chisel.sh`

- Constants: `AGENTS_PROFILES_SRC`, `FOREMAN_SRC`, `GEN_MARKER='chisel:generated'`.
- `copy_managed_files`: `cp -R` the profiles dir, `cp` `foreman.md` — same
  shape as `formulas/` and `discipline.md`.
- New `render_agent_definitions <target>`: loop over `.agents/profiles/*.md`,
  skip files with no `name:` frontmatter, render both definitions through
  `install_generated` (the marker guard of D5.3). Called from `cmd_init` and
  `cmd_update`, right after `copy_managed_files` and before `write_manifest`
  — so `update` re-renders and the manifest always reflects what is on disk.
- `managed_relative_files`: `.agents/profiles` joins the `find` list,
  `.agents/foreman.md` joins the literal list, and the rendered definitions
  are listed by scanning `.claude/agents` + `.codex/agents` and keeping only
  the files that carry the marker.
- Untouched: adapters, `project.md` ownership, `check`/`update` semantics.
  `update` does not delete a definition whose profile disappeared upstream —
  removing stale files on an equipped repo is `upgrade-v2`'s job (parent
  decision: no heavy machinery in `update`).

### D7 — `test/run.sh`

- `assert_full_layout`: the 3 profiles, `profiles/README.md`, `foreman.md`,
  the 3 Claude definitions, the 3 Codex definitions; negative asserts —
  no `.agents/profiles/foreman.md`, no `foreman` definition for either tool,
  no definition rendered from the README.
- Group 4 (update): hand-edit a rendered definition → `update` brings it back
  byte-identical to a fresh render.
- Group 5 (check): hand-edit `.claude/agents/architect.md` → exit 1, path named.
- NEW group 8 (profiles: contract, rendering, tool coverage):
  - each profile carries the five sections and a `tier:` from the abstract
    vocabulary; the neutrality greps (no vendor/model name, no W-label) run
    over the profiles, `foreman.md` and the rendered definitions;
  - AC3: the tier each profile declares matches the tier the slice-01
    formulas state for that role, and every role named in a formula step has
    a profile file;
  - the rendered body is byte-identical to the profile body (extract both,
    `diff`) — the renders are thin, not paraphrases;
  - a foreign `.claude/agents/architect.md` (no marker) survives `init` with
    its content intact and a warning on stderr;
  - the Codex TOML parses with `tomllib` when the interpreter has one
    (`name`/`description`/`developer_instructions` present, instructions
    equal to the body), skipped out loud otherwise — same floor as group 7.
- Idempotence (group 2, `init` twice → zero diff) covers the renderer for
  free, since the generated files live inside that fixture.

### D8 — Order of execution

1. Persist this design (done — nothing half-decided crosses the line).
2. `profiles/README.md`, the three profiles, `foreman.md`.
3. `bin/chisel.sh`, then `test/run.sh`.
4. `bash test/run.sh` green + `bash -n` on both scripts + the ACs' greps.
5. Two-axis review (Standards + Spec in parallel, fixed point `a7ce105`),
   confirmed findings applied.
6. Slice status/ACs/Notes, dated CHANGELOG entry, explicit-path commit.

---

> 🤖 **AGENT ZONE** — working space; humans skim or skip.

## Notes

### Worklog (2026-08-26)

- Wrote the three profiles from `../factory-bench/roster.md` (mission, tier,
  prohibitions, escalation per role) and from the obligations the slice-01
  mapping table routed to the `type` and `review` steps. Same five sections,
  same order, in all three files — a reader who knows one profile knows where
  to look in the others.
- `profiles/README.md` carries what is true of every profile and of no role in
  particular: the "read the profile before spawning it" rule, the per-tool
  render table, the managed-file contract, and the universal fallback
  (inline at spawn, or a fresh session on the profile file). It has no
  frontmatter, which is exactly what keeps the renderer from treating it as a
  role.
- `socle/agents/foreman.md`: the human in Controlled, a scheduled job around
  the tracker's "what is ready / which gates are open" queries in Auto, and
  the conditions under which it would become an agent. Placed next to
  `discipline.md`, not in `profiles/` — the generator's input directory is
  the one place it must not be.
- `bin/chisel.sh`: profiles and `foreman.md` join the copied managed files;
  `render_agent_definitions` renders `.claude/agents/<role>.md` and
  `.codex/agents/<role>.toml` from each profile that declares a `name`. Pure
  `awk`/`printf` — `python3` stays what the header says it is, the JSON
  manifest reader. Called from `init` and from `update`, before the manifest
  is written.
- `test/run.sh`: layout assertions for the profiles, the doc page and the six
  rendered definitions (plus the negative ones — no Foreman anywhere, nothing
  rendered from the README); `update` and `check` now exercise a rendered
  definition; new group 8 for the contract shape, the tier agreement with the
  formulas, the verbatim-body property, the foreign-file guard and the Codex
  TOML parse.

### Decisions taken at the plan gate (no human to ask — recorded, per the mode)

1. **`--actor` stays out of the socle.** The slice asked for the "roles sign
   their acts" convention to land here. It does — as *the act carries the
   role name as its actor, per the §B tracker convention*. The backend's flag
   spelling is slice 05's wiring; writing it into a role contract would put a
   ledger backend's CLI surface into the vendor-neutral layer that slice 01
   just finished clearing out.
2. **No tool name in prose, anywhere in this layer** — revised after review,
   see the dispositions below. The plan (D3) had `profiles/README.md` carry a
   named per-tool table; the Spec axis was right that this granted an
   exemption to the parent's vendor AC that only the Owner can grant. The
   table now speaks in **paths** (`.claude/agents/<role>.md`,
   `.codex/agents/<role>.toml`), which is the fact that actually matters and
   is already how the socle names its adapters elsewhere. The rule the suite
   enforces: with code spans stripped, no tool name and no model name in any
   of the five files or in the six renders.
3. **No `model:` and no `tools:` key** in the profiles or in any render. A
   model name would break the parent's vendor AC and pre-empt slice 03's
   `user.md` cascade; `tools:` is a per-tool permission concept that belongs
   to the adapter, not to a role contract. The tier travels as prose in the
   body, where both a human and an agent read it.
4. **A definition chisel did not write is never overwritten** (D5.3).
   `.claude/agents/` is shared with the user's own sub-agents; a role name
   can collide. Accepted consequence: such a file is not tracked as managed,
   so `check` reports nothing about it — chisel only claims what it wrote.

### Verification output

`bash test/run.sh`, real run against the committed fixtures (TMPDIR pointed
at the session scratchpad), after the review fixes: **198 passed, 0 failed**
on the default `python3` (3.9 — the two optional TOML parse checks print
`SKIP` out loud), and **200 passed, 0 failed** with a 3.13 interpreter on
PATH, both optional checks running.

Group 8 lines (3.13 run; the per-role assertions abbreviated):

```
-- 8. profiles: contract, neutrality, rendering --
PASS: profiles: <role> declares a mission                                    (×3)
PASS: profiles: <role> declares a tier                                       (×3)
PASS: profiles: <role> declares prohibitions                                 (×3)
PASS: profiles: <role> declares escalation rules                             (×3)
PASS: profiles: <role> declares what it receives                             (×3)
PASS: profiles: <role> frontmatter names the role                            (×3)
PASS: profiles: mason is never handed the planning conversation
PASS: profiles: inspector is handed a pinned fixed point
PASS: profiles: architect tier is frontier
PASS: formulas: architect step states the same tier
PASS: profiles: mason tier is cheap or mid
PASS: formulas: mason step states the same tier
PASS: profiles: inspector tier is frontier
PASS: formulas: inspector step states the same tier
PASS: profiles: the universal fallback is documented
PASS: foreman: documented as routing, not as an agent
PASS: render: claude definition of <role> carries the profile body verbatim  (×3)
PASS: render: claude definition of <role> has a name in frontmatter          (×3)
PASS: render: codex definition of <role> declares developer_instructions     (×3)
PASS: render: codex definition of <role> declares its name                   (×3)
PASS: render: claude definition of <role> points at its source               (×3)
PASS: render: codex definition of <role> points at its source                (×3)
PASS: render: the source <role> points at exists                             (×3)
PASS: formulas: the steps name exactly the three profiled roles
PASS: formulas: every role named in a step resolves to a profile
PASS: neutrality: no W0/W1/W2 mode label in the profiles or their renders
PASS: neutrality: no model name in the profiles or their renders
PASS: neutrality: no tool name in the prose of this layer (paths excepted)
PASS: foreign definition: init still exits 0
PASS: foreign definition: left untouched by init
PASS: foreign definition: init warns about it
PASS: foreign definition: the other roles are still rendered
PASS: render: codex definitions parse as TOML and carry the profile body
```

Three new invariants were mutation-tested rather than trusted:

- making the renderer drop the first body line (a "paraphrasing" render)
  turns the three verbatim-body assertions red;
- removing the foreign-file guard turns the two foreign-definition
  assertions red (the hand-written file is destroyed, no warning printed);
- renaming a role in one formula step (`Mason` → `Plumber`) turns the two
  generic role assertions red, naming the unprofiled role.

Manual probes on an equipped scratch fixture, beyond the suite:

- a profile whose body contains `'''` makes `update` **refuse**, name the
  file and exit 1 — it never writes a broken TOML;
- dropping a fourth profile in `.agents/profiles/` and running `update`
  renders both its definitions and leaves `check` clean, which is the
  extensibility the README promises;
- a hand-edit of `.claude/agents/mason.md` → `check` exits 1 naming the file,
  `update` re-renders it byte-identically, `check` clean again.

Greps (slice AC 2, and the parent's vendor / W-label ACs for the files this
slice ships):

```
$ grep -rnE 'W0|W1|W2' socle/agents/profiles/ socle/agents/foreman.md
(none)
$ grep -rniE 'grok|composer|sonnet|opus|fable|gpt|gemini|anthropic|openai' \
    socle/agents/profiles/ socle/agents/foreman.md
(none)
$ grep -rniE '\bbd\b|beads|--actor|CHANGELOG' socle/agents/profiles/ socle/agents/foreman.md
(none)
$ for f in socle/agents/profiles/*.md socle/agents/foreman.md; do
    sed -e 's|`[^`]*`||g' "$f" | grep -niE 'cursor|codex|claude|copilot|windsurf'
  done
(none — tool names survive only inside adapter paths, in code spans)
```

`bash -n bin/chisel.sh` and `bash -n test/run.sh` → syntax OK.

### Two-axis review (2026-08-26, fixed point `a7ce105`)

Run per `skills/code-review`: two sub-agents in parallel, Standards and Spec
(the spec being the 🧑 zones of this slice — its ACs and its persisted Design
— and of the parent), aggregated without re-ranking. The Spec axis confirmed
the allotment is clean: nothing outside profiles / `foreman.md` /
`bin/chisel.sh` / `test/run.sh` / this file / the changelog was touched.

**Applied**

| Axis | Finding | Fix |
|---|---|---|
| Standards | `managed_relative_files` ran `find` over directories that may not exist; under `set -euo pipefail` a missing operand aborted the function mid-body, dropping the five trailing entries and truncating the manifest — with `2>/dev/null` hiding the cause. Reproduced in isolation (rc=1, no output) | `\|\| true` on both finds, `sort` moved outside the subshell, and a comment saying why. Re-probed: a tree with no `.agents/profiles` now returns all five trailing entries, rc=0 |
| Standards | The provenance comment was built from the frontmatter `name`, so a profile whose `name` differed from its filename would point at a file that does not exist | the pointer is built from `basename "$profile"`; the README now states that `name` is the role's identity and must be unique and equal to the file's name. Asserted: every render points at a source that exists |
| Standards | `description` went into the generated YAML frontmatter unquoted while the TOML side was escaped — a future description containing `: ` or a leading `[`/`#` would break the frontmatter | both `name` and `description` are now double-quoted and escaped on both sides; `toml_escape_line` renamed `escape_double_quoted`, since YAML's double-quoted scalar and TOML's basic string agree on the characters at stake |
| Spec | D7 promised the neutrality greps would cover **the rendered definitions**; the suite only read the socle sources | the label and model greps now also run over the six renders |
| Spec | AC3 was asserted by three hardcoded role names read out of the Controlled formula only — a fourth role in a step would pass silently, and the Auto formula was never read | roles are now extracted from the `Role:` lines of BOTH formulas and each must resolve to a profile file; mutation-tested (`Mason` → `Plumber` fails, naming it) |
| Spec | Drift was proven on one render only | `update` and `check` now also exercise a Codex render |
| Spec | `profiles/README.md` named the tools in prose, which granted an exemption to the parent's vendor AC that is the Owner's to grant, not this session's | the table now speaks in adapter **paths** and names no tool; the suite's neutrality rule became uniform — code spans stripped, then no tool and no model name in any of the five files |

**Declined, with reason**

- *Standards: the frontmatter-parsing awk in `test/run.sh` duplicates the one
  in `bin/chisel.sh`.* Deliberate: a test that reuses the implementation's
  parser cannot catch that parser being wrong. The duplication IS the oracle.
- *Standards: the two render blocks are structurally identical (Divergent
  Change if a third tool arrives).* At two formats, an indirection for "how
  to write a header" costs more than the twelve lines it would save; the day
  a third format lands is the day the shape is known.
- *Standards: a user file under `.claude/agents/` that happens to contain the
  string `chisel:generated` would be claimed as managed.* True, and narrow:
  that directory holds agent definitions, and the failure mode is one visible
  `DIVERGED` line, not data loss. Anchoring the marker to the top of the file
  would trade a real constraint for a hypothetical one.
- *Standards: `mktemp` without a `trap` leaks on interrupt.* Matches the
  existing style of the script (two other sites do the same); changing the
  cleanup discipline of `chisel.sh` is not this slice's business.
- *Standards / Spec: the Codex TOML parse SKIPs on the default interpreter.*
  It is the group-7 precedent — the repo's floor is a bare `python3`, and the
  suite says the skip out loud. The 3.13 run above exercises it for real.
- *Spec: two prohibitions are not in the persisted D4 list* (mason's "never
  accepts an open question", inspector's "never invents standards"). Both are
  traceable rather than invented: the first is TP obligation 24, which D4
  cites in the same profile's Inputs; the second is the `code-review` skill's
  own rule that a finding cites its standard. D4's per-role bullets were a
  summary of the contract, not a cap on it.
- *Spec: nothing routes an agent to `.agents/profiles/` from the ambient
  layer, and no later slice explicitly owns fixing it.* Correct, and out of
  this slice's allotment — recorded as the first residual below, with a
  recommendation. **Flagged to the Owner: this one needs assigning, not
  just noting.**

### Known residuals, owned by later slices

Both are one-line edits in files this slice is not allowed to touch; flagged
rather than fixed, and neither blocks an AC.

- **Nothing points at `.agents/profiles/` from the ambient layer.** The
  formula steps name the roles ("Role: Mason") and the profiles resolve by
  name, but `discipline.md` and the AGENTS block (slice 01, delivered) carry
  no "before spawning a role, read its profile" line. Today that rule lives
  in `profiles/README.md` and in `architect.md` — the role that delegates.
  → whoever next edits the router or the ambient core (slice 07's doc pass).
- **`project.md.tpl` §E lists three adapters and now under-reports.**
  `.claude/agents/` and `.codex/agents/` are installed but not inventoried
  there, so `chisel check`'s adapter section stays silent about them (their
  drift IS caught, via the manifest). → slice 04, which rewrites that
  template anyway.
