#!/usr/bin/env bash
# Claude Code statusLine: model | cwd (git branch) | context % | session cost.
# Receives session JSON on stdin; the first stdout line is displayed.
# Refreshed at most every 300ms, so keep this cheap (one jq, one git call).
set -uo pipefail

input=$(cat)
model="?" dir="?" ctx=0 cost=0
eval "$(jq -r '@sh "model=\(.model.display_name // "?")
dir=\(.workspace.current_dir // "?")
ctx=\((.context_window.used_percentage // 0) | floor)
cost=\(.cost.total_cost_usd // 0)"' <<<"$input" 2>/dev/null)" || exit 0

branch=$(git -C "$dir" branch --show-current 2>/dev/null)

# context colour: green under 60%, yellow under 85%, red above
if ((ctx < 60)); then
  ctx_col=$'\033[32m'
elif ((ctx < 85)); then
  ctx_col=$'\033[33m'
else
  ctx_col=$'\033[31m'
fi
dim=$'\033[2m'
cyan=$'\033[36m'
magenta=$'\033[35m'
reset=$'\033[0m'

printf '%s%s%s %s%s%s%s %sctx %s%%%s %s$%.2f%s\n' \
  "$magenta" "$model" "$reset" \
  "$cyan" "${dir/#$HOME/~}" "${branch:+ ($branch)}" "$reset" \
  "$ctx_col" "$ctx" "$reset" \
  "$dim" "$cost" "$reset"
