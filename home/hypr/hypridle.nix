{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hypridle.homeManagerModules.default
  ];

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages."${pkgs.system}".default;

    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    lockCmd = (import ../scripts/lock.nix pkgs).outPath;

    listeners = [
      {
        timeout = 300;
        onTimeout = "hyprctl dispatch dpms off";
        onResume = "hyprctl dispatch dpms on";
      }

      # moved to desktop profile
      # {
      #   timeout = 1800; # 30 minutes
      #   onTimeout = suspendScript.outPath;
      # }

    ];
  };
}
