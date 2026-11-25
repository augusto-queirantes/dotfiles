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

# ruby-lsp / rubocop: one copy per mise-managed ruby. Neovim runs both through
# `mise exec` so the project's .ruby-version picks the right one; mason is not
# used for these because it bakes a single interpreter into the gem shebang.
if command -v mise >/dev/null 2>&1; then
  while read -r rb_version; do
    [[ -n "$rb_version" ]] || continue
    for gem_name in ruby-lsp rubocop; do
      if mise exec "ruby@$rb_version" -- gem list -i "$gem_name" >/dev/null 2>&1; then
        continue
      fi
      echo "Installing $gem_name for ruby $rb_version..."
      mise exec "ruby@$rb_version" -- gem install "$gem_name" --no-document ||
        echo "$gem_name install failed for ruby $rb_version — install it manually."
    done
  done < <(mise ls ruby --installed 2>/dev/null | awk '{print $2}')
fi

# Claude Code: the native installer, which keeps it up to date on its own.
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash || echo "Claude Code install failed — run 'curl -fsSL https://claude.ai/install.sh | bash' manually."
  export PATH="$HOME/.local/bin:$PATH"
fi

# Claude Code: the MCP servers every session uses.
if command -v claude >/dev/null 2>&1; then
  if ! claude mcp list 2>/dev/null | grep -q '^linear-server:'; then
    echo "Registering the Linear MCP server with Claude Code (sign in with /mcp)..."
    claude mcp add --transport http linear-server https://mcp.linear.app/mcp -s user ||
      echo "claude mcp add linear-server failed — register it manually."
  fi
  if ! claude mcp list 2>/dev/null | grep -q '^posthog:'; then
    echo "Registering the PostHog MCP server with Claude Code (sign in with /mcp)..."
    claude mcp add --transport http posthog https://mcp.posthog.com/mcp -s user ||
      echo "claude mcp add posthog failed — register it manually."
  fi
fi

# conclave: the roles (each brings the actions it uses) and the Datadog plugin
# the project manager reads metrics from. Installed plugins are left alone.
if command -v claude >/dev/null 2>&1; then
  if ! claude plugin marketplace list 2>/dev/null | grep -q '❯ conclave$'; then
    echo "Adding the conclave marketplace..."
    claude plugin marketplace add augusto-queirantes/conclave ||
      echo "claude plugin marketplace add conclave failed — add it manually."
  fi
  for plugin in developer@conclave designer@conclave qa@conclave project-manager@conclave datadog@claude-plugins-official; do
    if ! claude plugin list 2>/dev/null | grep -q "❯ $plugin$"; then
      echo "Installing $plugin..."
      claude plugin install "$plugin" --scope user || echo "claude plugin install $plugin failed — install it manually."
    fi
  done
fi

# Docker Desktop: cap its VM at 4 GiB and let Resource Saver pause it when idle,
# so agents' stacks can't take the machine's memory. Docker keeps only the
# settings that differ from its defaults in this file and writes it on first
# launch, so a machine where it never ran gets the cap on the next run.
DOCKER_SETTINGS="$HOME/Library/Group Containers/group.com.docker/settings-store.json"
if [[ -f "$DOCKER_SETTINGS" ]]; then
  if ! jq -e '.MemoryMiB == 4096 and .UseResourceSaver == true' "$DOCKER_SETTINGS" >/dev/null; then
    echo "Capping Docker Desktop at 4 GiB with Resource Saver on (restart Docker Desktop to apply)..."
    if settings="$(jq '.MemoryMiB = 4096 | .UseResourceSaver = true' "$DOCKER_SETTINGS")"; then
      printf '%s\n' "$settings" >"$DOCKER_SETTINGS"
    else
      echo "Docker Desktop settings update failed — set Memory to 4 GB and turn on Resource Saver in its Settings."
    fi
  fi
elif [[ -d /Applications/Docker.app ]]; then
  echo "Open Docker Desktop once, then re-run 'make post' to cap its memory at 4 GiB."
fi

# atuin: one-time import of existing zsh history into its SQLite store.
if command -v atuin >/dev/null 2>&1; then
  marker="$HOME/.local/share/atuin/.imported"
  if [[ ! -f "$marker" ]]; then
    echo "Importing shell history into atuin..."
    mkdir -p "$(dirname "$marker")"
    atuin import auto && touch "$marker" || echo "atuin import failed — run 'atuin import auto' manually."
  fi
fi

# gh: conclave's project manager moves tasks on GitHub Projects, which needs
# the token's `project` scope, and `gh auth login` does not grant it unasked.
# Signing in or refreshing opens the browser once; a token with it is left alone.
if command -v gh >/dev/null 2>&1; then
  if ! gh auth token --hostname github.com >/dev/null 2>&1; then
    echo "Signing in to GitHub with the project scope..."
    gh auth login --hostname github.com --git-protocol ssh --web --scopes project ||
      echo "gh auth login failed — run 'gh auth login --scopes project' manually."
  elif ! gh auth status --hostname github.com 2>/dev/null | grep -q "'project'"; then
    echo "Adding the project scope to gh's token..."
    gh auth refresh --hostname github.com --scopes project ||
      echo "gh auth refresh failed — run 'gh auth refresh -s project' manually."
  fi
fi

# git maintenance: launchd-scheduled prefetch + commit-graph. Registered in
# ~/.gitconfig.local (untracked) so machine paths never land in the repo.
# Add big/hot repos here as they appear.
MAINTENANCE_REPOS=(
  "$HOME/Personal/dotfiles"
)
touch "$HOME/.gitconfig.local"
for repo in "${MAINTENANCE_REPOS[@]:-}"; do
  if [[ -n "$repo" && -d "$repo/.git" ]]; then
    git -C "$repo" config get --file "$HOME/.gitconfig.local" --all maintenance.repo 2>/dev/null | grep -qx "$repo" ||
      git -C "$repo" maintenance register --config-file "$HOME/.gitconfig.local" >/dev/null 2>&1 || true
  fi
done

# Rex: xterm-rex terminfo plus its ssh guard (keeps TERM safe on hosts without
# the entry), and the skill + SessionStart hook for Claude Code and Codex. The
# Claude hook is already committed in settings.json, so setup leaves it as is.
REX="/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"
if [[ -x "$REX" ]]; then
  "$REX" terminfo setup || echo "rex terminfo setup failed — run it manually."
  "$REX" skill setup || echo "rex skill setup failed — run it manually."
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
