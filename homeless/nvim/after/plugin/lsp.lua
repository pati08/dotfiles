local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, buffnr)
    lsp_zero.default_keymaps({ buffer = buffnr })
end)

-- require'lspconfig'.rust_analyzer.setup({
--     settings = {
--         ["rust-analyzer"] = {
--             check = {command = "clippy",},
--             cargo = {
--                 ["allFeatures"] = true,
--             },
--             checkOnSave = {
--                 ["allFeatures"] = true,
--                 -- ["extraArgs"] = {"--all-features"},
--             },
--             procMacro = {
--                 enabled = true,
--                 ignored = {
--                     leptos_macro = {
--                         "server",
--                     },
--                 },
--             },
--         },
--     }
-- })

require'lspconfig'.clangd.setup({})

require'lspconfig'.clojure_lsp.setup({})

require'lspconfig'.tailwindcss.setup({})

require'lspconfig'.marksman.setup{}

-- local cmp = require('cmp')
-- local cmp_action = require('lsp-zero').cmp_action()
--
-- cmp.setup({
--     mapping = cmp.mapping.preset.insert({
--         ['<CR>'] = cmp.mapping.confirm({select = false}),
--         ['<C-Space>'] = cmp.mapping.complete(),
--
--         ['<C-f>'] = cmp_action.luasnip_jump_forward(),
--         ['<C-b>'] = cmp_action.luasnip_jump_backward(),
--
--         ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-d>'] = cmp.mapping.scroll_docs(4),
--     })
-- })
