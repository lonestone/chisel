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
  name:
    "captures: a page captured twice gives the captures, a diff map and a report",
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
          [
            SCRIPT,
            base,
            "/",
            "--out",
            join(work, out),
            "--largeurs",
            "390",
            ...more,
          ],
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
