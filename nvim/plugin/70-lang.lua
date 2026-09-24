-- vimtex reads these at load time.
vim.g.vimtex_view_method = 'general'
vim.g.vimtex_view_general_viewer = 'bookokrat'
vim.g.vimtex_view_general_options =
    '--synctex-forward @line:@col:@tex @pdf '
    .. ' || tmux split-window -h -l 40% -e BOOKOKRAT_PROTOCOL=kittyv2 bookokrat @pdf --zen-mode'

vim.pack.add({
    -- Started per project from ftplugin/java.lua (lua/lang/java.lua).
    { src = 'https://github.com/mfussenegger/nvim-jdtls' },
    { src = 'https://github.com/lervag/vimtex', version = 'v2.18' },
    -- Detects playbooks/roles as yaml.ansible, K runs ansible-doc.
    { src = 'https://github.com/mfussenegger/nvim-ansible' },
})

vim.filetype.add({ extension = { j2 = 'jinja' } })
