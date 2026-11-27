# The researcher's brief

The Architect fills the block below and sends it as it is. The researcher
runs at the Architect's tier and does steps 2 and 3 of
[SKILL.md](./SKILL.md).

## The first round

```
You are a UX researcher. You write research and mockups, not code in the
repo.

1. The human's intent
<The human's words as said, complaints included. Each quote was checked at
its source.>

2. What I understand
<What the task is.>
What it is not: <the neighbouring screens it must not become>.
Scope: <which screens: these, the flow, the whole section>.
Kinds of question the human will answer: <quick choice, visual comparison,
free text>.
Usage: <the keyboard, the phone, touch, the mouse — when it matters>.

3. What you do — research, not code in the repo
 3.1 The survey. Look at <kinds of product, named: those that solve the
     same gesture, not the same domain>. For each, note what we take and
     why. The method is .agents/skills/research/SKILL.md.
 3.2 The house references. <What the human already liked in this project,
     with paths, and the taste the project keeps.>
 3.3 The real data. Take real records from <a demo or an anonymised copy>,
     never written to production, never invented. Read the data model; you
     may propose a change to it, said apart.
 3.4 Directions really different. Build <how many> directions on <which
     axes>, each a self-contained page filled with the real data, at phone
     and desktop width.
 3.5 The directions page. Start from
     .agents/skills/lead-ux/templates/directions.html. Under each
     direction: its idea, what it sacrifices, its "answers: …" line, the
     request it answers and the gesture that follows it, or its "proposal"
     mark. Re-read the Asked for or placed table for each direction before
     it removes, lightens or moves anything. Mark one direction preferred,
     with its reason in one line.

4. The project's rules for mockups
<The rules the project keeps, or "none".>

5. Where the files go, and done
Files go in <Tasks>/<task-id>/ux/, laid out as in
.agents/skills/lead-ux/SKILL.md. Done: the directions page is written and
the command that rebuilds it is at the top of ux/scripts/. The Architect
runs the eye; you open no capture.

6. Write the survey to its file before drawing
A long session loses what is not on disk. Write ux/survey.md, in the format
of .agents/skills/lead-ux/SURVEY.md, first. When your context grows, hand
back after the survey: the drawing runs in a fresh session that reads the
files.

What comes back to me: paths and a few lines, never images.
```

## A next round

A short block, sent to the researcher that built the directions or, when it
is gone, to a fresh one:

```
Round <n+1>. Read <path of round-n/feedback.md> whole.
The gist, in three lines:
<line 1>
<line 2>
<line 3>
This round makes: <the combinations of what the human kept>, and one line
on the page for what the human did not understand last time:
<that line>.
```
