{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  lockScriptPath = (import ../../scripts/lock.nix pkgs).outPath;
in {
  config.services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages."${pkgs.system}".default;

    settings = {
      before_sleep_cmd = lockScriptPath;
      lock_cmd = lockScriptPath;

      listener = [
        {
          timeout = 300;
          on_timeout = "hyprctl dispatch dpms off";
          on_resume = "hyprctl dispatch dpms on";
        }
        {
          timout = 5;
          on_resume = "notify-send TIMEDOUT";
        }
      ];
    };
  };
}
