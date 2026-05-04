---
description: Stage, verify, and create a commit with a message in this repo's style
argument-hint: [optional message hint]
---

You will create a commit for the current changes. Be careful and follow this repo's conventions.

## Inputs

Optional hint from the user: `$ARGUMENTS` (treat as guidance for the message, not the literal message).

## Steps

1. **Survey the changes** (run in parallel):
   - `git status --porcelain`
   - `git diff` (unstaged)
   - `git diff --staged` (already staged)
   - `git log --oneline -15` (to match the prevailing commit-message style)

2. **Decide what to stage**
   - If the user already has things staged, respect that — do not silently add more.
   - Otherwise, stage the files you intend to commit by name. Never use `git add -A` or `git add .`.
   - Skip files that look like secrets (`.env`, `*.pem`, `credentials*`, `*.key`). If any are present, stop and ask.

3. **Pre-commit verification** — only if the user has not just run them:
   - If `make check` exists, run it. Otherwise try `make lint` then `make test`. If neither exists, skip.
   - If lefthook / pre-commit is wired up, the hook will run on `git commit` anyway — do not bypass with `--no-verify`.
   - On failure: stop, surface the failure, and ask whether to fix or abort. **Never `--no-verify`.**

4. **Draft the commit message**
   - Match the existing log: short imperative summary, sentence case, no trailing period (look at `git log --oneline -15` to confirm).
   - Title ≤ 70 chars. Add a body only if the *why* is non-obvious from the diff — bug context, design decision, follow-up to a prior commit. Skip the body for small changes.
   - Do not reference issue/PR numbers unless the user mentioned one.
   - Append the standard `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` trailer.

5. **Show the user the proposed message and the staged file list, then commit.**
   - Use a HEREDOC for the message to preserve formatting.
   - If a hook fails: fix the underlying issue and create a NEW commit. Never `--amend` here.

6. **Confirm** with `git status` and the new commit hash.

## Output

End with one short line: `Committed <hash>: <subject>`. Nothing else.
