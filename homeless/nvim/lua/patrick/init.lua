vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.g.mapleader = " "

require("patrick.remap")
require('patrick.lazy_plugins')
require('patrick.set')
require('patrick.maps')

require('nvim-tree').setup()
