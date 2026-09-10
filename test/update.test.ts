// `update`: what it refreshes, what it must never touch, and what it does
// with a file that has left the managed set.

import {
  assert,
  assertEquals,
  assertMatch,
  assertStringIncludes,
} from "@std/assert";
import { join } from "@std/path";
import { appendTo, REPO_ROOT, runChisel, withRepo } from "./helpers.ts";

const MANIFEST = join(".agents", ".chisel.json");

async function sha256Of(text: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(text),
  );
  return Array.from(new Uint8Array(digest)).map((byte) =>
    byte.toString(16).padStart(2, "0")
  )
    .join("");
}

async function recordInManifest(
  target: string,
  name: string,
  hash: string,
): Promise<void> {
  const path = join(target, MANIFEST);
  const manifest = JSON.parse(await Deno.readTextFile(path)) as {
    version: string;
    managed: Record<string, string>;
  };
  manifest.managed[name] = hash;
  await Deno.writeTextFile(path, `${JSON.stringify(manifest, null, 2)}\n`);
}

Deno.test("update: managed refresh, glue and personal file left alone", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");

    const glue = join(target, ".agents", "project.md");
    const journal = join(target, "project-management", "LOG.md");
    const personal = join(target, ".agents", "user.md");
    await appendTo(
      glue,
      "\n<!-- hand-edited by a human, must survive update -->\n",
    );
    await appendTo(
      journal,
      "\n## 2099-01-01\n\n- hand-edited entry, must survive update\n",
    );
    await Deno.writeTextFile(
      personal,
      "# Personal agent settings\n\n## Model tiers\n\n- **frontier:** my-own-model-id\n",
    );
    const glueBefore = await Deno.readTextFile(glue);
    const journalBefore = await Deno.readTextFile(journal);
    const personalBefore = await Deno.readTextFile(personal);

    // A render comes back from its profile, so the pristine copy is what the
    // comparison needs — not a re-copy of the edited file.
    const claudeDefinition = join(target, ".claude", "agents", "mason.md");
    const codexDefinition = join(target, ".codex", "agents", "inspector.toml");
    const skill = join(target, ".agents", "skills", "tdd", "SKILL.md");
    const formula = join(
      target,
      ".agents",
      "formulas",
      "chisel-default.formula.toml",
    );
    const claudeBefore = await Deno.readTextFile(claudeDefinition);
    const codexBefore = await Deno.readTextFile(codexDefinition);

    const localEdit = "\n<!-- local edit that update must overwrite -->\n";
    await appendTo(skill, localEdit);
    await appendTo(formula, "\n# local edit that update must overwrite\n");
    await appendTo(claudeDefinition, localEdit);
    await appendTo(
      codexDefinition,
      "\n# local edit that update must overwrite\n",
    );

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);

    assertEquals(
      await Deno.readTextFile(glue),
      glueBefore,
      ".agents/project.md untouched",
    );
    assertEquals(
      await Deno.readTextFile(journal),
      journalBefore,
      "the journal is untouched",
    );
    assertEquals(
      await Deno.readTextFile(personal),
      personalBefore,
      "a personal user.md is untouched",
    );
    assert(
      (await Deno.stat(join(target, ".agents", "user.md.tpl"))).isFile,
      "the user.md template is still installed",
    );

    const skillAfter = await Deno.readTextFile(skill);
    assert(
      !skillAfter.includes("local edit that update must overwrite"),
      "the skill edit reverted",
    );
    assertEquals(
      skillAfter,
      await Deno.readTextFile(
        join(REPO_ROOT, "socle", "agents", "skills", "tdd", "SKILL.md"),
      ),
      "the skill matches the socle source",
    );
    assertEquals(
      await Deno.readTextFile(formula),
      await Deno.readTextFile(
        join(
          REPO_ROOT,
          "socle",
          "agents",
          "formulas",
          "chisel-default.formula.toml",
        ),
      ),
      "the default formula matches the socle source",
    );
    assertEquals(
      await Deno.readTextFile(claudeDefinition),
      claudeBefore,
      "the hand-edited definition is re-rendered from the profile",
    );
    assertEquals(
      await Deno.readTextFile(codexDefinition),
      codexBefore,
      "the codex render comes back too",
    );

    assertStringIncludes(result.stdout, "chisel update:", "the summary header");
    assertMatch(
      result.stdout,
      /^ {2}(changed: |\(no managed files changed\))/m,
      "the summary reports changed-or-unchanged per the manifest",
    );
  });
});

Deno.test("update: a file that left the managed set unchanged is removed", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const retired = ".agents/formulas/retired.formula.toml";
    const asInstalled =
      "# a formula an earlier socle shipped and this one does not\n";
    await Deno.writeTextFile(join(target, retired), asInstalled);
    await recordInManifest(target, retired, await sha256Of(asInstalled));

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);
    assertStringIncludes(result.stdout, `removed: ${retired}`);
    assertEquals(
      await Deno.stat(join(target, retired)).then(() => true).catch(() =>
        false
      ),
      false,
      "the orphan is gone",
    );
    assert(
      !(await Deno.readTextFile(join(target, MANIFEST))).includes(
        "retired.formula.toml",
      ),
      "and it is out of the manifest",
    );
  });
});

Deno.test("update: a file that left the managed set and was modified is kept and named", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const retired = ".agents/formulas/retired.formula.toml";
    const modified = "# a retired formula the project has since edited\n";
    await Deno.writeTextFile(join(target, retired), modified);
    await recordInManifest(
      target,
      retired,
      await sha256Of("what chisel had installed here\n"),
    );

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);
    assertStringIncludes(result.stdout, `orphaned: ${retired}`);
    assertStringIncludes(result.stderr, retired);
    assertEquals(
      await Deno.readTextFile(join(target, retired)),
      modified,
      "the local content is left byte for byte",
    );
  });
});

Deno.test("update: a definition the user wrote survives and never enters the manifest", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const own = join(target, ".claude", "agents", "release-captain.md");
    const content =
      "---\nname: release-captain\n---\n\nMy own sub-agent, not chisel's.\n";
    await Deno.writeTextFile(own, content);

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);
    assertEquals(await Deno.readTextFile(own), content, "byte for byte");
    assert(
      !(await Deno.readTextFile(join(target, MANIFEST))).includes(
        "release-captain",
      ),
      "absent from the manifest",
    );
  });
});

Deno.test("update: a retired glue subsection is reported and the glue left byte-identical", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const glue = join(target, ".agents", "project.md");
    const withResidue = (await Deno.readTextFile(glue)).replace(
      "## C · Reading list",
      "### B3 · Autonomous runs\n\nA subsection an older socle read and nothing reads now.\n\n## C · Reading list",
    );
    await Deno.writeTextFile(glue, withResidue);

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);
    assertStringIncludes(result.stdout, "stale:");
    assertStringIncludes(result.stdout, "B3 · Autonomous runs");
    assertEquals(
      await Deno.readTextFile(glue),
      withResidue,
      "the glue is never rewritten",
    );
  });
});
