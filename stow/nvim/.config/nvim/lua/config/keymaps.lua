local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Fast save / quit (muscle memory)
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<C-q>", "<cmd>q<cr>", { desc = "Quit" })

-- System clipboard copy / paste (alongside unnamedplus default)
map("v", "<C-c>", '"+y',         { desc = "Copy to system clipboard" })
map("i", "<C-v>", "<C-r><C-o>+", { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })

-- Move lines
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better paste over selection
map("x", "<leader>p", [["_dP]])
