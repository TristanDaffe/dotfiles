vim.pack.add({
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
    { src = 'https://github.com/EdenEast/nightfox.nvim' },
    { src = 'https://github.com/Mofiqul/dracula.nvim' },
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },

    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
})

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

-- Colorscheme: whatever ~/.config/themes/current points at.
-- Switch with `~/.config/themes/theme-set <name>`.
require('util.theme').setup({
    lualine = {
        options = {
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            globalstatus = true,
        },
    },
})
