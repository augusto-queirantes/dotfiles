---
description: Rebase the current feature branch onto the latest origin/main
argument-hint: (no arguments)
---

You will rebase the current branch on top of the latest `origin/main` so
the feature stays current. This is a sibling to `/start-feature`: that
one creates a worktree, this one keeps it fresh.

## Steps

1. **Refuse to rebase main/master.** Run `git rev-parse --abbrev-ref HEAD`.
   If on `main` or `master`, stop and tell the user.

2. **Capture working-tree state**
   - `git status --porcelain`. If dirty, `git stash push -u -m "sync-feature autostash"`
     and remember to pop it at the end. (Use stash, not autostash, so you
     can recover cleanly if the rebase aborts.)

3. **Fetch latest main**
   - `git fetch origin main` (do not `pull` — never modify the local
     `main` branch from this command).

4. **Determine if a rebase is needed**
   - `git rev-list --count HEAD..origin/main` — if 0, branch is already
     up to date. Tell the user and stop (after popping stash if any).

5. **Rebase**
   - `git rebase origin/main`.
   - On conflict: stop, list the conflicted files, and ask the user how
     to proceed. Never `git rebase --skip`. Never `git checkout --theirs`
     or `--ours` blindly.

6. **Restore working tree**
   - If you stashed in step 2: `git stash pop`. If pop conflicts, surface
     it; do not auto-resolve.

7. **Decide about pushing**
   - If the branch has an upstream and is now diverged from it (rebase
     rewrote history), tell the user a force-push is required. Do **not**
     run `git push --force` automatically — confirm first, and prefer
     `git push --force-with-lease`.
   - If no upstream yet, do nothing — `/open-pr` will push when ready.

## Output

Two lines: `Rebased <n> commit(s) onto origin/main (<short-sha>).` and a
status summary (clean / needs force-push / conflicts unresolved).
