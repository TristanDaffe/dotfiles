vim.pack.add({
    { src = 'https://github.com/mfussenegger/nvim-dap' },
    { src = 'https://github.com/nvim-neotest/nvim-nio' },
    { src = 'https://github.com/rcarriga/nvim-dap-ui' },
    { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
})

local debug = require('util.debug')

local function map(key, fn, desc, mode, palette)
    vim.keymap.set(mode or 'n', key, fn, { silent = true, desc = (palette == false and 'Debug ' or 'Debug: ') .. desc })
end

local function call(name)
    return function() debug.dap()[name]() end
end

local function widget(name)
    return function()
        debug.dap()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets[name])
    end
end

-- Bare prefix must be mapped: with timeoutlen=300, hesitating otherwise falls
-- through to <Space> then d, which waits for a motion and deletes.
map('<leader>d', function()
    vim.api.nvim_echo({ { 'Debug: c j k o  b B L X  u r l t q  h s f   (<leader>? for the list)', 'WarningMsg' } }, false, {})
end, 'prefix (shows available keys)', nil, false)

map('<leader>dc', call('continue'), 'start / continue')
map('<leader>dj', call('step_over'), 'step over')
map('<leader>dk', call('step_into'), 'step into')
map('<leader>do', call('step_out'), 'step out')

map('<leader>db', call('toggle_breakpoint'), 'toggle breakpoint')
map('<leader>dB', function() debug.dap().set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'conditional breakpoint')
map('<leader>dL', function() debug.dap().set_breakpoint(nil, nil, vim.fn.input('Log message ({expr} interpolated): ')) end, 'log point')
map('<leader>dX', call('clear_breakpoints'), 'clear all breakpoints')

map('<leader>du', function() debug.dap(); require('dapui').toggle() end, 'toggle debug UI')
map('<leader>dr', function() debug.dap().repl.toggle() end, 'toggle REPL')
map('<leader>dl', call('run_last'), 're-run last config')
map('<leader>dt', debug.stop('terminate'), 'terminate session')
map('<leader>dq', debug.stop('disconnect'), 'detach (app keeps running)')

map('<leader>dh', function() debug.dap(); require('dap.ui.widgets').hover() end, 'hover value under cursor', { 'n', 'x' })
map('<leader>ds', widget('scopes'), 'scopes (variables in frame)')
map('<leader>df', widget('frames'), 'call stack frames')

map('<F5>', call('continue'), 'start / continue')
map('<F10>', call('step_over'), 'step over')
map('<F11>', call('step_into'), 'step into')
map('<F12>', call('step_out'), 'step out')
