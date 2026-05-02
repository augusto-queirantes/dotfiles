#!/usr/bin/env bash
set -euo pipefail

# Tmux Plugin Manager
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed."
fi

# mise: trust config and install runtimes declared in ~/.config/mise/config.toml
if command -v mise >/dev/null 2>&1; then
  mise trust "$HOME/.config/mise/config.toml" 2>/dev/null || true
  echo "Installing mise runtimes..."
  mise install || echo "mise install failed — check ~/.config/mise/config.toml"
fi

# fzf shell integrations are loaded from .zshrc; nothing extra to install.

# Set zsh as default shell if it isn't
ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$ZSH_PATH"
  echo "zsh set as default shell (takes effect on next login)."
fi

echo "Post-install done."
echo "Open tmux and press prefix + I to install tmux plugins."
echo "Open nvim — lazy.nvim will install plugins on first run."
