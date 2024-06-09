{self, ...}: {
  programs.nixvim = {
    keymaps = [
      # Neo-tree bindings
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>e";
      }

      # Telescope bindings

      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>fw";
      }
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
      }
      {
        action = "<cmd>Telescope git_commits<CR>";
        key = "<leader>fg";
      }

      # Notify bindings

      {
        mode = "n";
        key = "<leader>un";
        action = ''
          <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
        '';
        options = {
          desc = "Dismiss All Notifications";
        };
      }

      # Bufferline bindings

      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }

      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }

      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }

      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }

      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = {
          desc = "Delete buffer";
        };
      }

      # pane switching
      {
        action = {__raw = ''function()
          vim.api.nvim_input("<C-w>l")
        end'';};
        key = "<C-l>";
        options.silent = true;
      }
      {
        action = {__raw = ''function()
          vim.api.nvim_input("<C-w>h")
        end'';};
        key = "<C-h>";
        options.silent = true;
      }
      {
        action = {__raw = ''function()
          vim.api.nvim_input("<C-w>j")
        end'';};
        key = "<C-j>";
        options.silent = true;
      }
      {
        action = {__raw = ''function()
          vim.api.nvim_input("<C-w>k")
        end'';};
        key = "<C-k>";
        options.silent = true;
      }

      # redo
      {
        action = {__raw = "function() vim.cmd(\"redo\") end";};
        key = "r";
        options.silent = true;
        mode = "n";
      }

      # Harpoon
      {
        action = {__raw = "require(\"harpoon.mark\").add_file";};
        key = "<leader>a";
        options.silent = true;
        mode = "n";
      }
      {
        action = {__raw = "require(\"harpoon.ui\").toggle_quick_menu";};
        key = "<C-e>";
        options.silent = true;
        mode = "n";
      }
      {
        action = {__raw = "function() require(\"harpoon.ui\").nav_file(1) end";};
        key = "<C-r>";
        options.silent = true;
        mode = "n";
      }
      {
        action = {__raw = "function() require(\"harpoon.ui\").nav_file(2) end";};
        key = "<C-t>";
        options.silent = true;
        mode = "n";
      }
      {
        action = {__raw = "function() require(\"harpoon.ui\").nav_file(3) end";};
        key = "<C-u>";
        options.silent = true;
        mode = "n";
      }

      # floaterm
      {
        action = {__raw = "function() vim.cmd(\"FloatermToggle\") end";};
        key = "<A-i>";
        options.silent = true;
        mode = "n";
      }
      {
        action = {__raw = ''function()
          vim.api.nvim_input("<C-\\><C-n>")
          vim.cmd("FloatermToggle")
        end'';};
        key = "<A-i>";
        options.silent = true;
        mode = "t";
      }
    ];
  };
}
