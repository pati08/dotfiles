{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  lockScriptPath = (import ../scripts/lock.nix pkgs).outPath;
in {
  imports = [
    inputs.hypridle.homeManagerModules.default
  ];

  services.hypridle = {
    #enable = true;
    package = inputs.hypridle.packages."${pkgs.system}".default;

    beforeSleepCmd = lockScriptPath;
    lockCmd = lockScriptPath;

    listeners = [
      {
        timeout = 300;
        onTimeout = "hyprctl dispatch dpms off";
        onResume = "hyprctl dispatch dpms on";
      }
    ];
  };
}
