// The literals chisel writes into files it shares with a project, and then
// reads back to recognise its own work. They are a contract with every
// repo already equipped: changing one orphans what earlier versions wrote.

/** Opens the managed block of an `AGENTS.md`. Matched on the whole line. */
export const BLOCK_BEGIN = "<!-- chisel:begin -->";

/** Closes the managed block of an `AGENTS.md`. Matched on the whole line. */
export const BLOCK_END = "<!-- chisel:end -->";

/** The line `CLAUDE.md` needs, so a tool reading it loads `AGENTS.md`. */
export const CLAUDE_IMPORT_LINE = "@AGENTS.md";
