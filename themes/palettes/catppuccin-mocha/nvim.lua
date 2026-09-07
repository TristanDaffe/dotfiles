-- Catppuccin Mocha — Neovim
-- Sets the colorscheme and returns the lualine theme name.
require('catppuccin').setup({
    flavour = 'mocha',
    dim_inactive = { enabled = true },
    integrations = {
        cmp = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        native_lsp = { enabled = true },
    },
})
vim.cmd.colorscheme('catppuccin-mocha')
return 'catppuccin'
