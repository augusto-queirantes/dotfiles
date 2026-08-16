-- Diagnostics come from nvim-lint (eslint_d) on write; this server is here for
-- the code actions it exposes -- source.fixAll.eslint and per-rule disables.
return {
  settings = {
    -- Resolve the nearest config from the file rather than the cwd. Without
    -- this, eslint silently reports nothing in a monorepo package.
    workingDirectories = { mode = "auto" },
    format = false, -- conform owns formatting (prettierd)
  },
  on_attach = function(_, bufnr)
    vim.keymap.set("n", "<leader>ce", "<cmd>LspEslintFixAll<cr>", {
      buffer = bufnr,
      desc = "LSP: ESLint fix all",
    })
  end,
}
