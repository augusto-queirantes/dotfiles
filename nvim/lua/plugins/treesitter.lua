return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local config = require("nvim-treesitter.configs")
			---@diagnostic disable-next-line: missing-fields
			config.setup({
				highlight = {
					enable = true,
				},
				indent = {
					enable = false,
				},
				sync_install = false,
				auto_install = true,
				ensure_installed = {
					"html",
					"javascript",
					"json",
					"lua",
					"tsx",
					"typescript",
					"vim",
					"elixir",
				},
			})
		end,
	},
}
