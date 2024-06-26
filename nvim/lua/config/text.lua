local vim_options = vim.o

-- Sets tab as it should
vim_options.tabstop = 2
vim_options.softtabstop = 2
vim_options.shiftwidth = 2
vim_options.expandtab = true
vim_options.smartindent = true

-- Sets line break on 1000 characters
vim_options.lbr = true
vim_options.tw = 1000

-- Encoding
vim_options.encoding = "utf-8"
vim_options.fileencoding = "utf-8"
vim_options.fileencodings = "utf-8"
