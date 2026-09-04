local map = vim.keymap.set

-- Basics
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

-- Center screen when jumping
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Keep the selection after indenting, so > and < can be repeated
-- 'x' (visual only), NOT 'v': 'v' also covers select mode, where LuaSnip
-- puts the cursor on snippet placeholders and typing > must replace them.
map('x', '>', '>gv', { desc = 'Indent right, keep selection' })
map('x', '<', '<gv', { desc = 'Indent left, keep selection' })

-- Layer 1 — splits.  Modifier = Option.
-- Same actions live at layer 2 (tmux, prefix C-b) and layer 3 (WM, Ctrl+Cmd);
-- only the modifier changes.  See the "Motion layers" note.

-- move: hjkl
map('n', '<M-h>', '<C-w>h', { desc = 'Layer 1: focus split left' })
map('n', '<M-j>', '<C-w>j', { desc = 'Layer 1: focus split down' })
map('n', '<M-k>', '<C-w>k', { desc = 'Layer 1: focus split up' })
map('n', '<M-l>', '<C-w>l', { desc = 'Layer 1: focus split right' })

-- resize: Shift + hjkl.  H/J shrink, K/L grow.
-- Shift alone would shadow H/L (screen top/bottom), J (join), K (LSP hover).
map('n', '<M-S-h>', ':vertical resize -2<CR>', { desc = 'Layer 1: split narrower' })
map('n', '<M-S-l>', ':vertical resize +2<CR>', { desc = 'Layer 1: split wider' })
map('n', '<M-S-k>', ':resize +2<CR>',          { desc = 'Layer 1: split taller' })
map('n', '<M-S-j>', ':resize -2<CR>',          { desc = 'Layer 1: split shorter' })

-- move the split itself: m then hjkl
map('n', '<M-m>h', '<C-w>H', { desc = 'Layer 1: move split far left' })
map('n', '<M-m>j', '<C-w>J', { desc = 'Layer 1: move split to bottom' })
map('n', '<M-m>k', '<C-w>K', { desc = 'Layer 1: move split to top' })
map('n', '<M-m>l', '<C-w>L', { desc = 'Layer 1: move split far right' })

-- close: x
map('n', '<M-x>', '<C-w>c', { desc = 'Layer 1: close split' })

-- split: leader s + h/v, and ss to even out every split
map('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split window vertically' })
map('n', '<leader>sh', ':split<CR>',  { desc = 'Split window horizontally' })
map('n', '<leader>ss', '<C-w>=',      { desc = 'Layer 1: equalize all split sizes' })

-- Exit terminal mode
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode', silent = true })

-- Clear search highlight on <Esc>
map('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight', silent = true })

-- Restore cursor to last position when reopening a file
-- (skip transient git/hg/svn files so rebase/commit always start at line 1)
local skip_ft = { gitcommit = true, gitrebase = true, hgcommit = true, svn = true }
local skip_name = {
    ['COMMIT_EDITMSG']  = true,
    ['MERGE_MSG']       = true,
    ['TAG_EDITMSG']     = true,
    ['git-rebase-todo'] = true,
}
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function(args)
        if skip_ft[vim.bo[args.buf].filetype] then return end
        if skip_name[vim.fs.basename(args.file)] then return end
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
