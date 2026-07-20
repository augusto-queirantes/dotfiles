#!/usr/bin/env bash
#
# git-guardrail.sh — PreToolUse hook for the Bash tool.
#
# Deterministically blocks destructive git operations that the global
# CLAUDE.md previously only *asked* Claude to avoid. A hook can't be talked
# out of it on a bad sampling day.
#
# Protocol (Claude Code hooks):
#   stdin   JSON: { tool_name, tool_input: { command }, cwd, ... }
#   exit 0  no opinion — normal permission flow applies
#   exit 2  block the tool call; stderr is fed back to Claude
#
# Requires jq (already in the Brewfile).
set -euo pipefail

input=$(cat)
cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
[[ -z "$cmd" ]] && exit 0

deny() {
  echo "git-guardrail: $1 This is blocked by a deterministic hook, not a preference — do not retry variants. If the operation is truly needed, ask the user to run it themselves." >&2
  exit 2
}

# Force pushes — every variant, including --force-with-lease. Agents do not
# rewrite remote history, full stop.
if grep -qE 'git[^|;&]*push' <<<"$cmd"; then
  if grep -qE '(--force-with-lease|--force|[[:space:]]-f([[:space:]]|$))' <<<"$cmd"; then
    deny "force push refused."
  fi
fi

# Hook bypass on commit or push.
if grep -qE 'git[^|;&]*(commit|push)[^|;&]*--no-verify' <<<"$cmd"; then
  deny "--no-verify refused (fix what the hook found instead)."
fi

# Amending a commit that is already on the upstream. Amend of an unpushed
# commit is allowed — the rule is about published history only.
if grep -qE 'git[^|;&]*commit[^|;&]*--amend' <<<"$cmd"; then
  if [[ -n "$cwd" ]] && git -C "$cwd" merge-base --is-ancestor HEAD '@{u}' 2>/dev/null; then
    deny "amending a pushed commit refused (HEAD is already on the upstream)."
  fi
fi

# Destructive working-tree operations.
if grep -qE 'git[^|;&]*reset[^|;&]*--hard' <<<"$cmd"; then
  deny "git reset --hard refused (use git stash or ask the user)."
fi
if grep -qE 'git[^|;&]*clean[^|;&]+-[A-Za-z]*f' <<<"$cmd"; then
  deny "git clean -f refused (deletes untracked files irrecoverably)."
fi

exit 0
