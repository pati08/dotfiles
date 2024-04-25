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
    loc
    fzf
    hyperfine # benchmarking
    file

    # Important utilities
    usbutils
    ncdu # ncurses disk usage
    exfatprogs # for the camera card

    # Zip files!
    unzip
    zip

    # For a cool system info greeting in the terminal
    neofetch
  ];

  # Use nushell
  programs.nushell = {
    enable = true;
    shellAliases = {
      ls = "lsd";
      ll = "lsd -l";
      cat = "bat";
    };
    extraConfig = builtins.readFile ./funcs.nu + ''
      
      $env.config = {
        show_banner: false,
      }
      neofetch
    '';
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
