{
  config,
  pkgs,
  inputs,
  ...
}:
let
  lib = pkgs.lib;
  screenshotScript = (import ../scripts/screenshot.nix pkgs).outPath;
  screenshotScript2 = (import ../scripts/screenshot2.nix pkgs).outPath;
  screenshotScript3 = (import ../scripts/screenshot3.nix pkgs).outPath;
  hyprpickerPkg = inputs.hyprpicker.packages."${pkgs.system}".default;
in {
  home.packages = with pkgs; [
    xwayland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    rofi-wayland
    dunst
    hyprpickerPkg
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  wayland.windowManager.hyprland =
  let
    cfg = config.wayland.hyprland;
  in {
    enable = true;
    # enableNvidiaPatches = true; # option removed
    xwayland.enable = true;
    settings = {
      # "experimental:explicit_sync" = true;
      "$mod" = "SUPER";
      exec-once = "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr & waybar & firefox & kitty & nm-applet --indicator & dunst & hypridle & lxqt-policykit-agent";
      env = [
        "XCURSOR_SIZE,24"
      ];
      input = {
        scroll_factor = 0.66667;
        kb_layout = "us,us";
        kb_variant = ",intl";
        kb_model = "";
        # kb_options = "caps:ctrl_modifier";
        # kb_options = "caps:swapescape";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 2;

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = 0;

        scroll_method = "2fg";
      };

      # render = {
        # explicit_sync = 1;
        # explicit_sync_kms = 1;
      # };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "master";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        rounding = 0;

        blur = {
          enabled = false;
          size = 3;
          passes = 1;
        };

        drop_shadow = "no";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        active_opacity = 1;
        inactive_opacity = 1;
        fullscreen_opacity = 1;
      };

      animations = {
        enabled = "no";
        # enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

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
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };

      gestures.workspace_swipe = "on";

      misc.force_default_wallpaper = 0;

      bind = [
        "$mod, Q, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, E, exec, dolphin"

        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod SHIFT, L, exec, ${(import ../scripts/lock.nix pkgs).outPath}"
        #"$mod, P, pseudo" not the current layout
        "$mod, P, exec, ${hyprpickerPkg}/bin/hyprpicker -an -f hex"
        # toggle bar
        "$mod, B, exec, pkill -SIGUSR1 waybar"

        "$mod, R, exec, rofi -show drun"
        "$mod SHIFT, R, exec, rofi -show run"

        # "$mod, T, togglesplit" not the current layout

        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod, Print, exec, ${screenshotScript2}"
        "$mod SHIFT, Print, exec, ${screenshotScript3}"
        ", Print, exec, ${screenshotScript}"
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
