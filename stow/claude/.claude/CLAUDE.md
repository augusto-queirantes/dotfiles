# Global instructions for Claude Code

These apply across every project on this machine. If there's any conflicts with the project level `CLAUDE.md` the project level wins.

## Writing code

Best code is code never written. Stop at the first rung that holds:

1. Does this need to exist? → no: skip it (YAGNI)
2. Already in this codebase? → reuse it, don't rewrite
3. Stdlib does it? → use it
4. Native platform feature? → use it
5. Installed dependency? → use it

**Lazy about the solution, never about reading.** Trust-boundary validation, data-loss handling, security, and accessibility are never on the chopping block. Code ends up small because it is necessary, not golfed.

## Writing code tests

- You should never test that something isn't there anymore or was removed
- Examples description should be short, simple and straight foward
- You should avoid every unnecesarry mock

## Code search

Default to the `semble` MCP tools (`mcp__semble__search`, `mcp__semble__find_related`) for any semantic question about a codebase. Fall back to `rg` only for exact literals, regexes, filename globs, or every-occurrence rename sweeps.
