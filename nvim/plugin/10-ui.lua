vim.pack.add({
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
    { src = 'https://github.com/EdenEast/nightfox.nvim' },
    { src = 'https://github.com/Mofiqul/dracula.nvim' },
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },

    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
})

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

require('mini.cmdline').setup({})

---------------------------------
--- Auto theme and bar style switching
---------------------------------

-- The colorscheme (~/.config/themes/current) and bar style (current-bar) are
-- switched by `theme-set` / `bar-set`, which run :ThemeReload / :BarStyleReload
-- in every listening instance.
local THEMES = vim.fn.expand('~/.config/themes')

-- lualine keeps its previous config across setup() calls, so the base must
-- spell out every default or a bar's sections outlive the switch away from it.
local base = vim.tbl_deep_extend('force', require('lualine').get_config(), {
    options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
    },
})
local lualine_theme = 'auto'

-- A palette's nvim.lua sets the colorscheme and returns its lualine theme name.
local function load_theme()
    local file = THEMES .. '/current/nvim.lua'
    if vim.uv.fs_stat(file) then
        local ok, res = pcall(dofile, file)
        if ok then
            lualine_theme = type(res) == 'string' and res or 'auto'
            return
        end
        vim.notify('theme: ' .. tostring(res), vim.log.levels.WARN)
    else
        vim.notify('theme: nothing selected at ' .. file, vim.log.levels.WARN)
    end
    pcall(vim.cmd.colorscheme, 'tokyonight')
    lualine_theme = 'auto'
end

-- A bar's nvim.lua returns lualine overrides; its sections replace the base ones whole.
local function bar_style()
    local file = THEMES .. '/current-bar/nvim.lua'
    if not vim.uv.fs_stat(file) then return {} end
    local ok, res = pcall(dofile, file)
    if ok and type(res) == 'table' then return res end
    vim.notify('bar style: ' .. (ok and file .. ' must return a table' or tostring(res)), vim.log.levels.WARN)
    return {}
end

local function apply_lualine()
    local opts = vim.deepcopy(base)
    for group, value in pairs(bar_style()) do
        if group == 'options' then
            opts.options = vim.tbl_deep_extend('force', opts.options, value)
        elseif type(value) == 'table' and type(opts[group]) == 'table' then
            for name, section in pairs(value) do
                opts[group][name] = section
            end
        else
            opts[group] = value
        end
    end
    opts.options.theme = lualine_theme
    require('lualine').setup(opts)
end

vim.api.nvim_create_user_command('ThemeReload', function()
    load_theme()
    apply_lualine()
end, { desc = 'Re-read ~/.config/themes/current' })
vim.api.nvim_create_user_command('BarStyleReload', apply_lualine, { desc = 'Re-read ~/.config/themes/current-bar' })

load_theme()
apply_lualine()
