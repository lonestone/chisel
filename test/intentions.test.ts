// Intentions: what a repo records of them, the fast path that closes the
// ones needing no judgement, the workspace staged for the others, `record`,
// and what `check` says of what is pending.

import { assert, assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import { shippedIntentions } from "../src/intentions.ts";
import {
  appendTo,
  outsideWorkspace,
  packageWith,
  REPO_ROOT,
  runChisel,
  snapshot,
  withRepo,
  WORKSPACE,
} from "./helpers.ts";

const MANIFEST = join(".agents", ".chisel.json");

interface ManifestShape {
  version: string;
  managed: Record<string, string>;
  intentions?: Record<
    string,
    { result: string; date: string; reason?: string }
  >;
}

async function manifestOf(target: string): Promise<ManifestShape> {
  return JSON.parse(await Deno.readTextFile(join(target, MANIFEST)));
}

async function writeManifestOf(
  target: string,
  manifest: ManifestShape,
): Promise<void> {
  await Deno.writeTextFile(
    join(target, MANIFEST),
    `${JSON.stringify(manifest, null, 2)}\n`,
  );
}

function today(): string {
  const now = new Date();
  return [
    now.getFullYear(),
    `${now.getMonth() + 1}`.padStart(2, "0"),
    `${now.getDate()}`.padStart(2, "0"),
  ].join("-");
}

Deno.test("intentions: init records every shipped intention as applied", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const manifest = await manifestOf(target);
    const shipped = shippedIntentions().map((intention) => intention.id);
    assertEquals(
      Object.keys(manifest.intentions ?? {}).sort(),
      [...shipped].sort(),
      "the baseline names every shipped intention",
    );
    for (const id of shipped) {
      assertEquals(manifest.intentions?.[id], {
        date: today(),
        result: "applied",
      });
    }

    // On a manifest that already exists, init keeps its record and adds
    // nothing: what is pending stays pending for `update`.
    const [first] = shipped;
    delete manifest.intentions?.[first];
    await writeManifestOf(target, manifest);
    const again = await runChisel(["init", target]);
    assertEquals(again.code, 0, again.output);
    const after = await manifestOf(target);
    assert(
      !(first in (after.intentions ?? {})),
      `${first} is still pending after a second init`,
    );
  });
});

Deno.test("intentions: the fast path refreshes, names what it overwrote, and records", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const entry = await packageWith(workspace, [
      { release: "unreleased", file: "a-copy.md", classification: "automatic" },
      {
        release: "unreleased",
        file: "a-notice.md",
        classification: "informational",
      },
    ]);
    const workflow = join(target, ".agents", "workflow.md");
    await appendTo(workflow, "\n<!-- a local edit -->\n");

    const result = await runChisel(["update", target], entry);
    assertEquals(result.code, 0, result.output);
    assertStringIncludes(result.stdout, "overwritten: .agents/workflow.md\n");
    assertEquals(
      await Deno.readTextFile(workflow),
      await Deno.readTextFile(
        join(REPO_ROOT, "socle", "agents", "workflow.md"),
      ),
      "the managed page is restored",
    );
    assertStringIncludes(
      result.stdout,
      "recorded: unreleased/a-copy (automatic)",
    );
    assertStringIncludes(
      result.stdout,
      "recorded: unreleased/a-notice (informational)",
    );
    assertStringIncludes(result.stdout, "A test intention, a-notice");

    const manifest = await manifestOf(target);
    for (const id of ["unreleased/a-copy", "unreleased/a-notice"]) {
      assertEquals(manifest.intentions?.[id], {
        date: today(),
        result: "applied",
      });
    }
    const checked = await runChisel(["check", target], entry);
    assertEquals(checked.code, 0, checked.output);
  });
});

Deno.test("intentions: a manifest from before intentions counts its own releases as applied", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const manifest = await manifestOf(target);
    delete manifest.intentions;
    manifest.version = "0.2.0";
    await writeManifestOf(target, manifest);
    const entry = await packageWith(workspace, [
      { release: "0.1.9", file: "01-older.md", classification: "migration" },
      { release: "0.2.1", file: "01-newer.md", classification: "automatic" },
    ]);

    const result = await runChisel(["update", target], entry);
    assertEquals(result.code, 0, result.output);
    assertStringIncludes(result.stdout, "recorded: 0.2.1/newer (automatic)");
    for (const id of shippedIntentions().map((intention) => intention.id)) {
      assertStringIncludes(result.stdout, `recorded: ${id} `);
    }
    assert(
      !result.stdout.includes("0.1.9/older"),
      "a release up to the manifest's version is not pending",
    );
    const after = await manifestOf(target);
    assertEquals(
      after.intentions?.["0.1.9/older"]?.result,
      "applied",
      "the implicit baseline is written down",
    );
  });
});

Deno.test("intentions: a pending intention that needs judgement stages a workspace and writes nothing else", async () => {
  await withRepo(async (workspace) => {
    for (const classification of ["migration", "breaking-manual"]) {
      const target = await workspace.install("brownfield");
      const entry = await packageWith(workspace, [
        { release: "unreleased", file: "a-move.md", classification },
      ]);
      const before = await snapshot(target);

      const result = await runChisel(["update", target], entry);
      assertEquals(result.code, 3, `an agent has work to do\n${result.output}`);
      assertEquals(
        outsideWorkspace(await snapshot(target)),
        before,
        "nothing outside the workspace moved",
      );
      const line = `- [ ] \`unreleased/a-move\` (${classification})`;
      assertStringIncludes(result.stdout, line, "the checklist is printed");
      assertStringIncludes(
        result.stdout,
        `${WORKSPACE}/reference/.agents/skills/chisel-update/SKILL.md`,
        "the skill to follow is named",
      );
      assertStringIncludes(
        await Deno.readTextFile(join(target, WORKSPACE, "session.md")),
        line,
      );
      assert(
        (await Deno.stat(
          join(target, WORKSPACE, "intentions", "unreleased", "a-move.md"),
        )).isFile,
        "the pending intention is staged",
      );
      assert(
        (await Deno.stat(
          join(
            target,
            WORKSPACE,
            "reference",
            ".agents",
            "skills",
            "chisel-update",
            "SKILL.md",
          ),
        )).isFile,
        "the reference tree carries the update skill",
      );
    }
  });
});
