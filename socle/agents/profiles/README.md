# Profiles — the role contracts

One file per role. A profile is the **contract** of a role, not a prompt
template: what the role is for, at which tier it runs, what it may never do,
when it stops and escalates, and — the part the delegating agent needs —
exactly what it receives when it is handed work.

The roles of the pipeline: `architect.md` (thinks), `checker.md` (reviews the
spec), `mason.md` (types), `inspector.md` (reviews the diff). They are the
roles the formula steps in `.agents/formulas/` name. The Foreman is
deliberately **not** here: it is not an agent — see `.agents/foreman.md`.

## Before spawning a role, read its profile

The delegating agent composes the brief from the **`Inputs` section of the
profile it is about to spawn** — never from habit and never from its own
conversation. That is the whole reason the input contract lives with the role
that consumes it: one source, read at the moment it is used.

## The body is the source; the per-tool definitions are renders

Tools do not agree on how a sub-agent is defined, and almost none of them can
import a shared file. So chisel **generates**, it does not reference. Two
formats cover the field today:

| Written | Shape |
|---|---|
| `.claude/agents/<role>.md` | frontmatter (`name`, `description`) + the profile body |
| `.codex/agents/<role>.toml` | `name`, `description`, the body as `developer_instructions` |

A tool that reads another's directory natively needs nothing of its own.
Anything with no definition format at all uses the fallback below.

Those generated files are **managed**: written by `chisel init`, re-rendered
by `chisel update`, hashed in `.agents/.chisel.json`, and reported by
`chisel check` when they drift. Never edit them — edit the profile and run
`chisel update`. A definition chisel did not write (a role name of your own
that happens to collide) is never overwritten: chisel warns and leaves it
alone.

To add a role: drop a file here with `name`, `description` and `tier` in its
frontmatter, then run `chisel update`. `name` is the role's identity — it is
what every tool addresses it by and what the generated files are named after,
so keep it unique across profiles and equal to the file's own name. A file
without frontmatter — this README, for instance — is documentation, and no
definition is rendered from it.

## The universal fallback

When a tool has no definition format at all, the role still applies. Two
equivalent ways to run it:

- **Inline at spawn** — paste the profile body into the sub-agent's
  instructions, then the brief built from its `Inputs` section.
- **A fresh session** — open one, give it the profile file to read and the
  same brief. Preferred when the role needs a full context window of its own,
  which is the normal case for a Mason working a slice.

Either way the contract is the same file. Nothing about a role lives in the
adapter: the adapter only knows how to *spawn*.
