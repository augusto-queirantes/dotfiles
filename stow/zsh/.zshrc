# ─── Homebrew ────────────────────────────────────────────────────────────────
# Static output of `brew shellenv` — saves ~40ms/start (shellenv also re-runs
# macOS path_helper internally). Regenerate if brew relocates: `brew shellenv`.
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# History (atuin owns Ctrl-R; the file remains for tools that read it)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS INC_APPEND_HISTORY

# ─── Completion ──────────────────────────────────────────────────────────────
# All fpath additions must come before the single compinit call.
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

# Full compinit (fpath scan + compaudit) at most once a day; -C otherwise.
autoload -Uz compinit
_zcd_stale=("$HOME"/.zcompdump(N.mh+24))
if (( $#_zcd_stale )); then compinit; else compinit -C; fi
unset _zcd_stale
# Byte-compile the dump in the background when it changed.
{
  zcd="$HOME/.zcompdump"
  [[ -s "$zcd" && ( ! -s "$zcd.zwc" || "$zcd" -nt "$zcd.zwc" ) ]] && zcompile "$zcd"
} &!

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu no          # fzf-tab renders the menu

# Vi mode
bindkey -e   # keep emacs bindings; switch to `bindkey -v` for vi mode

# ─── Cached tool inits ───────────────────────────────────────────────────────
# Cache `eval "$(tool init zsh)"` output; re-generate when the binary changes.
# Saves a fork + script eval per tool per shell (~10-50ms each).
_cached_eval() {
  local name="$1" bin cache="$HOME/.cache/zsh/$1.zsh"; shift
  bin="$(command -v "$1")" || return 0
  if [[ ! -s "$cache" || "$bin" -nt "$cache" ]]; then
    mkdir -p "${cache:h}"
    "$@" >| "$cache" 2>/dev/null
    zcompile "$cache" 2>/dev/null
  fi
  source "$cache"
}

_cached_eval fzf fzf --zsh                                  # Ctrl-T, Alt-C, ** completion
_cached_eval zoxide zoxide init zsh
_cached_eval mise mise activate zsh
_cached_eval atuin atuin init zsh --disable-up-arrow        # Ctrl-R history TUI; up-arrow stays native
# --print-full-init: the stage-1 init would fork starship again every shell
_cached_eval starship starship init zsh --print-full-init

# ─── Plugins (installed via brew) ────────────────────────────────────────────
# Order matters: fzf-tab after compinit, before autosuggestions;
# syntax-highlighting must be sourced last.
[[ -f "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]] && \
  source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --group-directories-first $realpath'
zstyle ':fzf-tab:*' fzf-flags '--height=50%'

ZSH_AUTOSUGGEST_MANUAL_REBIND=1   # skip widget rebinding every prompt (~cuts keystroke lag)
[[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ─── Functions ───────────────────────────────────────────────────────────────
# Default claude with the conclave plugin loaded.
claude() {
  command claude --plugin-dir "$HOME/Personal/conclave" "$@"
}

# yazi: cd to the directory you were in when quitting.
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(<"$tmp")"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# ─── Aliases ─────────────────────────────────────────────────────────────────
alias ls="eza --group-directories-first"
alias ll="eza -l --group-directories-first --git"
alias la="eza -la --group-directories-first --git"
alias lt="eza --tree --level=2 --group-directories-first"
alias cat="bat --paging=never"
alias g="git"
alias lg="lazygit"
alias v="nvim"
alias t="tmux"
alias ts="tmux-sessionizer"
alias ccu="bunx ccusage@latest"   # Claude Code usage/cost report

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Stable tmux socket dir (avoids /tmp cleanup wiping the socket dir)
export TMUX_TMPDIR="$HOME/.tmux-tmp"
[[ -d "$TMUX_TMPDIR" ]] || { mkdir -p "$TMUX_TMPDIR" && chmod 700 "$TMUX_TMPDIR"; }
