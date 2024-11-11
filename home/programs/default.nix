{ config, pkgs, inputs, ... }: {
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
    theme = "duckbones";
  };
  imports = [
    ./spotify.nix
    ./browser.nix
    ./zellij.nix
    ./term.nix
    ./wayland
    # ./ags.nix
    ./nixvim
  ];
}
