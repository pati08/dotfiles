-- tab width 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- folding
vim.o.foldmethod = "indent"
vim.o.foldlevelstart=99

vim.o.swapfile = false

vim.o.number = true
vim.o.relativenumber = true

-- This line caused annoying issues with `#` comments
-- vim.o.smartindent = true

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"

vim.o.colorcolumn = "80"

-- Set tabstop to 2 for HTML files
vim.api.nvim_exec([[
  autocmd FileType html set tabstop=2
]], false)
vim.api.nvim_exec([[
  autocmd FileType html set softtabstop=2
]], false)
vim.api.nvim_exec([[
  autocmd FileType html set shiftwidth=2
]], false)

vim.api.nvim_exec([[
    autocmd FileType markdown set colorcolumn=
]], false)

