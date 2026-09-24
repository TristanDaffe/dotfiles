vim.pack.add({ { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } })

-- Highlighting is started per buffer and parsers are kept in sync on update
-- by config/autocmds.lua.
require('nvim-treesitter').install({
    'lua', 'vim', 'vimdoc', 'bash', 'yaml', 'json', 'sql',
    'java', 'proto', 'html', 'css', 'javascript', 'typescript', 'tsx', 'graphql',
})
