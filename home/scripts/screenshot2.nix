pkgs: pkgs.writeShellScript "screenshot-script" ''
    ${pkgs.grim}/bin/grim -g "$(slurp -a 2:3)" /home/patrick/screenshots/$(date +'%s_grim.png')
  ''
