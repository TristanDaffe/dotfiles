local M = {}

local SIGNS = {
    DapBreakpoint          = { '󰝤 ', 'DiagnosticError' },
    DapBreakpointCondition = { '󰘥 ', 'DiagnosticError' },
    DapBreakpointRejected  = { '󰜺 ', 'DiagnosticHint' },
    DapLogPoint            = { '󰛿 ', 'DiagnosticInfo' },
    DapStopped             = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
}

local TITLES = {
    dapui_scopes      = 'Scopes',
    dapui_stacks      = 'Stacks',
    dapui_watches     = 'Watches',
    dapui_breakpoints = 'Breakpoints',
}

local did_setup = false

-- nvim-dap and its UI are only required on first use, not at startup.
function M.dap()
    local dap = require('dap')

    if did_setup then
        return dap
    end
    did_setup = true

    -- Rename dap-ui windows
    local group = vim.api.nvim_create_augroup('user.dap', { clear = true })

    vim.api.nvim_create_autocmd('BufWinEnter', {
        group = group,
        callback = function(ev)
            local title = TITLES[vim.bo[ev.buf].filetype]
            if not title then
                return
            end
            for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
                vim.wo[win].winbar = ' ' .. title
            end
        end,
    })

    -- Change symbols 
    for name, s in pairs(SIGNS) do
        vim.fn.sign_define(name, { text = s[1], texthl = s[2], linehl = s[3] })
    end

    local dapui = require('dapui')
    dapui.setup()
    require('nvim-dap-virtual-text').setup({})

    dap.listeners.before.launch.dapui_config = function()
        -- when the debugger is launched open up the debug ui
        dapui.open()
    end

    return dap
end

-- Functions used in dap.lua
function M.with_ui(fn, what)
    return function()
        M.dap()
        require('dapui').open()
        vim.notify('Running ' .. what .. ' ...')
        fn()
    end
end

function M.stop(how)
    return function()
        M.dap()[how]()
        require('dapui').close()
    end
end

return M
