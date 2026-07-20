# Read by every zsh (login, interactive, scripts) — keep it tiny.

# `brew bundle` / `brew bundle cleanup` work from any directory.
export HOMEBREW_BUNDLE_FILE="$HOME/Personal/dotfiles/Brewfile"

# Stop Apple Terminal's session save/restore churn (~/.zsh_sessions).
export SHELL_SESSIONS_DISABLE=1

# just-a-cli shell init, cached by binary mtime (a live eval costs ~65ms on
# every shell, including scripts). No-op on machines without it.
_just_bin="$HOME/Projects/just-a-cli/bin/just"
_just_cache="$HOME/.cache/zsh/just-init.zsh"
if [[ -x "$_just_bin" ]]; then
  if [[ ! -s "$_just_cache" || "$_just_bin" -nt "$_just_cache" ]]; then
    mkdir -p "${_just_cache:h}"
    "$_just_bin" init it >| "$_just_cache" 2>/dev/null
  fi
  source "$_just_cache"
fi
unset _just_bin _just_cache

# Machine-local env — API keys, tokens. Untracked; never put secrets in this
# repo (it is public).
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
