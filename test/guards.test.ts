// The two refusals: a repo still carrying the retired layout, and a file
// chisel did not install.

import { assert, assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import {
  appendTo,
  copyTree,
  runChisel,
  snapshot,
  withRepo,
  type Workspace,
} from "./helpers.ts";

async function absent(path: string): Promise<boolean> {
  return await Deno.lstat(path).then(() => false).catch(() => true);
}

Deno.test("guards: update refuses a repo still carrying the v1 layout", async () => {
  await withRepo(async (workspace) => {
    const legacy = await workspace.copy("brownfield-v1");
    const workflowsBefore = await Deno.readTextFile(
      join(legacy, ".agents", "workflows.md"),
    );

    const refused = await runChisel(["update", legacy]);
    assertEquals(refused.code, 1, "the refusal exits 1");
    assertStringIncludes(
      refused.stderr,
      "chisel-upgrade",
      "it names the migration skill",
    );
    assertStringIncludes(
      refused.stderr,
      ".agents/rules/",
      "it names what it found",
    );
    assert(
      await absent(join(legacy, ".agents", "discipline.md")),
      "no discipline.md installed",
    );
    assert(
      await absent(join(legacy, ".agents", "workflow.md")),
      "no workflow.md installed",
    );
    assert(
      await absent(join(legacy, ".agents", ".chisel.json")),
      "no manifest written",
    );
    assertEquals(
      await Deno.readTextFile(join(legacy, ".agents", "workflows.md")),
      workflowsBefore,
      "the v1 files are byte-intact",
    );

    // The guard refuses a situation, not a command: the same command on a v2
    // layout still works.
    const current = await workspace.install("brownfield");
    assertEquals(
      (await runChisel(["update", current])).code,
      0,
      "a v2 layout still updates",
    );
  });
});

Deno.test("guards: a skill chisel did not install is never adopted or overwritten", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    const foreignDir = join(target, ".agents", "skills", "beads");
    const foreign = join(foreignDir, "SKILL.md");
    await Deno.mkdir(foreignDir, { recursive: true });
    await Deno.writeTextFile(
      foreign,
      "# A skill installed by another tool, not by chisel.\n",
    );
    const before = await Deno.readTextFile(foreign);

    const updated = await runChisel(["update", target]);
    assertEquals(updated.code, 0, updated.output);
    assertEquals(
      await Deno.readTextFile(foreign),
      before,
      "it survives update byte-intact",
    );
    assertStringIncludes(
      updated.stderr,
      "was not installed by chisel",
      "update says out loud that it does not manage it",
    );
    assert(
      !(await Deno.readTextFile(join(target, ".agents", ".chisel.json")))
        .includes("skills/beads"),
      "never adopted into the manifest",
    );

    // The point of not adopting it: its owner edits their own file and chisel
    // stays quiet.
    await appendTo(foreign, "\n<!-- edited by its owner, not by chisel -->\n");
    assertEquals(
      (await runChisel(["check", target])).code,
      0,
      "check stays clean after its owner edits it",
    );

    // A socle skill in the same tree is still managed: the guard narrows the
    // claim, not the coverage.
    await appendTo(
      join(target, ".agents", "skills", "tdd", "SKILL.md"),
      "\n<!-- diverged -->\n",
    );
    assertEquals(
      (await runChisel(["check", target])).code,
      1,
      "a socle skill next to it is still checked",
    );
  });
});

Deno.test("guards: update refuses a repo with no manifest and writes nothing", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.install("brownfield");
    await Deno.remove(join(target, ".agents", ".chisel.json"));
    const before = await snapshot(target);

    const refused = await runChisel(["update", target]);
    assertEquals(refused.code, 1, "the refusal exits 1");
    assertStringIncludes(
      refused.stderr,
      "chisel-upgrade",
      "it names the migration skill",
    );
    assertEquals(await snapshot(target), before, "the target is unchanged");
  });
});

