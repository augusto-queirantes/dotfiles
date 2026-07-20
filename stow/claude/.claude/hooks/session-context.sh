#!/usr/bin/env bash
# SessionStart hook (compact|resume): re-inject fresh git state. The built-in
# gitStatus snapshot is taken at session start and goes stale after
# compaction — this keeps Claude oriented without re-running git status.
set -uo pipefail

input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)
[[ -z "$cwd" ]] && exit 0
git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
dirty=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
upstream=$(git -C "$cwd" rev-list --left-right --count '@{u}...HEAD' 2>/dev/null |
  awk '{print "behind " $1 ", ahead " $2}')

ctx="Refreshed git state: branch ${branch:-<detached>}, ${dirty} dirty file(s)${upstream:+, $upstream}."
jq -n --arg ctx "$ctx" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'
exit 0
