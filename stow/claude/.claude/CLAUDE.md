# Global instructions for Claude Code

These apply across every project on this machine. Per-project `CLAUDE.md` files override and extend this — when in conflict, the project file wins.

Markdown is not hard-wrapped. One line per paragraph; let the editor soft-wrap. Reflowing a wrapped paragraph touches every following line and makes diffs unreadable.

## Writing code

Best code is code never written. Stop at the first rung that holds:

1. Does this need to exist? → no: skip it (YAGNI)
2. Already in this codebase? → reuse it, don't rewrite
3. Stdlib does it? → use it
4. Native platform feature? → use it
5. Installed dependency? → use it
6. One line? → one line
7. Only then: the minimum that works

The ladder runs _after_ understanding the problem, not instead of it. Read the code the change touches and trace the real flow before picking a rung.

**Lazy about the solution, never about reading.** Trust-boundary validation, data-loss handling, security, and accessibility are never on the chopping block. Code ends up small because it is necessary, not golfed.

Do not add speculative abstraction, config surface, defensive branches for conditions that cannot occur, or tests for code the task did not ask for. Do not restate the request as a comment. Match the surrounding file's comment density, naming, and idiom rather than your own defaults.

Adapted from [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail).

## Defaults

- **No emoji** in code, commits, or PR bodies unless I ask.
- **Match the project's conventions over your own preferences** — read `git log --oneline -20` and a few neighbouring files first.
- Destructive git operations (force push, `--no-verify`, amending pushed commits, `reset --hard`, `clean -f`) are not yours to run. Ask me instead.
- **NO COMMENTS ARE ALLOWED UNLESS IT DESCRIBES A BEHAVIOUR THAT CAN'T BE UNDERSTOOD ONLY BY READING THE CODE**. The reason you removed some piece of code, why that method is called by that name or why you added a new method are not good reasons. You can add a comment to explain something that lives outside of the code such as a regex explanation or something like this. Are you not 100% sure if that piece of code needs a comment? It do not need. It's either a hard yes or a no.

## Code search

Default to the `semble` MCP tools (`mcp__semble__search`, `mcp__semble__find_related`) for any semantic question about a codebase. Fall back to `rg` only for exact literals, regexes, filename globs, or every-occurrence rename sweeps.
