/// <reference lib="dom" />
/**
 * Capture script of the `lead-ux` skill.
 *
 * Captures a page — a local directions page or a URL — at several widths, in
 * light and dark, at device scale 2 by default, and writes a text report the
 * Architect reads instead of the images: overflow, console errors, what sits
 * below the fold, images, and with `--keyboard` the controls Tab never
 * reaches.
 *
 * Usage:
 *   deno run -A --no-config --no-lock .agents/skills/lead-ux/scripts/capture.ts \
 *     <url-or-file> <out-dir> [--widths 390,1280] [--each <css>] \
 *     [--only <name,name>] [--name <prefix>] [--for-eye] [--keyboard]
 *
 * The browser is installed once per machine:
 *   deno run -A npm:playwright@1.65.1 install chromium
 *
 * Exit codes: 0 = the report is written, its findings are in the text;
 * 1 = a usage error, no browser, or at least one capture failed (the report
 * is still written, and lists the failures under "## Failures").
 *
 * A repo whose own checker scans every `.ts` excludes `.agents/`. This
 * script is checked by a real run, not by the suite.
 */

import { chromium } from "npm:playwright@1.65.1";

const INSTALL_COMMAND = "deno run -A npm:playwright@1.65.1 install chromium";

const CANDIDATES =
  'a[href], button, input, select, textarea, summary, [tabindex]:not([tabindex="-1"]), [contenteditable], [role="button"], [onclick]';

type Scheme = "light" | "dark";

interface Options {
  target: string;
  outDir: string;
  widths: number[];
  each?: string;
  only?: string[];
  name?: string;
  forEye: boolean;
  keyboard: boolean;
}

interface Section {
  title: string;
  files: string[];
  overflow: string[];
  errors: string[];
  below: string[];
  images: string[];
  keyboard?: string[];
}

class UsageError extends Error {}

function parseArgs(args: string[]): Options {
  const positional: string[] = [];
  const flags = new Map<string, string | true>();
  const withValue = new Set(["--widths", "--each", "--only", "--name"]);
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (!arg.startsWith("--")) {
      positional.push(arg);
    } else if (withValue.has(arg)) {
      const value = args[++i];
      if (value === undefined) throw new UsageError(`${arg} needs a value`);
      flags.set(arg, value);
    } else if (arg === "--for-eye" || arg === "--keyboard") {
      flags.set(arg, true);
    } else {
      throw new UsageError(`unknown option ${arg}`);
    }
  }
  if (positional.length !== 2) {
    throw new UsageError("expected <url-or-file> <out-dir>");
  }
  const widths = String(flags.get("--widths") ?? "390,1280")
    .split(",")
    .map((w) => Number(w.trim()));
  if (widths.some((w) => !Number.isInteger(w) || w <= 0)) {
    throw new UsageError("--widths takes integers, like 390,1280");
  }
  const each = flags.get("--each");
  const only = flags.get("--only");
  if (only !== undefined && each === undefined) {
    throw new UsageError("--only needs --each");
  }
  return {
    target: positional[0],
    outDir: positional[1],
    widths,
    each: typeof each === "string" ? each : undefined,
    only: typeof only === "string"
      ? only.split(",").map((s) => slug(s)).filter(Boolean)
      : undefined,
    name: typeof flags.get("--name") === "string"
      ? String(flags.get("--name"))
      : undefined,
    forEye: flags.has("--for-eye"),
    keyboard: flags.has("--keyboard"),
  };
}

