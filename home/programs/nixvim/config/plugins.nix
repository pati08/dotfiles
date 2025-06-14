{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # completions
      blink-cmp = {
        enable = true;
        settings = {
          cmdline.enabled = false;
          signature.enabled = true;
          completion = {
            ghost_text.enabled = true;
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 250;
            };
            list.max_items = 30;
          };
          keymap = {
            preset = "none";
            "<S-CR>" = [ "select_and_accept" "fallback" ];
            "<Tab>" = [ "select_next" "fallback" ];
            "<C-p>" = [ "select_prev" "fallback" ];
            "<C-n>" = [ "select_next" "fallback" ];
            "<C-d>" = [ "scroll_documentation_up" "fallback" ];
            "<C-f>" = [ "scroll_documentation_down" "fallback" ];
            "<C-l>" = [ "snippet_forward" "fallback" ];
            "<C-h>" = [ "snippet_backward" "fallback" ];
          };
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };
        };
      };

      #lsp
      lsp = {
        enable = true;
        servers = {
          cssls.enable = true; # CSS
          tailwindcss.enable = true; # TailwindCSS
          html.enable = true; # HTML
          
          jdtls.enable = true;

          # Python
          ruff.enable = true;
          pylsp.enable = true;

          # Markdown
          marksman.enable = true;

          # Bash
          bashls.enable = true;

          # C/C++
          clangd.enable = true;
        };
      };

      none-ls = {
        enable = true;
        sources = {
          code_actions = {
            statix.enable = true;
            gitsigns.enable = true;
          };
          diagnostics = {
            statix.enable = true;
            deadnix.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            stylua.enable = true;
            shfmt.enable = true;
            nixpkgs_fmt.enable = true;
            google_java_format.enable = false;
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
            black = {
              enable = true;
              settings = ''
                {
                  extra_args = { "--fast" },
                }
              '';

            };
          };
        };
      };

      # flutter language support
      flutter-tools = {
        enable = true;
      };

      # Buffer bar
      bufferline = {
        enable = true;
      };

      # Status bar
      lualine = {
        enable = true;
      };

      colorizer.enable = true;

      zen-mode.enable = true;

      # Includes all parsers for treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          auto_install = true;
          indent.enable = true;
        };
      };
      # Treesitter text objects
      treesitter-textobjects = {
        enable = true;

        select = {
          enable = true;
          lookahead = true;

          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ap" = "@parameter.outer";
            "ip" = "@parameter.inner";
          };

          selectionModes = {
            "@function.outer" = "V";
            "@class.outer" = "V";
          };

          includeSurroundingWhitespace = false;
        };

        move.enable = false;

        lspInterop = {
          enable = true;
          border = "rounded";

          peekDefinitionCode = {
            "<leader>pd" = "@function.outer";
            "<leader>pc" = "@class.outer";
          };

          floatingPreviewOpts = {
            max_width = 80;
            max_height = 20;
          };
        };
      };

      # Auto-tagging
      ts-autotag.enable = true;

      dap-view = {
        enable = true;
      };
      dap-virtual-text = {
        enable = true;
      };

      # Debugger
      dap = {
        enable = true;
        adapters.executables = {
          lldb = {
            command = "${pkgs.lldb}/bin/lldb-dap";
          };
        };
        signs = {
          dapBreakpoint = {
            text = "●";
            texthl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "◆";
            texthl = "DapBreakpointCondition";
          };
          dapLogPoint = {
            text = "";
            texthl = "DapLogPoint";
          };
        };
        configurations = {
          cpp = [
            {
              name = "Launch C++";
              type = "lldb";
              request = "launch";
              program = {__raw = ''function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end'';};
              cwd = "\${workspaceFolder}";
              stopOnEntry = false;
              args = [];
            }
          ];
          c = [
            {
              name = "Launch C";
              type = "lldb";
              request = "launch";
              program = {__raw = ''function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end'';};
              cwd = "\${workspaceFolder}";
              stopOnEntry = false;
              args = [];
            }
          ];
        };
      };
      dap-python.enable = true;

      # Trouble
      trouble = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings.cmd = "Trouble";
        };
      };

      # Code snippets
      luasnip = {
        enable = true;
      };

      # Easily toggle comments
      comment = {
        enable = true;
        settings.sticky = true;
      };

      # Git signs in code
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };

      which-key = {
        enable = true;
      };

      # Markdown preview server
      markdown-preview = {
        enable = true;
        settings.theme = "dark";
      };

      # Prettier fancier command window
      noice = {
        enable = true;
      };

      # Good old Telescope
      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
      };

      # Todo comments
      todo-comments = {
        enable = true;
        settings.colors = {
          error = ["DiagnosticError" "ErrorMsg" "#DC2626"];
          warning = ["DiagnosticWarn" "WarningMsg" "#FBBF24"];
          info = ["DiagnosticInfo" "#2563EB"];
          hint = ["DiagnosticHint" "#10B981"];
          default = ["Identifier" "#7C3AED"];
          test = ["Identifier" "#FF00FF"];
        };
      };

      nvim-tree = {
        enable = true;
        git = {
          enable = true;
          ignore = true;
        };
        diagnostics = {
          enable = true;
          showOnDirs = true;
          showOnOpenDirs = false;
        };
        actions.openFile.quitOnOpen = true;
        modified.enable = true;
        renderer = {
          addTrailing = true;
        };
        view.width = 40;
      };

      # Nice surrounding features
      vim-surround = {
        enable = true;
      };

      # terminal
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<A-i>]]";
          direction = "horizontal";
        };
      };

      # lazy loading
      lz-n.enable = true;

      # Nix expressions in Neovim
      nix = {
        enable = true;
      };

      # Rust language support
      rustaceanvim = {
        enable = true;
        settings.dap.adapter = "lldb";
        lazyLoad = {
          enable = true;
          settings.ft = "rust";
        };
      };

      # Status column
      statuscol.enable = true;

      web-devicons.enable = true;

      # Dashboard
      alpha = {
        enable = true;
        theme = "dashboard";
      };

      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
        };
      };
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        no_bold = false;
        no_italic = false;
        no_underline = false;
        transparent_background = true;
        integrations = {
          cmp = true;
          noice = true;
          notify = true;
          # harpoon = true;
          gitsigns = true;
          which_key = true;
          illuminate.enabled = true;
          treesitter = true;
          treesitter_context = true;
          telescope.enabled = true;
          indent_blankline.enabled = true;
          native_lsp = {
            enabled = true;
            inlay_hints = {
              background = true;
            };
            underlines = {
              errors = ["underline"];
              hints = ["underline"];
              information = ["underline"];
              warnings = ["underline"];
            };
          };
        };
      };
    };

    extraConfigLua = /* lua */ ''
      luasnip = require("luasnip")
      kind_icons = {
        Text = "󰊄",
        Method = "",
        Function = "󰡱",
        Constructor = "",
        Field = "",
        Variable = "󱀍",
        Class = "",
        Interface = "",
        Module = "󰕳",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }
      require("headlines").setup {
          markdown = {
              query = vim.treesitter.query.parse(
                  "markdown",
                  [[
                      (atx_heading [
                          (atx_h1_marker)
                          (atx_h2_marker)
                          (atx_h3_marker)
                          (atx_h4_marker)
                          (atx_h5_marker)
                          (atx_h6_marker)
                      ] @headline)

                      (thematic_break) @dash

                      (fenced_code_block) @codeblock

                      (block_quote_marker) @quote
                      (block_quote (paragraph (inline (block_continuation) @quote)))
                      (block_quote (paragraph (block_continuation) @quote))
                      (block_quote (block_continuation) @quote)
                  ]]
              ),
              headline_highlights = { "Headline" },
              bullet_highlights = {
                  "@text.title.1.marker.markdown",
                  "@text.title.2.marker.markdown",
                  "@text.title.3.marker.markdown",
                  "@text.title.4.marker.markdown",
                  "@text.title.5.marker.markdown",
                  "@text.title.6.marker.markdown",
              },
              bullets = { "◉", "○", "✸", "✿" },
              codeblock_highlight = "CodeBlock",
              dash_highlight = "Dash",
              dash_string = "-",
              quote_highlight = "Quote",
              quote_string = "┃",
              fat_headlines = true,
              fat_headline_upper_string = "▃",
              fat_headline_lower_string = "🬂",
          },
      }

      local snippets = vim.env.LUASNIP_SNIPPETS_DIR
      if snippets then
        require("luasnip.loaders.from_lua").lazy_load({ paths = snippets })
      end

      local snippets_multi = vim.env.LUASNIP_SNIPPETS_DIRS

      if snippets_multi then
        local paths = {}
        for path in snippets_multi:gmatch("[^:]+") do
          table.insert(paths, path)
        end
        require("luasnip.loaders.from_lua").lazy_load({ paths = paths })
      end

      local npairs = require'nvim-autopairs'
      local Rule = require'nvim-autopairs.rule'
      local cond = require 'nvim-autopairs.conds'

      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(' ', ' ')
          -- Pair will only occur if the conditional function returns true
          :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2]
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only want to delete the pair of spaces when the cursor is as such: ( | )
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. '  ' .. brackets[1][2],
              brackets[2][1] .. '  ' .. brackets[2][2],
              brackets[3][1] .. '  ' .. brackets[3][2]
            }, context)
          end)
      }
      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts) return opts.char == bracket[2] end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
        }
      end
    '';

    extraConfigVim = ''
      map f <Plug>Sneak_f
      map F <Plug>Sneak_F
      map t <Plug>Sneak_t
      map T <Plug>Sneak_T
    '';

    extraPlugins = with pkgs.vimPlugins;
      [
        vim-be-good
        headlines-nvim # Should load this in at the opening of filetypes that require this, namely Markdown.
        nvim-web-devicons # Should load this in at Telescope/NvimTree actions.
        # friendly-snippets # Should load this in at LuaSnip's initialisation, no clue how tho yet...
        glow-nvim # Glow inside of Neovim
        # ultisnips
        clipboard-image-nvim
        vim-suda # saving root-owned files
        vim-sneak
      ];
  };
}
