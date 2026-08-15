-- The launch command is NOT set here: nvim-lspconfig ships its own
-- lsp/ruby_lsp.lua and wins the runtimepath merge, so a `cmd` in this file is
-- replaced by its plain `{ "ruby-lsp" }`. It is applied through
-- vim.lsp.config() in lua/plugins/lsp.lua instead; the reasoning lives in
-- lua/config/ruby_lsp_cmd.lua.
--
-- Rails support needs no config here: ruby-lsp activates its Rails addon
-- automatically when the project's Gemfile carries `ruby-lsp-rails`.
return {
  filetypes = { "ruby", "eruby" },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop" },
  },
}
