-- Reads the bar style selected in ~/.config/themes/current-bar and applies it.
--
-- A bar directory may hold an nvim.lua that returns lualine overrides
-- (options/sections). Bars without one use the base options from setup().
-- Switch with `~/.config/themes/bar-set <name>`; :BarStyleReload re-reads
-- the selection in a running instance.

local M = {}

local CURRENT = vim.fn.expand('~/.config/themes/current-bar')

local lualine_opts
local base

---@return table lualine overrides
function M.load()
    local file = CURRENT .. '/nvim.lua'
    if not vim.uv.fs_stat(file) then
        return {}
    end
    local ok, res = pcall(dofile, file)
    if ok and type(res) == 'table' then
        return res
    end
    vim.notify('bar style: ' .. (ok and file .. ' must return a table' or tostring(res)), vim.log.levels.WARN)
    return {}
end

-- Rebuilds lualine_opts in place (base + bar overrides) so util.theme, which
-- holds the same table, keeps the bar style, while the theme is preserved here.
local function apply()
    local theme = lualine_opts.options and lualine_opts.options.theme
    local style = M.load()
    local merged = vim.deepcopy(base)
    for group, value in pairs(style) do
        if group == 'options' then
            merged.options = vim.tbl_deep_extend('force', merged.options, value)
        elseif type(value) == 'table' and type(merged[group]) == 'table' then
            for name, section in pairs(value) do
                merged[group][name] = section
            end
        else
            merged[group] = value
        end
    end
    for k in pairs(lualine_opts) do
        lualine_opts[k] = nil
    end
    for k, v in pairs(merged) do
        lualine_opts[k] = v
    end
    lualine_opts.options = lualine_opts.options or {}
    lualine_opts.options.theme = theme
end

function M.reload()
    if not lualine_opts then
        return
    end
    apply()
    require('lualine').setup(lualine_opts)
end

--- Merges the current bar style into opts.lualine. Call before util.theme.setup
--- with the same table; lualine itself is set up by the theme.
---@param opts { lualine: table }
function M.setup(opts)
    lualine_opts = opts.lualine
    -- lualine keeps its previous config across setup() calls, so the base must
    -- spell out every default or a bar's sections outlive the switch away from it.
    base = vim.tbl_deep_extend('force', require('lualine').get_config(), lualine_opts)
    apply()
end

vim.api.nvim_create_user_command('BarStyleReload', M.reload, { desc = 'Re-read ~/.config/themes/current-bar' })

return M
