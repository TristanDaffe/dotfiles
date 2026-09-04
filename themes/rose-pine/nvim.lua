-- Rose Pine (main) — Neovim
-- Sets the colorscheme and returns the lualine theme name.
require('rose-pine').setup({
    variant = 'main',
    dark_variant = 'main',
    dim_inactive_windows = true,
    styles = { italic = false, transparency = false },
})
vim.cmd.colorscheme('rose-pine')
return 'rose-pine'
