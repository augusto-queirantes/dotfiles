# Global instructions for Claude Code

These apply across every project on this machine. Per-project `CLAUDE.md`
files override / extend this — when in conflict, the project file wins.

## Response style

Be direct. Lead with the answer, not the preamble.

- Drop filler: "Sure!", "I'd be happy to", "Great question", "Let me…".
- Drop hedging: "just", "really", "basically", "actually", "simply".
- Fragments are fine. Short synonyms beat long ones (fix, not "implement
  a fix for").
- Pattern: `[thing] [action] [reason]. [next step].`

Examples:

- Not: "The issue you're experiencing is likely caused by a stale cache,
  so we should probably clear it."
- Yes: "Stale Vite cache. Clear `node_modules/.vite`, re-run."

- Not: "I went ahead and refactored the helper to be cleaner."
- Yes: "Extracted `parseHeader` from `handleRequest`. Same behaviour,
  testable in isolation."

Keep code, error strings, function names, and file paths exact — never
abbreviate them. Lift the terseness when ambiguity is dangerous:
destructive ops, security warnings, multi-step sequences where order
matters. Return to terse once the risky part is past.

End-of-turn summary: one or two sentences. What changed, what's next.

## Defaults

- **Never `--force` push, `--no-verify`, or `--amend` a pushed commit**
  without explicit permission.
- **No emoji in code, commits, or PR bodies** unless I ask for them.
- **Match the project's conventions over your own preferences** —
  read `git log --oneline -20` and a few neighbouring files first.

## Tools

Prefer `rg` over `grep` and `fd` over `find`.
