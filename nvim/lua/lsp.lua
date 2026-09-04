require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'yamlls',
        'angularls',
        'ansiblels',
        'bashls',
        'ts_ls',
        'html',
        'cssls',
    },
})
vim.keymap.set('n', '<leader>m', ':Mason<CR>', { desc = 'Open Mason' })

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(_, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,     opts)
    vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,    opts)
    vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr',         vim.lsp.buf.references,     opts)
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,          opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,         opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,    opts)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format,         opts)
    vim.keymap.set('n', '<leader>d',  vim.diagnostic.open_float,  opts)
    vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,   opts)
    vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,   opts)
    vim.keymap.set('n', '<C-k>',      vim.lsp.buf.signature_help, opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then on_attach(client, args.buf) end
    end,
})

local mason_pkgs = vim.fn.expand('~/.local/share/nvim/mason/packages/angular-language-server')

vim.lsp.config.angularls = {
    cmd = { 'ngserver', '--stdio', '--tsProbeLocations', mason_pkgs, '--ngProbeLocations', mason_pkgs },
    filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx' },
    root_markers = { 'angular.json', 'project.json' },
    capabilities = capabilities,
}

vim.lsp.config.ts_ls = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    capabilities = capabilities,
}

vim.lsp.config.html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_markers = { '.git' },
    capabilities = capabilities,
}

vim.lsp.config.cssls = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { '.git' },
    capabilities = capabilities,
}

vim.lsp.config.lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
}

vim.lsp.config.yamlls = {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose' },
    root_markers = { '.git' },
    capabilities = capabilities,
}

vim.lsp.config.bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash' },
    root_markers = { '.git' },
    capabilities = capabilities,
}

vim.lsp.config.ansiblels = {
    cmd = { 'ansible-language-server', '--stdio' },
    filetypes = { 'yaml.ansible' },
    root_markers = { 'ansible.cfg', '.ansible-lint' },
    capabilities = capabilities,
}

vim.lsp.enable({ 'angularls', 'ts_ls', 'html', 'cssls', 'lua_ls', 'yamlls', 'bashls', 'ansiblels' })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
