{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../wayland
    ../term.nix
    ../neovim.nix
    ../kitty
  ];

  wayland.windowManager.hyprland.settings.bindl = [
    ", switch:on:Lid Switch, exec, systemctl suspend"
  ];
  wayland.hyprland.enableBlur = true;
  wayland.waybar.backlight = true;
  wayland.waybar.battery = true;

  wayland.windowManager.hyprland.settings.monitor = "eDP-1,preferred,0x0,1";

  programs.waybar.settings.mainBar."hyprland/language"."on-click"
    = "hyprctl switchxkblayout at-translated-set-2-keyboard next";

  programs.waybar.settings.mainBar."hyprland/language"."keyboard-name" = "at-translated-set-2-keyboard";
}
