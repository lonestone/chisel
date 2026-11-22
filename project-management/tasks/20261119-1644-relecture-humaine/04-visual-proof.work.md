# 04 — Visual proof — work

Created by the Mason at the plan step, 2026-11-22. Spec:
`project-management/tasks/20261119-1644-relecture-humaine/04-visual-proof.spec.md`.

**Plan:** approved by the Architect, 2026-11-22, with these rulings on the
Mason's questions: (1a) the script lives in the skill folder; (2a) the copy
as described — Olympe's three changes, the MIT header (the licence
`deno.json` declares), the rewritten comment, `visual-proof`, `node
captures.ts`; the French stays, no translation; the skill says in one line
that a project whose linter reaches `.agents/` excludes the script; (3a) one
`**Review depth:**` line; (4a) a committed `<name>.proofs/` folder beside
the spec, as §J's default — the skill keeps captures to the screens and
widths the floor asks, since PNGs weigh in git; (5a) the fixture browser
test and this slice's own close; music-downloader's dry run stays an open
item, flagged to the human; (6a) no command, no captures; (7) Typist on the
mid tier. The finding on `review-videos` is accepted.
Mason handle: aa450428155af1d37.

**Depth:** chosen `full`, §J's default, since the spec has no `**Review
depth:**` line; floor none, no screen touched (this repo has no front, and
the diff changes the socle's prose, its install lists and a script, never a
page). At the floor: no capture taken and no `04-visual-proof.proofs/`
folder created. This is the no-screen-no-capture dry run.

## Program Design

This slice carries these parent decisions:

- *A touched screen has a proof* (5);
- *Visual proof as a Chisel skill* (10);
- *The depth is a line of the spec, the diff a floor* (13);
- *Chisel serves its own pages* (16);
- *The proofs live in Chisel's pages* (17): until that page exists, the
  proofs are files;
- *The visual proof starts from the Harness's method* (24). The Architect's ruling stands: the close record of decision 13
belongs here. The work template gets a `**Depth:**` line, step 7 asks for
it, and `retro` compares the depth with the floor.

What I found while reading:

- **`review-videos` is not in this repo.** It is not in any commit. Only
  the test fixture names of fee75e0 and b20f3bb mention it, and there is
  no music-downloader checkout on this machine. So the skill is built from
  the Harness's `verification-visuelle` (read at the vault, read-only) and
  from the spec.
- **The source script runs as is.** I took a scratch copy of
  `captures.ts` at a05b1092 and ran it under Node 24.13.0 with
  `playwright-core` linked from another project. Two captures of a
  `file://` page in two versions gave the PNGs, a `.diff.png` and the
  report "0.46 % des pixels changent…". The script closes its own
  browser.
- **Node needs a recent version.** Node runs the `.ts` file directly
  because it strips the types. `import.meta.main` needs Node 24.2 or later.
  On an older Node, `main` silently never runs. The skill and the intention
  say so.
- **Where the script goes decides who receives it.** `update` writes
  anything under `.agents/`. Outside `.agents/` it writes only files that
  the last manifest listed and that are still on disk. So a new
  `scripts/captures.ts` at the repo root would reach fresh installs only,
  never repos already equipped. A file inside the skill tree reaches
  every repo through the copy of `agents/skills/` that already exists, with
  no installer change. A skill already ships a script this way:
  `diagnosing-bugs/scripts/hitl-loop.template.sh`. Question 1.
- **Nothing reads §J's items in the code.** Only the init test reads
  *Default depth*. Adding lines to §J breaks no parser.
- **The synthesis stays as it is.** Its template says "No proofs": they are
  the second reading. So the proofs are linked from the pull request's
  description, not from the synthesis.

### Files touched

| File | Change |
|---|---|
| `socle/agents/skills/visual-proof/scripts/captures.ts` (new) and its `.agents/skills/` copy | The copy of the Harness script, with the edits of "The copy". |
| `socle/agents/skills/visual-proof/SKILL.md` (new) and its `.agents/skills/` copy | The skill. Edit 1. |
| `socle/agents/project.md.tpl` and `.agents/project.md` | §J gets four lines and a new comment. Edit 2. Only §J must be identical in the two files, since the other sections differ. |
| `socle/agents/skills/chisel-setup/SKILL.md` and its copy | A second verbatim §J question; the defaults list. Edit 3. |
| `socle/agents/workflow.md` and `.agents/workflow.md` | Steps 2, 3, 5, 7 and 8 and the depth paragraph. Edits 4 to 9. |
| `socle/templates/000-template.spec.md` and `project-management/000-template.spec.md` | The depth line and its section. Edit 10. |
| `socle/templates/000-template.work.md` and `project-management/000-template.work.md` | The `**Depth:**` line and a Context paragraph. Edit 11. |
| `socle/agents/skills/retro/SKILL.md` and its copy | The Depth line among the sources, a category, and the `x-upstream` changes. Edit 12. |
| `socle/intentions/unreleased/review-proofs.md` (new) | Migration intention. Edit 13. |
| `socle/intentions/unreleased/visual-proof.md` (new) | Informational intention. Edit 14. |
| `src/socle-files.ts` | Four lines. Edit 15. |
| `test/fixtures/golden-tree.txt` | Four lines. Edit 15. |
| `test/captures.test.ts` (new) | The capture command's tests. "The tests". |
| `test/init.test.ts` | The review-section test also checks the four new §J lines. "The tests". |
| `test/TESTS.md` | A `captures` row, and the `init` row extended. Edit 16. |

Each socle file and its copy in this repo end byte-identical; check with
`cmp`. For `project.md`, compare §J only:
`diff <(sed -n '/^## J/,$p' socle/agents/project.md.tpl) <(sed -n '/^## J/,$p' .agents/project.md)`.
Untouched: `synthesis.md.tpl`, `src/install.ts`, `src/update.ts`, `CHARTER.md`
and `AGENTS.md`.

### How the Node script ships (the first Node file in the socle)

- **Installed** by the copy of `agents/skills/` that already exists, to
  `.agents/skills/visual-proof/scripts/captures.ts`. No exec mode is
  needed, because it runs as `node .agents/skills/visual-proof/scripts/captures.ts …`
  from the project's root. The shebang stays.
