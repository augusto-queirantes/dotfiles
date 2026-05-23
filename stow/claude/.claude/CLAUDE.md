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

## Code Search

`semble` is registered globally as an MCP server (`mcp__semble__search`,
`mcp__semble__find_related`). It returns ranked, syntax-aware code chunks
and burns ~98% fewer tokens than `rg` + `Read`.

**Default for any semantic question** — "what does this codebase do?",
"where is X handled?", "how does feature Y work?", "show me code like
this". Call the MCP tool, pass `repo` as the project root (or an
https:// git URL).

**Fall back to `rg` / `fd` only for**:
- exact literal strings (error messages, magic constants)
- regex / multi-line patterns
- filename globs or file-tree questions
- refactor renames where you need every occurrence

MCP call shape:

```
mcp__semble__search(query="authentication flow", repo="/abs/path/to/project", top_k=5)
mcp__semble__find_related(file_path="src/auth.py", line=42, repo="/abs/path/to/project")
```

The server is started with `--include-text-files`, so the same call
covers source, markdown, yaml, json, and other config formats — no need
to re-issue queries per content type.

CLI fallback (scripts, hooks, environments without MCP access):

```bash
semble search "authentication flow" .                   # default: code only
semble search "deployment guide" . --include-text-files # also md/yaml/json
semble search "save_pretrained" . -k 10
semble find-related src/auth.py 42 .
semble savings                                           # how much was saved
```

Notes:
- `path` defaults to `.`; remote git URLs are accepted.
- v0.2.0 has no persistent `index` subcommand and no `--content` flag — the
  MCP server caches per-session; the CLI re-indexes per invocation (250ms).
- Reach for `semble` *before* opening `Read` on a file you haven't
  located yet. Once you know the file, `Read` is fine.
