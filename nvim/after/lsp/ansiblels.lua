-- There is no `python` on PATH; Homebrew's ansible runs from its own venv,
-- which is also where it finds its collections.
local brew_python = '/opt/homebrew/opt/ansible/libexec/bin/python'

return {
    settings = {
        ansible = {
            python = {
                interpreterPath = vim.fn.executable(brew_python) == 1 and brew_python or 'python3',
            },
        },
    },
}
