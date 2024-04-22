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
  wayland.waybar.backlight = true;
  wayland.waybar.battery = true;
}
