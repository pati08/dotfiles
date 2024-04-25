local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

return require('lazy').setup({
    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },

    -- colorscheme
    {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    -- syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter', 
        config = function()
          -- setup treesitter with config
        end,
        dependencies = {
          { "nushell/tree-sitter-nu" },
        },
        build = ":TSUpdate",
    },

    'theprimeagen/harpoon',
    'mbbill/undotree',

    -- command in center
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },

    -- sudo saving
    {
        "lambdalisue/suda.vim",
        cmd = {"SudaWrite", "SudaRead"}
    },

    -- shh
    {
        'ernstwi/vim-secret',
        cmd = 'Secret'
    },

    -- lsp & completion stuff
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        ft = { 'rust', 'python', 'lua', 'typescript', 'javascript', 'c', 'cpp', 'java', 'css', 'html' },
        dependencies = {
            -- managing lsps from neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- LSP Support
            'neovim/nvim-lspconfig',

            -- LSP Trouble
            'folke/trouble.nvim',

            -- visualize lsp progress
            {
                'j-hui/fidget.nvim',
                config = function()
                    require('fidget').setup()
                end
            },

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            -- lsp completion
            'hrsh7th/cmp-nvim-lsp',
            -- snippet completion
            'L3MON4D3/LuaSnip',
            -- path completion
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            {
                'RaafatTurki/corn.nvim',
                config = function()
                    require'corn'.setup()
                end
            }
        },
        config = function()
            -- keybindings for cmp and lsp
            local function on_attach(client, buffer)
                local keymap_opts = { buffer = buffer }
                -- Code navigation and shortcuts
                vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
                vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
                vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
                vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
                vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
                vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)
            end


            -- Set updatetime for CursorHold
            -- 300ms of no cursor movement to trigger CursorHold
            vim.opt.updatetime = 100

            -- Goto previous/next diagnostic warning/error
            vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
            vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)

            -- make the signcolumn always present
            vim.wo.signcolumn = "yes"

            -- format on write for rust
            local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.rs",
                callback = function()
                    vim.lsp.buf.format({ timeout_ms = 200 })
                end,
                group = format_sync_grp,
            })
        end
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- lsp completion
            'hrsh7th/cmp-nvim-lsp',
            -- snippet completion
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            -- path completion
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
        },
        config = function()
            vim.o.completeopt = 'menuone,noinsert,noselect'
            vim.opt.shortmess = vim.opt.shortmess + 'c'

            local cmp = require('cmp')
            cmp.setup({
              preselect = cmp.PreselectMode.None,
              snippet = {
                expand = function(args)
                  vim.fn["vsnip#anonymous"](args.body)
                end,
              },
              mapping = {
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                -- Add tab support
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<Tab>"] = cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
                }),
              },

              -- Installed sources
              sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
                { name = "buffer" },
              },
            })

        end
    },

    'nvim-lua/popup.nvim',

    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    },
    { "catppuccin/nvim", as = "catppuccin" },
    {
        'nvim-tree/nvim-tree.lua',
        opts = {
            view = {
                side = 'right',
                width = 70
            }
        }
    },
    'nvim-tree/nvim-web-devicons',
    'tpope/vim-surround',
    -- vim floaterm
    --[[ 'voldikss/vim-floaterm', ]]
    {
        'voldikss/vim-floaterm',
        cmd = 'FloatermToggle',
    },

    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    'ryanoasis/vim-devicons',
    'kabouzeid/nvim-lspinstall',

    -- rust!
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        ft = { 'rust' },
        -- config = function()
        --     --
        -- end
    },


    -- looks
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
    },
    {
        "luukvbaal/statuscol.nvim", config = function()
            -- local builtin = require("statuscol.builtin")
            require("statuscol").setup({
            -- configuration goes here, for example:
            })
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require'lualine'.setup()
        end
    },

    -- git
    -- 'tpope/vim-fugitive',
    
 --    -- copilot
 --    {
 --        'zbirenbaum/copilot.lua',
 --        cmd = 'Copilot',
 --        build = ':Copilot auth',
 --        event = 'InsertEnter',
 --        event = "InsertEnter",
 --        config = function()
 --            require("copilot").setup({
 --                suggestion = {
 --                    enabled = true,
 --                    auto_trigger = true,
 --                    keymap = {
 --                        accept = "<Tab>",
 --                        accept_word = false,
 --                        accept_line = false,
 --                        next = "<C-j>",
 --                        prev = "<C-k>",
 --                        dismiss = false,
 --                        -- dismiss = "<Esc>",
 --                    },
 --                },
 --            })
	--
 --            -- hide copilot suggestions when cmp menu is open
 --            -- to prevent odd behavior/garbled up suggestions
 --            local cmp_status_ok, cmp = pcall(require, "cmp")
 --            if cmp_status_ok then
 --                cmp.event:on("menu_opened", function()
 --                    vim.b.copilot_suggestion_hidden = true
 --                end)
	--
 --                cmp.event:on("menu_closed", function()
 --                    vim.b.copilot_suggestion_hidden = false
 --                end)
 --            end
	-- end
 --    },
})
