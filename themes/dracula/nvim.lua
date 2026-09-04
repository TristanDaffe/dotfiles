-- Dracula — Neovim
-- Sets the colorscheme and returns the lualine theme name.
require('dracula').setup({
    italic_comment = true,
    transparent_bg = false,
})
vim.cmd.colorscheme('dracula')
return 'dracula'
