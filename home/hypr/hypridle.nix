{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # don't suspend if audio is playing
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
  lockScript = pkgs.writeShellScript "lock-script" ''
    pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}
  '';
in {
  imports = [
    inputs.hypridle.homeManagerModules.default
  ];

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages."${pkgs.system}".default;

    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    lockCmd = lockScript.outPath;

    listeners = [
      {
        timeout = 300;
        onTimeout = "hyprctl dispatch dpms off";
        onResume = "hyprctl dispatch dpms on";
      }

      {
        timeout = 1800; # 30 minutes
        onTimeout = suspendScript.outPath;
      }

    ];
  };
}
