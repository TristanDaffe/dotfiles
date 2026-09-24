-- <leader>t action palette. Lists every normal-mode keymap whose desc reads
-- "Category: name" (buffer-local ones included, so it follows the filetype),
-- plus key-less entries registered with M.add.
local M = {}

local extra = {}

--- @param a { cat: string, name: string, run: function, buf?: integer }
function M.add(a)
    if a.buf == 0 then a.buf = vim.api.nvim_get_current_buf() end
    extra[a.cat .. a.name .. (a.buf or '')] = a
end

local function collect(filter)
    local items = {}
    local function push(a)
        if not filter or a.cat == filter then items[#items + 1] = a end
    end
    local seen = {}
    for _, maps in ipairs({ vim.api.nvim_buf_get_keymap(0, 'n'), vim.api.nvim_get_keymap('n') }) do
        for _, m in ipairs(maps) do
            local cat, name = (m.desc or ''):match('^(%w+): (.+)$')
            if cat and not seen[m.lhs] then
                seen[m.lhs] = true
                push({
                    cat = cat,
                    name = name,
                    key = m.lhs:gsub('^ ', '<leader>'),
                    run = m.callback or function()
                        vim.api.nvim_feedkeys(vim.keycode(m.lhs), 'm', false)
                    end,
                })
            end
        end
    end
    for _, a in pairs(extra) do
        if not a.buf or a.buf == vim.api.nvim_get_current_buf() then push(a) end
    end
    table.sort(items, function(x, y) return x.cat .. x.name < y.cat .. y.name end)
    return items
end

function M.open(filter)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local tactions = require('telescope.actions')
    local tstate = require('telescope.actions.state')
    local entry_display = require('telescope.pickers.entry_display')

    local win = vim.api.nvim_get_current_win()
    local items = collect(filter)
    if #items == 0 then
        vim.notify('No actions available here')
        return
    end

    local width, keyw = 0, 0
    for _, a in ipairs(items) do
        width = math.max(width, #a.cat + #a.name + 2)
        keyw = math.max(keyw, #(a.key or ''))
    end

    local displayer = entry_display.create({
        separator = '  ',
        items = { { width = width }, { remaining = true } },
    })

    -- prompt_position must be passed here, not inherited: get_dropdown picks its
    -- borderchars from this value and draws a broken frame if it disagrees.
    local theme = require('telescope.themes').get_dropdown({
        sorting_strategy = 'descending',
        layout_config = {
            prompt_position = 'bottom',
            width = width + keyw + 10,
            height = math.min(#items + 5, 22),
        },
    })

    pickers.new(theme, {
        prompt_title = filter and ('Actions: ' .. filter) or 'Actions',
        finder = finders.new_table({
            results = items,
            entry_maker = function(a)
                local label = a.cat .. ': ' .. a.name
                return {
                    value = a,
                    ordinal = label,
                    display = function()
                        return displayer({ label, { a.key or '', 'Comment' } })
                    end,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(bufnr)
            tactions.select_default:replace(function()
                local entry = tstate.get_selected_entry()
                tactions.close(bufnr)
                if entry then
                    vim.schedule(function()
                        if vim.api.nvim_win_is_valid(win) then
                            vim.api.nvim_win_call(win, entry.value.run)
                        else
                            entry.value.run()
                        end
                    end)
                end
            end)
            return true
        end,
    }):find()
end

return M
