# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS INC_APPEND_HISTORY

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Vi mode
bindkey -e   # keep emacs bindings; switch to `bindkey -v` for vi mode

# Plugins (installed via brew)
[[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# fzf (key bindings + completion)
[[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && \
  source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
[[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && \
  source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"

# zoxide
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# mise
command -v mise >/dev/null && eval "$(mise activate zsh)"

# Aliases
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

# Starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"
