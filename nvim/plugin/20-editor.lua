vim.pack.add({
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/folke/which-key.nvim' },
})

local map = vim.keymap.set

require('mini.pairs').setup()

-- .java files get the icon of the type they declare, read from the file and
-- cached until its mtime changes.
local JAVA_KINDS = {
    class          = { lsp = 'class',     hl = 'MiniIconsOrange' },
    abstract       = { lsp = 'class',     hl = 'MiniIconsGrey' },
    interface      = { lsp = 'interface', hl = 'MiniIconsGreen' },
    enum           = { lsp = 'enum',      hl = 'MiniIconsYellow' },
    record         = { lsp = 'struct',    hl = 'MiniIconsCyan' },
    ['@interface'] = { lsp = 'event',     hl = 'MiniIconsRed' },
}
local JAVA_MODIFIERS = {
    public = true, protected = true, private = true, static = true,
    final = true, sealed = true, non = true, strictfp = true,
}
local java_cache = {}

local function java_kind(path, mtime)
    local cached = java_cache[path]
    if cached and cached.mtime == mtime then return cached.kind end
    local kind
    local f = io.open(path, 'r')
    if f then
        local in_comment, n = false, 0
        for line in f:lines() do
            n = n + 1
            if n > 300 then break end
            if in_comment then
                local close = line:find('*/', 1, true)
                in_comment = not close
                line = close and line:sub(close + 2) or ''
            end
            line = line:gsub('/%*.-%*/', ''):gsub('//.*$', ''):gsub('%b()', '')
            local open = line:find('/*', 1, true)
            if open then
                in_comment, line = true, line:sub(1, open - 1)
            end
            local abstract = false
            for word in line:gmatch('[%w_@]+') do
                if word == 'abstract' then
                    abstract = true
                elseif not JAVA_MODIFIERS[word] and not (word:sub(1, 1) == '@' and word ~= '@interface') then
                    if JAVA_KINDS[word] then kind = (word == 'class' and abstract) and 'abstract' or word end
                    break
                end
            end
            if kind then break end
        end
        f:close()
    end
    java_cache[path] = { mtime = mtime, kind = kind }
    return kind
end

local JavaKindDecorator = require('nvim-tree.api').Decorator:extend()

function JavaKindDecorator:new()
    self.enabled = true
    self.highlight_range = 'none'
    self.icon_placement = 'none'
end

function JavaKindDecorator:icon_node(node)
    if node.type ~= 'file' or not node.name:match('%.java$') then return nil end
    local stat = node.fs_stat or vim.uv.fs_stat(node.absolute_path)
    local kind = JAVA_KINDS[java_kind(node.absolute_path, stat and stat.mtime.sec) or '']
    if not kind then return nil end
    return { str = (MiniIcons.get('lsp', kind.lsp)), hl = { kind.hl } }
end

require('nvim-tree').setup({
    sort = { sorter = 'case_sensitive' },
    view = {
        number = true,
        preserve_window_proportions = true,
    },
    renderer = {
        group_empty = true,
        decorators = { 'Git', 'Open', 'Hidden', 'Modified', 'Bookmark', 'Diagnostics', 'Copied', JavaKindDecorator, 'Cut' },
    },
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

