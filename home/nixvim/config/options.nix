{self, ...}: {
    programs.nixvim = {
    globalOpts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Always show the signcolumn, otherwise text would be shifted when displaying error icons
      signcolumn = "yes";

      # Search
      ignorecase = true;
      smartcase = true;

      # Tab defaults (might get overwritten by an LSP server)
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 0;
      expandtab = true;
      smarttab = true;

      # folding
      foldmethod = "indent";
      foldlevelstart = 99;

      # System clipboard support, needs xclip/wl-clipboard
      # clipboard = "unnamedplus";

      # Highlight the current line
      cursorline = true;

      # Show line and column when searching
      ruler = true;

      # Global substitution by default
      gdefault = true;

      # Start scrolling when the cursor is X lines away from the top/bottom
      scrolloff = 5;
    };

    globals.mapleader = " ";

    # autoCmd = [
    #   {
    #     event = [ "BufEnter" "BufWinEnter" ];
    #     pattern = [ "*.md" "*.mdx" ];
    #     command = "MarkdownPreviewToggle";
    #   }
    # ];

    highlight = {
      Comment.fg = "#ff00ff";
      Comment.bg = "#000000";
      Comment.underline = true;
      Comment.bold = true;
    };

    autoCmd = [
      {
        event = ["BufNewFile" "BufRead"];
        pattern = "*.wgsl";
        callback = {__raw = "function() vim.bo.filetype = wgsl end";};
      }
      {
        event = "FileType";
        # pattern = [ "html" "nix"];
        pattern = "html";
        callback = "set softtabstop=2 | set shiftwidth=2 | set tabstop=2";
      }
      {
        event = "FileType";
        pattern = "markdown";
        callback = "set colorcolumn=";
      }
    ];
  };
}
