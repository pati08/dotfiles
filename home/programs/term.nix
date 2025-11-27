{ config
, pkgs
, inputs
, ...
}:
let
  aliases = {
    grep = "${pkgs.ripgrep}/bin/rg";
    cat = "${pkgs.bat}/bin/bat";
    ls = "${pkgs.eza}/bin/eza";
    zj = "${pkgs.zellij}/bin/zellij";
    za = "${pkgs.zellij}/bin/zellij a";
    zn = "${pkgs.zellij}/bin/zellij -s";
    top = "${pkgs.btop}/bin/btop";
    df = "${pkgs.duf}/bin/duf";
    ll = "${pkgs.eza}/bin/eza -l";
    lso = "command ls";
    lbk = "${pkgs.util-linux}/bin/lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL";
  };
  thokrPkg = inputs.thokr.packages."${pkgs.system}".default;
in
{
  home.terminal = "wezterm";

  # command line utils
  home.packages = with pkgs; [
    alejandra # nix code formatting
    tokei
    scc # count lines of code
    hyperfine # benchmarking
    file # very basic utility
    d2 # graphrendering
    duf # better df
    inlyne # markdown rendering
    mdcat # markdown rendering in terminal
    fselect # file finding with sql-like syntax
    jless # json reading
    pipr # interactive pipe construction
    fclones # duplicate file finder
    bc # calculator
    caligula # burning disk images
    dua # disk space usage visualizer
    nixos-generators
    xh # curl but better
    mpg123 # mp3 player
    wiki-tui # firefox in the terminal
    just
    mask # command runners
    mprocs # background process manager
    presenterm

    usbutils # duh, it's utils for usb!
    exfatprogs # for the camera card

    # Zip files!
    unzip
    zip

    thokrPkg # custom thokr

    g810-led # keyboard lighting
  ];

  programs = {
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
    fish = {
      enable = true;
      shellAliases = aliases;
      shellInit = ''
        set fish_greeting
      '';
      functions = {
        hm-switch = ''
          pushd ~/dotfiles
          set arg ".#$argv"
          home-manager switch --flake $arg
          popd
        '';
        os-switch = ''
          pushd ~/dotfiles
          set arg ".#$argv"
          sudo nixos-rebuild switch --flake $arg
          popd
        '';
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      difftastic.enable = true;
      difftastic.background = "dark";
      userName = "Patrick Oberholzer";
      userEmail = "patrickoberholzer08@gmail.com";
    };
    direnv.enable = true;
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
    wezterm = {
      enable = config.home.terminal == "wezterm";
      extraConfig =
        /*
        lua
        */
        ''
          local wezterm = require 'wezterm'

          local config = {}

          if wezterm.config_builder then
              config = wezterm.config_builder()
          end

          -- config.font = wezterm.font 'FiraCode Nerd Font'
          config.font = wezterm.font_with_fallback { 'FiraCode Nerd Font', 'JetBrains Mono Nerd Font' }
          config.enable_tab_bar = false
          config.window_padding = {
            left = 6,
            right = 2,
            top = 6,
            bottom = 2,
          }

          -- Catppuccin mocha theme
          config.color_scheme = 'Catppuccin Mocha'

          config.adjust_window_size_when_changing_font_size = false

          -- config.enable_wayland = false -- Currently required when using hyprland
          config.enable_wayland = true

          config.key_map_preference = "Physical";
          config.keys = {
            -- Bindings for copying and pasting
            { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
            { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
            -- Bindings for changing font size
            { key = '=', mods = 'CTRL|SHIFT', action = wezterm.action.IncreaseFontSize },
            { key = '-', mods = 'CTRL|SHIFT', action = wezterm.action.DecreaseFontSize },
            -- Reset font size
            { key = '0', mods = 'CTRL|SHIFT', action = wezterm.action.ResetFontSize },
            -- Send modified enter keys
            {
              key = "\r",
              mods = "SHIFT",
              action = wezterm.action.SendString("\x1b[13;2u"),
            },
            {
              key = "\r",
              mods = "CTRL",
              action = wezterm.action.SendString("\x1b[13;5u"),
            },
          }
          config.disable_default_key_bindings = true

          return config
        '';
    };
    fd.enable = true;
    bat.enable = true;
    eza = {
      enable = true;
      icons = "auto";
    };
    ripgrep.enable = true;
    btop.enable = true;
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    git-cliff.enable = true;
    gitui.enable = true;
    helix = {
      enable = true;
      package = pkgs.evil-helix;
    };
  };

  imports = [
    ./zellij.nix
  ];
}
