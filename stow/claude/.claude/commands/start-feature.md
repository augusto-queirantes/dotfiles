---
description: Create a new git worktree from latest origin/main and a feature branch
argument-hint: <short feature description>
---

You will create a new worktree off the latest `origin/main` so the user can develop a feature in isolation.

## Inputs

User-supplied description: `$ARGUMENTS`

If `$ARGUMENTS` is empty, ask the user for one short sentence describing the feature, then proceed.

## Steps

1. **Sanity-check the repo state**
   - Run `git rev-parse --show-toplevel` to find the main repo root. All git commands below run with `-C <root>`.
   - Run `git status --porcelain` — if the current worktree has uncommitted changes, mention them but continue (worktree creation does not touch them).
   - Run `git worktree list` so you can see existing worktrees and avoid path/branch collisions.

2. **Update main without checking it out**
   - `git fetch origin main` (do NOT switch branches; the user may be mid-task on the current one).

3. **Pick a branch name**
   - Slug the description: lowercase, kebab-case, drop punctuation, cap at ~40 chars.
   - Branch name: `augusto/<slug>` unless the user has a different convention visible in `git branch -r | head` — in that case match it.
   - If the branch already exists locally or remotely, append `-2`, `-3`, etc.

4. **Pick a worktree path**
   - Default: `<repo-parent>/<repo-name>-<slug>` (sibling directory next to the main checkout).
   - If `git worktree list` shows a different convention being used (e.g. a dedicated worktrees directory), match it.
   - If the path already exists, append `-2`, `-3`, etc.

5. **Create the worktree**
   - `git worktree add <path> -b <branch> origin/main`

6. **Report back to the user**
   - Show the worktree path and branch name.
   - Tell them: open a new Claude Code session in that directory to continue — this session stays in the current worktree. Show the exact `cd` command.
   - Do NOT cd or attempt to operate on the new worktree from this session.

## Constraints

- Never run `git checkout` / `git switch` on the current worktree.
- Never `git pull` on main directly — `git fetch` + branching from `origin/main` keeps the local main untouched.
- If the user has a multi-worktree setup that shares Docker containers (check `CLAUDE.md` for hints), do not start any services — just create the worktree.
