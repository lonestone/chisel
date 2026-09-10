// The three literals chisel writes into files it shares with a project, and
// then reads back to recognise its own work. They are a contract with every
// repo already equipped: changing one orphans what earlier versions wrote.

/** Opens the managed block of an `AGENTS.md`. Matched on the whole line. */
export const BLOCK_BEGIN = "<!-- chisel:begin -->";

/** Closes the managed block of an `AGENTS.md`. Matched on the whole line. */
export const BLOCK_END = "<!-- chisel:end -->";

// Stamped into every per-tool agent definition chisel renders. It is what
// tells a render apart from a definition of the user's own that happens to
// carry the same role name: chisel only ever overwrites its own.
export const GEN_MARKER = "chisel:generated";

/** The line `CLAUDE.md` needs, so a tool reading it loads `AGENTS.md`. */
export const CLAUDE_IMPORT_LINE = "@AGENTS.md";
