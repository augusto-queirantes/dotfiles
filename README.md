# dotfiles

[![ci](https://github.com/augusto-queirantes/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/augusto-queirantes/dotfiles/actions/workflows/ci.yml)

Personal macOS dev environment. One command on a fresh machine, everything is set up.

## Quick start

```bash
git clone git@github.com:augusto-queirantes/dotfiles.git ~/Personal/dotfiles
cd ~/Personal/dotfiles
make setup
```

Reopen the terminal afterwards. Inside `tmux`, press `prefix + I` (Ctrl-a, then `I`) to install tmux plugins. Open `nvim` once — lazy.nvim auto-installs plugins.

## What `make setup` does

1. Installs Xcode Command Line Tools (if missing).
2. Installs Homebrew (if missing).
3. `brew bundle` — installs every CLI/cask/font in `Brewfile`.
4. `stow` — symlinks every `stow/<pkg>/` into `$HOME`.
5. Symlinks `bin/*` into `~/.local/bin`.
6. Applies macOS defaults (`install/macos.sh`).
7. Post-install: TPM, mise runtimes, atuin history import, git maintenance, default shell.

## Make targets

| Target       | Purpose |
|--------------|---------|
| `setup`      | Full bootstrap — what you run on a fresh Mac. |
| `brew`       | Run `brew bundle`. |
| `stow`       | Symlink every package into `$HOME`. |
| `restow`     | Re-link after adding/renaming files. |
| `unstow`     | Remove all symlinks. |
| `bin`        | Symlink `bin/*` into `~/.local/bin`. |
| `macos`      | Apply macOS defaults. |
| `post`       | Re-run post-install steps. |
| `check`      | Stow dry-run + `brew bundle check` + shell-startup benchmark. |
| `lint`       | shellcheck + shfmt over every script. |
| `brew-drift` | List packages installed but not declared in the Brewfile. |

CI runs `lint` and a stow smoke test on every push, plus a full
`brew bundle` install on a macOS runner weekly — Brewfile rot and
macOS-update breakage surface there before they hit a fresh machine.

## How config sync works

Configs live under `stow/<package>/` and are **symlinked** into `$HOME`. That means:

- Edit a file in this repo → the running tool sees the change immediately.
- Edit a file under `~/.config/...` directly → you edited the file in this repo (it's a symlink).
- After committing repo changes, no sync step is needed — symlinks already point here.

If you add a new file or rename one inside a stow package, run `make restow`.

## Layout

```
dotfiles/
├── Makefile              # `make setup` entrypoint
├── Brewfile              # all brew/cask/font packages
├── .github/workflows/    # CI: lint + stow smoke + weekly full install
├── install/
│   ├── bootstrap.sh      # xcode + brew + brew bundle
│   ├── macos.sh          # macOS defaults
│   └── post.sh           # TPM, mise, atuin import, git maintenance, shell
├── docs/                 # per-tool cheatsheets (tmux, nvim, …)
├── stow/                 # each subdir is a stow package
│   ├── zsh/.zshrc + .zshenv
│   ├── starship/.config/starship.toml
│   ├── alacritty/.config/alacritty/alacritty.toml
│   ├── tmux/.config/tmux/tmux.conf
│   ├── nvim/.config/nvim/...
│   ├── git/.gitconfig + .gitignore_global
│   ├── mise/.config/mise/config.toml
│   └── claude/.claude/    # Claude Code: settings, CLAUDE.md, hooks, skills
└── bin/                  # personal scripts → ~/.local/bin
    ├── feature
    └── tmux-sessionizer
```

## Stack

- **Shell:** zsh (bare, tuned for <70ms startup: static brew env, cached
  compinit, cached tool inits) + starship prompt + zsh-autosuggestions +
  zsh-syntax-highlighting + fzf + fzf-tab + zoxide + atuin (Ctrl-R history)
- **Terminal:** day to day inside [cmux](https://cmux.io); the Alacritty
  config (Tokyo Night Moon) is kept as the standalone fallback
- **Multiplexer:** tmux + TPM (`tmux-sensible`, `resurrect`, `continuum`);
  `Ctrl-a` prefix; `prefix + f` opens [sesh](https://github.com/joshmedeski/sesh)
  (zoxide-aware session picker), `prefix + F` the classic sessionizer
- **Editor:** Neovim + lazy.nvim — blink.cmp completion, conform.nvim
  format-on-save, nvim-lint, telescope (+ fzf-native, ui-select), treesitter
  (main branch + textobjects), LSP via Mason (Ruby, TypeScript, Go, Elixir,
  Lua), neo-tree, flash.nvim, nvim-surround, mini.ai, trouble.nvim, gitsigns,
  lualine, vim-tmux-navigator. Plugin versions pinned in `lazy-lock.json`.
  See [`docs/nvim.md`](docs/nvim.md).
- **Runtimes:** mise (configure in `stow/mise/.config/mise/config.toml`)
- **CLI:** ripgrep, fd, bat, eza, delta, difftastic, jq, yq, gh, lazygit,
  git-absorb, jj, btop, yazi (`y` cd-on-quit wrapper), dust, duf, sd,
  hyperfine, xh, glow, tree
- **Code search for agents:** [semble](https://github.com/MinishLab/semble) —
  installed via `uv tool install semble`, registered as a global Claude Code
  MCP server; usage lives in the `semble` skill so every session prefers it
  over `grep`+`Read` for semantic lookups.
- **Other:** Raycast, JetBrainsMono Nerd Font
- **AI assistant:** Claude Code with global `CLAUDE.md`, guardrail/format
  hooks, statusline, and language server plugins (Ruby, TypeScript/JS, Go).

## Claude Code setup

The `claude` stow package symlinks settings into `~/.claude/`:

| Path | What it is |
|------|-----------|
| `settings.json` | Global settings — model, permissions, sandbox, hooks, statusline |
| `CLAUDE.md` | Personal instructions injected into every session |
| `statusline.sh` | Status line: model \| dir (branch) \| context % \| session cost |
| `hooks/git-guardrail.sh` | PreToolUse hook — deterministically blocks force-push, `--no-verify`, amend-of-pushed, `reset --hard`, `clean -f` |
| `hooks/session-context.sh` | SessionStart (compact/resume only) — re-injects fresh git state after the built-in snapshot goes stale |
| `skills/semble/` | Code-search skill — call shapes and CLI usage for semble |

Hooks run harness-side and never enter model context; the only per-session
context cost of this package is CLAUDE.md plus one description line per
skill. Code formatting is deliberately **not** a global hook — that belongs
to each project's pre-commit/CI.

Per-machine overrides go in `~/.claude/settings.local.json` (untracked).

Auto-memory is on by default (Claude Code ≥ 2.1.59): per-project notes live in
`~/.claude/projects/<project>/memory/MEMORY.md` (first 200 lines load every
session; worktrees share the repo's memory dir). Monthly ritual: open `/memory`
in each active project and prune — stale facts accumulate otherwise. Opt a
sensitive repo out with `{"autoMemoryEnabled": false}` in its settings.

`install/post.sh` also runs `uv tool install semble` and `claude mcp add
semble -s user -- uvx --from "semble[mcp]" semble --include-text-files` (both
idempotent), so the semble CLI and its MCP server are available to every
Claude Code session.

Feature workflow is driven by `bin/feature` rather than slash commands:
`feature add <desc>` creates a worktree + tmux session and attaches;
`feature remove` tears it down.

## Personal config

`stow/git/.gitconfig` ships my identity. On a work machine, override it in
`~/.gitconfig.local` (loaded last, untracked):

```ini
[user]
	email = you@work.com
```

## Adding a new tool

1. Create `stow/<tool>/<path-relative-to-$HOME>/<config>`.
2. Append the package name to `STOW_PACKAGES` in the `Makefile`.
3. Add the brew formula/cask to `Brewfile`.
4. `make restow && make brew`.
