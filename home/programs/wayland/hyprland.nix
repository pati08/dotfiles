{
  config,
  pkgs,
  inputs,
  ...
}:
let
  screenshotScript = (import ../../scripts/screenshot.nix pkgs).outPath;
  lockScript = (import ../../scripts/lock.nix pkgs).outPath;
  hyprpickerPkg = inputs.hyprpicker.packages."${pkgs.system}".default;

  active_opacity = 0.95;
  inactive_opacity = 0.8;
  toggleOpacity = pkgs.writeShellScript "toggle-opacity-script" ''
    active_opacity=$(hyprctl getoption decoration:active_opacity | rg 'float: ([\.\d]+)' -r '$1')

    if [ "$active_opacity" != "1.000000" ]; then
      hyprctl keyword decoration:active_opacity 1
      hyprctl keyword decoration:inactive_opacity 1
    else
      hyprctl keyword decoration:active_opacity ${toString active_opacity}
      hyprctl keyword decoration:inactive_opacity ${toString inactive_opacity}
    fi
  '';
in {
  home.packages = with pkgs; [
    xwayland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    hyprpickerPkg
    nautilus
    cliphist
    wl-clip-persist
    wtype
    grimblast
    dunst

    wl-gammarelay-rs
  ];

  services.dunst.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
  };
  gtk.enable = true;

  wayland.windowManager.hyprland =
  let
    cfg = config.wayland.hyprland;
  in {
    enable = true;
    xwayland.enable = true;
    settings = {
      "$mod" = "SUPER";
      exec-once = "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr & firefox & kitty & nm-applet --indicator & lxqt-policykit-agent & wl-paste --watch cliphist store & wl-clip-persist --clipboard regular & blueman-applet & dunst & waybar &";
      exec = "wl-gammarelay-rs";
      env = [
        "XCURSOR_SIZE,24"
      ];
      input = {
        scroll_factor = 0.66667;
        kb_layout = "us,us,gr";
        kb_variant = ",intl,";
        kb_model = "";
        kb_options = "grp:alt_shift_toggle";
        kb_rules = "";

        follow_mouse = 2;

        touchpad = {
          natural_scroll = false;
          disable_while_typing = true;
        };

        sensitivity = 0;

        scroll_method = "2fg";
      };

      general = {
        gaps_in = 2;
        gaps_out = 1;
        border_size = 2;

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        rounding = 5;

        blur = {
          enabled = true;
          size = 10;
          passes = 1;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;

        inherit active_opacity;
        inherit inactive_opacity;
        fullscreen_opacity = 1;
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      gestures.workspace_swipe = true;

      misc = {
        force_default_wallpaper = 0;
        enable_swallow = true;
        swallow_regex = "kitty";
      };

      bind = [
        # Binds that launch things
        "$mod, Return, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, E, exec, nautilus"
        "$mod, P, exec, ${hyprpickerPkg}/bin/hyprpicker -an -f hex"
        "$mod, R, exec, rofi -show drun"
        "$mod SHIFT, R, exec, rofi -show run"
        ", Print, exec, ${screenshotScript} area"
        "SHIFT, Print, exec, ${screenshotScript} screen"

        # gammarelay
        "$mod ,Up,exec,busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -500"
        "$mod ,Down,exec,busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +500"

        # Cliphist operations
        "$mod, semicolon, exec, ${(pkgs.writeShellScript "cliphist-selector" ''
          cliphist list | rofi -dmenu | cliphist decode | wl-copy
        '').outPath}"
        "$mod SHIFT, semicolon, exec, ${(pkgs.writeShellScript "cliphist-deleter" ''
          cliphist list | rofi -dmenu | cliphist delete
        '').outPath}"
        "$mod CTRL, semicolon, exec, ${(pkgs.writeShellScript "cliphist-selector" ''
          cliphist list | rofi -dmenu | cliphist decode | wl-copy && wtype -M ctrl -k v -m ctrl
        '').outPath}"


        # Hyprland utility operations
        "$mod, C, killactive"
        "$mod, Delete, exit" # would be escape, but that seems too easy to do by accident
        "$mod, V, togglefloating"
        "$mod, bracketleft, togglesplit"
        "$mod, T, exec, ${toggleOpacity.outPath}"
        "$mod, N, exec, ${lockScript}"

        # Switching windows
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Special workspaces
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, O, togglespecialworkspace, obsidian"
        "$mod SHIFT, O, movetoworkspace, special:obsidian"

        # Workspace scrolling
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Move windows within the layout
        "$mod SHIFT, H, moveactive, l"  # Move active window left
        "$mod SHIFT, L, moveactive, r"  # Move active window right
        "$mod SHIFT, K, moveactive, u"  # Move active window up
        "$mod SHIFT, J, moveactive, d"  # Move active window down

        # Swap window positions
        "$mod CTRL, H, swapwindow, l"   # Swap with left window
        "$mod CTRL, L, swapwindow, r"   # Swap with right window
        "$mod CTRL, K, swapwindow, u"   # Swap with upper window
        "$mod CTRL, J, swapwindow, d"   # Swap with lower window
      ]
      ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
          )
        10)
      );


      windowrule = [
        "opaque,title:^(darktable)$"
        "opaque,title:^(Hollow Knight)$"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, pamixer --increase 10"
        ", XF86AudioLowerVolume, exec, pamixer --decrease 10"
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, pamixer --toggle-mute"
        ", XF86AudioPlay, exec, playerctl -- play-pause"
        ", XF86AudioNext, exec, playerctl -- next "
        ", XF86AudioPrev, exec, playerctl -- previous"
      ];
    };
    package = inputs.hyprland.packages.${pkgs.system}.default;
  };
}
