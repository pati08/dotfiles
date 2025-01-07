{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  # lockScriptPath = (import ../../scripts/lock.nix pkgs).outPath;
  # lockScriptPath = "${pkgs.hyprlock}/bin/hyprlock";
  lockScriptPath = (pkgs.writeShellScript "lock-script" ''
    pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock
  '').outPath;
in {
  config.services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages."${pkgs.system}".default;

    settings = {
      general = {
        lock_cmd = lockScriptPath;
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # screen off after 5 minutes
        {
          timeout = 300;
          on_timeout = "hyprctl dispatch dpms off";
          on_resume = "hyprctl dispatch dpms on";
        }
        # sleep after 30 minutes
        {
          timeout = 1800;
          on_timeout = "systemctl suspend";
        }
      ];
    };
  };
}
