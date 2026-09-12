vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    { src = "https://github.com/Mofiqul/dracula.nvim" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim", depends = { "plenary.nvim" } },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/akinsho/toggleterm.nvim" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/github/copilot.vim.git" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
    { src = "https://github.com/tpope/vim-obsession.git" },
})

local map = vim.keymap.set

-- Colorscheme: whatever ~/.config/themes/current points at.
-- Switch with `~/.config/themes/theme-set <name>`.
local theme = require('theme')
local lualine_theme = theme.load()

-- Statusline
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
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
}
theme.lualine_opts = lualine_opts
require('lualine').setup(lualine_opts)

-- File explorer
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

-- Telescope
require('telescope').setup({
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            prompt_position = 'bottom',
            horizontal = { preview_width = 0.55, results_width = 0.8 },
            vertical = { mirror = false },
        },
        preview = { treesitter = false },
    },
})
local tb = require('telescope.builtin')
map('n', '<leader>f', tb.find_files, { desc = 'Find files' })
map('n', '<leader>F', function()
    tb.find_files({ hidden = true, no_ignore = true })
end, { desc = 'Find files (incl. hidden + ignored)' })
map('n', '<leader>g', tb.live_grep,  { desc = 'Live grep' })
map('n', '<leader>;', tb.buffers,    { desc = 'List open buffers' })
map('n', '<leader>h', tb.help_tags,  { desc = 'Search help tags' })

-- Treesitter (main branch API)
local ts_parsers = {
    'lua', 'vim', 'vimdoc', 'bash', 'yaml', 'json',
    'html', 'css', 'javascript', 'typescript', 'tsx', 'sql',
}
require('nvim-treesitter').install(ts_parsers)
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- Autopairs
require('nvim-autopairs').setup({})

-- Terminal
require('toggleterm').setup({
    direction = 'horizontal',
    size = 15,
    open_mapping = [[<C-t>]],   -- not <C-w> (vim window prefix), not <C-\> (needs opt-shift-/ on Belgian)
})

-- Comment
require('Comment').setup({})

-- Copilot
vim.g.copilot_no_tab_map = true
map('i', '<C-J>', 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false, desc = 'Copilot accept' })

-- Session tracking (tpope/vim-obsession)
--
-- Vimscript plugin: no Lua module, no setup(), and no options for a session
-- directory. It is driven entirely by the command, which writes to the path you
-- give it and then keeps that file up to date:
--
--   :Obsession ~/.local/share/nvim/sessions/foo.vim   start tracking
--   :Obsession!                                       stop and delete
--   nvim -S ~/.local/share/nvim/sessions/foo.vim      restore
--
-- With no argument it writes ./Session.vim in the current directory.
