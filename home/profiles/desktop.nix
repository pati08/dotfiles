{ config
, lib
, pkgs
, inputs
, ...
}:
let
  keyboard = "kanata";
in
{
  _module.args = { inherit inputs; };
  imports = [
    ../programs
  ];

  home.packages = with pkgs; [
    prismlauncher
    darktable
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-3,2560x1440@60,5760x0,1,vrr,2"
    "DP-2,1920x1080@60,3840x0,1"
    "HDMI-A-1,3840x2160@60,0x0,1"
    "Unknown-1,disable"
  ];

  wayland.windowManager.hyprland.settings.decoration.blur = {
    size = lib.mkForce 40;
    passes = lib.mkForce 3;
  };

  programs.waybar.settings.mainBar."hyprland/language"."on-click" = "hyprctl switchxkblayout ${keyboard} next";

  programs.waybar.settings.mainBar."hyprland/language"."keyboard-name" = "${keyboard}";
}