function toUrl(target: string): string {
  if (/^https?:\/\//.test(target)) return target;
  if (target.startsWith("file://")) return target;
  return new URL(target, `file://${Deno.cwd()}/`).href;
}

function slug(text: string): string {
  return text.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(
    /^-+|-+$/g,
    "",
  );
}

function defaultName(url: string): string {
  const path = new URL(url).pathname.split("/").filter(Boolean).pop() ?? "";
  const base = slug(decodeURIComponent(path).replace(/\.[a-z0-9]+$/i, ""));
  return base || "page";
}

/** Runs in the page: scrolls to the bottom one viewport at a time, then up. */
async function scrollThrough(): Promise<void> {
  const step = window.innerHeight;
  let y = 0;
  while (y < document.documentElement.scrollHeight) {
    window.scrollTo(0, y);
    await new Promise((r) => setTimeout(r, 120));
    y += step;
  }
  window.scrollTo(0, 0);
}

interface Measure {
  overflow: string[];
  below: string[];
  images: string[];
  scrollWidth: number;
  innerWidth: number;
}

/** Runs in each frame: the measures. */
function measureFrame(each: string | null): Measure {
  const describe = (el: Element): string => {
    const id = el.id ? `#${el.id}` : "";
    const cls = typeof el.className === "string" && el.className.trim()
      ? "." + el.className.trim().split(/\s+/).join(".")
      : "";
    return `${el.tagName.toLowerCase()}${id}${cls}`;
  };
  const vw = window.innerWidth;
  const vh = window.innerHeight;
  const over = new Set<Element>();
  for (const el of Array.from(document.querySelectorAll("body *"))) {
    const r = el.getBoundingClientRect();
    if (r.width > 0 && r.right > vw + 0.5) over.add(el);
  }
  const leaves = Array.from(over).filter((el) =>
    !Array.from(el.children).some((c) => over.has(c))
  );
  const overflow = leaves.slice(0, 10).map((el) =>
    `${describe(el)} (${Math.round(el.getBoundingClientRect().width)} px wide)`
  );
  for (const el of Array.from(document.querySelectorAll("body *"))) {
    const x = getComputedStyle(el).overflowX;
    if (
      (x === "hidden" || x === "clip") && el.scrollWidth > el.clientWidth + 1
    ) {
      overflow.push(
        `${describe(el)} clips its content ` +
          `(${el.scrollWidth} px in ${el.clientWidth} px)`,
      );
    }
  }
  if (each) {
    for (const box of Array.from(document.querySelectorAll(each))) {
      const edge = box.getBoundingClientRect().right;
      const past = new Set<Element>();
      for (const child of Array.from(box.querySelectorAll("*"))) {
        const r = child.getBoundingClientRect();
        if (r.width > 0 && r.right > edge + 1) past.add(child);
      }
      for (const child of past) {
        if (Array.from(child.children).some((c) => past.has(c))) continue;
        const n = Math.round(child.getBoundingClientRect().right - edge);
        overflow.push(`${describe(child)} passes ${describe(box)} by ${n} px`);
      }
    }
  }
  const below: string[] = [];
  const watched = document.querySelectorAll(
    'h1, h2, h3, h4, h5, h6, button, a[class*="btn"], a[class*="button"], a[role="button"], input, textarea, select, [data-direction]',
  );
  for (const el of Array.from(watched)) {
    const top = el.getBoundingClientRect().top + window.scrollY;
    if (top >= vh) below.push(`${describe(el)} at ${Math.round(top)} px`);
  }
  const images: string[] = [];
  for (const img of Array.from(document.images)) {
    const w = img.getBoundingClientRect().width;
    const src = (img.currentSrc || img.src || "").slice(0, 80);
    if (img.complete && img.naturalWidth === 0 && src) {
      images.push(`${describe(img)} failed to load (${src})`);
    } else if (w > 0 && w < 48) {
      images.push(`${describe(img)} rendered ${Math.round(w)} px wide`);
    }
  }
  return {
    overflow,
    below,
    images,
    scrollWidth: document.documentElement.scrollWidth,
    innerWidth: vw,
  };
}

/** Runs in each frame: the visible controls that never took focus. */
function unfocused(selector: string): string[] {
  const describe = (el: Element): string => {
    const id = el.id ? `#${el.id}` : "";
    const cls = typeof el.className === "string" && el.className.trim()
      ? "." + el.className.trim().split(/\s+/).join(".")
      : "";
    return `${el.tagName.toLowerCase()}${id}${cls}`;
  };
  const out: string[] = [];
  for (const el of Array.from(document.querySelectorAll(selector))) {
    if (el.hasAttribute("data-lead-ux-focused")) continue;
    if ((el as HTMLButtonElement).disabled) continue;
    const r = el.getBoundingClientRect();
    if (r.width === 0 || r.height === 0) continue;
    if (getComputedStyle(el).visibility === "hidden") continue;
    const frame = el.ownerDocument.defaultView?.frameElement;
    const host = el.closest("[data-direction]") ??
      frame?.closest("[data-direction]");
    const direction = host?.getAttribute("data-direction");
    out.push(direction ? `${describe(el)} (${direction})` : describe(el));
  }
  return out;
}

/** Marks each element that takes focus, and keeps the order of the focus. */
const FOCUS_TRACKER = `(() => {
  const root = (() => { try { return window.top.document ? window.top : window; } catch (_) { return window; } })();
  root.__leadUxLog = root.__leadUxLog || [];
  document.addEventListener("focusin", (e) => {
    const t = e.target;
    if (!(t instanceof Element)) return;
    t.setAttribute("data-lead-ux-focused", "");
    const log = root.__leadUxLog;
    if (log[log.length - 1] !== t) log.push(t);
  }, true);
})();`;

async function keyboardPass(
  // deno-lint-ignore no-explicit-any
  page: any,
): Promise<string[]> {
  let candidates = 0;
  for (const frame of page.frames()) {
    candidates += await frame.evaluate(
      (sel: string) =>
        Array.from(document.querySelectorAll(sel)).filter((el) => {
          const r = el.getBoundingClientRect();
          return r.width > 0 && r.height > 0;
        }).length,
      CANDIDATES,
    );
  }
  const limit = candidates * 2 + 1;
  for (let i = 0; i < limit; i++) {
    await page.keyboard.press("Tab");
    const back = await page.evaluate(() => {
      // deno-lint-ignore no-explicit-any
      const log = (window as any).__leadUxLog as Element[] | undefined;
      return !!log && log.length > 1 && log[0] === log[log.length - 1];
    });
    if (back) break;
  }
  const missed: string[] = [];
  for (const frame of page.frames()) {
    missed.push(...await frame.evaluate(unfocused, CANDIDATES));
  }
  return missed;
}

async function captureOne(
  // deno-lint-ignore no-explicit-any
  browser: any,
  url: string,
  width: number,
  scheme: Scheme,
  scale: number,
  opts: Options,
  name: string,
  seen: Set<string>,
): Promise<Section> {
  const height = width < 600 ? 844 : 800;
  const context = await browser.newContext({
    viewport: { width, height },
    colorScheme: scheme,
    deviceScaleFactor: scale,
  });
  const page = await context.newPage();
  const section: Section = {
    title: `${name} ${width} ${scheme}`,
    files: [],
    overflow: [],
    errors: [],
    below: [],
    images: [],
  };
  const keyboard = opts.keyboard && scheme === "light";
  try {
    page.on("console", (m: { type(): string; text(): string }) => {
      if (m.type() === "error") section.errors.push(m.text());
    });
    page.on("pageerror", (e: Error) => section.errors.push(e.message));
    if (keyboard) await page.addInitScript(FOCUS_TRACKER);
    await page.goto(url, { waitUntil: "networkidle" });
    await page.evaluate(scrollThrough);
    await page.evaluate(() => document.fonts.ready);
    await page.waitForLoadState("networkidle");

    const frames = page.frames();
    for (let i = 0; i < frames.length; i++) {
      const m: Measure = await frames[i].evaluate(
        measureFrame,
        opts.each ?? null,
      );
      const tag = i === 0 ? "" : ` [frame ${i}]`;
      if (m.scrollWidth > m.innerWidth) {
        section.overflow.push(
          `scrollWidth ${m.scrollWidth} against ${m.innerWidth}: ` +
            `${m.scrollWidth - m.innerWidth} px too wide${tag}`,
        );
      }
      section.overflow.push(...m.overflow.map((o) => o + tag));
      if (i === 0) section.below.push(...m.below);
      section.images.push(...m.images.map((o) => o + tag));
    }

    const base = `${opts.outDir}/${name}`;
    if (!opts.only) {
      const file = `${base}-${width}-${scheme}.png`;
      await page.screenshot({ path: file, fullPage: true });
      section.files.push(file);
    }
    if (opts.each) {
      const loc = page.locator(opts.each);
      const count = await loc.count();
      for (let i = 0; i < count; i++) {
        const el = loc.nth(i);
        const attr = await el.getAttribute("data-direction");
        const dir = (attr && slug(attr)) || String(i + 1);
        seen.add(dir);
        if (opts.only && !opts.only.includes(dir)) continue;
        const file = `${base}-${dir}-${width}-${scheme}.png`;
        await el.screenshot({ path: file });
        section.files.push(file);
      }
    }
    if (keyboard) section.keyboard = await keyboardPass(page);
  } finally {
    await context.close();
  }
  return section;
}

function list(items: string[]): string {
  return items.length ? items.map((i) => `- ${i}`).join("\n") : "none";
}

function renderReport(
  head: string[],
  sections: Section[],
  failures: string[],
): string {
  const out = ["# Capture report", "", ...head, ""];
  for (const s of sections) {
    out.push(`## ${s.title}`, "");
    out.push(`Files: ${s.files.length ? s.files.join(", ") : "none"}`, "");
    out.push("### Overflow", "", list(s.overflow), "");
    out.push("### Console errors", "", list(s.errors), "");
    out.push("### Below the fold", "", list(s.below), "");
    out.push("### Images", "", list(s.images), "");
    if (s.keyboard) out.push("### Keyboard", "", list(s.keyboard), "");
  }
  if (failures.length) out.push("## Failures", "", list(failures), "");
  return out.join("\n");
}

async function main(): Promise<number> {
  let opts: Options;
  try {
    opts = parseArgs(Deno.args);
  } catch (e) {
    console.error((e as Error).message);
    return 1;
  }
  const url = toUrl(opts.target);
  const name = slug(opts.name ?? "") || defaultName(url);
  const scale = opts.forEye ? 1 : 2;
  const schemes: Scheme[] = opts.forEye ? ["light"] : ["light", "dark"];
  await Deno.mkdir(opts.outDir, { recursive: true });

  let browser;
  try {
    browser = await chromium.launch();
  } catch (e) {
    const message = (e as Error).message;
    if (/Executable doesn't exist|playwright install/i.test(message)) {
      console.error(
        `The browser is missing. Install it with:\n${INSTALL_COMMAND}`,
      );
    } else {
      console.error(message);
    }
    return 1;
  }
  const sections: Section[] = [];
  const failures: string[] = [];
  const seen = new Set<string>();
  try {
    for (const width of opts.widths) {
      for (const scheme of schemes) {
        try {
          sections.push(
            await captureOne(
              browser,
              url,
              width,
              scheme,
              scale,
              opts,
              name,
              seen,
            ),
          );
        } catch (e) {
          const message = (e as Error).message.split("\n")[0];
          failures.push(`${name} ${width} ${scheme}: ${message}`);
          console.error(`capture failed (${width} ${scheme}): ${message}`);
        }
      }
    }
  } finally {
    await browser.close();
  }
  if (opts.only && sections.length) {
    const unmatched = opts.only.filter((o) => !seen.has(o));
    if (unmatched.length) {
      console.error(
        `warning: --only matches no data-direction: ${unmatched.join(", ")}`,
      );
    }
  }
  const head = [
    `URL: ${url}`,
    `Scale: ${scale}`,
    `Schemes: ${schemes.join(", ")}`,
  ];
  await Deno.writeTextFile(
    `${opts.outDir}/report.md`,
    renderReport(head, sections, failures),
  );
  return failures.length ? 1 : 0;
}

if (import.meta.main) Deno.exit(await main());
