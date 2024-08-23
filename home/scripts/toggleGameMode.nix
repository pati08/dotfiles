pkgs: keyboard: pkgs.writeShellScript "toggle_game_mode_script" ''
    HYPRGAMEMODE=$(hyprctl getoption decoration:blur:enabled | awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:drop_shadow 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 2;\
            keyword decoration:active_opacity 1; \
            keyword decoration:inactive_opacity 1; \
            keyword decoration:fullscreen_opacity 1; \
            keyword decoration:rounding 0"
        exit
    fi
    hyprctl reload
    sleep 0.3
    hyprctl switchxkblayout ${keyboard} next
  ''
