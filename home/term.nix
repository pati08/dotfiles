{
  config,
  pkgs,
  ...
}: {

  # command line utils
  home.packages = with pkgs; [
    # Improved from GNU
    ripgrep
    bat
    lsd
    alejandra # nix code formatting

    # Misc tools
    scc
    fzf
    hyperfine # benchmarking
    file
    d2
    duf

    # Important utilities
    usbutils
    ncdu # ncurses disk usage
    exfatprogs # for the camera card

    # Zip files!
    unzip
    zip
  ];

  # Use fish
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "lsd";
      ll = "lsd -l";
      cat = "bat";
      zj = "zellij";
      za = "zellij a";
      zn = "zellij -s";
    };
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
