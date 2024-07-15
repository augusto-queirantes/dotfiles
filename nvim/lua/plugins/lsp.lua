return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/lazydev.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local servers = { "lua_ls", "tsserver" }

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

		-- Elixirls must be handled different because the lsp server is installed manually
		require("lspconfig")["elixirls"].setup({
			capabilities = capabilities,
			cmd = { "/home/augusto/.elixirls/language_server.sh" },
		})
	end,
}
