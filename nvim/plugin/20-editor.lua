vim.pack.add({
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/folke/which-key.nvim' },
})

local map = vim.keymap.set

require('mini.pairs').setup()

require('nvim-tree').setup({
    sort = { sorter = 'case_sensitive' },
    view = {
        number = true,
        preserve_window_proportions = true,
    },
    renderer = { group_empty = true },
    filters = { dotfiles = true },
    git = { ignore = false, timeout = 500 },
})
map('n', '<leader>b', ':NvimTreeToggle<CR>',   { desc = 'Toggle file explorer' })
map('n', '<leader>B', ':NvimTreeFindFile<CR>', { desc = 'Reveal current file in explorer' })

-- Telescope: Fuzzy finder
require('telescope').setup({
    defaults = {
        path_display = { 'filename_first' },
        layout_config = {
            prompt_position = 'bottom',
            horizontal = { preview_width = 0.55 },
        },
    },
})
local tb = require('telescope.builtin')
map('n', '<leader>ff', tb.find_files, { desc = 'Find files' })
map('n', '<leader>fF', function()
    tb.find_files({ hidden = true, no_ignore = true })
end, { desc = 'Find files (incl. hidden + ignored)' })
map('n', '<leader>fg', tb.live_grep, { desc = 'Live grep' })
map('n', '<leader>fb', tb.buffers, { desc = 'List open buffers' })
map('n', '<leader>fh', tb.help_tags, { desc = 'Search help tags' })

-- Helpers
map('n', '<leader>?', ':Telescope keymaps<CR>', { desc = 'Show keybind help' })
map('n', '<leader>t', function() require('util.palette').open() end, { desc = 'Action palette' })

-- Show key combinations in a popup
require('which-key').setup({
})

-- Use mini.sessiosn to save and restore sessions
-- Change defautl behavior to be compatible with tmux-resurrect
require('mini.sessions').setup()
vim.api.nvim_create_autocmd({ 'BufWritePost', 'FocusLost' }, {
    group = vim.api.nvim_create_augroup('user.session', { clear = true }),
    callback = function(args)
        if vim.v.this_session ~= '' and vim.g.SessionLoad == nil and vim.bo[args.buf].buftype == '' then
            MiniSessions.write(nil, { verbose = false })
        end
    end,
})

vim.api.nvim_create_user_command('SessionWrite', function(o)
    local name = o.args ~= '' and o.args or nil
    if not name and vim.v.this_session == '' then name = MiniSessions.config.file end
    MiniSessions.write(name)
end, { nargs = '?', desc = 'Write session (default: ./Session.vim)' })
vim.api.nvim_create_user_command('SessionLoad', function() MiniSessions.select() end, {})
vim.api.nvim_create_user_command('SessionDelete', function() MiniSessions.select('delete') end, {})

