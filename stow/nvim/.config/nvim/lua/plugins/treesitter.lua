return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
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
    },
  },
}
