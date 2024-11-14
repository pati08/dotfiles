{self, ...}: let
  opts = {
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

    # color column
    colorcolumn="80";

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
in {
  programs.nixvim = {
    globalOpts = opts;
    inherit opts;

    diagnostics = {
      virtual_text = {
        severity = {
          # This defines the priority order of diagnostic severity
          # min = vim.diagnostic.severity.HINT;
          min = { __raw = "vim.diagnostic.severity.HINT"; };
          max = { __raw = "vim.diagnostic.severity.ERROR"; };
        };
        # Show only the highest priority diagnostic on a line
        severity_sort = true;
      };
      float = {
        source = "always"; # You can also include the source of the diagnostic
      };
      signs = true; # Show signs on the left column
      underline = true; # Underline diagnostics
      update_in_insert = false; # Update diagnostics only in normal mode
    };

    globals.mapleader = " ";

    highlight = {
      Comment = {
        fg = "#ff00ff";
        bg = "#000000";
        underline = true;
        bold = true;
      };
    };

    autoCmd = [
      {
        event = ["BufNewFile" "BufRead"];
        pattern = "*.wgsl";
        command = "set filetype=wgsl";
      }
      {
        event = ["BufNewFile" "BufRead"];
        pattern = "*.mdp";
        command = "set filetype=markdown";
      }
      {
        event = "FileType";
        pattern = "html";
        command = "set softtabstop=2 | set shiftwidth=2 | set tabstop=2";
      }
      {
        event = "FileType";
        pattern = "lisp";
        command = "set softtabstop=2 | set shiftwidth=2 | set tabstop=2";
      }
      {
        event = "FileType";
        pattern = "markdown";
        command = "set colorcolumn= | set linebreak";
      }
      {
        event = "BufWritePre";
        pattern = "*.rs";
        callback = { __raw = "function() vim.lsp.buf.format({ timeout_ms = 200 }) end"; };
      }
    ];
  };
}
