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

  # idle settings
  config.services.hypridle.settings.listener = [
    # min brightness after 2.5 mins
    {
      timeout = 150;
      on_timeout = "brightnessctl -s set 10";
      on_resume = "brightnessctl -r";
    }
    # kb backlight off after 2.5 mins
    {
      timeout = 150;
      on_timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
      on_resume = "brightnessctl -rd rgb:kbd_backlight";
    }
    # lock after 2 mins
    {
      timeout = 120;
      on_timeout =  (pkgs.writeShellScript "lock-script" ''
        pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock
      '').outPath;
    }
  ];
}
