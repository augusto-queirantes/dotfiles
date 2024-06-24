return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lspsaga").setup({
			lightbulb = {
				sign = false,
			},
			symbol_in_winbar = {
				enable = false,
			},
		})

		vim.keymap.set("n", "<leader>a", ":Lspsaga code_action<CR>")
		vim.keymap.set("n", "<S-K>", ":Lspsaga hover_doc<CR>")
		vim.keymap.set("n", "<leader>o", ":Lspsaga outline<CR>")
		vim.keymap.set("n", "<leader>f", ":Lspsaga finder<CR>")
		vim.keymap.set("n", "<leader>i", ":Lspsaga finder imp<CR>")
	end,
}
