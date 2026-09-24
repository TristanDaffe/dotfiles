local M = {}

-- Proto and GraphQL names are used from generated Java/TS, which the schema's
-- own server cannot see: gr greps the whole project for the word instead.
function M.grep_usages(buf)
    vim.keymap.set('n', 'gr', function()
        require('telescope.builtin').grep_string({
            search = vim.fn.expand('<cword>'),
            word_match = '-w',
            cwd = vim.fs.root(0, { '.git' }) or vim.fn.getcwd(),
        })
    end, { buffer = buf, desc = 'Usages project-wide' })
end

return M
