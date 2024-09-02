{
  config,
  pkgs,
  inputs,
  ...
}: let
  aliases = {
    grep = "${pkgs.ripgrep}/bin/rg";
    cat = "${pkgs.bat}/bin/bat";
    ls = "${pkgs.lsd}/bin/lsd";
    zj = "${pkgs.zellij}/bin/zellij";
    za = "${pkgs.zellij}/bin/zellij a";
    zn = "${pkgs.zellij}/bin/zellij -s";
    top = "${pkgs.btop}/bin/btop";
    du = "${pkgs.diskonaut}/bin/diskonaut";
    df = "${pkgs.duf}/bin/duf";
    find = "${pkgs.fd}/bin/fd";
    ll = "${pkgs.lsd}/bin/lsd -l";
    lso = "command ls";
  };
  thokrPkg = inputs.thokr.packages."${pkgs.system}".default;
in {

  # command line utils
  home.packages = with pkgs; [
    ripgrep # better grep
    bat # better cat
    lsd # better ls
    alejandra # nix code formatting
    btop # better top
    diskonaut # better du
    scc # count lines of code
    fzf skim # kinda the same, idk which to use
    hyperfine # benchmarking
    file # very basic utility
    d2 # graphrendering
    duf # better df
    inlyne # markdown rendering
    mdcat # markdown rendering in terminal
    fd # better find
    fselect # file finding with sql-like syntax
    jless # json reading
    git-cliff # git changelogs
    pipr # interactive pipe construction
    fclones # duplicate file finder
    fend # calculator
    caligula # burning disk images
    nixos-generators
    mpg123

    usbutils # duh, it's utils for usb!
    exfatprogs # for the camera card

    # Zip files!
    unzip
    zip

    thokrPkg
  ];

  # Use fish
  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellInit = ''
      ${pkgs.fastfetch}/bin/fastfetch
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

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Patrick Oberholzer";
    userEmail = "patrickoberholzer08@gmail.com";
  };

  # programs.wezterm = {
  #   enable = true;
  #   extraConfig = /* lua */ ''
  #     local wezterm = require 'wezterm'
  #
  #     local config = {}
  #
  #     if wezterm.config_builder then
  #         config = wezterm.config_builder()
  #     end
  #
  #     -- config.font = wezterm.font 'FiraCode Nerd Font'
  #     config.font = wezterm.font_with_fallback { 'FiraCode Nerd Font', 'JetBrains Mono Nerd Font' }
  #     config.enable_tab_bar = false
  #     config.window_padding = {
  #         left = 6,
  #         right = 2,
  #         top = 6,
  #         bottom = 2,
  #     }
  #
  #     config.adjust_window_size_when_changing_font_size = false
  #
  #     config.color_scheme = "Argonaut"
  #
  #     -- config.enable_wayland = false -- Currently required when using hyprland
  #     config.enable_wayland = true
  #
  #     return config
  #   '';
  # };

  imports = [
    ./zellij.nix
  ];

  programs.direnv = {
    enable = true;
    #enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
