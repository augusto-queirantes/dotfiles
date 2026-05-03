return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        go = { "golangcilint" },
      }

      local group = vim.api.nvim_create_augroup("user_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = group,
        callback = function() lint.try_lint() end,
      })

      vim.keymap.set("n", "<leader>cl", function() lint.try_lint() end, { desc = "Lint buffer" })
    end,
  },
}
