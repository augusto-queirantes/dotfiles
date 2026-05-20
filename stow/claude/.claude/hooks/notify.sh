#!/usr/bin/env bash
# Claude Code hook: emit a macOS notification for events that need attention.
#
# Usage: notify.sh <mode>
#   stop        main agent finished a turn — banner only, no sound
#   permission  claude is blocked on a permission decision — banner + sound
#
# Suppressed when a terminal app is frontmost (you're already looking).

set -u

[[ "$(uname -s)" == "Darwin" ]] || exit 0

mode="${1:-stop}"

front=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null || true)
case "$front" in
  Alacritty|Ghostty|iTerm2|Terminal|WezTerm|kitty|Hyper) exit 0 ;;
esac

case "$mode" in
  permission)
    body="Decision needed"
    sound_clause=' sound name "Glass"'
    ;;
  *)
    body="Done — your turn"
    sound_clause=''
    ;;
esac

osascript -e "display notification \"$body\" with title \"Claude Code\"$sound_clause" >/dev/null 2>&1 || true
