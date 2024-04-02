-- navigation between nvim panes
vim.keymap.set('n', '<C-l>', function()
    vim.api.nvim_input('<C-w>l')
end)

vim.keymap.set('n', '<C-h>', function()
    vim.api.nvim_input('<C-w>h')
end)

vim.keymap.set('n', '<C-j>', function()
    vim.api.nvim_input('<C-w>j')
end)

vim.keymap.set('n', '<C-k>', function()
    vim.api.nvim_input('<C-w>k')
end)


-- redo
vim.keymap.set('n', 'r', function()
    vim.cmd('redo')
end)


-- leptos rs formatting
vim.keymap.set('n', '<A-f>', function()
    vim.cmd('!leptosfmt ./**/*.rs')
end)


-- Image pasting for markdown
function PasteImage ()
    vim.ui.input({ prompt = 'Enter the name for the image file: ' }, function(input)
        vim.cmd('!xclip -selection clipboard -t image/png -o > ' .. input .. '.png')
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { '![['.. input ..'.png]]' })
    end)
end

vim.api.nvim_create_user_command('PasteImage', PasteImage, {desc="Paste an image from the clipboard and link to it (Markdown)"})


-- code to insert a google search link in Markdown
local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local function urlencode(url)
    if url == nil then
        return
    end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
end

vim.keymap.set('n', '<leader>gp', function() 
    vim.ui.input({ prompt = 'Enter search: ' }, function(input)
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, {
            '[Google - ' .. input .. '](https://google.com/search?q=' .. urlencode(input) .. ')',
        })
    end)
end)

vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
