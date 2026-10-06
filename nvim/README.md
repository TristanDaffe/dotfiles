# Neovim

Neovim 0.12. Plugins are managed by the built-in `vim.pack`; `nvim-pack-lock.json`
is committed. Install the external tools listed in `dependencies.txt` first.

## Layout

| Path | What goes there |
|---|---|
| `init.lua` | Only what must run before everything else: `vim.loader`, leaders, netrw off, and libraries shared by several `plugin/` files (mini.nvim). |
| `plugin/NN-*.lua` | Sourced by Neovim in name order. One domain per file: it adds its plugins (`vim.pack.add`), configures them, and holds their keymaps and autocmds. A file never relies on a plugin added by another `plugin/` file. |
| `plugin/lang/<language>.lua` | Everything specific to one language: its plugins, server settings (`vim.lsp.config`, which wins over nvim-lspconfig's defaults) and buffer-local keymaps (`FileType` autocmd). Only languages that need something get a file; load order does not matter. |
| `lua/` | Only modules required from several places. Requiring a module defines no commands or autocmds. |

Colorscheme and statusline-shape files live in `~/.config/themes/`, one directory
per theme for every app; see its README.

## Conventions

- New keymaps go under `<leader>`; window keys live on the `<M-…>` layer.
- A keymap whose `desc` reads `Word: name` (one-word category) is listed in the
  `<leader>t` action palette.
- Project-specific behaviour is detected (root markers, folder names), never
  declared inside the project: no `.nvim.lua` / `exrc`.

## Adding a language

1. Parser: `plugin/30-treesitter.lua`.
2. Server: `SERVERS` (lspconfig name) and `MASON` (package name) in `plugin/50-lsp.lua`.
3. Plugins, server settings, keymaps: `plugin/lang/<language>.lua`.
4. Anything Mason cannot install: `dependencies.txt`.
