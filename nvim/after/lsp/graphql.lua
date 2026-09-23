-- Adds plain ts/js for Angular's gql`...` literals; lspconfig's root_dir stays
-- config-file-only so this does not start in every TS project.
return {
    filetypes = { 'graphql', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
}
