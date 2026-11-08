-- Rex config, migrated from tmux (~/.config/tmux/tmux.conf) and Ghostty.

-- cmd+k clears the terminal; the session picker moves to shift+cmd+k.
rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("shift+cmd+k", "session.switch")

-- tmux prefix ctrl+a
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })
rex.bind("ctrl+a>a", "pane.send_key", { key = "ctrl+a" })

-- Reload / edit conf
rex.bind("ctrl+a>r", "client.config.reload")
rex.bind("ctrl+a>e", "client.tab.new")

-- Splits & windows
rex.bind("ctrl+a>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>shift+-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>x", "pane.close")
rex.bind("ctrl+a>shift+x", "client.tab.close")

rex.bind("ctrl+a>ctrl+l", "pane.send_key", { key = "ctrl+l" })

-- Pane resize (bind -r: plain sequence plus repeat mode)
rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+a>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")

rex.bind("ctrl+a>shift+h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("repeat/shift+h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("ctrl+a>shift+j", "pane.resize", { amount = 3, direction = "down" })
rex.bind("repeat/shift+j", "pane.resize", { amount = 3, direction = "down" })
rex.bind("ctrl+a>shift+k", "pane.resize", { amount = 3, direction = "up" })
rex.bind("repeat/shift+k", "pane.resize", { amount = 3, direction = "up" })
rex.bind("ctrl+a>shift+l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("repeat/shift+l", "pane.resize", { amount = 5, direction = "right" })

rex.bind("alt+left", "pane.resize", { amount = 5, direction = "left" })
rex.bind("alt+down", "pane.resize", { amount = 3, direction = "down" })
rex.bind("alt+up", "pane.resize", { amount = 3, direction = "up" })
rex.bind("alt+right", "pane.resize", { amount = 5, direction = "right" })

-- Swap panes
rex.bind("ctrl+a>shift+.", "pane.move", { direction = "down" })
rex.bind("ctrl+a>shift+,", "pane.move", { direction = "up" })

-- Sessions
rex.bind("ctrl+a>s", "session.switch")
rex.bind("ctrl+a>w", "session.switch")
rex.bind("ctrl+a>shift+s", "session.rename")
rex.bind("ctrl+a>shift+w", "client.tab.rename")
