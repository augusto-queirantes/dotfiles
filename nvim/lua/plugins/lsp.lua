return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/lazydev.nvim",
		"b0o/schemastore.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = { "typos_lsp", "elixirls", "lua_ls" },
		})

		require("lazydev").setup()

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("lspconfig").typos_lsp.setup({
			capabilities = capabilities,
		})

		require("lspconfig").elixirls.setup({
			capabilities = capabilities,
		})

		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
		})
	end,
}
