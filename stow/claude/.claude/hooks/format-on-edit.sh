#!/usr/bin/env bash
# PostToolUse hook (Write|Edit): format the file Claude just touched with the
# same formatters conform.nvim uses, so agent edits match editor saves.
# Convenience only — never blocks; always exits 0.
set -uo pipefail

# Formatters live in Mason's bin (installed by nvim) and brew.
export PATH="$HOME/.local/share/nvim/mason/bin:/opt/homebrew/bin:$PATH"

file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[[ -z "$file" || ! -f "$file" ]] && exit 0

run() { command -v "$1" >/dev/null 2>&1 && "$@" >/dev/null 2>&1; }

case "$file" in
  *.lua) run stylua "$file" ;;
  *.rb | *.rake | */Gemfile | */Rakefile)
    run rubocop --server --autocorrect --force-exclusion --fail-level fatal "$file"
    ;;
  *.js | *.jsx | *.ts | *.tsx | *.json | *.jsonc | *.yaml | *.yml | *.md | *.css | *.scss | *.html)
    if command -v prettierd >/dev/null 2>&1; then
      tmp=$(mktemp)
      # shellcheck disable=SC2094  # prettierd uses the arg for config lookup only; content comes from stdin
      if prettierd "$file" <"$file" >"$tmp" 2>/dev/null && [[ -s "$tmp" ]]; then
        mv "$tmp" "$file"
      else
        rm -f "$tmp"
      fi
    fi
    ;;
  *.go)
    run goimports -w "$file"
    run gofumpt -w "$file"
    ;;
  *.ex | *.exs | *.heex)
    (cd "$(dirname "$file")" && run mix format "$file")
    ;;
esac

exit 0
