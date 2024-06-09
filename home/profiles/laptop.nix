{
  config,
  pkgs,
  inputs,
  ...
}: let
  keyboard = "at-translated-set-2-keyboard";
in {
  _module.args = { inherit inputs; };
  imports = [
    ../wayland
    ../term.nix
    ../nixvim
    ../kitty
  ];

  wayland = {
    windowManager.hyprland.settings.bindl = [
      ", switch:on:Lid Switch, exec, systemctl suspend"
    ];
    hyprland.enableBlur = true;
    waybar.backlight = true;
    waybar.battery = true;
    windowManager = {
      hyprland.settings.monitor = "eDP-1,preferred,0x0,1";
      hyprland.settings.bind = ["$mod, T, exec, ${(import ../scripts/toggleGameMode.nix pkgs keyboard).outPath}"];
    };
  };

  programs.waybar.settings.mainbar."hyprland/language" = {
    "on-click"
      = "hyprctl switchxkblayout at-translated-set-2-keyboard next";

    "keyboard-name" = "at-translated-set-2-keyboard";
  };
}
