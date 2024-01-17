---- Lazy.nvim Plugin manager -----
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup
require("lazy").setup({
  -- Plugins
  -- mason
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- lsp zero
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true
  },

  -- lsp support
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
    }
  },

  -- autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'L3MON4D3/LuaSnip' }
    },
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate"
  },

  -- telescope
  {
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.5',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
  },

  -- harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- commentnvim
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },

  -- rose pine
  { 'rose-pine/neovim', name = 'rose-pine' }
})

----- LSP ------
-- lsp-zero
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
  client.server_capabilities.semanticTokensProvider = nil
end)

-- mason
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
  },
})

-- cmp
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- Enter and Tab key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),

    -- Ctrl+i  to trigger completion menu
    ['<C-i>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})

-- commentnvim
require('Comment').setup()

---- REMAPS -----
-- file explorer
vim.keymap.set("n", "|", vim.cmd.Ex)

-- navigation keys in normal mode
vim.keymap.set("n", "l", "j")
vim.keymap.set("n", "k", "h")
vim.keymap.set("n", "ñ", "k")
vim.keymap.set("n", "{", "l")

-- navigation keys in visual mode
vim.keymap.set("v", "k", "h")
vim.keymap.set("v", "l", "j")
vim.keymap.set("v", "ñ", "k")
vim.keymap.set("v", "{", "l")

-- saves file on normal mode when pressing Control + S
vim.keymap.set("n", "<C-s>", ":update<CR>")

-- enters normal mode and saves the file on Control + S
vim.keymap.set("i", "<C-s>", "<Esc>:update<CR>")

-- undo and redo
vim.keymap.set("n", "'", "u")
vim.keymap.set("n", "<C-'>", "<C-r>")

-- extreme back and forth jumps
vim.keymap.set("n", "q", "b")
vim.keymap.set("n", "W", "$")
vim.keymap.set("n", "Q", "0")

-- tab indentation
vim.api.nvim_set_keymap('n', '<Tab>', '>>', { noremap = true })
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<', { noremap = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true })

-- relocate selected line(s) up and down
vim.keymap.set("v", "L", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "Ñ", ":m '<-2<CR>gv=gv")

----- SET ------
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 8
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
