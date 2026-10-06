vim.loader.enable()

vim.g.mapleader = ' '
-- vimtex leader for Belgian keyboard layout
vim.g.maplocalleader = ','

-- nvim-tree replaces netrw; both would otherwise claim `nvim <dir>`.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Shared by several plugin/ files, so added before any of them.
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Options, keymaps, autocmds and plugins live in plugin/NN-*.lua, sourced in order after this file.
