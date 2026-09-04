-- Duskfox — Neovim
-- Sets the colorscheme and returns the lualine theme name.
require('nightfox').setup({
    options = { dim_inactive = true, styles = { comments = 'italic' } },
})
vim.cmd.colorscheme('duskfox')
return 'duskfox'
