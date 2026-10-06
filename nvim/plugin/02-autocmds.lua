-- Restore cursor to last position when reopening a file
-- (skip transient git/hg/svn files so rebase/commit always start at line 1).
-- 'filetype' is not set yet at BufReadPost, hence the explicit match.
local skip_ft = { gitcommit = true, gitrebase = true, hgcommit = true, svn = true }
vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('user', { clear = true }),
    callback = function(args)
        if skip_ft[vim.filetype.match({ buf = args.buf }) or ''] then return end
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
