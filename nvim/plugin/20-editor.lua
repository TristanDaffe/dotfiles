vim.pack.add({
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
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

-- Global sessions live in stdpath('data')/session; the active one is saved on
-- exit, and on write/focus loss below.
require('mini.sessions').setup()

-- Keep the active session current like vim-obsession did, so tmux-resurrect
-- (`nvim -S Session.vim`) gets a fresh one even if nvim never exits cleanly.
-- SessionLoad is set while a session file is being sourced.
-- Only real file buffers: skips Telescope prompts, NvimTree and terminals.
vim.api.nvim_create_autocmd({ 'BufWritePost', 'FocusLost' }, {
    group = vim.api.nvim_create_augroup('user.session', { clear = true }),
    callback = function(args)
        if vim.v.this_session ~= '' and vim.g.SessionLoad == nil and vim.bo[args.buf].buftype == '' then
            MiniSessions.write(nil, { verbose = false })
        end
    end,
})

-- No name and no active session: local ./Session.vim, the one tmux-resurrect looks for.
vim.api.nvim_create_user_command('SessionWrite', function(o)
    local name = o.args ~= '' and o.args or nil
    if not name and vim.v.this_session == '' then name = MiniSessions.config.file end
    MiniSessions.write(name)
end, { nargs = '?', desc = 'Write session (default: ./Session.vim)' })
vim.api.nvim_create_user_command('SessionLoad', function() MiniSessions.select() end, {})
vim.api.nvim_create_user_command('SessionDelete', function() MiniSessions.select('delete') end, {})

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
map('n', '<leader>f', tb.find_files, { desc = 'Find files' })
map('n', '<leader>F', function()
    tb.find_files({ hidden = true, no_ignore = true })
end, { desc = 'Find files (incl. hidden + ignored)' })
map('n', '<leader>g', tb.live_grep, { desc = 'Live grep' })
map('n', '<leader><leader>', tb.buffers, { desc = 'List open buffers' })
map('n', '<leader>h', tb.help_tags, { desc = 'Search help tags' })

map('n', '<leader>?', ':Telescope keymaps<CR>', { desc = 'Show keybind help' })
map('n', '<leader>t', function() require('util.palette').open() end, { desc = 'Action palette' })
