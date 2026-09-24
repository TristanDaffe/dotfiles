vim.loader.enable()

vim.g.mapleader = ' '
-- vimtex leader for Belgian keyboard layout
vim.g.maplocalleader = ','

-- nvim-tree replaces netrw; both would otherwise claim `nvim <dir>`.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('config.options')
require('config.keymaps')
require('config.autocmds')
-- Plugins are added and configured by plugin/NN-*.lua, sourced in order after this file.
