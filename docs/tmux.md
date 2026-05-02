# tmux

Personal tmux setup. Config lives at `stow/tmux/.config/tmux/tmux.conf` and is
symlinked to `~/.config/tmux/tmux.conf` by `make stow`.

> Prefix is **`Ctrl-a`** (not the default `Ctrl-b`).
> Below, **`p`** denotes the prefix — e.g. `p |` means `Ctrl-a` then `|`.

---

## First run

```bash
make restow            # symlink the new tmux.conf
tmux                   # start a session
# inside tmux: press `p I` (capital i) to install plugins via TPM
```

If `~/.config/tmux/plugins/tpm` is missing, run `bash install/post.sh` once.

---

## Cheatsheet

### Sessions

| Keys      | Action                                                          |
|-----------|-----------------------------------------------------------------|
| `p f`     | **Sessionizer popup** — fzf over `~/Personal`, `~/Work`, `~/dev`, plus existing sessions. Creates or switches. |
| `p s`     | Pick session (zoomed tree)                                      |
| `p w`     | Pick window (zoomed tree)                                       |
| `p S`     | Rename current session                                          |
| `p D`     | Detach client                                                   |
| `p Space` | Toggle last window                                              |

Closing the last window in a session jumps you to another session instead of
killing tmux (`detach-on-destroy off`).

### Windows

| Keys      | Action                            |
|-----------|-----------------------------------|
| `p c`     | New window in current pane's `$PWD` |
| `p ,` / `p W` | Rename window                |
| `p n` / `p p` | Next / previous window       |
| `p 1`..`p 9` | Jump to window by number      |
| `p X`     | Kill window                       |

Windows are **renumbered automatically** when one is killed.

### Panes — splits

| Keys      | Action                                  |
|-----------|-----------------------------------------|
| `p \|`    | Split right (vertical), inherit `$PWD`  |
| `p -`     | Split down (horizontal), inherit `$PWD` |
| `p \\`    | Full-width vertical split               |
| `p _`     | Full-height horizontal split            |
| `p x`     | Kill pane                               |
| `p z`     | Zoom / unzoom current pane              |
| `p Space` | Cycle pane layout                       |
| `p >` / `p <` | Swap pane forward / back            |
| `p q`     | Show pane numbers (then digit to jump)  |

### Panes — navigation (no prefix needed)

`Ctrl-h/j/k/l` are **smart-aware** via `vim-tmux-navigator`: inside Neovim they
move between vim splits; outside they move between tmux panes. Same keystroke,
no context switch.

