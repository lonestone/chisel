// Where the package is, and how its own files are read.
//
// The root is derived from the entry module's location, never from the
// working directory: `chisel` is run from inside the repo it equips, and the
// socle it installs is the one shipped beside the code doing the installing.

import { fromFileUrl, toFileUrl } from "@std/path";

let cachedRoot: URL | undefined;

// `../` from `src/` is the package root. For a local checkout the resolved
// directory is then canonicalised, which is what makes a package reached
// through a symlinked directory find its own socle rather than nothing at
// all. A remote root (the module cache, after `deno x jsr:…`) has no
// filesystem path to canonicalise and is used as it stands.
export function packageRoot(): URL {
  if (cachedRoot) return cachedRoot;
  const derived = new URL("../", import.meta.url);
  if (derived.protocol === "file:") {
    try {
      const real = Deno.realPathSync(fromFileUrl(derived));
      cachedRoot = toFileUrl(real.endsWith("/") ? real : `${real}/`);
      return cachedRoot;
    } catch {
      // Unreadable or gone: the underived URL is still the best answer, and
      // the caller's own read is where the failure belongs.
    }
  }
  cachedRoot = derived;
  return cachedRoot;
}

export function packageFileUrl(relative: string): URL {
  return new URL(relative, packageRoot());
}

// One reader for both shapes a package can take: a checkout on disk and a
// module served over HTTP, where the socle files sit beside the code.
export async function readPackageFile(relative: string): Promise<Uint8Array> {
  const url = packageFileUrl(relative);
  if (url.protocol === "file:") {
    return await Deno.readFile(fromFileUrl(url));
  }
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(
      `cannot read ${relative} from the chisel package (${response.status})`,
    );
  }
  return new Uint8Array(await response.arrayBuffer());
}

export async function readPackageText(relative: string): Promise<string> {
  return new TextDecoder().decode(await readPackageFile(relative));
}

/** The single source of truth for the version, shared with the publish step. */
export async function packageVersion(): Promise<string> {
  const config = JSON.parse(await readPackageText("deno.json")) as {
    version?: string;
  };
  return config.version ?? "";
}

export const SOCLE_ROOT = "socle/";

export const SOCLE = {
  agentsBlock: "socle/templates/AGENTS-block.md",
  specTemplate: "socle/templates/000-template.spec.md",
  workTemplate: "socle/templates/000-template.work.md",
  taskIdScript: "socle/scripts/task-id.sh",
  projectMdTemplate: "socle/agents/project.md.tpl",
  userMdTemplate: "socle/agents/user.md.tpl",
  discipline: "socle/agents/discipline.md",
  methodology: "socle/agents/methodology.md",
  reference: "socle/agents/reference.md",
} as const;
