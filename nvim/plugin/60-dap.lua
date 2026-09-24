vim.pack.add({ { src = 'https://github.com/mfussenegger/nvim-dap' } })

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
-- through to <Space> then D, which deletes to end of line.
map('<leader>D', function()
    vim.api.nvim_echo({ { 'Debug: b B c l r t h s f   (<leader>? for the list)', 'WarningMsg' } }, false, {})
end, 'prefix (shows available keys)', nil, false)

map('<leader>Db', call('toggle_breakpoint'), 'toggle breakpoint')
map('<leader>DB', function() debug.dap().set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'conditional breakpoint')
map('<leader>Dc', debug.start_or_toggle, 'start session / show-hide its window')
map('<leader>Dl', call('run_last'), 're-run last config')
map('<leader>Dr', function() debug.dap().repl.toggle() end, 'toggle REPL')
map('<leader>Dt', call('terminate'), 'terminate session')
map('<F5>', call('continue'), 'resume from breakpoint')
map('<F10>', call('step_over'), 'step over')
map('<F11>', call('step_into'), 'step into')
map('<F12>', call('step_out'), 'step out')
map('<leader>Dh', function() debug.dap(); require('dap.ui.widgets').hover() end, 'hover value under cursor', { 'n', 'x' })
map('<leader>Ds', widget('scopes'), 'scopes (variables in frame)')
map('<leader>Df', widget('frames'), 'call stack frames')