- **Listed** in `src/socle-files.ts` as
  `"agents/skills/visual-proof/scripts/captures.ts"`, which the integrity
  test compares with the tree. The golden tree gets the four new paths.
- **Licence header** goes right after the shebang:

  ```
  // SPDX-License-Identifier: MIT
  // Copied into Chisel from the Harness (vault commit a05b1092), with Olympe's
  // agreement of 21/11/2026, under Chisel's licence. A copy, not a link.
  ```

  MIT is the licence in `deno.json`. The repo has no LICENSE file.
- **Deno never compiles it.** `deno check`, `lint` and `fmt` cover `src/`,
  `test/` and `scripts/`. The tests run it with `node` as a subprocess
  and never import it into Deno: its DOM types and `Buffer` would break
  `deno check`. `deno publish` ships `socle/` as files. The module graph
  starts at `src/main.ts` and does not reach the script. The gates include
  `deno publish --dry-run --allow-dirty` once to confirm this. If that
  command fails for a reason other than this file, I note it and move on.
- **Tested** by `test/captures.test.ts` in three layers ("The tests"):
  - **Text checks.** They always run.
  - **Node checks.** They are skipped when `node` is missing or older
    than 24.2, which covers a CI runner on Node 20 or 22.
  - **A real browser check.** It is skipped unless `CHISEL_TEST_PLAYWRIGHT`
    names a `playwright-core` package directory. Here it runs with
    `CHISEL_TEST_PLAYWRIGHT=/home/pierrick/projects/atlas/node_modules/playwright-core`.

### The copy

The Typist creates the file with the vault read-only, reading only:

    git -C "/home/pierrick/ContainersData/obsidian/vault" show "a05b1092:00-09 System/04 Harness/scripts/captures.ts" > socle/agents/skills/visual-proof/scripts/captures.ts

Then it makes exactly these edits, and nothing else. The French stays
verbatim (question 2).

1. **Licence.** Insert the three header lines above between line 1 (the
   shebang) and line 2.
2. **Olympe's third change: the name.** In the header line,
   `// harness captures : prendre` becomes `// captures : prendre`.
3. **The skill pointer** (question 2). In the header comment,
   `// (skill verification-visuelle), jamais du fil principal.` becomes
   `// (skill visual-proof), jamais du fil principal.`
4. **Third change, usage comment.** `//   harness captures <url de base>`
   becomes `//   node captures.ts <url de base>` (rest of the line
   unchanged).
5. **First and second changes, the comment that describes them.** Replace
   the four lines from `// Playwright vient du repo où l'on se trouve` to
   `// Playwright commun, pw-commun : chromium.connect …` with:

   ```
   // Playwright vient du repo où l'on se trouve (node_modules : playwright, playwright-core ou
   // @playwright/test), sinon d'un playwright-core posé à côté de ce script.
   // Si CHISEL_PLAYWRIGHT_WS est définie, le navigateur est celui du serveur Playwright qu'elle désigne :
   // chromium.connect avec exposeNetwork '<loopback>', qui lui montre le localhost de ce client.
   ```
6. **Third change, the two usage errors** in `parseArgs`: each
   `usage : harness captures <url de base>` becomes
   `usage : node captures.ts <url de base>`.
7. **First change.** In `chargerPlaywright`,
   `const essais = [process.cwd(), ...repos()];` becomes
   `const essais = [process.cwd()];`
8. **First change.** Delete the whole `function repos(): string[] { … }`
   (five lines) and the blank line after it. `homedir`, `existsSync`
   and `readdirSync` stay: `chromeEnCache` uses them.
9. **Second change.** In `voieNavigateur`, `env.HARNESS_PLAYWRIGHT_WS`
   becomes `env.CHISEL_PLAYWRIGHT_WS`.
10. **The skill pointer.** In `rapport`, `(skill verification-visuelle).`
    becomes `(skill visual-proof).`
