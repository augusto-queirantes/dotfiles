# Global instructions for Claude Code

These apply across every project on this machine. Per-project `CLAUDE.md`
files override / extend this — when in conflict, the project file wins.

## About me

- Senior software engineer. Comfortable with Go, Ruby, TypeScript, Elixir.
- Primary editor: Neovim. Multiplexer: tmux. Shell: zsh.
- I work in git worktrees, one per feature. Don't `git switch`/`git checkout`
  on the current worktree — branch via `git worktree add` instead.

## Workflow commands

I drive day-to-day work through these slash commands. Prefer them over
ad-hoc git/gh invocations:

- `/start-feature <desc>` — new worktree off latest `origin/main`.
- `/sync-feature` — rebase the current branch on latest `origin/main`.
- `/fix-ci [pr#]` — diagnose failing checks, fix root cause, push.

If a request maps to one of these, run the slash command rather than
reimplementing it inline.

## Defaults

- **Don't commit, push, or open PRs unless I ask.** Stage and stop.
- **Never `--force` push, `--no-verify`, or `--amend` a pushed commit**
  without explicit permission.
- **No emoji in code, commits, or PR bodies** unless I ask for them.
- **No "Generated with Claude Code" footers** in commits or PRs unless
  the repo's existing history uses them.
- **Match the project's conventions over your own preferences** —
  read `git log --oneline -20` and a few neighbouring files first.
- Keep responses tight. End-of-turn summary is one or two sentences.

## Tools available on this machine

`gh`, `lazygit`, `rg`, `fd`, `bat`, `eza`, `delta`, `jq`, `yq`, `mise`,
`docker`, `tmux`, `nvim`. Prefer `rg`/`fd` over `grep`/`find`.
