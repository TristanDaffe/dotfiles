local group = vim.api.nvim_create_augroup('user', { clear = true })
local autocmd = function(event, opts)
    vim.api.nvim_create_autocmd(event, vim.tbl_extend('force', { group = group }, opts))
end

-- Restore cursor to last position when reopening a file
-- (skip transient git/hg/svn files so rebase/commit always start at line 1).
-- 'filetype' is not set yet at BufReadPost, hence the explicit match.
local skip_ft = { gitcommit = true, gitrebase = true, hgcommit = true, svn = true }
autocmd('BufReadPost', {
    callback = function(args)
        if skip_ft[vim.filetype.match({ buf = args.buf }) or ''] then return end
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Keep the active session current like vim-obsession did, so tmux-resurrect
-- (`nvim -S Session.vim`) gets a fresh one even if nvim never exits cleanly.
-- SessionLoad is set while a session file is being sourced.
-- Only real file buffers: skips Telescope prompts, NvimTree and terminals.
autocmd({ 'BufWritePost', 'FocusLost' }, {
    callback = function(args)
        if vim.v.this_session ~= '' and vim.g.SessionLoad == nil and vim.bo[args.buf].buftype == '' then
            MiniSessions.write(nil, { verbose = false })
        end
    end,
})

autocmd('FileType', {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- nvim-treesitter (main) only supports parsers matching its own version.
autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
            vim.cmd('TSUpdate')
        end
    end,
})
