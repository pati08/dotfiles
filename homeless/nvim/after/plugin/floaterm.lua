vim.keymap.set('n', '<A-i>', function()
    vim.cmd('FloatermToggle')
end)

vim.keymap.set('t', '<A-i>', function()
    vim.api.nvim_input('<C-\\><C-n>')
    vim.cmd('FloatermToggle')
end)
