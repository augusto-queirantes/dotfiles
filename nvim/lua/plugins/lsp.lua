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
		local servers = { "typos_lsp", "elixirls", "lua_ls" }
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = servers,
		})

		require("lazydev").setup()

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		for _, server in pairs(servers) do
			require("lspconfig")[server].setup({
				capabilities = capabilities,
			})
		end
	end,
}
