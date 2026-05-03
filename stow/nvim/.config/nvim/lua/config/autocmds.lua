-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("trim_trailing_ws", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
