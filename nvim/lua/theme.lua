-- Reads the theme selected in ~/.config/themes/current and applies it.
--
-- Each theme directory holds an nvim.lua that sets the colorscheme and
-- returns the lualine theme name to use with it. Switch themes with
-- `~/.config/themes/theme-set <name>`; :ThemeReload re-reads the selection
-- in a running instance (which is what theme-set drives over the socket).

local M = {}

local CURRENT = vim.fn.expand('~/.config/themes/current')
local FALLBACK = 'tokyonight'

-- Set by plugins.lua so a reload can rebuild lualine without losing its sections.
M.lualine_opts = nil

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
    if M.lualine_opts then
        M.lualine_opts.options.theme = name
        local ok, lualine = pcall(require, 'lualine')
        if ok then
            lualine.setup(M.lualine_opts)
        end
    end
end

vim.api.nvim_create_user_command('ThemeReload', function()
    M.reload()
end, { desc = 'Re-read ~/.config/themes/current' })

return M
