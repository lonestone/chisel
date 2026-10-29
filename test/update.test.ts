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

async function absent(path: string): Promise<boolean> {
  return await Deno.lstat(path).then(() => false).catch(() => true);
}

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

    const skill = join(target, ".agents", "skills", "tdd", "SKILL.md");
    const workflow = join(target, ".agents", "workflow.md");

    const localEdit = "\n<!-- local edit that update must overwrite -->\n";
    await appendTo(skill, localEdit);
    await appendTo(workflow, localEdit);

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
      await Deno.readTextFile(workflow),
      await Deno.readTextFile(
        join(REPO_ROOT, "socle", "agents", "workflow.md"),
      ),
      "the workflow page matches the socle source",
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
    const retired = ".agents/retired-page.md";
    const asInstalled =
      "# a page an earlier socle shipped and this one does not\n";
    await Deno.writeTextFile(join(target, retired), asInstalled);
    await recordInManifest(target, retired, await sha256Of(asInstalled));
    // A retired skill, which lives one directory deeper: what it leaves behind
    // when its file goes is the second half of the question.
    const retiredSkill = ".agents/skills/retired/SKILL.md";
    const skillAsInstalled =
      "# a skill an earlier socle shipped and this one does not\n";
    await Deno.mkdir(join(target, ".agents", "skills", "retired"));
    await Deno.writeTextFile(join(target, retiredSkill), skillAsInstalled);
    await recordInManifest(
      target,
      retiredSkill,
      await sha256Of(skillAsInstalled),
    );

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);
    assertStringIncludes(result.stdout, `removed: ${retired}`);
    assertStringIncludes(result.stdout, `removed: ${retiredSkill}`);
    assertEquals(
      await Deno.stat(join(target, retired)).then(() => true).catch(() =>
        false
      ),
      false,
      "the orphan is gone",
    );
    assert(
      !(await Deno.readTextFile(join(target, MANIFEST))).includes(
        "retired-page.md",
      ),
      "and it is out of the manifest",
    );
    assert(
      !result.stderr.includes("not installed by chisel"),
      `a directory the old manifest tracked is not called foreign:\n${result.stderr}`,
    );
    assertEquals(
      await absent(join(target, ".agents", "skills", "retired")),
      true,
      "the directory the removal emptied went with it",
    );
    assert(
      (await Deno.stat(join(target, ".agents", "skills"))).isDirectory,
      "and the walk up stops at a directory chisel owns",
    );

    // The lasting cost of getting this wrong was a warning on every later run.
    const again = await runChisel(["update", target]);
    assertEquals(again.code, 0, again.output);
    assert(
      !again.stderr.includes("retired"),
      `nothing is said about it again:\n${again.stderr}`,
    );
  });
});

Deno.test("update: a file that left the managed set and was modified is kept and named", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const retired = ".agents/retired-page.md";
    const modified = "# a retired page the project has since edited\n";
    await Deno.writeTextFile(join(target, retired), modified);
    await recordInManifest(
      target,
      retired,
      await sha256Of("what chisel had installed here\n"),
    );

    const retiredSkill = ".agents/skills/retired/SKILL.md";
    const modifiedSkill = "# a retired skill the project has since edited\n";
    await Deno.mkdir(join(target, ".agents", "skills", "retired"));
    await Deno.writeTextFile(join(target, retiredSkill), modifiedSkill);
    await recordInManifest(
      target,
      retiredSkill,
      await sha256Of("what chisel had installed there\n"),
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
    assertStringIncludes(result.stdout, `orphaned: ${retiredSkill}`);
    assertEquals(
      await Deno.readTextFile(join(target, retiredSkill)),
      modifiedSkill,
      "the kept skill file too",
    );
    assert(
      (await Deno.stat(join(target, ".agents", "skills", "retired")))
        .isDirectory,
      "a directory that still holds something stays",
    );
    assert(
      !result.stderr.includes("not installed by chisel"),
      `and it is still not called foreign:\n${result.stderr}`,
    );
  });
});

