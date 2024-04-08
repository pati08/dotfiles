{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = { mainBar = import ./settings.nix; };
  }; 
}
