pkgs: pkgs.writeShellScript "lock-script" ''
    ps -e | grep lock || ${pkgs.lib.getExe pkgs.swaylock-fancy}
  ''
