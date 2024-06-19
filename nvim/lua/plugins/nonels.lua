return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"jay-babu/mason-null-ls.nvim",
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local null_ls_utils = require("null-ls.utils")
			local mason_null_ls = require("mason-null-ls")

			mason_null_ls.setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"eslint",
				},
			})

			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			local code_actions = null_ls.builtins.code_actions

			null_ls.setup({
				root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),

				sources = {
					formatting.prettier,
					formatting.stylua,
					diagnostics.eslint,
					code_actions.gitsigns,
				},
			})
		end,
	},
}
