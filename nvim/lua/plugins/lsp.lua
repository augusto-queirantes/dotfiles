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
			ensure_installed = vim.tbl_keys(require("lsp.servers")),
		})

		require("lazydev").setup()

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					settings = require("lsp.servers")[server_name],
					filetypes = (require("lsp.servers")[server_name] or {}).filetypes,
				})
			end,
		})
	end,
}
