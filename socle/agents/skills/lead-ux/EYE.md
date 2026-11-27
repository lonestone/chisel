# The eye — cost, brief and checklist

Read at step 4 of [SKILL.md](./SKILL.md).

## Who

A fresh sub-agent at the *mid* tier, which never saw the session. It reads
images and returns text; it decides nothing and proposes no design. The
shared rule — the builder never opens a capture, a new sub-agent for each
look — is `.agents/skills/visual-proof/SKILL.md`, "Looking: a fresh
sub-agent".

## Cost

- One pass per round, one sub-agent for every direction at once.
- It sees the light phone and desktop captures at scale 1, the `--for-eye`
  set, so four directions make eight images.
- Dark mode and the scale-2 captures are the human's; the eye sees them
  only when the report flags them.
- After a fix, one re-look on the fixed directions only, captured again
  with `--only`. What is still open goes to the human as unverified.
- In a quick round, no eye unless the report flags something.

## The brief

The Architect fills it and sends it as it is.

```
You check captures of UI directions. You did not build them.
Captures: <round-n/eye/ path>, named <name>-<direction>-<width>-light.png.
The script's text report: <round-n/eye/report.md>.
Open every capture. For each one, go through the checklist below, item
by item. Return a markdown table per capture:
| Item | Clean / Defect / Unverified | Where (direction, area: top/middle/bottom, left/right) | What |
Mark an item Unverified, with why, whenever the capture does not let you
see it; never mark it absent. Change nothing, propose no fix and no
design. Then list the report's findings you could not confirm on the
images.
```

## The checklist

Fixed, in this order. The keyboard is the script's `--keyboard` pass.

1. *Empty frames*: a frame, image, map or chart left blank or on a
   placeholder, often lazy loading that never fired.
2. *Tiny images*: an image, avatar or icon too small to read what it shows.
3. *Text crushed at 390 px*: words broken letter by letter, a column
   narrower than a word, text over text.
4. *Low contrast*: text or a control that barely stands out from its
   background.
5. *A lone half-width element*: one block at half width with nothing beside
   it, where the row calls for a pair or the full width.
6. *Overflow*: content cut at an edge, a horizontal scrollbar, checked
   against `report.md`.

## What comes back to the builder

The tables, never the images. An unverified item goes to the human with the
directions page.
