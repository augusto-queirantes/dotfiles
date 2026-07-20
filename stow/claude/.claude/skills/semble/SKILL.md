---
name: semble
description: Call shapes, flags, and fallback rules for the semble code-search MCP server and CLI. Use when searching a codebase semantically, or when unsure whether to reach for semble or rg/fd.
---

# semble — ranked, syntax-aware code search

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

## MCP call shape

```
mcp__semble__search(query="authentication flow", repo="/abs/path/to/project", top_k=5)
mcp__semble__find_related(file_path="src/auth.py", line=42, repo="/abs/path/to/project")
```

The server is started with `--include-text-files`, so the same call
covers source, markdown, yaml, json, and other config formats — no need
to re-issue queries per content type.

## CLI fallback (scripts, hooks, environments without MCP access)

```bash
semble search "authentication flow" .                   # default: code only
semble search "deployment guide" . --include-text-files # also md/yaml/json
semble search "save_pretrained" . -k 10
semble find-related src/auth.py 42 .
semble savings                                           # how much was saved
```

## Notes

- `path` defaults to `.`; remote git URLs are accepted.
- v0.2.0 has no persistent `index` subcommand and no `--content` flag — the
  MCP server caches per-session; the CLI re-indexes per invocation (250ms).
- Reach for `semble` *before* opening `Read` on a file you haven't
  located yet. Once you know the file, `Read` is fine.
