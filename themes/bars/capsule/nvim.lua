-- Capsule — Neovim
-- Returns lualine overrides merged over the base options in 10-ui.lua.
return {
    options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
        },
    },
}
