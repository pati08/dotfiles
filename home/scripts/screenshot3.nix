pkgs: pkgs.writeShellScript "screenshot-script" ''
    ${pkgs.grim}/bin/grim -g "$(slurp -a 3:2)" /home/patrick/screenshots/$(date +'%s_grim.png')
  ''
