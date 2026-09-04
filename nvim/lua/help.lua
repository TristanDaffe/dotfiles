-- Floating-window keybind cheatsheet, opened with <leader>?
-- Edit the `lines` table below when you add/remove keymaps.

local lines = {
    '  Keybindings  (leader = <Space>)',
    '',
    '  General',
    '    jk            Exit insert mode',
    '    <leader>w     Save file',
    '    <leader>q     Quit',
    '    <Esc>         Clear search highlight',
    '    <leader>?     This help window',
    '',
    '  Indent',
    '    > / <         (visual) Indent, selection kept — repeatable',
    '    >> / <<       Indent current line',
    '',
    '  Navigation',
    '    n / N         Next / prev search result (centered)',
    '    <C-d> / <C-u> Half page down / up (centered)',
    '',
    '  Layer 1 - splits  (modifier = Option)',
    '    <M-h/j/k/l>   Move between splits',
    '    <M-S-h/j/k/l> Resize   (H/J shrink, K/L grow)',
    '    <M-m> h/j/k/l Move the split itself',
    '    <M-x>         Close split',
    '    <leader>sv/sh Split vertically / horizontally',
    '    <leader>ss    Equalize all split sizes',
    '    <C-w> + ...   Vim window prefix (v, s, q, o, =)',
    '',
    '  Files & search',
    '    <leader>b     Toggle file explorer (nvim-tree)',
    '    <leader>B     Reveal current file in explorer',
    '    <leader>f     Find files (Telescope)',
    '    <leader>F     Find files incl. hidden + ignored',
    '    <leader>g     Live grep (Telescope)',
    '    <leader>;     List open buffers',
    '    <leader>h     Search help tags',
    '',
    '  Terminal',
    '    <C-t>         Toggle terminal',
    '    <Esc>         (in term) leave terminal mode',
    '',
    '  Comments',
    '    gcc           Toggle comment on line',
    '    gc + motion   Toggle comment over motion',
    '    gc            (visual) Toggle comment on selection',
    '',
    '  LSP (active when a language server attaches)',
    '    gd / gD       Go to definition / declaration',
    '    gi            Go to implementation',
    '    gr            List references',
    '    K             Hover documentation',
    '    <C-k>         Signature help',
    '    <leader>rn    Rename symbol',
    '    <leader>ca    Code action',
    '    <leader>lf    Format buffer',
    '    <leader>d     Show diagnostic float',
    '    [d / ]d       Previous / next diagnostic',
    '    <leader>m     Open Mason (LSP installer)',
    '',
    '  Completion (insert mode)',
    '    <C-Space>     Trigger completion',
    '    <CR>          Confirm selection',
    '    <Tab> / <S-Tab>  Next / prev item or snippet jump',
    '    <C-b> / <C-f> Scroll docs',
    '    <C-e>         Abort',
    '    <C-J>         Accept Copilot suggestion',
    '',
    '  Press q or <Esc> to close',
}

local function open_help()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden  = 'wipe'
    vim.bo[buf].filetype   = 'help'

    local width  = 70
    local height = math.min(#lines + 2, vim.o.lines - 4)
    local row    = math.floor((vim.o.lines - height) / 2)
    local col    = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width    = width,
        height   = height,
        row      = row,
        col      = col,
        style    = 'minimal',
        border   = 'rounded',
        title    = ' Keybindings ',
        title_pos = 'center',
    })
    vim.wo[win].cursorline = true

    local close = function() pcall(vim.api.nvim_win_close, win, true) end
    vim.keymap.set('n', 'q',     close, { buffer = buf, nowait = true })
    vim.keymap.set('n', '<Esc>', close, { buffer = buf, nowait = true })
end

vim.api.nvim_create_user_command('Keybinds', open_help, {})
vim.keymap.set('n', '<leader>?', open_help, { desc = 'Show keybind help' })
