# 03 — The two recipes become release intentions

**Status:** ready **Blocked by:** 01 — Update reads intentions

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** the changes of 0.2.0 to 0.2.4 are written as the intentions
of the releases that made them — the prose workflow replacing the formulas and
profiles, the tracker section, the seven statuses, the journal's new name, the
merge and publish section, and so on — each with its classification. A 0.1.x
repo running `update` gets exactly those it has not applied, through the
workspace of slice 01. A repo chisel did not install, or installed with the
first version, is handled by one baseline intention that finds the method
wherever it lives. `chisel-upgrade` goes away; its content lives in these
intentions and in the update skill.

## Acceptance criteria

- [ ] **one-change-one-intention** — each change of 0.2.0 to 0.2.4 that a repo
      must act on is one intention, in its release's folder, with its
      classification.
- [ ] **baseline-intention** — one intention covers a repo without a manifest,
      layout-free, ending with the human choosing which tree to keep.
- [ ] **upgrade-skill-gone** — `chisel-upgrade` is removed from the socle;
      nothing in the socle or the README points at it any more.
- [ ] **replay-0.1.1** — a test fixture shaped like a 0.1.1 install gets, from
      `update`, a workspace listing exactly the intentions of 0.2.0 to the
      current release.
- [ ] **suite-green** — `deno task test` and `deno task check` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- id-by-rivoli applied the 0.1.x recipe by hand on 2026-11-02 (branch
  `chore/chisel-0.2.4` there): its manifest will need those intentions recorded
  as applied, which the update skill can do from the journal entry.
- Architect, 2026-11-02, from slice 01's close: without a manifest, the
  session's first step runs `chisel init .`, and `init` records every shipped
  intention as applied — including those still pending in the session. The
  baseline intention must create the manifest without marking the pending
  intentions applied (for instance a baseline that records only up to the
  version the repo actually reached).
- Architect, 2026-11-02: there is no command to promote `unreleased/` intentions
  into a release folder; the ids change at the move. Decide in this slice
  whether the release step needs one, and say how a repo that recorded an
  `unreleased/` id is treated.
