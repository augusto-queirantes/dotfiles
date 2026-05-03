# nvim

Personal Neovim setup. Config lives at `stow/nvim/.config/nvim/` and is
symlinked to `~/.config/nvim/` by `make stow`.

> Leader is **Space** (both `mapleader` and `maplocalleader`).
> Below, **`<leader>`** means Space — e.g. `<leader>ff` is `Space` then `f` then `f`.

---

## First run

```bash
make restow            # symlink config
nvim                   # lazy.nvim bootstraps and installs plugins
# inside nvim:
:Mason                 # watch LSPs / formatters / linters install
:checkhealth           # verify externals (node, ruby, go, elixir, …)
```

Plugin lock state lives in `stow/nvim/.config/nvim/lazy-lock.json`. Update with
`:Lazy update` and commit the lockfile.

Language runtimes are managed by **mise** — set what you need in
`stow/mise/.config/mise/config.toml` (or per-project `mise.toml`).

---

## Layout

```
stow/nvim/.config/nvim/
├── init.lua                       # bootstraps options/keymaps/autocmds/lazy
├── lazy-lock.json                 # plugin version lockfile
├── lsp/                           # Neovim 0.11+ per-server configs
│   ├── lua_ls.lua
│   ├── ruby_lsp.lua
│   ├── vtsls.lua
│   ├── gopls.lua
│   └── lexical.lua
└── lua/
    ├── config/
    │   ├── options.lua            # vim.opt.* settings
    │   ├── keymaps.lua            # global keymaps
    │   ├── autocmds.lua           # global autocmds
    │   └── lazy.lua               # lazy.nvim bootstrap
    └── plugins/
        ├── colorscheme.lua        # tokyonight-moon
        ├── completion.lua         # blink.cmp + friendly-snippets
        ├── editor.lua             # surround / flash / oil / todo / mini.ai / trouble / ts-autotag
        ├── formatting.lua         # conform.nvim + format-on-save
        ├── linting.lua            # nvim-lint
        ├── lsp.lua                # mason + mason-lspconfig + LspAttach
        ├── misc.lua               # gitsigns / autopairs / comment / which-key / lualine / tmux-nav
        ├── telescope.lua          # + fzf-native + ui-select
        └── treesitter.lua
```

---

## Cheatsheet

### File / window

| Keys              | Action                              |
|-------------------|-------------------------------------|
| `<leader>w` / `<C-s>` | Save                            |
| `<leader>q` / `<C-q>` | Quit                            |
| `<Esc>`           | Clear search highlight              |
| `<C-h/j/k/l>`     | Move between splits **and** tmux panes (vim-tmux-navigator) |

### Editing

| Keys              | Action                                            |
|-------------------|---------------------------------------------------|
| `J` / `K` (visual) | Move selected lines down / up                    |
| `<C-d>` / `<C-u>` | Half-page down/up, cursor stays centered          |
| `n` / `N`         | Next / prev search match, centered                |
| `<leader>p` (visual) | Paste over selection without clobbering register |
| `<C-c>` (visual)  | Copy to system clipboard                          |
| `<C-v>` (insert)  | Paste from system clipboard                       |
| `<C-v>` (n/v)     | Paste from system clipboard *(shadows visual-block — see Troubleshooting)* |

### Surround (`nvim-surround`)

| Keys      | Action                                |
|-----------|---------------------------------------|
| `ysiw"`   | Wrap inner-word in `"…"`              |
| `ys$)`    | Wrap rest-of-line in `(…)`            |
| `cs"'`    | Change surrounding `"` to `'`         |
| `ds"`     | Delete surrounding `"`                |
| `S"` (visual) | Surround selection with `"`        |

### Text objects (mini.ai + treesitter)

| Object | Inner / Around                          |
|--------|------------------------------------------|
| `f`    | `vif` / `vaf` — function                 |
| `c`    | `vic` / `vac` — class                    |
| `o`    | `vio` / `vao` — block / conditional / loop |

Plus all builtin objects: `iw`, `ip`, `i"`, `i(`, `it` (HTML tag), etc.

### Motion (`flash.nvim`)

| Keys (n/x/o)  | Action                       |
|---------------|------------------------------|
| `s`           | Flash jump (label-based)     |
| `S`           | Flash treesitter (jump to nodes) |
| `r` (operator-pending) | Remote flash       |
| `R` (operator/visual)  | Treesitter search  |

### Treesitter selection

| Keys        | Action                          |
|-------------|---------------------------------|
| `<C-Space>` | Init / grow incremental selection |
| `<BS>`      | Shrink selection                |

### LSP

| Keys                  | Action                              |
|-----------------------|-------------------------------------|
| `gd` / `gD`           | Goto definition / declaration       |
| `gr`                  | References                          |
| `gI`                  | Implementations                     |
| `gy`                  | Type definition                     |
| `K`                   | Hover docs                          |
| `<C-k>` (insert)      | Signature help                      |
| `<leader>rn`          | Rename symbol                       |
| `<leader>ca` (n/v)    | Code action                         |
| `<leader>cd`          | Line diagnostics float              |
| `[d` / `]d`           | Prev / next diagnostic              |
| `<leader>uh`          | Toggle inlay hints                  |

