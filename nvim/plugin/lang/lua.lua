-- Only what this config calls into; the whole runtimepath is slow and indexes
-- every installed plugin. Root is pinned by .luarc.json, not ~/.config/.git.
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                    vim.fn.stdpath('data') .. '/site/pack/core/opt/mini.nvim',
                },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})
