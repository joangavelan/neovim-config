local builtin = require('telescope.builtin')

-- open telescope on control + p
vim.keymap.set('n', '<C-p>', builtin.find_files, {})

-- config
local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-p>"] = actions.close,
                ["<Esc>"] = actions.close,
            },
        },
    },
})
