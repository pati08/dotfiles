{
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.wayland.waybar;
in {
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 42;
      spacing = 4;
      "modules-left" =
        [
          "hyprland/workspaces"
          "idle_inhibitor"
          "pulseaudio"
        ]
        ++ (
          if cfg.backlight
          then ["backlight"]
          else []
        )
        ++ [
          "network"
          # "mpd" disabled for now because I don't (yet) use it
        ];

      "modules-center" = [
        "hyprland/window"
      ];
      "modules-right" =
        [
          "hyprland/language"
          "cpu"
          "memory"
          "temperature"
        ]
        ++ (
          if cfg.battery
          then ["battery"]
          else []
        )
        ++ [
          "tray"
          "clock"
        ];
      "hyprland/workspaces" = {
        "disable-scroll" = true;
        "on-click" = "activate";
        format = "{name}";
        "on-scroll-up" = "hyprctl dispatch workspace m-1 > /dev/null";
        "on-scroll-down" = "hyprctl dispatch workspace m+1 > /dev/null";
      };
      "hyprland/window" = {
        "max-length" = 50;
        "separate-outputs" = true;
      };
      "hyprland/language" = {
        format = "{}";
        "max-length" = 18;
      };
      mpd = {
        format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
        "format-disconnected" = "Disconnected ";
        "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
        "unknown-tag" = "N/A";
        interval = 2;
        "consume-icons" = {
          on = " ";
        };
        "random-icons" = {
          off = "<span color=\"#f53c3c\"></span> ";
          on = " ";
        };
        "repeat-icons" = {
          on = " ";
        };
        "single-icons" = {
          on = "1 ";
        };
        "state-icons" = {
          paused = "";
          playing = "";
        };
        "tooltip-format" = "MPD (connected)";
        "tooltip-format-disconnected" = "MPD (disconnected)";
      };
      "idle_inhibitor" = {
        format = "{icon}";
        "format-icons" = {
          activated = "";
          deactivated = "";
        };
      };
      tray = {
        spacing = 0;
      };
      clock = {
      format = "{:%I:%M %p}";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        "format-alt" = "{:%Y-%m-%d}";
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory = {
        format = "{}% ";
      };
      temperature = {
        "critical-threshold" = 80;
        format = "{temperatureC}°C {icon}";
        "format-icons" = [
          ""
          ""
          ""
        ];
      };
      backlight = {
        format = "{percent}% {icon}";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        "format-charging" = "{capacity}% 🗲";
        "format-plugged" = "{capacity}% ";
        "format-alt" = "{time} {icon}";
        "format-icons" = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      "battery#bat0" = {
        bat = "BAT0";
      };
      network = {
        interface = "wlan0";
        "format-wifi" = "{essid}  ";
        "format-ethernet" = "{ipaddr}/{cidr} ";
        "tooltip-format" = "{ifname} via {gwaddr} ";
        "format-linked" = "{ifname} (No IP) ";
        "format-disconnected" = "Disconnected ⚠";
        "format-alt" = "{ifname}: {ipaddr}/{cidr}";
      };
      pulseaudio = {
        format = "{volume}%{icon} {format_source}";
        "format-bluetooth" = "{volume}% {icon} {format_source}";
        "format-bluetooth-muted" = " {icon} {format_source}";
        "format-muted" = " {format_source}";
        "format-source" = "{volume}% ";
        "format-source-muted" = "";
        "format-icons" = {
          headphone = "";
          "hands-free" = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
    };
  };
}
