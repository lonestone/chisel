# 02 — Install arranges what it finds

**Status:** in-progress **Blocked by:** 01 — Update reads intentions

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** `init` on a repo with nothing to arrange installs as today.
On a repo that already has project management — OpenSpec, Spec Kit, a task
folder with files, decision records, a hand-written `AGENTS.md` or `CLAUDE.md`,
another tool's agent rules, a tracker — `init` writes nothing in the project's
files: it stages the socle and hands over to the setup skill. The setup
inventories what it found, states it as facts, and proposes a placement for each
item: keep it where it is and point the glue at it, migrate it into chisel's
format, or leave it alongside. It writes only after the human's ruling, then
records the baseline.

## Acceptance criteria

- [ ] **fast-install** — `init` on a repo with none of the signals below behaves
      as today and exits 0.
- [ ] **signals-detected** — `init` detects, and lists by name: an `openspec/`
      folder; a `.specify/` folder or `specs/*/spec.md` beside `plan.md` or
      `tasks.md`; a task folder with files (`project-management/`,
      `doc/project-management/`, `tasks/` or the like); decision records
      (`docs/adr/`, `adr/`, `decisions/`); `CONTEXT.md`; agent rules of other
      tools (`.cursor/rules/`, `.windsurf/`, `.github/copilot-instructions.md`);
      a hand-written `AGENTS.md` or `CLAUDE.md`; `.beads/`.
- [ ] **stage-not-write** — on any signal, `init` writes nothing outside the
      workspace, prints the list and the setup skill's path, and exits with the
      agent code of slice 01.
- [ ] **placement-proposed** — the setup skill presents each found item with a
      recommended placement among the three, one decision at a time, and writes
      only what the human accepted.
- [ ] **dogfood** — the chisel repo equips itself with this install: its
      `project-management/` with files and its hand-written `AGENTS.md` go
      through the placement; afterwards `chisel check` is clean and the older
      dogfood task is cancelled with a pointer here.
- [ ] **suite-green** — `deno task test` and `deno task check` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- The detection is cheap and scripted; the placement is the agent's.
- Spec Kit and OpenSpec layouts must be read from their own documentation at the
  plan step, not guessed.
