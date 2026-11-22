# 04 — Visual proof

**Status:** ready — group A, approved by Pierrick on 22/11 (ffaf5ec)
**Blocked by:** 01 — Human review with crit

---

> 🧑 **REVIEW CAREFULLY** — human decision surface. Read it all before code.

**What to build:** when a task touches a screen, the agent checks it itself
(a recorded Playwright e2e test, or at least a browser or Playwright check)
and the human review shows at least a screenshot of it, with a before →
after comparison when the screen existed.

Two pieces, inside Chisel, with no Harness command (decision 16):

- **A capture command**, the equivalent of the Harness's `captures.ts`:
  Playwright captures written to disk, at the widths asked; a before →
  after comparison at the pixel, with a `.diff.png` map and a verdict per
  screen (identical, changed, new, size); and a text report: overflow,
  console errors, off-site requests, content below the fold. Playwright
  comes from the project. Pierrick (21/11): `captures.ts` is copied, in
  Node, not rewritten. Olympe agreed (21/11, 23:55): « d'accord pour la
  copie dans lonestone/chisel, sous sa licence. Prends la version du vault
  à a05b1092 (la dernière, avec --clic, --sombre et le navigateur
  distant). Trois choses propres à nos machines à retirer ou rendre
  génériques : la recherche de playwright-core dans ~/projects/* (l. 71),
  le nom HARNESS_PLAYWRIGHT_WS (renomme-le pour Chisel), et le texte
  « harness captures » des messages et de l'usage. Aucun secret ni chemin
  du vault dedans. Une copie, pas un lien : les deux vivront séparément,
  je ne reporterai pas nos changements chez toi. »
- **A `visual-proof` skill**, made generic from music-downloader's
  `review-videos`, that carries the method of the Harness's
  `verification-visuelle`: mechanical first, through the capture command,
  whose text often suffices; an agent never reads a capture in its own
  thread; when looking is needed, a fresh sub-agent gets the paths, the
  report, the precise question and the list of what it must find, reports
  per capture, and says « not verified » for what it cannot see, never
  « absent ». The human sees the images himself.

The project declares in §J its e2e, recording and screenshot commands, each
optional, and where the proofs go. The depth is the Architect's line in the
spec; the diff only adds a floor (a screen touched means captures). The
proofs are the second of the three readings of the human review (slice 01);
until group B's tool shows them in a page, they are files in the folder §J
names, linked from the review. The close records the depth chosen and the
floor the diff computed, and `retro` compares them, so an agent that always
asks more than the floor shows. Parent spec: decisions 5, 10, 13, 16, 17,
24.

## Acceptance criteria

- [ ] **visual-proof-skill** — the skill exists, reads its commands from
  §J, names no command of one project, and says an agent never reads a
  capture in its own thread.
- [ ] **capture-tool** — the capture command ships with Chisel, is listed
  in `src/socle-files.ts`, and on a page captured twice produces the
  captures, a `.diff.png` for a changed screen and a text report.
- [ ] **capture-copy-generic** — the copy carries none of the three
  machine-specific things Olympe named: no search for `playwright-core` in
  `~/projects/*`, no `HARNESS_PLAYWRIGHT_WS` (renamed for Chisel), no
  « harness captures » in its messages or usage; and no vault path.
- [ ] **review-section-commands** — §J declares the e2e, recording and
  screenshot commands, each optional.
- [ ] **spec-line-read** — the skill reads the depth line of the spec and
  adds captures when the diff touches a screen the line left out.
- [ ] **depth-against-floor** — the work-document template records the
  depth chosen and the floor computed, and `retro` compares them.
- [ ] **no-screen-no-capture** — a dry run on a repo with no front touched
  produces no capture.
- [ ] **intention-per-change** — the Intention gate passes.
- [ ] **suite-green** — `deno task check` and `deno task test` pass.

---

> 🧑 **REVIEW IF RELEVANT** — notes written before the work document exists.

## Notes

- Dry run on music-downloader before shipping (screens, e2e, recording).
- Sources: Harness `scripts/captures.ts` (245 lines, Node, Playwright) and
  `skills/verification-visuelle/SKILL.md`. Why the method exists: on 02/11
  a crewmate read 22 PNGs (about 10 MB) in its own thread, for about $10.
- The copy is taken from the vault at commit a05b1092, under Chisel's
  licence. It is a copy, not a link: Olympe will not carry the Harness's
  later changes over, and Chisel owns its copy from then on.
- The socle ships only shell scripts today, so a Node script under
  `socle/scripts/` is a first.
