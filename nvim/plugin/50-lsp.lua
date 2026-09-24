vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
})

-- Server defaults come from nvim-lspconfig; overrides live in after/lsp/<name>.lua.
-- jdtls is started per project by nvim-jdtls (lua/lang/java.lua), so it is
-- installed but not enabled here.
local SERVERS = {
    'lua_ls', 'yamlls', 'bashls', 'ansiblels',
    'angularls', 'ts_ls', 'html', 'cssls', 'graphql',
    'protols',
}

local MASON = {
    'lua-language-server', 'yaml-language-server', 'bash-language-server', 'ansible-language-server', 'ansible-lint',
    'angular-language-server', 'typescript-language-server', 'html-lsp', 'css-lsp',
    'graphql-language-service-cli', 'protols',
    'jdtls', 'java-debug-adapter', 'java-test',
}

require('mason').setup()
local registry = require('mason-registry')
registry.refresh(function()
    for _, name in ipairs(MASON) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then
            pkg:install()
        end
    end
end)
vim.keymap.set('n', '<leader>m', ':Mason<CR>', { desc = 'Open Mason' })

vim.lsp.enable(SERVERS)

local function has_buf_map(buf, lhs)
    for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, 'n')) do
        if m.lhs == lhs then return true end
    end
    return false
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user.lsp', { clear = true }),
    callback = function(args)
        local function map(key, fn, desc)
            vim.keymap.set('n', key, fn, { buffer = args.buf, desc = 'LSP: ' .. desc })
        end
        local tb = require('telescope.builtin')
        map('gd', tb.lsp_definitions, 'go to definition')
        if not has_buf_map(args.buf, 'gr') then
            map('gr', tb.lsp_references, 'references')
        end
        map('<leader>ca', vim.lsp.buf.code_action, 'code action')
        map('<leader>rn', vim.lsp.buf.rename, 'rename symbol')
        map('<leader>lf', vim.lsp.buf.format, 'format buffer')
        map('<C-k>', vim.lsp.buf.signature_help, 'signature help')
        map('<leader>d', vim.diagnostic.open_float, 'show diagnostic')
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
            [vim.diagnostic.severity.INFO] = ' ',
        },
    },
    float = {
        source = 'if_many',
        focusable = false,
    },
})
