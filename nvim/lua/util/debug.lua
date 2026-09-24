local M = {}

local function show_dap_terminal(session)
    local buf = session and session.term_buf
    if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
    if #vim.fn.win_findbuf(buf) > 0 then return end
    local cur = vim.api.nvim_get_current_win()
    vim.cmd('belowright split')
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_win_set_height(0, 12)
    pcall(vim.api.nvim_set_current_win, cur)
end

local did_setup = false

-- nvim-dap is only required on first use, not at startup.
function M.dap()
    local dap = require('dap')
    if did_setup then return dap end
    did_setup = true

    for name, text in pairs({ DapBreakpoint = '󰝤 ', DapBreakpointCondition = '󰘥 ', DapStopped = '󰁕 ' }) do
        vim.fn.sign_define(name, { text = text, texthl = name == 'DapStopped' and 'DiagnosticWarn' or 'DiagnosticError' })
    end

    -- nvim-dap pools terminal buffers and reuses them without running
    -- terminal_win_cmd, so after the first session the output has no window.
    dap.listeners.after.event_initialized['show-terminal'] = function(session)
        vim.schedule(function() show_dap_terminal(session) end)
    end
    return dap
end

-- Compile + JVM start means seconds of no output otherwise.
function M.with_repl(fn, what)
    return function()
        M.dap().repl.open({ height = 12 }, 'belowright split')
        vim.notify('Running ' .. what .. ' ...')
        fn()
    end
end

function M.start_or_toggle()
    local dap = M.dap()
    local session = dap.session()
    if not session then return dap.continue() end
    local buf = session.term_buf
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return dap.repl.toggle({ height = 12 }, 'belowright split')
    end
    local wins = vim.fn.win_findbuf(buf)
    if #wins > 0 then
        for _, w in ipairs(wins) do pcall(vim.api.nvim_win_close, w, true) end
    else
        show_dap_terminal(session)
    end
end

return M
