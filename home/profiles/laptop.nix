{
  config,
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland.settings.bindl = [
    ", switch:on:Lid Switch, exec, systemctl suspend"
  ];
}
