{
  config,
  pkgs,
  inputs,
  ...
}:
let
  lib = pkgs.lib;
in {
  options = {
    wayland.hyprland = {
      enableBlur = lib.mkEnableOption "Hyprland blur";
      enableAnimations = lib.mkEnableOption "Hyprland animations";
    };
  };

  config = {
    home.packages = with pkgs; [
      xwayland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      meson
      wayland-protocols
      wayland-utils
      wl-clipboard
      waybar
      rofi-wayland
      hypridle
      dunst
      inputs.hyprpicker.packages."${pkgs.system}".default
    ];

    wayland.windowManager.hyprland =
    let
      cfg = config.wayland.hyprland;
    in {
      enable = true;
      # enableNvidiaPatches = true; # option removed
      xwayland.enable = true;
      settings = {
        "$mod" = "SUPER";
        monitor = ",preferred,0x0,1";
        exec-once = "waybar & firefox & kitty & nm-applet --indicator & dunst & hypridle";
        env = [
          "XCURSOR_SIZE,24"
        ];
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 0;

          touchpad = {
            natural_scroll = "no";
          };

          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
        };

        decoration = {
          rounding = 5;

          blur = {
            enabled = cfg.enableBlur;
            # enabled = true;
            size = 3;
            passes = 1;
          };

          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          enabled = if cfg.enableAnimations then "yes" else "no";
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

        master.new_is_master = true;

        gestures.workspace_swipe = "off";

        misc.force_default_wallpaper = -1;

        bind = [
          "$mod, Q, exec, kitty"
          "$mod, F, exec, firefox"
          "$mod, E, exec, dolphin"

          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, V, togglefloating"
          "$mod SHIFT, L, exec, ${(import ../scripts/lock.nix pkgs).outPath}"
          "$mod, P, pseudo"

          "$mod, R, exec, rofi -show drun"
          "$mod SHIFT, R, exec, rofi -show run"

          "$mod, T, togglesplit"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
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
    };
  };
}