| Keys         | Action       |
|--------------|--------------|
| `Ctrl-h`     | Pane left    |
| `Ctrl-j`     | Pane down    |
| `Ctrl-k`     | Pane up      |
| `Ctrl-l`     | Pane right   |
| `Ctrl-\`     | Last pane    |
| `p Ctrl-l`   | Clear screen (since `Ctrl-l` alone is stolen for "pane right") |

### Panes — resize

| Keys                         | Action            |
|------------------------------|-------------------|
| `Alt-←` / `Alt-↓` / `Alt-↑` / `Alt-→` | Resize (no prefix) |
| `p H` / `p J` / `p K` / `p L`         | Resize (repeatable while prefix held) |

Alt works because Alacritty has `option_as_alt = "Both"`.

### Copy mode (vi)

| Keys              | Action                                |
|-------------------|---------------------------------------|
| `p [` or `p Enter` | Enter copy mode                      |
| `v`               | Begin selection                       |
| `V`               | Line selection                        |
| `Ctrl-v`          | Toggle rectangle selection            |
| `y` or `Enter`    | Copy to system clipboard (`pbcopy`) and exit |
| `q`               | Quit copy mode                        |
| `/` `?`           | Search forward / backward             |
| `n` `N`           | Next / previous match                 |
| `p p`             | Paste latest buffer                   |
| `p P`             | Choose paste buffer                   |

Mouse selection auto-copies to the system clipboard on release. `set-clipboard
on` + Alacritty's `osc52 = "CopyPaste"` mean clipboard sync works **even over
SSH**.

### Popups

| Keys  | Action                                            |
|-------|---------------------------------------------------|
| `p f` | Sessionizer (fzf project picker)                  |
| `p g` | Lazygit, scoped to the pane's `$PWD`              |
| `p !` | Scratch shell, scoped to the pane's `$PWD`        |
| `p u` | Pick a URL from the current pane (fzf) and open it |

### Misc

| Keys  | Action                          |
|-------|---------------------------------|
| `p r` | Reload `tmux.conf`              |
| `p e` | Edit `tmux.conf` in a new window |
| `p I` | TPM: install missing plugins    |
| `p U` | TPM: update plugins             |
| `p alt-u` | TPM: uninstall plugins not in conf |
| `p :` | Tmux command prompt             |
| `p ?` | List every binding              |

---

## Plugins (TPM)

| Plugin | What it does |
|--------|--------------|
| [`tpm`](https://github.com/tmux-plugins/tpm) | Plugin manager. |
| [`tmux-sensible`](https://github.com/tmux-plugins/tmux-sensible) | Sane baseline (history, focus-events, etc.). |
| [`vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator) | `Ctrl-hjkl` across vim and tmux. |
| [`tmux-yank`](https://github.com/tmux-plugins/tmux-yank) | Better clipboard integration. |
| [`tmux-resurrect`](https://github.com/tmux-plugins/tmux-resurrect) | Save and restore sessions, panes, working dirs. Captures pane contents and restores `nvim` sessions. |
| [`tmux-continuum`](https://github.com/tmux-plugins/tmux-continuum) | Auto-saves every 15 min and auto-restores on first tmux start. |
| [`tmux-fzf-url`](https://github.com/wfxr/tmux-fzf-url) | `p u` → fuzzy-pick a URL from the pane and open it. |

### Resurrect — manual save/restore

| Keys              | Action  |
|-------------------|---------|
| `p Ctrl-s`        | Save   |
| `p Ctrl-r`        | Restore |

Snapshots live in `~/.local/share/tmux/resurrect/` (or
`~/.tmux/resurrect/` on older versions).

---

## Sessionizer (`bin/tmux-sessionizer`)

`p f` opens an fzf popup that lists:

1. `Create new session...` (prompt for a name)
2. Existing tmux sessions (current session shown last)
3. Git repositories under `~/Personal`, `~/Work`, `~/dev` (depth ≤ 3)
4. Top-level directories under those roots

Selecting an existing session **switches** to it; selecting a directory creates
a session named after the basename (with `.` → `_`) and `cd`s into it. The
script is symlinked to `~/.local/bin/tmux-sessionizer` by `make bin`, so it's
also runnable from a plain shell — handy for `alacritty -e tmux-sessionizer`.

To change search roots, edit the `ROOTS=( ... )` array at the top of
`bin/tmux-sessionizer`.

---

## Status bar

Tokyo Night Moon, top of screen:

```
[ session ]  1:nvim  2:shell  3:logs                 PREFIX  hostname │ Fri 02 May │ 14:23
```

- Left: current session name (purple).
- Middle: window list. Active window highlighted blue; activity in other
  windows yellow; bell red.
- Right: red `PREFIX` indicator while prefix is held, hostname, date, time.

Refresh interval: 5s.

---

## Notable defaults

| Setting | Value | Why |
|---------|-------|-----|
| `prefix` | `C-a` | `C-Space` collides with Raycast's macOS global hotkey; `C-a` is the de-facto tmux/screen alternative. Shadows readline's beginning-of-line — use `Home`, or `p a` to send a literal `C-a`. |
| `base-index` / `pane-base-index` | `1` | Matches the keyboard row. |
| `renumber-windows` | `on` | No gaps after closing a window. |
| `escape-time` | `10ms` | Snappy ESC for nvim, but not so low it breaks SSH. |
| `history-limit` | `100000` | Long-lived scrollback per pane. |
| `mouse` | `on` | Click to focus, drag to resize, drag-select to copy. |
| `set-clipboard` | `on` | OSC 52 — clipboard works inside SSH. |
| `focus-events` | `on` | nvim `autoread` and gitsigns refresh on pane focus. |
| `aggressive-resize` | `on` | A pane resizes only when the active client looks at it. |
| `detach-on-destroy` | `off` | Closing the last window in a session jumps to another session instead of killing tmux. |
| `default-terminal` | `tmux-256color` + `RGB` overrides | True color and italics. |

---

## Troubleshooting

**Plugins didn't load.** Run `p I` once. If TPM itself is missing:
`git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`.

**Colors look washed out.** Verify the terminal advertises true color:
`tmux info | grep -i Tc` should show `Tc: (flag) true`.

**`Ctrl-hjkl` doesn't move panes.** The plugin must be installed (`p I`) and
the Neovim side (`christoomey/vim-tmux-navigator`) is already wired in
`stow/nvim/lua/plugins/misc.lua`.

**Clipboard doesn't sync over SSH.** The remote terminal (or the local one
hosting the SSH client) needs OSC 52 enabled. Alacritty does this with
`osc52 = "CopyPaste"`. tmux side: `set-clipboard on` (already set).

**Reload config without restarting:** `p r`.

**Kill the server entirely:** `tmux kill-server`.
