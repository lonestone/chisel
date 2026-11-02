// Intentions: what a repo records of them, the fast path that closes the
// ones needing no judgement, the workspace staged for the others, `record`,
// and what `check` says of what is pending.

import { assert, assertEquals } from "@std/assert";
import { join } from "@std/path";
import { shippedIntentions } from "../src/intentions.ts";
import { runChisel, withRepo } from "./helpers.ts";

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
