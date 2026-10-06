local group = vim.api.nvim_create_augroup('user.treesitter', { clear = true })

-- nvim-treesitter (main) only supports parsers matching its own version.
vim.api.nvim_create_autocmd('PackChanged', {
    group = group,
    callback = function(ev)
        if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
            vim.cmd('TSUpdate')
        end
    end,
})

vim.pack.add({ { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } })

require('nvim-treesitter').install({
    'lua', 'vim', 'vimdoc', 'bash', 'yaml', 'json', 'sql',
    'java', 'proto', 'html', 'css', 'javascript', 'typescript', 'tsx', 'graphql',
    'jinja', 'jinja_inline',
})

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
