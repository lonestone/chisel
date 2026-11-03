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
- **At the release**: `git mv unreleased/<slug>.md <version>/NN-<slug>.md`,
  where `<version>` is the release's, bare (`0.3.0`), and `NN` the
  zero-padded order inside the release (`01`, `02`, ...). Rewrite the id to
  `<version>/<slug>`. A repo that recorded the unreleased id is not asked
  again: a record under `unreleased/<slug>` counts for the promoted one.
  `deno task promote-intentions <version>` does both, and keeps
  `src/socle-files.ts` in step ([CONTRIBUTING.md](/CONTRIBUTING.md)).
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

| Classification | Who closes it |
|---|---|
| `automatic` | The copy of `chisel update` closes it: nothing to judge. |
| `migration` | An agent applies it with judgement, the human validating each move. |
| `breaking-manual` | A human decides before anything moves. |
| `informational` | Read, nothing to do. |

An update whose pending intentions are all `automatic` or `informational`
takes the fast path and records them itself. One `migration` or
`breaking-manual` pending stages a workspace instead.

## Its sections

In this order, each one a heading of its own:

- **Goal** — the end state, in one or two sentences.
- **Why** — what changed in chisel and what it costs a repo not to follow.
- **Applies When** — observable signals that the repo concerns this
  intention. Finding the old state is a reason to apply, never to skip.
- **Do Not Apply When** — hard stops only, such as the human having
  decided, after reading it, to stay as they are.
- **Observable Gaps** — independent gaps, each with a signal to observe,
  what to compare against, and a "Done when". A gap whose signal is absent
  is already closed.
- **Out of Scope** — what it must not touch, even if it looks related.
- **Reference Paths** — files of the reference tree to compare, each
  **copy** (the reference is the truth) or **adapt** (the project's own
  answers win).
- **Validation** — how to tell it worked.
- **Record Result** — `chisel record <id> --applied`, or
  `--skipped "<reason>"` after the human's word.
