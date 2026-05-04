---
description: Push the current branch and open a pull request with a generated description
argument-hint: [optional title hint]
---

You will open a GitHub pull request for the current branch.

## Inputs

Optional hint: `$ARGUMENTS`. Use as guidance for the title; do not treat it as the literal title unless it already looks well-formed.

## Steps

1. **Refuse to PR from main/master.** If on main or master, stop and tell the user.

2. **Survey the branch** (parallel):
   - `git status --porcelain`
   - `git rev-parse --abbrev-ref HEAD`
   - Determine base branch via `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` (fall back to `main`).
   - `git log --oneline <base>..HEAD` — every commit on the branch, not just the latest.
   - `git diff <base>...HEAD --stat` and `git diff <base>...HEAD` (the second one only if the stat is small enough to be useful).
   - `gh pr list --head <branch> --json number,url -q '.[]'` — to detect an existing PR.

3. **Push if needed**
   - If the branch has no upstream: `git push -u origin <branch>`.
   - If it has an upstream and is ahead: `git push`.
   - Never `--force` unless the user asks.

4. **If a PR already exists for this branch**
   - Tell the user the URL and ask whether they want to update the description (use `gh pr edit`) or just push.

5. **Draft title and body**
   - **Title** (≤ 70 chars): imperative summary covering the *whole branch*, not just the last commit. Match the style of recent merged PRs (`gh pr list --state merged --limit 10`).
   - **Body** with these sections:
     - `## Summary` — 1–3 bullets on what changed and why.
     - `## Test plan` — checklist of how to verify (commands run, manual steps, edge cases). Mark items already done with `[x]`.
   - Skip a "Generated with Claude Code" footer unless the repo's existing PRs include one.

6. **Open the PR** with `gh pr create --base <base> --title ... --body "$(cat <<'EOF' ... EOF)"`.

7. **Print the PR URL** as the final line.

## Constraints

- Do not invent reviewers, labels, or milestones.
- Do not attach files.
- Never run `gh pr merge`.