11. **Third change, the error prefix.** In the last line,
    `` `harness captures : ${ `` becomes `` `captures : ${ ``.

Check: `grep -n -i "harness\|repos()\|verification-visuelle\|crewbox\|/kit" <file>`
finds only the licence line's "Harness". The diff against the vault copy
shows these hunks and no other.

### The tests

`test/captures.test.ts`, written first; the text test is red until the
copy exists:

```ts
// The capture command of the visual-proof skill: a copy of another project's
// script, run by Node, never imported into Deno. The text checks always run;
// the Node checks run when Node 24.2 or later is there; the browser check
// runs only when CHISEL_TEST_PLAYWRIGHT names a playwright-core directory.

import {
  assert,
  assertEquals,
  assertMatch,
  assertStringIncludes,
} from "@std/assert";
import { join, toFileUrl } from "@std/path";
import { REPO_ROOT } from "./helpers.ts";

const SCRIPT = join(
  REPO_ROOT,
  "socle",
  "agents",
  "skills",
  "visual-proof",
  "scripts",
  "captures.ts",
);

function recentNode(): boolean {
  try {
    const out = new Deno.Command("node", {
      args: ["--version"],
      stdout: "piped",
      stderr: "null",
    }).outputSync();
    if (!out.success) return false;
    const [major, minor] = new TextDecoder().decode(out.stdout).trim()
      .replace(/^v/, "").split(".").map(Number);
    return major > 24 || (major === 24 && minor >= 2);
  } catch {
    return false;
  }
}

const NODE = recentNode();
const PLAYWRIGHT = Deno.env.get("CHISEL_TEST_PLAYWRIGHT");

async function node(
  args: string[],
  cwd?: string,
): Promise<{ code: number; stdout: string; stderr: string }> {
  const out = await new Deno.Command("node", {
    args,
    cwd,
    stdout: "piped",
    stderr: "piped",
  }).output();
  const decode = (bytes: Uint8Array) => new TextDecoder().decode(bytes);
  return {
    code: out.code,
    stdout: decode(out.stdout),
    stderr: decode(out.stderr),
  };
}

Deno.test("captures: the copy carries nothing of the machines it came from", async () => {
  const text = await Deno.readTextFile(SCRIPT);
  assert(!/['"]projects['"]/.test(text), "no search under ~/projects");
  assert(!text.includes("HARNESS_PLAYWRIGHT_WS"), "the variable is renamed");
  assertStringIncludes(text, "CHISEL_PLAYWRIGHT_WS");
  assert(!/harness captures/i.test(text), "no « harness captures »");
  assert(
    !text.includes("ContainersData") && !text.includes("obsidian"),
    "no vault path",
  );
});

Deno.test({
  name: "captures: a missing argument is a usage error under its own name",
  ignore: !NODE,
  async fn() {
    const result = await node([SCRIPT]);
    assertEquals(result.code, 1, result.stderr);
    assertMatch(result.stderr, /^captures : usage : node captures\.ts /);
  },
});

Deno.test({
  name: "captures: CHISEL_PLAYWRIGHT_WS names the remote browser",
  ignore: !NODE,
  async fn() {
    const probe = `import { voieNavigateur } from ${
      JSON.stringify(toFileUrl(SCRIPT).href)
    };
console.log(JSON.stringify([
  voieNavigateur({ CHISEL_PLAYWRIGHT_WS: "ws://pw:3000" }),
  voieNavigateur({ HARNESS_PLAYWRIGHT_WS: "ws://pw:3000" }),
]));`;
    const result = await node(["--input-type=module", "-e", probe]);
    assertEquals(result.code, 0, result.stderr);
    assertEquals(JSON.parse(result.stdout), [
      { voie: "distant", ws: "ws://pw:3000" },
      { voie: "local" },
    ]);
  },
});

function page(title: string, colour: string): string {
  return `<!doctype html><html><head><title>${title}</title></head>` +
    `<body style="margin:0;background:${colour}"><h1>${title}</h1></body></html>`;
}

Deno.test({
  name: "captures: a page captured twice gives the captures, a diff map and a report",
  ignore: !NODE || !PLAYWRIGHT,
  async fn() {
    const work = await Deno.makeTempDir({ prefix: "chisel-captures-" });
    try {
      await Deno.mkdir(join(work, "node_modules"));
      await Deno.symlink(
        PLAYWRIGHT!,
        join(work, "node_modules", "playwright-core"),
      );
      let body = page("Before", "#ffffff");
      const stop = new AbortController();
      const server = Deno.serve(
        { hostname: "127.0.0.1", port: 0, signal: stop.signal, onListen() {} },
        () =>
          new Response(body, {
            headers: { "content-type": "text/html; charset=utf-8" },
          }),
      );
      const base = `http://127.0.0.1:${server.addr.port}`;
      const capture = (out: string, ...more: string[]) =>
        node(
          [SCRIPT, base, "/", "--out", join(work, out), "--largeurs", "390",
            ...more],
          work,
        );
      try {
        const before = await capture("before", "--json");
        assertEquals(before.code, 0, before.stderr);
        assert(
          (await Deno.stat(join(work, "before", "accueil-390.png"))).isFile,
          "the first run writes the capture",
        );

        body = page("After", "#ffcc00");
        const after = await capture(
          "after",
          "--avant",
          join(work, "before"),
          "--json",
        );
        assertEquals(after.code, 0, after.stderr);
        const report = JSON.parse(after.stdout) as {
          diffs: { fichier: string; statut: string }[];
        };
        assertEquals(
          report.diffs.map((d) => [d.fichier, d.statut]),
          [["accueil-390.png", "change"]],
        );
        assert(
          (await Deno.stat(join(work, "after", "accueil-390.diff.png")))
            .isFile,
          "a changed screen gets its diff map",
        );

        const again = await capture("again", "--avant", join(work, "after"));
        assertEquals(again.code, 0, again.stderr);
        assertStringIncludes(again.stdout, "accueil-390.png : identique");
        assertStringIncludes(again.stdout, "sous-agent (skill visual-proof)");
      } finally {
        stop.abort();
        await server.finished;
      }
    } finally {
      await Deno.remove(work, { recursive: true });
    }
  },
});
```

`deno fmt` may reflow this. Run `deno fmt test/captures.test.ts` after
writing it; `deno fmt --check` is a gate.

`test/init.test.ts`, the test "init: the review section and the synthesis
template are installed": after the `Default depth` assertion, add:

```ts
    for (
      const label of [
        "E2E command",
        "Recording command",
        "Screenshot command",
        "Proofs folder",
      ]
    ) {
      assert(
        glueItem(glueSection(glue, "J"), label) !== undefined,
        `§J declares the ${label} line`,
      );
    }
