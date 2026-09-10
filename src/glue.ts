// The structured reader of a project's glue (`.agents/project.md`).
//
// The glue is a human-owned document that chisel has to find two things in:
// the adapter inventory it may tick on the run that created the file, and the
// journal path it may retarget on that same run. Matching the template's
// sentences character by character made every edit to the template a silent
// break here; a section is found by its letter and an item by its label
// instead, so a project may rewrite the prose around them freely.

/** One list item of a section: `- [ ] `.claude/skills` → …` or `- **Key:** v`. */
export interface GlueItem {
  /** Index into the document's `lines`, so an edit can be surgical. */
  readonly line: number;
  readonly raw: string;
  readonly checkbox: "checked" | "unchecked" | null;
  /** The leading backticked or bold label, without its markup or trailing colon. */
  readonly label: string;
  /** Whatever follows the label, trimmed. */
  readonly value: string;
}

export interface GlueSubsection {
  /** A letter and a digit, as in `B1`. */
  readonly id: string;
  readonly title: string;
  readonly line: number;
  readonly items: GlueItem[];
}

export interface GlueSection {
  /** A single letter, as in `A` or `E`. */
  readonly id: string;
  readonly title: string;
  readonly line: number;
  readonly items: GlueItem[];
  readonly subsections: GlueSubsection[];
}

export interface GlueDocument {
  /** The file split on newlines, verbatim: joining them restores it byte for byte. */
  readonly lines: string[];
  readonly sections: GlueSection[];
}

const SECTION_HEADING = /^##\s+([A-Z])\s+·\s+(.*)$/;
const SUBSECTION_HEADING = /^###\s+([A-Z]\d+)\s+·\s+(.*)$/;
const LIST_ITEM = /^-\s+(?:\[([ xX])\]\s+)?(.*)$/;

function parseItem(raw: string, line: number): GlueItem | null {
  const match = LIST_ITEM.exec(raw);
  if (!match) return null;
  const box = match[1];
  const rest = match[2];
  let label = "";
  let value = rest;
  if (rest.startsWith("`")) {
    const end = rest.indexOf("`", 1);
    if (end > 1) {
      label = rest.slice(1, end);
      value = rest.slice(end + 1).trim();
    }
  } else if (rest.startsWith("**")) {
    const end = rest.indexOf("**", 2);
    if (end > 2) {
      label = rest.slice(2, end).replace(/:$/, "");
      value = rest.slice(end + 2).trim();
    }
  }
  return {
    line,
    raw,
    checkbox: box === undefined ? null : box === " " ? "unchecked" : "checked",
    label,
    value,
  };
}

export function parseGlue(text: string): GlueDocument {
  const lines = text.split("\n");
  const sections: GlueSection[] = [];
  let section: GlueSection | undefined;
  let subsection: GlueSubsection | undefined;

  lines.forEach((raw, index) => {
    const heading = SECTION_HEADING.exec(raw);
    if (heading) {
      section = {
        id: heading[1],
        title: heading[2].trim(),
        line: index,
        items: [],
        subsections: [],
      };
      subsection = undefined;
      sections.push(section);
      return;
    }
    if (raw.startsWith("## ")) {
      // A section chisel cannot address by letter still closes the previous
      // one: an item below it belongs to nobody.
      section = undefined;
      subsection = undefined;
      return;
    }
    const subheading = SUBSECTION_HEADING.exec(raw);
    if (subheading && section) {
      subsection = {
        id: subheading[1],
        title: subheading[2].trim(),
        line: index,
        items: [],
      };
      section.subsections.push(subsection);
      return;
    }
    if (!section) return;
    const item = parseItem(raw, index);
    if (item) (subsection ?? section).items.push(item);
  });

  return { lines, sections };
}

export function glueSection(
  document: GlueDocument,
  id: string,
): GlueSection | undefined {
  return document.sections.find((section) => section.id === id);
}

export function glueSubsection(
  document: GlueDocument,
  sectionId: string,
  subsectionId: string,
): GlueSubsection | undefined {
  return glueSection(document, sectionId)?.subsections.find(
    (subsection) => subsection.id === subsectionId,
  );
}

export function glueItem(
  owner: GlueSection | GlueSubsection | undefined,
  label: string,
): GlueItem | undefined {
  return owner?.items.find((item) => item.label === label);
}

/** The document as text again. Unmodified lines round-trip byte for byte. */
export function serializeGlue(document: GlueDocument): string {
  return document.lines.join("\n");
}
