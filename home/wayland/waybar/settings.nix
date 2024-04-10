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
      height = 34;
      spacing = 4;
      "modules-left" =
        [
          "hyprland/workspaces"
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
        ]
        ++ (
          if cfg.backlight
          then ["backlight"]
          else []
        )
        ++ [
          "network"
          "custom/updates"
          "mpd"
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
        "format-icons" = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          urgent = "";
          focused = "";
          default = "";
        };
      };
      "keyboard-state" = {
        numlock = false;
        capslock = false;
        format = "{name} {icon}";
        "format-icons" = {
          locked = "";
          unlocked = "";
        };
      };
      "hyprland/window" = {
        "max-length" = 50;
        "separate-outputs" = true;
      };
      "hyprland/language" = {
        format = "{}";
        "max-length" = 18;
      };
      "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };
      "sway/scratchpad" = {
        format = "{icon} {count}";
        "show-empty" = false;
        "format-icons" = [
          ""
          ""
        ];
        tooltip = true;
        "tooltip-format" = "{app}: {title}";
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
        "on-click" = "pavucontrol";
      };
      "custom/notification" = {
        tooltip = false;
        format = "{} {icon}";
        "format-icons" = {
          notification = "<span foreground='red'><sup></sup></span> ";
          none = "";
          "dnd-notification" = "<span foreground='red'><sup></sup></span> ";
          "dnd-none" = "";
          "inhibited-notification" = "<span foreground='red'><sup></sup></span> ";
          "inhibited-none" = "";
          "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span> ";
          "dnd-inhibited-none" = "";
        };
        "return-type" = "json";
        "exec-if" = "which swaync-client";
        exec = "swaync-client -swb";
        "on-click" = "sleep 0.1 && swaync-client -t -sw";
        "on-click-right" = "swaync-client -d -sw";
        escape = true;
      };
      "custom/updates" = {
        format = "{} {icon}";
        "return-type" = "json";
        "format-icons" = {
          "has-updates" = "󱍷";
          updated = "󰂪";
        };
        "exec-if" = "which waybar-module-pacman-updates";
        exec = "waybar-module-pacman-updates --interval-seconds 5 --network-interval-seconds 300";
      };
    };
  };
}
