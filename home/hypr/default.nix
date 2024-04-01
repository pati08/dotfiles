{
  config,
  pkgs,
  inputs,
  ...
}: {
  _module.args = { inherit inputs; };
  imports = [
    ./hyprland.nix
    ./hypridle.nix
  ];
}
