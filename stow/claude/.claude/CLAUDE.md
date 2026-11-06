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

## Production and destructive actions

`settings.json` sorts commands into three tiers:

- **Operate** (runs freely): logs, inspection, preview deploys, listing migrations, and the repo's own deploy workflow (`gh workflow run deploy.yml`), which migrates and deploys what is already on `main`.
- **Change production** (asks Augusto): production deploys or rollbacks from a CLI, env vars and secrets, applying migrations outside the deploy workflow, dumping a remote database.
- **Destroy** (denied): pushing to `main`, force pushes, merging pull requests, and deleting repos, projects, domains, env vars, databases, schemas or tables.

Push with an explicit branch name: `git push -u origin <branch>`. A bare `git push` or a `HEAD` refspec is denied, because it can't be told apart from a push to `main`. A global git pre-push hook also refuses pushes to `main` or `master` from any tool; `--no-verify` is denied.

When a rule denies something you believe is needed, don't route around it with another tool, a package runner, a script or a browser. Stop and hand it to Augusto: the exact command, why it's needed, what it destroys, and how to undo it. In Maestri, also post `maestri floor status "<one line>" --state blocked`. He runs it himself.
