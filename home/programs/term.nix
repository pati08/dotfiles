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
    df = "${pkgs.duf}/bin/duf";
    ll = "${pkgs.lsd}/bin/lsd -l";
    lso = "command ls";
    lbk = "${pkgs.util-linux}/bin/lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL";
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
    dust # disk space usage visualizer
    nixos-generators
    mpg123 # mp3 player

    usbutils # duh, it's utils for usb!
    exfatprogs # for the camera card

    # Zip files!
    unzip
    zip

    thokrPkg # custom thokr

    g810-led # keyboard lighting
  ];

  # programs.thefuck = {
  #   enable = true;
  #   enableNushellIntegration = true;
  # };

  # # Use fish
  # programs.fish = {
  #   enable = true;
  #   shellAliases = aliases;
  #   shellInit = ''
  #     ${pkgs.fastfetch}/bin/fastfetch
  #     set fish_greeting
  #   '';
  #   functions = {
  #     hm-switch = ''
  #       pushd ~/dotfiles
  #       set arg ".#$argv"
  #       home-manager switch --flake $arg
  #       popd
  #     '';
  #     os-switch = ''
  #       pushd ~/dotfiles
  #       set arg ".#$argv"
  #       sudo nixos-rebuild switch --flake $arg
  #       popd
  #     '';
  #   };
  # };
  # use nushell
  programs.nushell = {
    enable = true;
    shellAliases = aliases;
    # maybe add fastfetch here later
    settings = {
      show_banner = false;
    };
    # define functions
    extraConfig = ''
      def hm-switch [arg?] {
          cd ~/dotfiles
          let flake = if $arg == ''' { '.' } else { ".$arg" }
          home-manager switch --flake $flake
          cd -
      }

      # Define the `os-switch` function
      def os-switch [arg?] {
          cd ~/dotfiles
          let flake = if $arg == ''' { '.' } else { ".$arg" }
          sudo nixos-rebuild switch --flake $flake
          cd -
      }
    '';
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.git = {
    enable = true;
    difftastic.enable = true;
    difftastic.background = "dark";
    userName = "Patrick Oberholzer";
    userEmail = "patrickoberholzer08@gmail.com";
  };

  imports = [
    ./zellij.nix
  ];

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
