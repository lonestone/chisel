// `chisel check` — say what the repo has, what drifted, and what adapter is
// missing. Zero writes: this command is the one a hook or a CI job can run.

import { join } from "@std/path";
import { agentsBlockHash, sha256File } from "./hash.ts";
import { BLOCK_KEY, manifestPath, readManifest } from "./manifest.ts";
import { packageVersion } from "./paths.ts";
import { staleGlueReport, staleGlueSubsection } from "./project-md.ts";
import { ChiselError, reportLine } from "./report.ts";
import {
  agentsMdHasBlockMarkers,
  claudeMdImportsAgents,
  isDirectory,
  isFile,
  readTextIfPresent,
  SKILLS_LINK_VALUE,
  skillsLinkValue,
} from "./target.ts";

export async function check(targetDir: string): Promise<number> {
  if (!(await isDirectory(targetDir))) {
    throw new ChiselError(`target dir does not exist: ${targetDir}`);
  }
  const manifest = await readManifest(targetDir);
  if (manifest === null) {
    throw new ChiselError(
      `no manifest at ${manifestPath(targetDir)} — run 'chisel init' first`,
    );
  }

  let exitCode = 0;
  const packaged = await packageVersion();

  console.log(`chisel check: ${targetDir}`);
  reportLine(`package version:  ${packaged}`);
  reportLine(`manifest version: ${manifest.version}`);
  if (packaged !== manifest.version) {
    reportLine(
      "MISMATCH: manifest was written by a different chisel version (run chisel update)",
    );
    exitCode = 1;
  }

  for (const name of Object.keys(manifest.managed).sort()) {
    let actual: string;
    if (name === BLOCK_KEY) {
      const agentsMd = await readTextIfPresent(join(targetDir, "AGENTS.md"));
      if (agentsMd === null) {
        reportLine("MISSING: AGENTS.md (expected managed block)");
        exitCode = 1;
        continue;
      }
      actual = await agentsBlockHash(agentsMd);
    } else {
      const path = join(targetDir, name);
      if (!(await isFile(path))) {
        reportLine(`MISSING: ${name}`);
        exitCode = 1;
        continue;
      }
      actual = await sha256File(path);
    }
    if (actual !== manifest.managed[name]) {
      reportLine(`DIVERGED: ${name} (local edit since last init/update)`);
      exitCode = 1;
    }
  }

  // A link is the adapter only while it points where the socle expects: a
  // link retargeted at another directory resolves perfectly and delivers the
  // wrong skills, which is exactly the failure a checker is for.
  const linkValue = await skillsLinkValue(targetDir);
  if (
    linkValue === SKILLS_LINK_VALUE &&
    await isDirectory(join(targetDir, ".claude", "skills"))
  ) {
    reportLine("OK adapter: .claude/skills");
  } else {
    reportLine("MISSING adapter: .claude/skills symlink");
    exitCode = 1;
  }

  if (await claudeMdImportsAgents(targetDir)) {
    reportLine("OK adapter: CLAUDE.md @AGENTS.md import");
  } else {
    reportLine("MISSING adapter: CLAUDE.md @AGENTS.md import");
    exitCode = 1;
  }

  if (await agentsMdHasBlockMarkers(targetDir)) {
    reportLine("OK adapter: AGENTS.md managed block markers");
  } else {
    reportLine("MISSING adapter: AGENTS.md managed block markers");
    exitCode = 1;
  }

  // Reported, never counted as divergence: the glue is the project's file,
  // and a residue in it is not a managed file that moved.
  const stale = await staleGlueSubsection(targetDir);
  if (stale !== null) reportLine(staleGlueReport(stale));

  if (exitCode === 0) reportLine("clean — no divergence");
  return exitCode;
}
