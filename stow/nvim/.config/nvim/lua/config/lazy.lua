local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "tokyonight-moon" } },
  -- No background update checker: plugins move only when lazy-lock.json is
  -- bumped on purpose. The checker ran git fetch for every plugin each hour
  -- in every open nvim and kept ~440 KB of heap per run for the life of the
  -- session.
  checker = { enabled = false },
})
