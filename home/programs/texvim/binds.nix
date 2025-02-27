[
  # Neo-tree bindings
  {
    action = "<cmd>NvimTreeToggle<CR>";
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
]
