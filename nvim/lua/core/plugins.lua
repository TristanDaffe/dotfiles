local SPECS = {
    -- Themes
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    { src = "https://github.com/Mofiqul/dracula.nvim" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },

    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
    { src = "https://github.com/github/copilot.vim" },

    -- lsp / debug
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mfussenegger/nvim-dap" },

    -- languages
    { src = "https://github.com/mfussenegger/nvim-jdtls" },
    { src = "https://github.com/lervag/vimtex", version = "v2.18" },
}

local PARSERS = {
    'lua', 'vim', 'vimdoc', 'bash', 'yaml', 'json', 'sql',
    'java', 'proto', 'html', 'css', 'javascript', 'typescript', 'tsx', 'graphql',
}

-- vimtex reads these at load time.
vim.g.vimtex_view_method = 'general'
vim.g.vimtex_view_general_viewer = 'bookokrat'
vim.g.vimtex_view_general_options =
    '--synctex-forward @line:@col:@tex @pdf '
    .. ' || tmux split-window -h -l 40% -e BOOKOKRAT_PROTOCOL=kittyv2 bookokrat @pdf --zen-mode'

vim.pack.add(SPECS)

local map = vim.keymap.set

-- Colorscheme: whatever ~/.config/themes/current points at.
-- Switch with `~/.config/themes/theme-set <name>`.
local theme = require('core.theme')
local lualine_theme = theme.load()

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.pairs').setup()

local lualine_opts = {
    options = {
        theme = lualine_theme,
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
        lualine_c = { { 'filename' } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
}
theme.lualine_opts = lualine_opts
require('lualine').setup(lualine_opts)

require('nvim-tree').setup({
    sort = { sorter = 'case_sensitive' },
    view = {
        width = 30,
        side = 'left',
        number = true,
        adaptive_size = false,
        preserve_window_proportions = true,
    },
    renderer = { group_empty = true },
    filters = { dotfiles = true },
    git = { enable = true, ignore = false, timeout = 500 },
})
map('n', '<leader>b', ':NvimTreeToggle<CR>',   { desc = 'Toggle file explorer' })
map('n', '<leader>B', ':NvimTreeFindFile<CR>', { desc = 'Reveal current file in explorer' })

-- Global sessions live in stdpath('data')/session; the active one is saved on exit.
require('mini.sessions').setup()
-- Keep the active session current like vim-obsession did, so tmux-resurrect
-- (`nvim -S Session.vim`) gets a fresh one even if nvim never exits cleanly.
-- SessionLoad is set while a session file is being sourced.
-- Only real file buffers: skips Telescope prompts, NvimTree and terminals.
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'FocusLost' }, {
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
        layout_strategy = 'horizontal',
        path_display = { 'filename_first' },
        cmd = { "grep", "-rn" },
        layout_config = {
            prompt_position = 'bottom',
            horizontal = { preview_width = 0.55, results_width = 0.8 },
            vertical = { mirror = false },
        },
        preview = { treesitter = true },
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

require('nvim-treesitter').install(PARSERS)
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },
    completion = { documentation = { auto_show = true } },
    sources = { default = { 'lsp', 'snippets', 'buffer', 'path' } },
})

vim.g.copilot_no_tab_map = true
map('i', '<C-J>', 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false, desc = 'Copilot accept' })