### Format / lint

| Keys           | Action                                   |
|----------------|------------------------------------------|
| `<leader>cf`   | Format buffer (`conform.nvim`, async)    |
| `<leader>cl`   | Lint buffer now (`nvim-lint`)            |
| `:FormatDisable` / `:FormatDisable!` | Disable autoformat globally / for buffer |
| `:FormatEnable`                      | Re-enable autoformat            |

Format-on-save runs automatically unless disabled.

### Telescope

| Keys           | Action                              |
|----------------|-------------------------------------|
| `<leader>ff`   | Find files                          |
| `<leader>fg`   | Live grep                           |
| `<leader>fb`   | Buffers                             |
| `<leader>fr`   | Recent files                        |
| `<leader>fh`   | Help tags                           |
| `<leader>fd`   | Diagnostics                         |
| `<leader>fs` / `<leader>fS` | Document / workspace symbols |
| `<leader>fk`   | Keymaps                             |
| `<leader>fc`   | Commands                            |
| `<leader>f/`   | Fuzzy search in current buffer      |
| `<leader>fw`   | Grep word under cursor              |
| `<leader>ft`   | Find todos                          |
| `<leader>gs` / `<leader>gc` | Git status / commits   |

Inside the picker: `<C-j>`/`<C-k>` move selection, `<C-q>` send to quickfix,
`<Esc>` close.

### File explorer (`oil.nvim`)

| Keys           | Action                              |
|----------------|-------------------------------------|
| `-`            | Open parent directory as a buffer   |
| `<leader>e`    | Open Oil in current file's dir      |
| `q` (in Oil)   | Close                               |

Oil **edits the filesystem like a buffer** — rename a file by editing the line
and `:w`. Delete by removing the line. Create by adding a line.

### Diagnostics list (`trouble.nvim`)

| Keys           | Action                              |
|----------------|-------------------------------------|
| `<leader>xx`   | Toggle workspace diagnostics        |
| `<leader>xX`   | Toggle current-buffer diagnostics   |
| `<leader>xs`   | Toggle symbol outline               |
| `<leader>xL` / `<leader>xQ` | Location / quickfix list |

### Todo comments

| Keys           | Action                              |
|----------------|-------------------------------------|
| `]t` / `[t`    | Next / prev TODO/FIXME/HACK marker  |
| `<leader>ft`   | Telescope picker over all todos     |

---

## Plugins

