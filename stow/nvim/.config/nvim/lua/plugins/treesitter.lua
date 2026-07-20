-- nvim-treesitter `main` rewrite: no configs.setup()/modules anymore.
-- Parsers install via ts.install(); highlight/indent start per buffer.
local parsers = {
  "bash", "regex",
  "json", "yaml", "toml",
  "markdown", "markdown_inline",
  "gitignore", "gitcommit", "git_rebase", "diff",
  "html", "css", "scss",
  "javascript", "typescript", "tsx", "jsdoc",
  "go", "gomod", "gowork", "gosum",
  "ruby", "embedded_template",
  "elixir", "heex", "eex",
  "dockerfile", "sql",
  "lua", "vim", "vimdoc", "query",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})
      ts.install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          -- start highlighting when a parser exists for this filetype
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Query definitions for @function.outer / @block.inner / @class.outer etc.
  -- mini.ai's gen_spec.treesitter and flash's treesitter search need these.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
  },
}
