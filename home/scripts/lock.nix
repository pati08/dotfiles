pkgs: pkgs.writeShellScript "lock-script" ''
    ps -e | grep hyprlock || ${pkgs.hyprlock}/bin/hyprlock
  ''
