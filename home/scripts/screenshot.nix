pkgs: pkgs.writeShellScript "screenshot-script" ''
    ${pkgs.grim}/bin/grim -g "$(slurp)" /home/patrick/screenshots/$(date +'%s_grim.png')
  ''
