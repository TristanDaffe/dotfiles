-- Gruvbox Dark (medium) — Neovim
-- Sets the colorscheme and returns the lualine theme name.
require('gruvbox').setup({
    contrast = 'medium',
    bold = true,
    italic = { strings = false, comments = false, folds = false, emphasis = false, operators = false },
    dim_inactive = false,
    transparent_mode = false,
})
vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')
return 'gruvbox'
