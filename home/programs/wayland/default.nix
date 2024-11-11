{
  config,
  pkgs,
  inputs,
  ...
}: {
  _module.args = { inherit inputs; };
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
    ./hypridle.nix
    ./waybar
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp
    hypridle
  ];

  programs.swaylock.enable = true;
}
