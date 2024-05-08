vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.g.mapleader = " "

-- Detect wgsl filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.wgsl",
  callback = function()
    vim.bo.filetype = "wgsl"
  end,
})

require('patrick.set')
require('patrick.maps')
require('patrick.lazy_plugins')

require('nvim-tree').setup()
