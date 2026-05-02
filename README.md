# dotfiles

Personal macOS dev environment. One command on a fresh machine, everything is set up.

## Quick start

```bash
git clone <this repo> ~/Personal/dotfiles
cd ~/Personal/dotfiles
make setup
```

Reopen the terminal afterwards. Inside `tmux`, press `prefix + I` (Ctrl-Space, then `I`) to install tmux plugins. Open `nvim` once — lazy.nvim auto-installs plugins.

## What `make setup` does

1. Installs Xcode Command Line Tools (if missing).
2. Installs Homebrew (if missing).
3. `brew bundle` — installs every CLI/cask/font in `Brewfile`.
4. `stow` — symlinks every `stow/<pkg>/` into `$HOME`.
5. Symlinks `bin/*` into `~/.local/bin`.
6. Applies macOS defaults (`install/macos.sh`).
7. Post-install: TPM, mise runtimes, sets zsh as default shell.

## Make targets

| Target    | Purpose |
|-----------|---------|
| `setup`   | Full bootstrap — what you run on a fresh Mac. |
| `brew`    | Run `brew bundle`. |
| `stow`    | Symlink every package into `$HOME`. |
| `restow`  | Re-link after adding/renaming files. |
| `unstow`  | Remove all symlinks. |
| `bin`     | Symlink `bin/*` into `~/.local/bin`. |
| `macos`   | Apply macOS defaults. |
| `post`    | Re-run post-install steps. |

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
├── install/
│   ├── bootstrap.sh      # xcode + brew + brew bundle
│   ├── macos.sh          # macOS defaults
│   └── post.sh           # TPM, mise, default shell
├── stow/                 # each subdir is a stow package
│   ├── zsh/.zshrc
│   ├── starship/.config/starship.toml
│   ├── alacritty/.config/alacritty/alacritty.toml
│   ├── tmux/.config/tmux/tmux.conf
│   ├── nvim/.config/nvim/...
│   ├── git/.gitconfig + .gitignore_global
│   ├── mise/.config/mise/config.toml
│   └── aerospace/.config/aerospace/aerospace.toml
└── bin/                  # personal scripts → ~/.local/bin
    └── tmux-sessionizer
```

## Stack

- **Shell:** zsh (bare) + starship prompt + zsh-autosuggestions + zsh-syntax-highlighting + fzf + zoxide
- **Terminal:** Alacritty (Tokyo Night Moon)
- **Multiplexer:** tmux + TPM (`tmux-sensible`, `resurrect`, `continuum`); `Ctrl-Space` prefix; `prefix + f` opens the sessionizer
- **Editor:** Neovim + lazy.nvim (telescope, treesitter, LSP via Mason, gitsigns, lualine, vim-tmux-navigator)
- **Runtimes:** mise (configure in `stow/mise/.config/mise/config.toml`)
- **CLI:** ripgrep, fd, bat, eza, delta, jq, yq, gh, lazygit, btop, tree
- **Window manager:** AeroSpace (alt+hjkl focus, alt+1..9 workspaces)
- **Other:** Raycast, JetBrainsMono Nerd Font

## Personal config

`stow/git/.gitconfig` does not set `user.name` / `user.email`. Set them per machine:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## Adding a new tool

1. Create `stow/<tool>/<path-relative-to-$HOME>/<config>`.
2. Append the package name to `STOW_PACKAGES` in the `Makefile`.
3. Add the brew formula/cask to `Brewfile`.
4. `make restow && make brew`.
