// Every line the CLI prints, in one place: a report line is a contract with
// whoever greps it — a script, a skill, or the next reader of a CI log.

/**
 * A refusal or a broken precondition. Carries no exit code: `main` maps it to
 * 1, the way every fatal error of the CLI has always exited.
 */
export class ChiselError extends Error {}

/** A usage mistake: the offending argument is named, and the CLI exits 2. */
export class UsageError extends Error {}

export function warn(message: string): void {
  console.error(`chisel: warning: ${message}`);
}

export function reportLine(text: string): void {
  console.log(`  ${text}`);
}
