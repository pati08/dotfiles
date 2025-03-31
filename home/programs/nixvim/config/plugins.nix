{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # copilot
      copilot-lua = {
        enable = true;
        settings = {
          panel.enabled = false;
          suggestion.enabled = false;
        };
      };
      blink-cmp-copilot.enable = true;
      copilot-chat.enable = true;

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
              "copilot"
            ];
            providers.copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
              score_offset = 100;
            };
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

          # Nix
          nil_ls.enable = true;

          # Bash
          bashls.enable = true;

          # C/C++
          clangd.enable = true;

          # typescript
          ts_ls.enable = true;

          # Golang
          gopls.enable = true;
          # golangci_lint_ls.enable = true;

          # haskell
          hls.enable = true;
          hls.installGhc = true;
        };
      };

      none-ls = {
        enable = true;
        settings = {
          cmd = ["bash -c nvim"];
          debug = true;
        };
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

      # Buffer bar
      bufferline = {
        enable = true;
      };

      # Status bar
      lualine = {
        enable = true;
      };

      # Make `nvim .` look prettier
      oil = {
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

        move = {
          enable = true;
          setJumps = true;

          gotoNextStart = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
          };
          gotoNextEnd = {
            "]F" = "@function.outer";
            "]C" = "@class.outer";
          };
          gotoPreviousStart = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[F" = "@function.outer";
            "[C" = "@class.outer";
          };
        };

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

      # Notify
      notify = {
        enable = true;
        backgroundColour = "#1e1e2e";
        fps = 60;
        render = "default";
        timeout = 500;
        topDown = true;
      };

      # Debugger
      dap = {
        enable = true;
        signs = {
          dapBreakpoint = {
            text = "●";
            texthl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "●";
            texthl = "DapBreakpointCondition";
          };
          dapLogPoint = {
            text = "◆";
            texthl = "DapLogPoint";
          };
        };
        extensions = {
          dap-python = {
            enable = true;
          };
          dap-ui = {
            enable = true;
            floating.mappings = {
              close = ["<ESC>" "q"];
            };
          };
          dap-virtual-text = {
            enable = true;
          };
        };
        configurations = {
          java = [
            {
              type = "java";
              request = "launch";
              name = "Debug (Attach) - Remote";
              hostName = "127.0.0.1";
              port = 5005;
            }
          ];
        };
      };

      # Trouble
      trouble = {
        enable = true;
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
        registrations = {
          "<leader>pg" = "Find Git files with telescope";
          "<leader>ps" = "Find text with telescope";
          "<leader>pf" = "Find files with telescope";
        };
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

      harpoon = {
        enable = true;
      };

      # Nice surrounding features
      vim-surround = {
        enable = true;
      };

      # Floating terminal
      floaterm = {
        enable = true;
      };

      # Nix expressions in Neovim
      nix = {
        enable = true;
      };

      # Rust language support
      rustaceanvim = {
        enable = true;
        # Use whatever is around
        rustAnalyzerPackage = null;
      };

      # Status column
      statuscol.enable = true;

      web-devicons.enable = true;

      # Dashboard
      alpha = {
        enable = true;
        theme = "dashboard";
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
          neotree = true;
          harpoon = true;
          gitsigns = true;
          which_key = true;
          illuminate.enabled = true;
          treesitter = true;
          treesitter_context = true;
          telescope.enabled = true;
          indent_blankline.enabled = true;
          mini.enabled = true;
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
      require("ultimate-autopair").setup({})

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
        ultimate-autopair-nvim
        vim-sneak
      ];
  };
}
