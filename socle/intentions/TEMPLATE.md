# Writing an intention

An intention is one change of a release that a repo equipped with chisel
must act on, written for the agent that will apply it. It describes the end
state, not a script: where the project keeps its method is found by reading
the repo, never assumed. `chisel update` reads the intentions the package
ships, records which ones a repo applied or skipped in its manifest
(`.agents/.chisel.json`), and hands the ones that need judgement to the
`chisel-update` skill.

## Where it lives

- **While the change is written**: `unreleased/<slug>.md`, in the same
  commit as the change. The id is `unreleased/<slug>`.
- **At the release**: `deno task promote-intentions <version>` moves it to
  `<version>/NN-<slug>.md` with the id `<version>/<slug>`
  ([RELEASING.md](/RELEASING.md)). A record under the unreleased id counts
  for the promoted one.
- **`baseline.md`**, beside this page and in no release folder, is the one
  exception: the intention of a repo chisel did not install, or installed in
  its first version. It is never pending for a repo already at the current
  layout.
- **The slug** names the change in a few words, lowercase with dashes, and
  is unique across every release.
- **A new file under `socle/`** is added to `src/socle-files.ts`, or it
  does not ship.

## Its frontmatter

On the very first line:

```
---
id: unreleased/<slug>
classification: migration
---
```

The classification says how much judgement the intention needs:

| Classification | Choose it when | Who closes it |
|---|---|---|
| `automatic` | The copy `chisel update` makes is the whole change. | The closing `chisel update`: nothing to judge. |
| `informational` | The repo has nothing to do but its human should know. | The agent reads it to the human. |
| `migration` | An agent must act on the project's own files. | An agent, the human validating each move. |
| `breaking-manual` | A human must decide before anything moves. | The human, then an agent. |

An update whose pending intentions are all `automatic` or `informational`
takes the fast path and records them itself. One `migration` or
`breaking-manual` pending stages a workspace instead.

## Its sections

In this order, each one a heading of its own, every one filled. One
intention is one bounded change, never "update the method".

- **Goal** — the end state, in one or two sentences.
- **Why** — what changed in chisel and what it costs a repo not to follow.
  Required: it is the decision nobody can invent later.
- **Applies When** — observable signals that the repo concerns this
  intention. Finding the old state is a reason to apply.
- **Do Not Apply When** — hard stops beyond the human's decision, which
  the `chisel-update` skill already honours. Without one, write
  `None beyond the human's decision.`; for `automatic` and
  `informational`, `Never: <why>`.
- **Observable Gaps** — independent gaps, each with a signal to observe,
  what to compare against, and a binary "Done when". A gap whose signal is
  absent is already closed.
- **Out of Scope** — only what goes beyond the "What is never touched"
  list of the `chisel-update` skill.
- **Reference Paths** — files of the reference tree to compare, each
  **copy** (the reference is the truth) or **adapt** (the project's own
  answers win), or `None`.
- **Validation** — yes-or-no checks the agent runs on the repo before
  recording, while `.chisel-workspace/` still exists: no check may need
  `chisel update`, which refuses to run then.
- **Record Result** — `chisel record <id> --applied`, or
  `--skipped "<reason>"` after the human's word. For `automatic` and
  `informational`: the closing `chisel update` records it.
