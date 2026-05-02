return {
  { "lewis6991/gitsigns.nvim",     event = "BufReadPre", opts = {} },
  { "windwp/nvim-autopairs",       event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim",       event = "BufReadPost", opts = {} },
  { "folke/which-key.nvim",        event = "VeryLazy",    opts = {} },
  { "nvim-lualine/lualine.nvim",   opts = { options = { theme = "tokyonight" } } },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp",   "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },
}
