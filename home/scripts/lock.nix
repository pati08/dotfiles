pkgs: pkgs.writeShellScript "lock-script" ''
    pidof swaylock || ${pkgs.lib.getExe pkgs.swaylock-fancy}
  ''
