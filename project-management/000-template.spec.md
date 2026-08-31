# Task Spec Template & Standards

**Status:** 🟢 Complete
**Version:** 3 (spec / work split; see [methodology.md](../socle/agents/methodology.md))

## Context

The spec document is the human review surface, the requirement against which a
diff is judged, and the archive record of what was asked. It contains no
program design, pseudo-code, worklog or implementation checkboxes: these are
in the work document, created at `plan` by the implementing session.

A spec with no work document beside it has never been typed. Version 3 keeps
the reading gradient but moves the agent working space into that other file.

## The two zones

| Zone | Who reads it | What belongs there |
|---|---|---|
| 🧑 **REVIEW CAREFULLY** | Human, always, before code | Context, Scope, named Acceptance Criteria, Seams, Architecture / system design |
| 🧑 **REVIEW IF RELEVANT** | Human, for medium/large tasks | Implementation Decisions, Testing Strategy, Slices & Dependencies, Deliverables, References, Notes, Retrospective |

- The 🧑 REVIEW CAREFULLY zone must fit in working memory. Prefer a diagram or
  mockup over three paragraphs.
- The 🧑 zones are the human's decisions. Surface a conflict; never silently
  contradict one.
- There is no agent zone here. The coding agent's working space is the work
  document, a different file with a different owner.

## The two documents

| Spec document | Work document |
|---|---|
| Context · Scope · Acceptance Criteria · Seams | Program design and pseudo-code |
| Architecture / system design | Worklog |
| Implementation Decisions | Implementation checkboxes |
| Testing Strategy · Slices & Dependencies | Notes & Snippets |
| Deliverables · References | Inspector findings from `diff-review` |
| Notes (pre-`plan` writers) · Retrospective | |

Before a work document exists, `spec-review`, a gateless preset's doubting
step and some Architect steps write into this file's **Notes**. Once work
starts, the Mason's notes go into **Notes & Snippets** in the work document,
never here.

One work document exists for every spec actually typed. The implementing
session creates it at `plan` beside this file by replacing `.spec.md` with
`.work.md`. A parent spec of a sliced task has none; each slice has its own.
It may be deleted and regenerated while work is live. At `close`, both files
are archived together.

## Where each kind of content lives

| Content | One task | Parent + slices |
|---|---|---|
| Why / what / success criteria / seams | this spec | parent spec |
| Architecture | this spec | parent spec |
| Program design + pseudo-code | work document, created at `plan` | each slice's work document |
| Slice list + blockers | — | parent spec |
| Worklog, checkboxes, Notes & Snippets | work document | each slice's work document |
| Status | this spec | each slice's spec |
| Archive | spec + work together | parent + slice folder together |

## Spec Document Template

All spec documents MUST follow this structure:

```markdown
# <Task name>

**Status:** [Status Emoji & Text]

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

## Context

<Why this task exists.>

## Scope

**Included:**
- <specific deliverable>

**Not Included:**
- <boundary>

## Acceptance Criteria

Every criterion has a short descriptive **name** (for example
`no-orphan-file`), never a bare ordinal label. Every criterion is
machine-verifiable. An amended criterion is struck and its dated replacement
is added below it.

- [ ] **descriptive-name** (testable/verifiable)
- [ ] **suite-green** — all tests pass

## Seams

- Seam 1: <public boundary> — <observable behavior>

## Architecture

**System design:** <how pieces relate>. The indicative files-to-modify /
files-to-avoid map belongs to this design and is written once per slice in
"Slices & Dependencies".

---

> 🧑 **REVIEW IF RELEVANT** — decisions, testing, slicing.

## Implementation Decisions

Cross-cutting rulings and constraints. Never put the program design here: it
belongs wholly to the work document.

## Testing Strategy

- <seam behavior to test>

## Slices & Dependencies

- **Slices:** 1. <slice> (blocked by: none)

## Deliverables

- [ ] <output>

## References

- <document and section, saying what the reader finds there>

## Notes

Only material written into this file before a work document exists. This is
not the Mason's working space; its notes, snippets and worklog belong in the
work document's **Notes & Snippets**.

## Retrospective

Added at `close`: lessons and proposals. The Owner rules on its proposals.
```

## File Naming Conventions

Name a spec `<YYYYMMDD-HHmm>-<intention>.spec.md`, using
`scripts/task-id.sh <intention>` for the prefix. Place it in the task
workspace declared in `.agents/project.md`. Its work document has the same
name with `.spec.md` replaced by `.work.md`. For slices use
`<NN>-<slice-slug>.spec.md`; each gains a work document at `plan`.

## Status Indicators

| Status | Emoji | Meaning |
|---|---|---|
| Not Started | 🔴 | Task not yet begun |
| In Progress | 🟡 | Active development |
| Blocked | 🟠 | Waiting on dependencies |
| Complete | 🟢 | All acceptance criteria met |
| Deferred | ⚪ | Postponed |
| Cancelled | ⚫ | No longer needed |

The thread owner maintains status in the spec. The Mason's resume point is
the work document's implementation checkboxes. Completed spec and work
documents move together to the archive.

## When Creating New Tasks

1. Interview first.
2. Agree seams before writing.
3. Fill both 🧑 zones carefully.
4. Keep the top short; order detail rather than deleting it.
5. At `close`, tick acceptance criteria against reality.
6. The implementing session creates the work document at `plan`, never before.

## When Reviewing Tasks (human)

- Read REVIEW CAREFULLY before code and REVIEW IF RELEVANT for medium/large work.
- This document is the whole review surface.
- Check named, machine-verifiable criteria and seams.
- A work document is evidence at diff review, never the requirement.
