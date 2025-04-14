vim.cmd("colorscheme kanagawa-wave")


-- vim.cmd("set expandtab") -- spaces instead of tab character
vim.opt.tabstop = 4      -- space count
vim.opt.softtabstop = 4  -- acts if spaces are tab characters
vim.opt.shiftwidth = 4   -- indentation space
vim.g.mapleader = ' ' -- set leader key as space
vim.api.nvim_create_user_command("Nohi", "nohlsearch", {})
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.conceallevel = 2
