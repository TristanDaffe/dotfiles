-- Adds plain ts/js for Angular's gql`...` literals; lspconfig's root_dir stays
-- config-file-only so this does not start in every TS project.
vim.lsp.config('graphql', {
    filetypes = { 'graphql', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user.graphql', { clear = true }),
    pattern = 'graphql',
    callback = function(ev) require('util.lsp').grep_usages(ev.buf) end,
})
