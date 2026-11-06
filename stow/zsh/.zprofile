# ─── Homebrew for non-interactive login shells ───────────────────────────────
# .zshrc is interactive-only, so `zsh -lc` never gets its Homebrew prepend and
# falls through to /etc/zprofile's path_helper, which ranks /usr/bin first —
# tools that shell out that way then pick up Apple's git 2.39 over brew's.
# This file is sourced after /etc/zprofile, so the order set here is the one
# that survives.
if [[ -d /opt/homebrew ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi

# ─── mise for non-interactive login shells ───────────────────────────────────
# `mise activate` lives in .zshrc, so `zsh -lc` gets no mise at all and `ruby`
# falls through to /usr/bin/ruby 2.6 — which then breaks any bundler binstub
# whose shebang is `#!/usr/bin/env ruby`. Shims are mise's documented answer
# for non-interactive contexts; activate stays interactive-only.
if [[ -d $HOME/.local/share/mise/shims ]]; then
  path=($HOME/.local/share/mise/shims $path)
fi