```

This is red until Edit 2 lands. The no-screen-no-capture criterion has no
test: it is a dry run at the close ("Decisions the spec left open").

### Writing rules for the Typist

Copy the text below exactly. Prose lines are 80 columns at most; every
paragraph touched is reflowed, and the blocks below already are. Shipped
text names a decision by its title, never by its number. When a "replace"
target below does not match the file word for word, stop and report: do
not overwrite.

### Edit 1 — the skill, `socle/agents/skills/visual-proof/SKILL.md`

The whole file:

````markdown
---
name: visual-proof
description: Prove a change to a screen without ever reading a capture in your own thread. Covers the proofs the depth line and the diff demand, the captures taken and compared by the command this skill ships, a fresh sub-agent when an image must be looked at, and the proof files the human review links. Use when a task touches a screen (a page, a component, a stylesheet, a template, a displayed string, an image), at the plan, code and close steps of `.agents/workflow.md`, or whenever you are about to take or look at a screenshot.
---

# Visual proof

A capture read in your own thread stays in its context and is read again at
every later call. One session read 22 captures, about 10 MB, and cost about
ten dollars. This skill does the mechanical work without a model, and
leaves the looking to a sub-agent and to the human.

## The project's commands

They are in §J · Review of `.agents/project.md`:

- **E2E command**: runs the end-to-end tests.
- **Recording command**: runs them and keeps a video.
- **Screenshot command**: captures pages and compares them before → after.
  The project usually names the command this skill ships,
  `node .agents/skills/visual-proof/scripts/captures.ts`.
- **Proofs folder**: where the proof files go, committed with the work.

A line left at _(none …)_ means the project has no command of that kind.
Then the task has no proof of that kind, and the review says so. Never
invent a command. The app the commands run against is started as the
Browser check line of §F · Gate commands says.

## Which proofs: the depth line and the floor

1. **Read the depth line.** The spec's `**Review depth:**` line is
   `full` or `strategic`, followed by each proof the Architect asks for
   after a `+`: `captures`, `recording`, `e2e`. For example,
   `strategic + captures`. When the spec has no such line, the depth is
   the default of §J and the only proofs are the floor's.
2. **Compute the floor from the diff.** Use the plan at the plan step and
   the real diff at the close. The diff touches a screen when it changes
   what a user sees: a page, a component, a stylesheet, a template, a
   displayed string, an image or a font. Judge from the diff, not from path
   patterns. A screen touched makes the floor `captures`. Otherwise the
   floor is none.
3. **The proofs to produce** are the line's plus the floor's. A screen
   touched gets captures even when the line left them out. Never produce
   fewer proofs than the floor. Capture only the screens the diff touches,
   at the widths they need (`--largeurs`): the captures are committed, and
   every image weighs in the repo's history.
4. **No floor and no proof asked: no capture.** Take no capture and start
   no browser. Write it in the depth record and stop here.

## When: before, during, after

- **Plan step.** The plan names the screens touched, with their paths and
  widths, and the proofs to produce.
- **Before the first code change.** Take the before captures of the
  screens that already exist, from the base:
  `<screenshot command> <base url> <path,path…> --out <proofs folder>/before`.
  A new screen has no before.
- **Once the work is typed.** Check the screen yourself: run the E2E
  command, through the Recording command when the depth asks for a
  recording. When the project has no e2e, the capture command's report is
  the least you check. This check is for you. It joins the proofs only
  when the depth line asks for `e2e` or `recording`.
- **At the close.** Take the after captures, compared with the before:
  `<screenshot command> <base url> <path,path…> --out <proofs folder>/after --avant <proofs folder>/before`.

## Mechanical first

The capture command writes the captures to disk and prints a text report,
in French. Widths default to 390 and 1280 (`--largeurs 390,1280`).
`--avant <folder>` compares each capture with the one of the same name in
that folder, at the pixel. Each screen gets one of these verdicts:

- `identique`: nothing changed;
- a share of pixels changed, with the zone and a `.diff.png` map;
- `pas de capture avant`: a new screen;
- `la taille change`: the size changed.

The report also gives:

- an overflow at each width (`DÉBORDE`);
- console errors;
- requests that leave the site;
- content hidden below the fold of a scrolling container (`SOUS LE PLI`).
  Run again with `--plein` to capture it.

Other options:

- `--sombre` captures the dark colour scheme;
- `--clic <selector>`, repeated, clicks before the capture: a menu, a tab,
  an accordion;
- `--json` prints the same facts as JSON.

Often the text is enough. `identique` where nothing should change is
verified. An overflow at 390 px is a bug: fix it before anyone looks.

The command needs these, run from the project's root:

- Node 24.2 or later. An older Node silently does nothing.
- Playwright in the project's `node_modules`: `playwright`,
  `playwright-core` or `@playwright/test`.
- A Chromium that Playwright installed.

When `CHISEL_PLAYWRIGHT_WS` is set, it names a remote Playwright server,
and the command uses that server's browser instead of a local one.

The script is TypeScript for Node, not for the project's own build. A
project whose linter or type checker reaches `.agents/` excludes the
script, `.agents/skills/visual-proof/scripts/captures.ts`.

## Looking: a sub-agent, never you

Never open a capture with your own Read tool, not even one. When the text
is not enough, launch a fresh sub-agent on the mid tier of
`.agents/reference.md`, and give it:

- the paths of the captures, the `.diff.png` maps and the text report;
- the precise question;
- the list of what it must find on each capture;
- the rule that what it cannot see is « not verified », never « absent »;
- the form of its report: for each capture, compliant or not, and where
  each defect sits; no general description;
- the order to change nothing.

Use a fresh sub-agent for each round. A sub-agent that saw the old version
sees what it expects.

## The proofs at the review

The proof files stay in the proofs folder, committed with the work. The
pull request's description links each one: for a changed screen, the
before and the after side by side, with the `.diff.png`. The human looks at
them himself. You write the paths without having looked at the images. A
kind of proof the depth asks for, which the project has no command for, is
named there as missing.

## The depth record

At the close, write the work document's `**Depth:**` line. It gives the
depth chosen, the floor the diff computed, and, when the task went above
the floor, what it added and why. The `retro` skill compares the two.
````

### Edit 2 — §J, `socle/agents/project.md.tpl` and `.agents/project.md`

Replace, in both files, the section from `## J · Review` to the end of the
file:

```markdown
## J · Review

<!-- How far down the human goes at the human review: `full` or
`strategic`, as step 8 of `.agents/workflow.md` defines them. A spec's own
`**Review depth:**` line wins over this default. The commands prove a
screen, and each is optional: a command left at none means no proof of
that kind, and the review says so. They run against the app started as
§F's Browser check says. The proofs go in the folder named here, committed
with the work. The visual-proof skill reads this section. -->

- **Default depth:** full
- **E2E command:** _(none — example: `npm run test:e2e`)_
- **Recording command:** _(none — example: `npx playwright test --video on`)_
- **Screenshot command:** _(none — example: `node .agents/skills/visual-proof/scripts/captures.ts`)_
- **Proofs folder:** beside the spec, named by replacing `.spec.md` with `.proofs/`
```

This repo has no screen, so the three commands stay at none in
`.agents/project.md`.

### Edit 3 — `chisel-setup/SKILL.md`

(a) In Step 2's defaults list, replace
`merge and publish left to the human; review depth `full`).` with
`merge and publish left to the human; review depth `full`; proof commands
from `package.json`, else none).` and reflow that list item.

(b) Replace the line `Write the answer on §J's one line, *Default depth*.`
with:

```markdown
Write the answer on §J's line *Default depth*. Then ask the second
question.

### §J — then ask this, verbatim

> **Which commands prove a screen in this project? Each one is optional.**
>
> 1. **E2E**: the command that runs the end-to-end tests (example:
>    `npm run test:e2e`).
> 2. **Recording**: the command that runs them and keeps a video
>    (example: `npx playwright test --video on`).
> 3. **Screenshots**: the command that captures pages and compares them
>    before → after.
>
> Answer « none » for any the project lacks: the task has no proof of that
> kind, and the review says so.
>
> Recommended: the e2e and recording commands found in `package.json`, else
> none; for screenshots, the capture command chisel ships,
> `node .agents/skills/visual-proof/scripts/captures.ts`, when Playwright
> is among the project's dependencies, else none.

Write each answer on its §J line: *E2E command*, *Recording command*,
*Screenshot command*. Leave *Proofs folder* as the reference writes it,
unless the human names another folder.
```

### Edit 4 — `workflow.md`, step 2

In the paragraph "**2. Write or sharpen the spec — Architect.**", replace
the sentence

"The spec carries a `**Review depth:**` line, `full` or `strategic`, when
the task departs from the default of §J · Review of `.agents/project.md`,
and a `**One shot:**` line when the Architect takes the one shot ("The one
shot", below)."

with

"The spec carries a `**Review depth:**` line when the task departs from the
default of §J · Review of `.agents/project.md`. The line gives `full` or
`strategic`, then each proof the Architect asks for after a `+`
(`captures`, `recording`, `e2e`), as in `strategic + captures`. The spec
also carries a `**One shot:**` line when the Architect takes the one shot
("The one shot", below)."

Then reflow the whole paragraph.

### Edit 5 — `workflow.md`, step 3

In "**3. Plan — Mason.**", replace
"program design there: files, seam signatures, test order, the decisions the
spec left to the implementation."
with
"program design there: files, seam signatures, test order, the decisions the
spec left to the implementation, and, when the task touches a screen, the
screens and the proofs the `visual-proof` skill asks for."
and reflow the paragraph.

### Edit 6 — `workflow.md`, step 5

In "**5. Code — a Typist the Mason launches.**", after the sentence ending
"test-first at the agreed seams (the `tdd` skill).", insert:
"When the task touches a screen, the before captures are taken before the
first code change, and the screen is checked once it is typed, as the
`visual-proof` skill says."
Reflow the paragraph: it already has a short line ("agreed seams (the
`tdd` skill). Tick"), which the reflow removes.

### Edit 7 — `workflow.md`, step 7

In "**7. Close — Mason.**", after "Tick the spec's acceptance criteria
against reality.", insert:
"When the task touches a screen, take the after captures into the proofs
folder of §J · Review. Write the work document's `**Depth:**` line: the
depth chosen, the floor the diff computed with the `visual-proof` skill,
and why the task went above the floor when it did."
Then reflow the paragraph.

### Edit 8 — `workflow.md`, step 8, the proofs bullet

Replace the bullet
"- **Proofs: what the floor demands.** The proofs the project's floor
  asks for, read after the synthesis and before the guide."
with:

```markdown
- **Proofs: what the depth and the floor demand.** The captures,
  recordings and e2e results the spec's depth line asks for, plus the
  captures the floor adds when the diff touches a screen. They are read
  after the synthesis and before the guide. They are files in the proofs
  folder of §J · Review, committed with the work. The pull request's
  description links each one, with a before → after pair for each changed
  screen. The human looks at them himself. A kind of proof the project has
  no command for is named there as missing.
```

### Edit 9 — `workflow.md`, the depth paragraph of step 8

Replace the paragraph "How far the human goes is the spec's
`**Review depth:**` line … `strategic` never skips the proofs." with:

```markdown
How far the human goes is the spec's `**Review depth:**` line, or §J ·
Review of `.agents/project.md` when the spec has none. `strategic` is the
synthesis plus the proofs; `full` goes down to the reading guide. The diff
stays a floor: `strategic` never skips the proofs, and a screen touched
brings captures whatever the line says.
```

### Edit 10 — the spec template, both copies

(a) Replace the line `**Review depth:** full | strategic` with
`**Review depth:** full | strategic [+ captures] [+ recording] [+ e2e]`.

(b) Replace the body of the section "## Review depth" (the paragraph
"The `**Review depth:**` line says … gives the default.") with:

```markdown
The `**Review depth:**` line says how far down the human goes at the human
review, and which proofs the Architect asks for. It starts with one of the
two depths that step 8 of [workflow.md](/.agents/workflow.md) defines.
Each proof wanted follows after a `+`: `captures`, `recording`, `e2e`, as
in `strategic + captures`. The diff only adds a floor: a screen touched
brings captures even when the line leaves them out (the `visual-proof`
skill). Keep what the task needs. Or delete the line: the review section
of `.agents/project.md` then gives the default depth, and the only proofs
are the floor's.
```

### Edit 11 — the work template, both copies

(a) In "## Context", after the paragraph "**The Architect reads it and
approves the plan.** …", insert:

```markdown
**The close records the depth.** At the close the Mason writes the
`**Depth:**` line: the depth the spec chose, the floor the diff computed
with the `visual-proof` skill, and why the task went above the floor when
it did. The `retro` skill compares the two across tasks.
```

(b) In the template block, after the `<!-- Once approved: … -->` line,
insert:

```markdown

**Depth:** written at the close.
<!-- chosen <the spec's Review depth line, or §J's default>; floor
<captures, or none>, from <the screens the diff touches, or "no screen
touched">; at the floor, or above it: <what was added>, because <why>. -->
```

### Edit 12 — `retro/SKILL.md`, both copies

(a) Under "**Corroborating**", replace the work-document bullet with:

```markdown
- Its **work document** — the program design, the implementation checkboxes,
  the worklog, Notes & Snippets and the review findings, including
  whatever was noted without stopping along the way, and its `**Depth:**`
  line: the depth chosen and the floor the diff computed.
```

(b) In step 3, after the "**Information access**" bullet, add:

```markdown
- **Depth against floor**: read the `**Depth:**` line of this task's work
  document and of the recently archived ones. A task above the floor
  with no reason given is a candidate. So is a run of tasks above the floor:
  either the floor is too low, or the Architect asks for more than the work
  needs. _Use when_ the depth chosen and the floor differ.
```

(c) In the frontmatter `changes:` string, before the closing `."`, add:
`; compares the depth each task chose with the floor its diff computed, from the work documents' Depth lines`.
Keep it on one line.

### Edit 13 — `socle/intentions/unreleased/review-proofs.md`

```markdown
---
id: unreleased/review-proofs
classification: migration
---

# The glue names the commands that prove a screen

## Goal

The "J · Review" section of `.agents/project.md` declares the project's
e2e, recording and screenshot commands, each optional, and the folder the
proofs go in.

## Why

When a task touches a screen, the agent checks it itself, and the human
review shows the proof: at least a capture, before → after when the screen
existed. The workflow and the `visual-proof` skill read the commands in
the glue. When a command is left at none, the task has no proof of that
kind and the review says so, instead of guessing a command.

## Applies When

- `.agents/project.md` has a "J · Review" section without one of the
  lines `E2E command`, `Recording command`, `Screenshot command` or
  `Proofs folder`.

## Do Not Apply When

- The glue has no "J · Review" section. The intention that adds the
  section comes first, and this one applies after it.

## Observable Gaps

1. **The command lines.** Signal: §J lacks one of the three command
   lines. Ask the commands question of the setup skill, and write each
   answer on its line. For an answer of none, write the reference's line
   as it stands.
   Done when: §J has the three command lines.
2. **The proofs folder.** Signal: §J has no `Proofs folder` line. Write
   the reference's line, unless the human names another folder.
   Done when: the line exists.

## Out of Scope

- The `Default depth` line.
- Taking any proof.

## Reference Paths

- `.agents/project.md` — **adapt**: the section of the reference, with
  the project's answers.
- `.agents/skills/chisel-setup/SKILL.md` — **copy**: the question.

## Validation

- The `## J · Review` section of `.agents/project.md` has the lines
  `E2E command`, `Recording command`, `Screenshot command` and
  `Proofs folder`.

## Record Result

`chisel record unreleased/review-proofs --applied`, or
`--skipped "<reason>"` after the human's word.
```

### Edit 14 — `socle/intentions/unreleased/visual-proof.md`

```markdown
---
id: unreleased/visual-proof
classification: informational
---

# A screen touched is proved, and the proof is shown

## Goal

The human knows how a task that touches a screen is now proved. It gets
captures, before → after, from the capture command that ships with the
`visual-proof` skill. The agent checks the screen itself, and never reads
a capture in its own thread. The spec's depth line can ask for proofs.
The close records the depth chosen and the floor, and `retro` compares
them.

## Why

A human review that shows only code never shows the screen a user will
see. And an agent that reads its own captures pays for every image again
at each call: one session read 22 of them for about ten dollars. The
capture command compares at the pixel and answers in text; when an image
must be looked at, a fresh sub-agent does it, and the human sees the images
himself. Recording the depth against the floor shows an Architect who
always asks for more than the diff needs.

## Applies When

- The repo is updated from a version with no `visual-proof` skill.

## Do Not Apply When

- Never: there is nothing to apply. The skill, its capture command, the
  workflow and the templates are managed files, and the copy that
  `chisel update` makes carries the change. The session only reads it to
  the human.

## Observable Gaps

1. **What the human knows.** Signal: none in the repo. Say it to the
   human in a few sentences:
   - The capture command is
     `node .agents/skills/visual-proof/scripts/captures.ts`. It needs Node
     24.2 or later, and Playwright in the project's own dependencies.
     `CHISEL_PLAYWRIGHT_WS` can name a remote Playwright server.
   - A screen touched always brings captures. The spec's
     `**Review depth:**` line can ask for more after a `+`: `captures`,
     `recording`, `e2e`.
   - The proofs are files in the folder §J names, linked from the pull
     request's description.
   - The work document's `**Depth:**` line records the depth chosen
     against the floor, and `retro` reads it.

   Done when: the human has read it.

## Out of Scope

- The commands of §J, which the migration intention on the review's
  commands asks for.
- A page that shows the proofs; for now they are files.

## Reference Paths

- `.agents/skills/visual-proof/SKILL.md` — **copy**, by the update.
- `.agents/skills/visual-proof/scripts/captures.ts` — **copy**, by the
  update.
- `.agents/workflow.md` — **copy**, by the update.
- `.agents/skills/retro/SKILL.md` — **copy**, by the update.

## Validation

- Nothing to check in the repo: the closing update carries the change.

## Record Result

The closing `chisel update` records it, with the other informational
intentions.
```

The two templates of the task workspace are not under `.agents/`, so
`update` writes them only where the last manifest listed them. That is the
case for every equipped repo.

### Edit 15 — `src/socle-files.ts` and `test/fixtures/golden-tree.txt`

`src/socle-files.ts`:

- after `"agents/skills/tdd/tests.md",`, add
  `"agents/skills/visual-proof/SKILL.md",` and
  `"agents/skills/visual-proof/scripts/captures.ts",`;
- after `"intentions/unreleased/one-shot.md",`, add
  `"intentions/unreleased/review-proofs.md",`;
- after `"intentions/unreleased/review-section.md",`, add
  `"intentions/unreleased/visual-proof.md",`.

`test/fixtures/golden-tree.txt`, after `.agents/skills/tdd/tests.md`:

```
.agents/skills/visual-proof
.agents/skills/visual-proof/SKILL.md
.agents/skills/visual-proof/scripts
.agents/skills/visual-proof/scripts/captures.ts
```

### Edit 16 — `test/TESTS.md`

(a) In the `init` row, after "the glue carries §J · Review", add
", with its default depth, its three proof commands and its proofs folder".

(b) Add this row after the `usage` row:

```markdown
| `captures` | The capture command the `visual-proof` skill ships is the copy agreed with its author, made generic: no search under `~/projects`, no Harness variable or name, no vault path. Under Node 24.2 or later, a missing argument is a usage error under its own name, and `CHISEL_PLAYWRIGHT_WS` selects the remote browser. When `CHISEL_TEST_PLAYWRIGHT` names a `playwright-core` directory, a page served twice gives its capture, a `change` verdict with a `.diff.png`, then an `identique` verdict in the text report. Without Node or Playwright, those tests are skipped. | The copy took back a machine-specific path or name, or the command stopped capturing, comparing or reporting. |
```

### Decisions the spec left open (my calls, unless the Architect rules)

- **The floor is judged, not matched.** Decision 13 set path patterns
  aside. The skill says what "touches a screen" means, and the Mason
  judges from the diff.
- **A Screenshot command of none means no captures, even though Chisel
  ships one** (question 6).
- **The before captures come from the base**, taken by the Typist before
  its first code change; the after captures come at the close. Both go
  under `<proofs folder>/before` and `/after`.
- **The no-screen-no-capture dry run is this slice.** This repo has no
  front, so at the close I apply the skill to this slice's diff: the floor
  is none, the spec asks for no proof, so I take no capture and create no
  `04-visual-proof.proofs/`. The `**Depth:**` line records it. The
  music-downloader dry run of the Notes becomes an open item in the close
  report, for when a checkout exists (question 5).
- **The capture-tool criterion is met by the browser test**, which I run
  here with `CHISEL_TEST_PLAYWRIGHT` set. Its output goes in the worklog.

### Order

Vertical steps, each committed green (`deno task check`, `deno task test`):

1. Write `test/captures.test.ts` (red). Make the copy and its edits. Run
   the test with and without `CHISEL_TEST_PLAYWRIGHT` (green).
2. The SKILL.md (Edit 1). Copy the whole `visual-proof/` folder into
   `.agents/skills/`. Add the four golden-tree lines and the two skill
   lines of `socle-files.ts` (Edit 15). The integrity, init and check
   tests are green. Steps 1 and 2 make one commit, so the golden tree
   changes once.
3. The init test extension (red), then §J in both files (Edit 2), then
   chisel-setup (Edit 3) (green).
4. Workflow (Edits 4 to 9), templates (Edits 10, 11), retro (Edit 12), each
   in both copies; `cmp` each pair.
5. The intentions (Edits 13, 14) and their `socle-files.ts` lines; TESTS.md
   (Edit 16).
6. Gates: `deno task check`, `deno task test`, the browser test with
   `CHISEL_TEST_PLAYWRIGHT`, `deno task release-check gate origin/main`,
   `deno publish --dry-run --allow-dirty` once.

Commits: `feat(socle): ship the capture command and the visual-proof
skill` (steps 1–2), `feat(socle): the review section names the proof
commands` (step 3), `feat(socle): the depth line asks for proofs and the
close records the floor` (step 4), `docs(socle): intentions for the visual
proof` (step 5).

### Questions for the Architect

1. **Where the script goes.**
   - (a) In the skill, `socle/agents/skills/visual-proof/scripts/captures.ts`.
     The existing tree copy installs it, `update` brings it to every
     equipped repo, and the installer does not change.
   - (b) `socle/scripts/captures.ts`, installed to `scripts/captures.ts`
     beside the task-id script. That needs installer code, and `update`
     would not write it into repos already equipped.

   Recommended: **(a)**. The spec's note on "a first under `socle/scripts/`"
   then reads "a first Node file in the socle".
2. **The copy beyond Olympe's three changes.** Four small additions, each a
   consequence of the copy:
   - the licence header;
   - the comment describing the Playwright lookup and the remote browser,
     rewritten because it described the two removed things;
   - the two pointers to "skill verification-visuelle" renamed "skill
     visual-proof", because the skill they name does not exist in Chisel;
   - the usage written `node captures.ts`.

   The French text stays verbatim, the report included.
   - (a) As above.
   - (b) Also translate it to English, which would be a rewrite in all but
     name.

   Recommended: **(a)**. I also keep the `.ts` extension. Risk: a project
   whose linter or type check reaches into `.agents/` sees a Node
   TypeScript file there. TypeScript's own globs skip dot folders, so I
   flag the risk and add nothing.
3. **The format of the depth line.**
   - (a) One line, `**Review depth:** strategic + captures + e2e`, which
     follows the decision's own « captures + e2e ».
   - (b) A separate `**Proofs:**` line.

   Recommended: **(a)**.
4. **Where the proofs go.**
   - (a) A folder beside the spec, `<name>.proofs/`, committed. The pull
     request can then link the files, and the archive moves them with the
     spec.
   - (b) A gitignored folder. The pull request cannot link it, so the
     human review cannot show it.

   Recommended: **(a)**. Videos weigh more; a project can name another
   folder in §J.
5. **The dry run that replaces music-downloader.**
   - (a) The browser test on fixture pages (capture-tool), plus this
     slice's own close as the repo with no front touched
     (no-screen-no-capture). The music-downloader dry run stays an open
     item for when a checkout exists.
   - (b) Also a dry run on atlas or olympe, which have Playwright. That
     means touching another repo, which my brief does not allow.

   Recommended: **(a)**.
6. **A Screenshot command of none.**
   - (a) No captures, as the decision on no command says, even though
     Chisel ships the command. The setup question recommends the shipped
     command whenever Playwright is among the dependencies.
   - (b) Fall back to the shipped command when the line is none.

   Recommended: **(a)**. It keeps one rule for all three kinds.
7. **Typist tier.** Mid, as the brief says. About fifteen files, two of
   them new, and code with tests.

## Worklog

- 2026-11-22 — Read the spec, the parent decisions, slices 01–03, the
  socle files touched, the source script at a05b1092 and
  `verification-visuelle` (vault, read-only). Ran a scratch copy of the
  script under Node 24.13.0: two captures, a `.diff.png`, a report; the
  browser closed itself. `review-videos` is not in this repo's history.
  Plan written; waiting for the Architect.
- 2026-11-22 — Typist. Typed the approved plan, steps 1 to 6, in four
  commits: the capture command, its test and the skill (steps 1–2); §J,
  chisel-setup and the init test (step 3); workflow, templates and retro
  (step 4); the two intentions and TESTS.md (step 5). Every socle file with
  a copy here checked with `cmp`; §J compared with `diff`. Gates: `deno task
  check` and `deno task test` green at each commit (80 passed, 1 ignored:
  the browser test, when run without `CHISEL_TEST_PLAYWRIGHT`). The browser
  test ran for real with `CHISEL_TEST_PLAYWRIGHT=/home/pierrick/projects/atlas/node_modules/playwright-core`:
  4 passed, 0 failed, 0 ignored (the page captured twice took 4 s).
  `deno task release-check gate origin/main`: "The socle change adds an
  intention." `deno publish --dry-run --allow-dirty`: success. Departure
  from the plan's order: the copy was made before `test/captures.test.ts`
  was written, so the text test was never seen red. The workflow
  paragraphs were reflowed greedily to 80 columns, so each reflowed
  paragraph's earlier lines moved too.
- 2026-11-22 — Mason. `code-review` from 157991e; findings below. Retouch
  of the script's header comment (private names and topics) and one
  assertion in the text test. Gates green, the browser test included: 81
  passed, 0 ignored. Close: criteria ticked, Depth line, synthesis,
  journal entry 55, retro, status `done`.

## Implementation Checkboxes

- [x] Step 1–2 — the copy, its tests, the skill, the lists (Edits 1, 15)
- [x] Step 3 — §J and chisel-setup, init test (Edits 2, 3)
- [x] Step 4 — workflow, templates, retro (Edits 4–12)
- [x] Step 5 — intentions, TESTS.md (Edits 13, 14, 16)
- [x] Step 6 — gates, browser test, release gate, publish dry run
- [x] Code review from 157991e, findings answered
- [x] Close: criteria, depth line, synthesis, journal, retro, status

## Notes & Snippets

- The scratch trial lives under the session scratchpad (`cap/`). It holds no
  repo file.
- `playwright-core` on this machine:
  `/home/pierrick/projects/atlas/node_modules/playwright-core`. Chromium
  is in `~/.cache/ms-playwright`.

### Retro (2026-11-22, Mason) — proposals, none applied

From this session, its Typist's report and its two reviewers. Severity
order; each waits for its owner's yes.

1. **Automated checks** — a socle-wide test that refuses private markers
   in shipped files (vault paths, Harness command names, personal names,
   internal topic slugs), not only in the copied script. The plan's grep
   and the first text test listed only the three things Olympe named, and
   the private topics in the comments passed both. Target: `test/`, the
   integrity tests. Owner: the human.
2. **Coding standards** — the 80-column rule counts characters, not bytes.
   A reviewer's byte count flagged three lines with em dashes as 81. Say so
   in the writing rules, with `wc -m` under a UTF-8 locale, or ship a
   small check. Target: `CONTRIBUTING.md`. Owner: the human.
3. **Information access** — the spec named two sources that are not
   reachable here: music-downloader's `review-videos` and its checkout. The
   Architect could check at spec time that each named source exists, and
   write its repo and commit in the Notes, as was done for `captures.ts`.
   Target: workflow step 2. Owner: the human.
4. **Tool economy** — the Typist reflowed whole paragraphs greedily, which
   moved untouched lines and made the workflow diff mostly noise for the
   review. The writing rule could say: reflow from the first changed line
   to the paragraph's end, and keep the earlier lines as they are. Target:
   the work template's writing rules. Owner: the human.
5. **Depth against floor** — nothing to propose: this task sits at the
   floor, and slices 01–03 predate the `**Depth:**` line.

## Diff-Review Findings

`code-review` from 157991e, two fresh reviewers (Standards, Spec), on
2026-11-22. Neither opened a PNG.

**Standards**

- **The copied script carried private names and topics** (hard): « les
  pages d'Olympe », « go de Pierrick le 05/11 », `lot3-corrections` and two
  `sujet …` slugs, in the header comment. Fixed as a retouch of five comment
  lines, both copies, French kept: the incident and the internal-scroll
  case stay, without names, dates or topics. The text test now also refuses
  `Pierrick`, `lot3-` and `sujet captures-`. The licence lines 3–4 keep
  « the Harness » and Olympe: that is the attribution ruling 2a asked for.
- **Three workflow lines over 80 columns** (hard): false positive. The
  check counted bytes; with the em dash counted as one character, lines
  42, 79 and 96 are 77, 79 and 79.
- **`§J` / `· Review` split across a line in step 7**: kept. It reads
  correctly; fixing it reflows the paragraph again.
- **The proofs rule and the Depth line written in several places**
  (judgement): answered. Workflow step 8 and the work template each carry
  the one sentence their reader needs at that point; the skill carries the
  method. The same layering as the review section and the workflow in
  slices 01–03.
- **The text test pins the script's source** (judgement, TESTS.md rule 1):
  answered. It pins the absence of machine-specific names, which is the
  criterion capture-copy-generic itself, not the socle's prose.
- **Smells in `captures.ts`** (usage string three times, a one-entry loop
  left by the removed search, short names, magic numbers, French names):
  answered. Ruling 2a makes the file a copy with Olympe's three changes and
  nothing else; refactoring it would make the copy diverge for no
  behaviour.

**Spec**

- **`review-videos` not used**: recorded in Program Design and accepted on
  the `**Plan:**` line.
- **music-downloader dry run not done**: open item (ruling 5a), flagged in
  the close report.
- **no-screen-no-capture has no test**: met by this slice's close, recorded
  on the `**Depth:**` line above.
- **capture-tool rests on a run with `CHISEL_TEST_PLAYWRIGHT`**: run again
  after the retouch, 81 passed, 0 ignored.
- **The copy's comment still carried Harness topics**: fixed, see
  Standards.
- **The test's `['"]projects['"]` guard is weak**: answered. The code
  holds no home-directory search at all (`chargerPlaywright` tries the
  working directory, then beside the script); the guard is a tripwire, not
  the proof.
- **Scope beyond the letter** (the chisel-setup question, retro reading
  recent Depth lines, the greedy reflow): answered. The first two serve the
  spec's « an agent that always asks more than the floor shows »; the
  reflow is noise the Typist recorded in the worklog.
