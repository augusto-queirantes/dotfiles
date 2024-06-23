vim.diagnostic.config({
	title = false,
	underline = true,
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = "if_many",
		style = "minimal",
		border = "rounded",
		header = "",
		prefix = "",
	},
})

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type

	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
