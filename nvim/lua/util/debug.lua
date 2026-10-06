local M = {}

local SIGNS = {
    DapBreakpoint          = { '󰝤 ', 'DiagnosticError' },
    DapBreakpointCondition = { '󰘥 ', 'DiagnosticError' },
    DapBreakpointRejected  = { '󰜺 ', 'DiagnosticHint' },
    DapLogPoint            = { '󰛿 ', 'DiagnosticInfo' },
    DapStopped             = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
}

local did_setup = false

-- nvim-dap and its UI are only required on first use, not at startup.
function M.dap()
    local dap = require('dap')
    if did_setup then return dap end
    did_setup = true

    vim.api.nvim_set_hl(0, 'DapStoppedLine', { link = 'Visual', default = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('user.dap', { clear = true }),
        callback = function() vim.api.nvim_set_hl(0, 'DapStoppedLine', { link = 'Visual', default = true }) end,
    })
    for name, s in pairs(SIGNS) do
        vim.fn.sign_define(name, { text = s[1], texthl = s[2], linehl = s[3] })
    end

    local dapui = require('dapui')
    dapui.setup()
    require('nvim-dap-virtual-text').setup({})

    -- Left open on exit so test results stay readable; closed by the terminate/disconnect maps.
    dap.listeners.before.launch['dapui'] = dapui.open
    dap.listeners.before.attach['dapui'] = dapui.open
    return dap
end

-- Compile + JVM start means seconds of no output otherwise.
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
