{ lib, ... }:
let
  mkVimWithMode = mode: key: action: desc: {
    inherit key action;
    inherit mode;
    options = {
      inherit desc;
    };
  };
  mkVim = mkVimWithMode "n";
  mkLua = key: lua: (mkVim key { __raw = lua; });
  mkLuaFn = key: body: (mkVim key { __raw = "function()\n${body}\nend"; });
  mkCmd = key: cmd: (mkVim key "<cmd>${cmd}<CR>");
  mkInput = key: input: (mkLuaFn key ''vim.api.nvim_input("${input}")'');
  withMode = keymap: mode: lib.attrsets.overrideExisting keymap { inherit mode; };
  mkSilent = keymap: keymap // { options.silent = true; };
  windowSwitches = [
    (mkSilent (withMode (mkInput "<C-l>" "<C-w>l" "Enter window to right") "n"))
    (mkSilent (withMode (mkInput "<C-l>" "<C-\\\\><C-n><C-w>l" "Enter window to right") "t"))
    (mkSilent (withMode (mkInput "<C-h>" "<C-w>h" "Enter window to left") "n"))
    (mkSilent (withMode (mkInput "<C-h>" "<C-\\\\><C-n><C-w>h" "Enter window to left") "t"))
    (mkSilent (withMode (mkInput "<C-k>" "<C-w>k" "Enter window above") "n"))
    (mkSilent (withMode (mkInput "<C-k>" "<C-\\\\><C-n><C-w>k" "Enter window above") "t"))
    (mkSilent (withMode (mkInput "<C-j>" "<C-w>j" "Enter window below") "n"))
    (mkSilent (withMode (mkInput "<C-j>" "<C-\\\\><C-n><C-w>j" "Enter window below") "t"))
  ];
  telescope = [
    (mkCmd "<leader>ff" "Telescope find_files" "Find files")
    (mkCmd "<leader>fw" "Telescope live_grep" "Grep find files")
    (mkCmd "<leader>fg" "Telescope git_commits" "Search git commits")
    (mkCmd "<leader>fh" "Telescope oldfiles" "Recently opened files")
    (mkCmd "<leader>fm" "Telescope marks" "Search marks")
  ];
  bufferline = [
    (mkCmd "<S-l>" "BufferLineCycleNext" "Cycle to next buffer")
    (mkCmd "<S-h>" "BufferLineCyclePrev" "Cycle to prev buffer")
    (mkCmd "<leader>bd" "bdelete" "Delete buffer")
  ];
  lsp = [
    (mkSilent (mkLua "<leader>r" "vim.lsp.buf.rename" "LSP Rename"))
    (mkSilent (mkLua "gd" "vim.lsp.buf.definition" "Go to definition"))
    (mkSilent (mkLua "gD" "vim.lsp.buf.type_definition" "Go to type definition"))
    (mkSilent (mkLua "gI" "vim.lsp.buf.implementation" "List implementations"))
    (mkSilent (mkLua "ga" "vim.lsp.buf.code_action" "List code actions"))
  ];
  mkDap = key: function: desc: (mkLuaFn key "require('dap').${function}()" "Debug: ${desc}");
  dap = [
    (mkDap "<leader>dc" "continue" "Continue")
    (mkDap "<leader>dn" "step_over" "Next line (step over)")
    (mkDap "<leader>dsi" "step_into" "Step into")
    (mkDap "<leader>db" "toggle_breakpoint" "Toggle breakpoint")
    (mkDap "<leader>dB" "set_breakpoint" "Set breakpoint")
    (mkLuaFn "<leader>dl"
      /*
      lua
      */
      ''
        require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
      '' "Debug: Set log point")
    (mkDap "<leader>dR" "repl.open" "Open REPL")
    (mkDap "<leader>dC" "run_to_cursor" "Run to cursor")
    (mkDap "<leader>dT" "terminate" "Terminate")
    (mkDap "<leader>dr" "run_last" "Run last")
  ];
in
{
  keymaps =
    windowSwitches
    ++ telescope
    ++ bufferline
    ++ lsp
    ++ dap
    ++ [
      # Toggle file tree
      (mkCmd "<leader>e" "NvimTreeToggle" "Toggle file tree")

      # Notify dismiss all
      (mkLuaFn "<leader>un" ''require("notify").dismiss({ silent = true, pending = true })'' "Dismiss all notifications")

      # zen mode
      (mkSilent (mkLuaFn "<leader>z" ''require("zen-mode").toggle({})'' "Toggle zen mode"))

      # redo
      (mkSilent (mkCmd "r" "redo" "Redo"))
    ];
}
