local map = vim.keymap.set

-- Basics
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Center screen when jumping
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Keep the selection after indenting, so > and < can be repeated
-- 'x' (visual only), NOT 'v': 'v' also covers select mode, where snippets
-- put the cursor on placeholders and typing > must replace them.
map('x', '>', '>gv', { desc = 'Indent right, keep selection' })
map('x', '<', '<gv', { desc = 'Indent left, keep selection' })

-- move: hjkl
map('n', '<M-h>', '<C-w>h', { desc = 'Focus split left' })
map('n', '<M-j>', '<C-w>j', { desc = 'Focus split down' })
map('n', '<M-k>', '<C-w>k', { desc = 'Focus split up' })
map('n', '<M-l>', '<C-w>l', { desc = 'Focus split right' })

-- resize: Shift + hjkl.  H/J shrink, K/L grow.
map('n', '<M-S-h>', ':vertical resize -2<CR>', { desc = 'Split narrower' })
map('n', '<M-S-l>', ':vertical resize +2<CR>', { desc = 'Split wider' })
map('n', '<M-S-k>', ':resize +2<CR>',          { desc = 'Split taller' })
map('n', '<M-S-j>', ':resize -2<CR>',          { desc = 'Split shorter' })

-- move the split itself: m then hjkl. Reads the next key itself, so
-- timeoutlen doesn't apply; any other key cancels.
map('n', '<M-m>', function()
    local ok, key = pcall(vim.fn.getcharstr)
    if ok and ('hjkl'):find(key, 1, true) and #key == 1 then
        vim.cmd.wincmd(key:upper())
    end
end, { desc = 'Layer 1: move split (then h/j/k/l)' })

-- split: leader s + h/v, and ss to even out every split
map('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split window vertically' })
map('n', '<leader>sh', ':split<CR>',  { desc = 'Split window horizontally' })
map('n', '<leader>ss', '<C-w>=',      { desc = 'Equalize all split sizes' })

-- Exit terminal mode
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode', silent = true })

-- Toggle a bottom terminal. Alt layer like the split keys: <C-t> is the LSP
-- tag-stack return, insert-mode indent and the shell's own Ctrl-T.
local term = { buf = -1, win = -1 }
map({ 'n', 't' }, '<M-t>', function()
    if vim.api.nvim_win_is_valid(term.win) and vim.api.nvim_win_get_buf(term.win) == term.buf then
        return vim.api.nvim_win_hide(term.win)
    end
    vim.cmd('botright 15split')
    term.win = vim.api.nvim_get_current_win()
    if vim.api.nvim_buf_is_valid(term.buf) then
        vim.api.nvim_win_set_buf(term.win, term.buf)
    else
        vim.cmd.terminal()
        term.buf = vim.api.nvim_get_current_buf()
    end
    vim.cmd.startinsert()
end, { desc = 'Toggle terminal' })

-- Clear search highlight on <Esc>
map('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight', silent = true })
