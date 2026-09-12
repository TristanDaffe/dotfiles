-- Tokyo Night Moon — Neovim
-- Sets the colorscheme and returns the lualine theme name.
require('tokyonight').setup({
    style = 'night',
    transparent = false,
    dim_inactive = true,
    lualine_bold = true,
})
vim.cmd.colorscheme('tokyonight-night')
return 'tokyonight'
