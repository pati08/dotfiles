{ config, pkgs, ... }:

let
  catppuccinMocha = {
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
    text = "#cdd6f4";
    subtext0 = "#a6adc8";
    subtext1 = "#bac2de";
    overlay0 = "#6c7086";
    overlay1 = "#7f849c";
    overlay2 = "#9399b2";
    surface0 = "#313244";
    surface1 = "#45475a";
    surface2 = "#585b70";
    blue = "#89b4fa";
    lavender = "#b4befe";
    sapphire = "#74c7ec";
    green = "#a6e3a1";
    teal = "#94e2d5";
    yellow = "#f9e2af";
    peach = "#fab387";
    maroon = "#eba0ac";
    red = "#f38ba8";
    mauve = "#cba6f7";
    pink = "#f5c2e7";
  };
in {
  # Enable Hyprland
  services.hyprland = {
    enable = true;
    windowManager = {
      hyprland = {
        configFile = ''
          # Input settings
          input {
            scroll_factor = 0.66667
            kb_layout = "us,us,gr"
            kb_variant = ",intl,"
            kb_model = ""
            follow_mouse = 2
            touchpad {
              natural_scroll = "no"
            }
            sensitivity = 0
            scroll_method = "2fg"
          }
          # General settings
          general {
            layout = "master"
            gaps_in = 5
            gaps_out = 5
            border_size = 1
            col.active_border = "${catppuccinMocha.blue}"
            col.inactive_border = "${catppuccinMocha.overlay0}"
            rounding = 8
            no_border_on_floating = true
            animations = true
            animation_speed = 0.2
          }

          # Animations
          animation {
            enabled = true
            duration = 0.2
            curve = "cubic-bezier(.25,.1,.25,1)"
          }

          # Binds
          bind = SUPER, Return, exec, alacritty
          bind = SUPER, D, exec, rofi -show drun

          # Bar (Waybar)
          exec-once = waybar

          # Wallpaper
          exec-once = swaybg -i /path/to/your/wallpaper.png

          # Misc
          misc {
            disable_hyprland_logo = true
          }
        '';
      };
    };
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    extraConfig = {
      "layer" = "top";
      "position" = "top";
      "height" = 30;
      "modules-left" = [ "workspaces" ];
      "modules-center" = [ "clock" ];
      "modules-right" = [ "cpu" "memory" "battery" "network" ];
      "cpu" = {
        "format" = "{usage}%";
        "tooltip" = false;
        "max-length" = 20;
        "format-alt" = "CPU: {usage}%";
        "tooltip-format" = "{usage}%";
      };
      "memory" = {
        "format" = "{used_mem} GB";
        "tooltip" = false;
        "max-length" = 20;
        "format-alt" = "RAM: {used_mem} / {total_mem} GB";
        "tooltip-format" = "{used_mem} / {total_mem} GB";
      };
      "style" = "${pkgs.lib.generators.toJSON {
        "@import" = "/home/yourusername/.config/waybar/style.css";
      }}";
    };
  };

  # Waybar style
  xdg.configFile."waybar/style.css".text = ''
    * {
      font-family: "JetBrains Mono Nerd Font";
      font-size: 12px;
      background-color: ${catppuccinMocha.base};
      color: ${catppuccinMocha.text};
    }
    #workspaces button {
      border-radius: 5px;
      padding: 5px;
    }
    #cpu, #memory, #battery, #network {
      border-radius: 15px;
      padding: 5px;
      background-color: ${catppuccinMocha.surface0};
    }
  '';

  # Dunst configuration
  programs.dunst = {
    enable = true;
    settings = {
      frame_width = 1;
      frame_color = "${catppuccinMocha.blue}";
      separator_color = "${catppuccinMocha.overlay0}";
      geometry = "300x5-10+45";
      font = "JetBrains Mono Nerd Font 10";
      format = "%s";
      transparency = 10;
      idle_threshold = 0;
      monitor = 0;
      follow = "mouse";
      icons = true;
      icon_position = "left";
      # More settings...
    };
  };

  # Additional packages
  home.packages = with pkgs; [
    alacritty
    rofi
    thunar
    wl-clipboard
    grim
    slurp
    clipman
    pavucontrol
    playerctl
    jetbrains-mono # Font
    # Add any other packages you need
  ];

  # Clipboard manager
  programs.clipman.enable = true;

  # GTK theme settings
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
    gtk-font-name=JetBrains Mono 10
  '';

  # Set environment variables for the theme
  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
  };
}

