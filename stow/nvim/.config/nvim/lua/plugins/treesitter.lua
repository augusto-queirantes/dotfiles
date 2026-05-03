return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua", "luadoc", "vim", "vimdoc", "query",
        "bash", "regex",
        "json", "jsonc", "yaml", "toml",
        "markdown", "markdown_inline",
        "gitignore", "gitcommit", "git_rebase", "diff",
        "html", "css", "scss",
        "javascript", "typescript", "tsx", "jsdoc",
        "go", "gomod", "gowork", "gosum",
        "ruby", "embedded_template",
        "elixir", "heex", "eex",
        "dockerfile", "sql",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
