local global_variables = vim.g
local vim_options = vim.o

-- Leaderkey
global_variables.mapleader = " "

-- Shows line number
vim_options.number = true

-- Allows mouse usage
vim_options.mouse = "a"

-- Shows commands preview in a split pane
vim_options.inccommand = "split"

-- Allows regex to work properly when searching
vim_options.magic = true

-- Highlights current line
vim_options.cursorline = true

-- Allows ctrl-c usage
vim_options.clipboard = "unnamedplus"

-- Allows undo
vim_options.undofile = true

-- Use termguicolors
vim_options.termguicolors = true
