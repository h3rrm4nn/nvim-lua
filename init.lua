---------------------------------------------------------------
-- Plugins
---------------------------------------------------------------

-- vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- You add plugins here
  use 'h3rrm4nn/bubblegum' -- custom colorscheme
  use 'arcticicestudio/nord-vim' -- nord colorscheme
  use 'neovim/nvim-lspconfig' -- configs for lsp
  use {'neoclide/coc.nvim', branch = 'release'} -- conquer of completion
  use 'lervag/vimtex' -- live view of tex documents
  use 'nvim-lualine/lualine.nvim' -- status bar similar to airline
  use 'tpope/vim-fugitive' -- git integration
  use 'numToStr/Comment.nvim' -- comment macros
  use 'gbprod/yanky.nvim' -- ringbuffer for copy/paste

end)

---------------------------------------------------------------
-- Settings
---------------------------------------------------------------

local g = vim.g
local o = vim.o

-- colorscheme
local ok, _ = pcall(vim.cmd, 'colorscheme bubblegum-256-dark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme nord-vim')

-- relative line numbers
o.number = true
o.relativenumber = true
o.cursorline = true

-- map leader key
g.mapleader = ','
g.maplocalleader = ','

-- Use spaces instead of tabs
o.expandtab = true

-- Wrap lines
o.wrap = true

-- Linebreak on characters
o.textwidth = 120

-- 1 tab == 4 spaces
o.shiftwidth = 4
o.tabstop = 4

-- Be smart when using tabs
o.smarttab = true

-- set auto indent
o.cindent = true

o.list = true
o.listchars = 'eol:↲,trail:•,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false

o.backupdir = '/home/matthias/.config/nvim/temp_dirs/backupdir/'
o.undodir = '/home/matthias/.config/nvim/temp_dirs/undodir/'

o.history = 500

o.wildmenu = true
o.wildmode = "longest,list:longest,full"

-- activate mouse
o.mouse="a"

-- jump to last cursor position when opening buffer (see :h last-position-jump)
vim.api.nvim_create_autocmd("BufReadPost", { command = [[if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]] })

-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

---------------------------------------------------------------
-- Key bindings
---------------------------------------------------------------

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- open new tab in directory of current buffer
map('n', '<leader>te', ':tabedit <c-r>=expand("%:p:h")<cr>/')

-- previous next in command line
map('n', '<C-P>', '<Up>')
map('n', '<C-N>', '<Down>')

-- coc autocompletion
map('n', 'gd', '<Plug>(coc-definition)')

-- coc: make <CR> auto-select the first completion item and notify coc.nvim to format on enter
map('i', '<cr>', [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], { expr = true})

-- copy to clipboard
map('v', '<leader>y', '"*y')
map('v', '<leader>p', '"*p')
map('v', '<leader>Y', '"+y')
map('v', '<leader>P', '"+p')

---------------------------------------------------------------
-- Vim-Latex
---------------------------------------------------------------

vim.g.vimtex_view_method = 'mupdf'
-- vim.g.vimtex_compiler_latexmk = {'callback' : 0}
vim.g.tex_conceal = ""
vim.g.tex_flavor = 'latex'

---------------------------------------------------------------
-- Lualine
---------------------------------------------------------------
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

---------------------------------------------------------------
-- Commentary
---------------------------------------------------------------
require('Comment').setup()
-- add not supported commentary strings
local ft = require('Comment.ft')
ft.set('vhdl',"--%s") -- /* */ supported only for VHDL>2008
ft.set('matlab',"%%s")


---------------------------------------------------------------
-- Yankring
---------------------------------------------------------------
require("yanky").setup({
  ring = {
    history_length = 20,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
  },
  system_clipboard = {
    sync_with_ring = true,
  },
})

-- keybindings for Yankring, there are no defaults
vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

---------------------------------------------------------------
-- Fugitive
---------------------------------------------------------------
vim.o.diffopt='vertical'