Deno.test("update: a definition the user wrote survives and never enters the manifest", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    await Deno.mkdir(join(target, ".claude", "agents"), { recursive: true });
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

// The 0.1.1 socle, the one JSR served from 2026-09-10: what it installed that
// the current socle no longer ships.
const FORMULAS_0_1_1 = [
  "chisel-auto-light",
  "chisel-auto",
  "chisel-default",
  "chisel-light",
  "chisel-supervised",
].map((name) => `.agents/formulas/${name}.formula.toml`);
const ROLES_0_1_1 = ["architect", "checker", "foreman", "inspector", "mason"];
const PROFILES_0_1_1 = [
  ".agents/profiles/README.md",
  ...ROLES_0_1_1.map((role) => `.agents/profiles/${role}.md`),
];
const DEFINITIONS_0_1_1 = [
  ...ROLES_0_1_1.map((role) => `.claude/agents/${role}.md`),
  ...ROLES_0_1_1.map((role) => `.codex/agents/${role}.toml`),
];

Deno.test("update: a 0.1.1 install is cleaned", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");

    // Pose the 0.1.1 shape: every retired file on disk as that version
    // installed it, and recorded in its manifest at that hash.
    const retired = [
      ...FORMULAS_0_1_1,
      ...PROFILES_0_1_1,
      ...DEFINITIONS_0_1_1,
    ];
    for (const name of retired) {
      const content = name.startsWith(".agents/")
        ? `# ${name}, as the 0.1.1 socle shipped it\n`
        : `<!-- chisel:generated from a 0.1.1 profile -->\n# ${name}\n`;
      await Deno.mkdir(join(target, name, ".."), { recursive: true });
      await Deno.writeTextFile(join(target, name), content);
      await recordInManifest(target, name, await sha256Of(content));
    }
    const manifestPath = join(target, MANIFEST);
    const manifest = JSON.parse(await Deno.readTextFile(manifestPath));
    manifest.version = "0.1.1";
    await Deno.writeTextFile(manifestPath, `${JSON.stringify(manifest)}\n`);
    // A definition of the user's own, in a directory 0.1.1 shared with them.
    const own = join(target, ".claude", "agents", "release-captain.md");
    await Deno.writeTextFile(own, "My own sub-agent, not chisel's.\n");
    // The two adapter lines a 0.1.1 glue carried in §E.
    const glue = join(target, ".agents", "project.md");
    const glue011 = (await Deno.readTextFile(glue)).replace(
      "## F · Gate commands",
      "- [x] `.claude/agents` (role definitions rendered from `.agents/profiles/`)\n" +
        "- [x] `.codex/agents` (role definitions rendered from `.agents/profiles/`)\n\n" +
        "## F · Gate commands",
    );
    await Deno.writeTextFile(glue, glue011);

    const result = await runChisel(["update", target]);
    assertEquals(result.code, 0, result.output);

    for (const name of retired) {
      assertStringIncludes(result.stdout, `removed: ${name}\n`);
      assertEquals(await absent(join(target, name)), true, `${name} is gone`);
    }
    for (
      const directory of [".agents/formulas", ".agents/profiles", ".codex"]
    ) {
      assertEquals(
        await absent(join(target, directory)),
        true,
        `${directory} went with its last file`,
      );
    }
    assertEquals(
      await Deno.readTextFile(own),
      "My own sub-agent, not chisel's.\n",
      "the user's own definition stays, byte for byte",
    );
    assert(
      (await Deno.lstat(join(target, ".claude", "skills"))).isSymlink,
      "the skills link stays",
    );

    const after = JSON.parse(await Deno.readTextFile(manifestPath)) as {
      version: string;
      managed: Record<string, string>;
    };
    assertEquals(
      Object.keys(after.managed).filter((name) =>
        retired.includes(name) || name.includes("release-captain")
      ),
      [],
      "the manifest names none of them",
    );
    assert(after.version !== "0.1.1", "the manifest moved to this version");

    assertStringIncludes(result.stdout, "stale:");
    assertStringIncludes(result.stdout, "`.claude/agents`");
    assertStringIncludes(result.stdout, "`.codex/agents`");
    assertEquals(
      await Deno.readTextFile(glue),
      glue011,
      "the glue is reported on, never rewritten",
    );

    const checked = await runChisel(["check", target]);
    assertEquals(checked.code, 0, checked.output);
  });
});
