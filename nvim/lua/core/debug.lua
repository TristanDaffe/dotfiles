local M = {}

-- Compile + JVM start means seconds of no output otherwise.
function M.with_repl(fn, what)
    return function()
        require('dap').repl.open({ height = 12 }, 'belowright split')
        vim.notify('Running ' .. what .. ' ...')
        fn()
    end
end

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

local function start_or_toggle()
    local dap = require('dap')
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

local dap = require('dap')
local widgets = require('dap.ui.widgets')

for name, text in pairs({ DapBreakpoint = '󰝤 ', DapBreakpointCondition = '󰘥 ', DapStopped = '󰁕 ' }) do
    vim.fn.sign_define(name, { text = text, texthl = name == 'DapStopped' and 'DiagnosticWarn' or 'DiagnosticError' })
end

-- nvim-dap pools terminal buffers and reuses them without running
-- terminal_win_cmd, so after the first session the output has no window.
dap.listeners.after.event_initialized['show-terminal'] = function(session)
    vim.schedule(function() show_dap_terminal(session) end)
end

local function map(key, fn, desc, mode, palette)
    vim.keymap.set(mode or 'n', key, fn, { silent = true, desc = (palette == false and 'Debug ' or 'Debug: ') .. desc })
end

-- Bare prefix must be mapped: with timeoutlen=300, hesitating otherwise falls
-- through to <Space> then D, which deletes to end of line.
map('<leader>D', function()
    vim.api.nvim_echo({ { 'Debug: b B c l r t h s f   (<leader>? for the list)', 'WarningMsg' } }, false, {})
end, 'prefix (shows available keys)', nil, false)

map('<leader>Db', dap.toggle_breakpoint, 'toggle breakpoint')
map('<leader>DB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'conditional breakpoint')
map('<leader>Dc', start_or_toggle, 'start session / show-hide its window')
map('<leader>Dl', dap.run_last, 're-run last config')
map('<leader>Dr', dap.repl.toggle, 'toggle REPL')
map('<leader>Dt', dap.terminate, 'terminate session')
map('<F5>', dap.continue, 'resume from breakpoint')
map('<F10>', dap.step_over, 'step over')
map('<F11>', dap.step_into, 'step into')
map('<F12>', dap.step_out, 'step out')
map('<leader>Dh', widgets.hover, 'hover value under cursor', { 'n', 'x' })
map('<leader>Ds', function() widgets.centered_float(widgets.scopes) end, 'scopes (variables in frame)')
map('<leader>Df', function() widgets.centered_float(widgets.frames) end, 'call stack frames')

return M
