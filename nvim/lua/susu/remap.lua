vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>cs", ":nohl<CR>")
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "<leader>m", ":Mason<CR>")
vim.keymap.set("i", "<C-BS>", "<C-W>")

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<F5>", ":setlocal spell! spelllang=fr<CR>")
