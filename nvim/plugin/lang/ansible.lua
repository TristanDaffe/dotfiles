-- Detects playbooks/roles as yaml.ansible, K runs ansible-doc.
vim.pack.add({ { src = 'https://github.com/mfussenegger/nvim-ansible' } })

vim.filetype.add({ extension = { j2 = 'jinja' } })

-- There is no `python` on PATH; Homebrew's ansible runs from its own venv,
-- which is also where it finds its collections.
local brew_python = '/opt/homebrew/opt/ansible/libexec/bin/python'

vim.lsp.config('ansiblels', {
    settings = {
        ansible = {
            python = {
                interpreterPath = vim.fn.executable(brew_python) == 1 and brew_python or 'python3',
            },
        },
    },
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user.ansible', { clear = true }),
    pattern = 'yaml.ansible',
    callback = function(ev)
        vim.keymap.set('n', '<leader>ar', function()
            vim.cmd.write()
            require('ansible').run()
        end, { buffer = ev.buf, desc = 'Ansible: run playbook/role' })
        vim.keymap.set('x', '<leader>ar', function() require('ansible').run() end, { buffer = ev.buf, desc = 'Ansible: run selected tasks' })
    end,
})
