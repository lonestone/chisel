# The Foreman — routing, and why it is not an agent

On a site, the Foreman is the point of serialization: it keeps the list of
what is ready, holds the priorities, and starts fresh sessions on it. It is
deliberately the one role that does not multiply — one per project — and it
is deliberately **not** the Architect: routing is mechanical, design is not,
and merging them means paying a frontier tier to sort a queue.

Note what the Foreman never does: it has no opinion on the content. It does
not design, does not review, does not decide what a slice should contain. It
answers one question — *what starts next, and who starts it* — and the answer
is supposed to be boring.

This is why there is no `foreman.md` profile in `.agents/profiles/`. A profile
exists to be delegated to; a role with no judgement to exercise has nothing to
delegate. Instead, the function is filled in one of two ways.

## Default: the Foreman is you

You look at the frontier — the tasks and slices whose blockers are all done —
pick the next one, and open a fresh session on it (`work on task <file>`, or
`work on slice <file>`). Priorities live in your head and in the spec files;
the "ready" state is whatever the tracker convention of `.agents/project.md`
§B says it is. Nothing else is needed, and nothing is automated: at this
scale, deciding what to do next is not the bottleneck.

## Auto: the Foreman is a cron, not an agent

When the pipeline runs without a human at the gates and the project's
coordination state is kept in a tool that can answer "what is ready?" and
"which gates are open?", the Foreman becomes a scheduled job around those two
queries — on a timer or on a hook, per the tracker convention of §B:

1. ask for the ready work,
2. ask which gates are waiting,
3. start a fresh session per ready item, inside its allotment,
4. write nothing else.

No daemon, no queue of its own, no state: the tracker holds the state, the
job only polls it. Anything that job cannot answer mechanically is not its
business — it escalates by leaving the item where it is.

## When it would become an agent

Only when routing starts requiring judgement: contested priorities, allotments
that overlap, an item that is ready on paper but obviously wrong to start.
That is a real possibility and an explicitly deferred one — the shape of that
agent should come from watching a real queue misbehave, not from imagining
one. Until then, a `foreman` definition is generated for no tool, on purpose.

The roles that DO have profiles — Architect, Checker, Mason, Inspector — are
in `.agents/profiles/`.
