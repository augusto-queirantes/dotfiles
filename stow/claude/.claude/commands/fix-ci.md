---
description: Diagnose and fix failing CI checks on the current branch's PR
argument-hint: [optional PR number]
---

You will inspect failing CI checks for the current branch (or PR `$ARGUMENTS` if provided), find the root cause, fix it, and push.

## Steps

1. **Locate the PR**
   - If `$ARGUMENTS` is a number: that's the PR.
   - Otherwise resolve from current branch: `gh pr view --json number,url,headRefName,statusCheckRollup`.
   - If there is no PR, stop and tell the user to run `/open-pr` first.

2. **List failing checks**
   - `gh pr checks <pr> --watch=false` — capture which workflows/jobs failed.
   - For each failed check, get the run ID via `gh pr checks <pr> --json name,state,link`.

3. **Pull the failing logs**
   - For each failing run: `gh run view <run-id> --log-failed` (this prints only failing-step output — much smaller than `--log`).
   - If the failed-log output is still > ~500 lines, delegate the read to the `ci-investigator` agent so it doesn't blow the main context. Ask it to report a punch list of root causes (file:line + minimal fix sketch). Do not have the agent write code.

4. **Reproduce locally if cheap**
   - For Go repos: `make check`, `make lint`, `make test`, or the specific failing target.
   - Skip reproduction if the failure is environmental (flaky network, runner OOM) — re-run instead via `gh run rerun <run-id> --failed` and tell the user.

5. **Fix the root cause in code**
   - One commit per logically distinct fix, not one big "fix CI" commit.
   - Each commit message should describe the actual fix, not "fix CI".
   - Re-run the local check before pushing.

6. **Push and report**
   - `git push`
   - Print the PR URL and the new check status (`gh pr checks <pr>`).
   - If checks are still pending, tell the user — do not poll in a sleep loop.

## Constraints

- Never push `--force` unless the user explicitly asks.
- Never mark a check "passed" by retrying without a fix. If you re-run, say so explicitly and explain why you believe it's environmental.
- Never disable a lint, skip a test, or comment out an assertion to make CI green. If a check is genuinely wrong, surface that to the user instead of working around it.
