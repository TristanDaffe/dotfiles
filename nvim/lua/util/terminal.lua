local M = {}

local term = { buf = -1, win = -1 }

function M.toggle()
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
end

return M