Deno.test("guards: update refuses to write through a symbolic link", async () => {
  await withRepo(async (workspace) => {
    // (a) A managed file that is itself a link to a file outside the target.
    const fileLinked = await workspace.install("brownfield");
    const elsewhere = await workspace.dir("elsewhere");
    const page = join(fileLinked, ".agents", "workflow.md");
    await Deno.copyFile(page, join(elsewhere, "workflow.md"));
    await appendTo(join(elsewhere, "workflow.md"), "\n<!-- not chisel's -->\n");
    await Deno.remove(page);
    await Deno.symlink(join(elsewhere, "workflow.md"), page);

    // (b) A directory above managed files, linked to a directory outside it.
    const dirLinked = await workspace.install("brownfield");
    const skillsElsewhere = await workspace.dir("skills-elsewhere");
    const skill = join(dirLinked, ".agents", "skills", "tdd");
    await copyTree(skill, join(skillsElsewhere, "tdd"));
    await appendTo(
      join(skillsElsewhere, "tdd", "SKILL.md"),
      "\n<!-- the project's own edit -->\n",
    );
    await Deno.remove(skill, { recursive: true });
    await Deno.symlink(join(skillsElsewhere, "tdd"), skill);

    for (
      const [target, destination, linked] of [
        [fileLinked, elsewhere, ".agents/workflow.md"],
        [dirLinked, skillsElsewhere, ".agents/skills/tdd"],
      ]
    ) {
      const targetBefore = await snapshot(target);
      const destinationBefore = await snapshot(destination);
      const refused = await runChisel(["update", target]);
      assertEquals(refused.code, 1, `the refusal exits 1\n${refused.output}`);
      assertStringIncludes(refused.stderr, linked, "it names the linked path");
      assertStringIncludes(refused.stderr, "chisel-upgrade");
      assertEquals(await snapshot(target), targetBefore, "target unchanged");
      assertEquals(
        await snapshot(destination),
        destinationBefore,
        "the link's destination is unchanged",
      );
    }

    // Only the paths chisel writes count: a skill of the project's own,
    // linked elsewhere, does not stop an update.
    const foreignLinked = await workspace.install("brownfield");
    const ownSkills = await workspace.dir("own-skills");
    await Deno.mkdir(join(ownSkills, "review-videos"));
    await Deno.writeTextFile(
      join(ownSkills, "review-videos", "SKILL.md"),
      "# A skill of the project's own\n",
    );
    await Deno.symlink(
      join(ownSkills, "review-videos"),
      join(foreignLinked, ".agents", "skills", "review-videos"),
    );
    const updated = await runChisel(["update", foreignLinked]);
    assertEquals(updated.code, 0, updated.output);
  });
});

Deno.test("guards: init refuses a linked skill and writes nothing", async () => {
  await withRepo(async (workspace) => {
    const target = await workspace.copy("brownfield");
    const ownSkills = await workspace.dir("own-skills");
    await Deno.mkdir(join(ownSkills, "tdd"));
    await Deno.writeTextFile(
      join(ownSkills, "tdd", "SKILL.md"),
      "# The project's own tdd skill\n",
    );
    await Deno.mkdir(join(target, ".agents", "skills"), { recursive: true });
    await Deno.symlink(
      join(ownSkills, "tdd"),
      join(target, ".agents", "skills", "tdd"),
    );
    const targetBefore = await snapshot(target);
    const destinationBefore = await snapshot(ownSkills);

    const refused = await runChisel(["init", target]);
    assertEquals(refused.code, 1, `the refusal exits 1\n${refused.output}`);
    assertStringIncludes(refused.stderr, ".agents/skills/tdd");
    assertEquals(await snapshot(target), targetBefore, "nothing written");
    assertEquals(
      await snapshot(ownSkills),
      destinationBefore,
      "the linked skill is unchanged",
    );
  });
});

/**
 * A repo whose method predates the CLI and lives where it chose: doctrine and
 * skills in `doc/agents/`, the task workspace in `doc/project-management/`,
 * the entries of `.agents/skills/` linked into `doc/agents/skills/`, and no
 * manifest. Built from plain files and links, never committed as a fixture.
 */
async function relocatedLayout(workspace: Workspace): Promise<string> {
  const target = await workspace.dir("relocated");
  const files: Record<string, string> = {
    "AGENTS.md":
      "# Relocated — agent instructions\n\nThe method lives in `doc/agents/`.\n",
    "doc/agents/rules/task-planning.md": "# Planning a task\n",
    "doc/agents/workflows.md": "# Workflows\n",
    "doc/agents/skills/tdd/SKILL.md": "# The project's own tdd skill\n",
    "doc/agents/skills/review-videos/SKILL.md": "# Review videos\n",
    "doc/project-management/CHANGELOG.md": "# Changelog\n\n## 2026-01-01\n",
    "doc/project-management/tasks/20260101-0900-a-task.md":
      "# A task\n\n**Status:** In Progress\n",
    "scripts/task-id.sh": "#!/usr/bin/env bash\necho the project's own\n",
  };
  for (const [relative, content] of Object.entries(files)) {
    await Deno.mkdir(join(target, relative, ".."), { recursive: true });
    await Deno.writeTextFile(join(target, relative), content);
  }
  await Deno.mkdir(join(target, ".agents", "skills"), { recursive: true });
  for (const skill of ["tdd", "review-videos"]) {
    await Deno.symlink(
      `../../doc/agents/skills/${skill}`,
      join(target, ".agents", "skills", skill),
    );
  }
  return target;
}

Deno.test("guards: a relocated layout with no manifest is refused by update and init", async () => {
  await withRepo(async (workspace) => {
    const target = await relocatedLayout(workspace);
    const before = await snapshot(target);

    const updated = await runChisel(["update", target]);
    assertEquals(updated.code, 1, `update refuses\n${updated.output}`);
    assertStringIncludes(updated.stderr, "chisel-upgrade");
    assertEquals(await snapshot(target), before, "update wrote nothing");

    const initialised = await runChisel(["init", target]);
    assertEquals(initialised.code, 1, `init refuses\n${initialised.output}`);
    assertStringIncludes(initialised.stderr, ".agents/skills/tdd");
    assertEquals(await snapshot(target), before, "init wrote nothing");
  });
});
