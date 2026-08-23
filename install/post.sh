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

# semble: install the CLI globally and register its MCP server with Claude Code.
if command -v uv >/dev/null 2>&1; then
  if ! command -v semble >/dev/null 2>&1; then
    echo "Installing semble..."
    uv tool install semble || echo "semble install failed — re-run after fixing uv."
  fi
  if command -v claude >/dev/null 2>&1; then
    if ! claude mcp list 2>/dev/null | grep -q '^semble:'; then
      echo "Registering semble MCP server with Claude Code..."
      # --include-text-files extends indexing to .md/.yaml/.json so docs + config
      # are searchable through the same MCP call as source code.
      claude mcp add semble -s user -- uvx --from "semble[mcp]" semble --include-text-files ||
        echo "claude mcp add semble failed — register it manually."
    fi
  fi
fi

# ai-memory: persistent cross-session memory for coding agents
# (https://github.com/akitaonrails/ai-memory). The hook entries stowed in
# stow/claude/.claude/settings.json reference this binary by absolute path,
# so it must live at ~/Applications/ai-memory on every machine.
AI_MEMORY_DIR="$HOME/Applications/ai-memory"
AI_MEMORY_BIN="$AI_MEMORY_DIR/ai-memory"
AI_MEMORY_DATA="$HOME/Library/Application Support/ai-memory"
AI_MEMORY_LABEL="tech.akitaonrails.ai-memory"
if [[ ! -x "$AI_MEMORY_BIN" ]]; then
  echo "Installing ai-memory..."
  mkdir -p "$AI_MEMORY_DIR"
  ai_memory_arch="$(uname -m)"
  [[ "$ai_memory_arch" == "arm64" ]] && ai_memory_arch="aarch64"
  curl -fsSL "https://github.com/akitaonrails/ai-memory/releases/latest/download/ai-memory-macos-${ai_memory_arch}.tar.gz" |
    tar -xz -C "$AI_MEMORY_DIR" || echo "ai-memory download failed — install it manually."
fi
if [[ -x "$AI_MEMORY_BIN" ]]; then
  ln -sfn "$AI_MEMORY_BIN" "$HOME/.local/bin/ai-memory"
  [[ -f "$AI_MEMORY_DATA/config.toml" ]] || "$AI_MEMORY_BIN" init

  AI_MEMORY_PLIST="$HOME/Library/LaunchAgents/$AI_MEMORY_LABEL.plist"
  mkdir -p "$(dirname "$AI_MEMORY_PLIST")"
  cat >"$AI_MEMORY_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$AI_MEMORY_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$AI_MEMORY_BIN</string>
        <string>serve</string>
        <string>--transport</string>
        <string>http</string>
        <string>--bind</string>
        <string>127.0.0.1:49374</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>AI_MEMORY_DATA_DIR</key>
        <string>$AI_MEMORY_DATA</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$AI_MEMORY_DATA/serve.log</string>
    <key>StandardErrorPath</key>
    <string>$AI_MEMORY_DATA/serve.log</string>
</dict>
</plist>
PLIST
  if ! launchctl print "gui/$(id -u)/$AI_MEMORY_LABEL" >/dev/null 2>&1; then
    launchctl bootstrap "gui/$(id -u)" "$AI_MEMORY_PLIST" ||
      echo "ai-memory launchd bootstrap failed — run 'ai-memory serve' manually."
  fi

  if command -v claude >/dev/null 2>&1; then
    if ! claude mcp list 2>/dev/null | grep -q '^ai-memory:'; then
      echo "Registering ai-memory MCP server with Claude Code..."
      claude mcp add --scope user --transport http ai-memory http://127.0.0.1:49374/mcp ||
        echo "claude mcp add ai-memory failed — register it manually."
    fi
  fi

  # Lifecycle hooks per agent harness: "<ai-memory agent name>:<cli>:<config file>".
  # install-hooks is idempotent but rewrites the config, so only run it when the
  # config doesn't mention ai-memory yet (keeps stowed files diff-free).
  AI_MEMORY_AGENTS=(
    "claude-code:claude:$HOME/.claude/settings.json"
    "codex:codex:$HOME/.codex/config.toml"
    "gemini-cli:gemini:$HOME/.gemini/settings.json"
    "open-code:opencode:$HOME/.config/opencode/plugins/ai-memory-hooks.ts"
    "cursor:cursor:$HOME/.cursor/hooks.json"
  )
  for entry in "${AI_MEMORY_AGENTS[@]}"; do
    agent="${entry%%:*}"
    rest="${entry#*:}"
    cli="${rest%%:*}"
    config="${rest#*:}"
    command -v "$cli" >/dev/null 2>&1 || continue
    if [[ ! -f "$config" ]] || ! grep -q "ai-memory" "$config"; then
      echo "Installing ai-memory hooks for $agent..."
      "$AI_MEMORY_BIN" install-hooks --agent "$agent" --apply ||
        echo "ai-memory install-hooks failed for $agent — run it manually."
    fi
  done
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
