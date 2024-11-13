{
  config,
  pkgs,
  inputs,
  ...
}: {
  _module.args = { inherit inputs; };
  imports = [
    ../programs
  ];

  wayland = {
    waybar.backlight = true;
    waybar.battery = true;
    windowManager.hyprland.settings = {
      bindl = [
        ", switch:on:Lid Switch, exec, systemctl suspend"
      ];
      monitor = "eDP-1,preferred,0x0,1";
      # bind = ["$mod, T, exec, ${(import ../scripts/toggleGameMode.nix pkgs keyboard).outPath}"];
    };
  };

  programs.waybar.settings.mainbar."hyprland/language" = {
    "on-click"
      = "hyprctl switchxkblayout kanata next";

    "keyboard-name" = "kanata";
  };
}