Loaded via [`lazy.nvim`](https://github.com/folke/lazy.nvim).

| Plugin | Purpose |
|--------|---------|
| [`tokyonight.nvim`](https://github.com/folke/tokyonight.nvim) | Colorscheme — `tokyonight-moon`. |
| [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax + indent + selection via tree-sitter parsers. |
| [`nvim-ts-autotag`](https://github.com/windwp/nvim-ts-autotag) | Auto-close JSX/TSX/HTML/HEEX tags. |
| [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy picker. With `fzf-native` (fast sort) and `ui-select` (uses Telescope as the picker for code actions etc). |
| [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) | LSP client glue. Per-server config in `lsp/<name>.lua`. |
| [`mason.nvim`](https://github.com/mason-org/mason.nvim) + [`mason-lspconfig.nvim`](https://github.com/mason-org/mason-lspconfig.nvim) | Installs LSP servers; `automatic_enable` calls `vim.lsp.enable` for each. |
| [`mason-tool-installer.nvim`](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Keeps formatters/linters installed. |
| [`blink.cmp`](https://github.com/saghen/blink.cmp) | Completion (Rust-backed). Pulls `friendly-snippets`. |
| [`conform.nvim`](https://github.com/stevearc/conform.nvim) | Formatter framework, format-on-save. |
| [`nvim-lint`](https://github.com/mfussenegger/nvim-lint) | Linter framework. |
| [`nvim-surround`](https://github.com/kylechui/nvim-surround) | Surround text-object operations. |
| [`flash.nvim`](https://github.com/folke/flash.nvim) | Label-based jump motions. |
| [`oil.nvim`](https://github.com/stevearc/oil.nvim) | Edit the filesystem like a buffer. |
| [`todo-comments.nvim`](https://github.com/folke/todo-comments.nvim) | Highlight + search TODO/FIXME/HACK. |
| [`mini.ai`](https://github.com/echasnovski/mini.ai) | Smarter text objects (treesitter-aware). |
| [`trouble.nvim`](https://github.com/folke/trouble.nvim) | Diagnostics / symbols / quickfix list. |
| [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) | Git hunks in the sign column. |
| [`nvim-autopairs`](https://github.com/windwp/nvim-autopairs) | Auto-close brackets/quotes. |
| [`Comment.nvim`](https://github.com/numToStr/Comment.nvim) | `gcc` / `gc` to toggle comments. |
| [`which-key.nvim`](https://github.com/folke/which-key.nvim) | Show pending keymaps after leader. |
| [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) | Status line — Tokyo Night theme. |
| [`vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator) | `<C-h/j/k/l>` traverses vim splits **and** tmux panes. |

---

## Languages

LSPs install via Mason; formatters/linters install via mason-tool-installer.

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| **Lua**        | `lua_ls`    | `stylua`               | (LSP) |
| **Ruby**       | `ruby_lsp`  | `rubocop`              | `rubocop` (via ruby_lsp) |
| **TypeScript / JS** | `vtsls` | `prettierd`            | `eslint_d` |
| **Go**         | `gopls`     | `goimports` + `gofumpt` | `golangci-lint` |
| **Elixir**     | `lexical`   | `mix format`           | (LSP) |
| **Markdown / JSON / YAML / HTML / CSS** | — | `prettierd` | — |

Adding a language:

1. Add the LSP name to the `servers` table in `lua/plugins/lsp.lua` and create
   `lsp/<name>.lua` with the per-server config.
2. Add the formatter to `formatters_by_ft` in `lua/plugins/formatting.lua` and
   to the `tools` list in `lua/plugins/lsp.lua` (so mason installs it).
3. Add the linter to `linters_by_ft` in `lua/plugins/linting.lua` and to the
   `tools` list in `lua/plugins/lsp.lua`.
4. Add tree-sitter parsers to `lua/plugins/treesitter.lua`.
5. Make sure the runtime is on `mise` (or `PATH`).

---

## Notable defaults

| Setting | Value | Why |
|---------|-------|-----|
| `clipboard` | `unnamedplus` | All yanks/puts use the system clipboard by default. |
| `relativenumber` | `true` | Easy `5j` / `12k` motions. |
| `signcolumn` | `yes` | No layout shift when diagnostics/git signs appear. |
| `scrolloff` / `sidescrolloff` | `8` | Cursor never sits at the edge. |
| `undofile` | `true` | Persistent undo across sessions. |
| `swapfile` / `backup` | `false` | undofile is enough; less filesystem noise. |
| `ignorecase` + `smartcase` | on | Case-insensitive unless you type a capital. |
| `splitright` / `splitbelow` | on | Splits open where you'd expect. |
| `updatetime` | `250` | Faster CursorHold (LSP highlight, gitsigns). |
| `timeoutlen` | `300` | Snappier which-key popup. |
| `expandtab` + `shiftwidth=2` | on | 2-space indent default; treesitter handles per-language. |
| Format-on-save | on | Disable per-buffer with `:FormatDisable!`, globally with `:FormatDisable`. |
| Inlay hints | auto-on per LSP | Toggle with `<leader>uh`. |
| Trim trailing whitespace | on | `BufWritePre` autocmd, runs in addition to formatters. |

---

## Troubleshooting

**A plugin didn't load.** `:Lazy` shows status; `:Lazy sync` reinstalls.

**An LSP isn't running.** `:LspInfo` shows attached clients and root_dir.
`:Mason` confirms the server is installed; `:checkhealth lsp` checks the
runtime. Make sure the project's runtime (Ruby/Node/Go/Elixir) is on `PATH` —
`mise current` in the project dir.

**Format-on-save is stomping on my code.** Run `:FormatDisable!` for the buffer
or `:FormatDisable` globally. To opt a filetype out permanently, remove it from
`formatters_by_ft` in `lua/plugins/formatting.lua`.

**`vtsls` is slow on a large monorepo.** Set `tsserver.maxTsServerMemory` and
`tsserver.useSyntaxServer` in `lsp/vtsls.lua`. Restart with `:LspRestart`.

**`<C-h/j/k/l>` doesn't cross into tmux.** The tmux side needs
`vim-tmux-navigator` plugin installed (`prefix + I` in tmux). See
`docs/tmux.md`.

**Colors look wrong inside tmux.** Verify true color: `:checkhealth` →
"termguicolors". The tmux config already sets `default-terminal` and `RGB`
overrides.

**`s` doesn't substitute a character anymore.** Flash took it. Use `cl` to
delete-and-insert one char, or remap `s` in `lua/plugins/editor.lua`.

**Mason can't install a tool.** `:checkhealth mason` lists missing externals
(usually `node`, `cargo`, `go`, or `python`). Install via mise or brew.

**Reload config without restarting.** `:source %` for the current file, or
just relaunch — startup is fast.

**Visual-block mode.** `<C-v>` is remapped to "paste from system clipboard",
which shadows the default visual-block trigger. Either remove the normal-mode
mapping in `lua/config/keymaps.lua`, or add a binding like
`map("n", "<leader>v", "<C-v>")` for visual-block entry.
