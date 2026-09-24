-- Reads the theme selected in ~/.config/themes/current and applies it.
--
-- Each theme directory holds an nvim.lua that sets the colorscheme and
-- returns the lualine theme name to use with it. Switch themes with
-- `~/.config/themes/theme-set <name>`; :ThemeReload re-reads the selection
-- in a running instance (which is what theme-set drives over the socket).

local M = {}

local CURRENT = vim.fn.expand('~/.config/themes/current')
local FALLBACK = 'tokyonight'

local lualine_opts

---@return string lualine theme name
function M.load()
    local file = CURRENT .. '/nvim.lua'
    if vim.uv.fs_stat(file) then
        local ok, res = pcall(dofile, file)
        if ok then
            return type(res) == 'string' and res or 'auto'
        end
        vim.notify('theme: ' .. tostring(res), vim.log.levels.WARN)
    else
        vim.notify('theme: nothing selected at ' .. file, vim.log.levels.WARN)
    end
    pcall(vim.cmd.colorscheme, FALLBACK)
    return 'auto'
end

function M.reload()
    local name = M.load()
    if lualine_opts then
        lualine_opts.options.theme = name
        require('lualine').setup(lualine_opts)
    end
end

--- Applies the current theme and keeps the lualine options for :ThemeReload.
---@param opts { lualine: table }
function M.setup(opts)
    lualine_opts = opts.lualine
    M.reload()
end

vim.api.nvim_create_user_command('ThemeReload', M.reload, { desc = 'Re-read ~/.config/themes/current' })

return M
