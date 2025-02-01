{
  config,
  pkgs,
  inputs,
  ...
}:
let
  lib = pkgs.lib;
in {
  options.wayland.waybar = {
    backlight = lib.mkEnableOption "backlight display module";
    battery = lib.mkEnableOption "battery display module";
  };

  config.home.packages = with pkgs; [
    font-awesome_5
  ];

  config.programs.waybar = {
    enable = true;
    style = ./style.css;
    package = inputs.waybar.packages."${pkgs.system}".waybar;
    # settings = { mainBar = import ./settings.nix; };
  }; 

  imports = [
    ./settings.nix
  ];
}
