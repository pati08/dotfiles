{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  keyboard = "kanata";
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # don't suspend if audio is playing
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  _module.args = { inherit inputs; };
  imports = [
    ../programs
  ];

  home.packages = with pkgs; [
    # blender
    prismlauncher
    darktable
    # cassowary
  ];

  home.sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
    # MOZ_ENABLE_WAYLAND = 0;
  };

  services.hypridle.settings.listener = [
    {
      timeout = 1800; # 30 minutes
      on_timeout = suspendScript.outPath;
    }
  ];


  wayland.windowManager.hyprland.settings.monitor = [
    "DP-3,2560x1440@60,1920x0,1,vrr,2"
    "HDMI-A-1,1920x1080@60,0x0,1"
    "Unknown-1,disable"
  ];

  wayland.windowManager.hyprland.settings.decoration.blur = {
    size = lib.mkForce 40;
    passes = lib.mkForce 3;
  };

  programs.waybar.settings.mainBar."hyprland/language"."on-click"
    = "hyprctl switchxkblayout ${keyboard} next";

  programs.waybar.settings.mainBar."hyprland/language"."keyboard-name" = "${keyboard}";
  # wayland.windowManager.hyprland.settings.bind = ["$mod, T, exec, ${(import ../scripts/toggleGameMode.nix pkgs keyboard).outPath}"];
}
