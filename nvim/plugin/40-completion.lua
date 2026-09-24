vim.g.copilot_no_tab_map = true

vim.pack.add({
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') },
    { src = 'https://github.com/github/copilot.vim' },
})

require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },
    completion = { documentation = { auto_show = true } },
})

vim.keymap.set('i', '<C-J>', 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false, desc = 'Copilot accept' })
