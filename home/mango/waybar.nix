{
  pkgs,
  lib,
  ...
}:
with lib; {
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        reload_on_style_change = true;
        # height = 36;
        height = 46;
        margin = "5, 5, 0, 5";
        modules-center = [
          "hyprland/workspaces"
          "clock"
        ];
        modules-left = [
          "custom/startmenu"
          "hyprland/window"
          "pulseaudio"
          "cpu"
          "memory"
          "idle_inhibitor"
        ];
        modules-right = [
          "custom/hyprbindings"
          "custom/notification"
          "battery"
          "tray"
          "custom/exit"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "custom/separator" = {
          format = "|";
          interval = "once";
          tooltip = false;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };
        "tray" = {
          spacing = 6;
          icon-size = 20;
        };
        "clock" = {
          format = " {:L%I:%M %p}";
          tooltip = true;
          tooltip-format = ''
            <big>{:%A, %d.%B %Y }</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
          on-click = "ghostty -e 'btop'";
        };
        "memory" = {
          interval = 30;
          format = " {used:0.2f}GB";
          tooltip = true;
          on-click = "ghostty -e 'btop'";
          max-length = 10;
          critical = 80;
        };
        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " 🙈 No Windows? ";
          };
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };
        "custom/startmenu" = {
          tooltip = false;
          format = "";
          # exec = "rofi -show drun";
          on-click = "sleep 0.1 && rofi-launcher";
        };
        "custom/hyprbindings" = {
          tooltip = false;
          format = "󱕴";
          on-click = "sleep 0.1 && list-hypr-bindings";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground = 'red' > <sup></sup> </span> ";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
      }
    ];
    style = concatStrings [
      ''
        @import "/home/jr/.config/randpaper/themes/waybar.css";
                * {
            border: none;
            font-family: "JetBrainsMono";
            font-size: 14px;
        }

        window#waybar {
            background-color: rgba(16, 18, 36, 0.8); /* Dark background (Kanagawa base) */
            color: @rp_fg; /* Light gray text */
            transition-property: background-color;
            transition-duration: .5s;
            border-radius: 10px;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces button {
            margin: 4px 0 6px 5px;
            padding: 5px;
            background-color: transparent;
            color: #c8c0c0; /* Light gray */
            min-width: 36px;
        }

        #workspaces button.active {
            padding: 0 0 0 0;
            margin: 4px 0 6px 0;
            min-width: 36px;
        }

        #workspaces button:hover {
            background: rgba(30, 34, 50, 0.5); /* Slightly lighter background */
            border-radius: 15px;
        }

        #workspaces button.focused {
            background-color: @rp_bg; /* Tan/brown focus */
            color: #161824; /* Dark text */
        }

        #workspaces button.urgent {
            color: @rp_warn; /* Red urgent */
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #custom-keyboard-layout,
        #custom-network_traffic,
        #custom-media,
        #tray,
        #idle_inhibitor,
        #custom-power,
        #custom-updates,
        #language {
            padding: 0px 3px;
            margin: 4px 3px 5px 3px;
            color: #c8c0c0; /* Light gray */
            background-color: transparent;
        }

        #window,
        #workspaces {
            border: solid 1px #5c5c5c; /* Darker border */
            border-radius: 100px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }

        #clock {
            color: @rp_accent; /* Orange clock */
        }

        #battery {
            color: @rp_fg; /* Red battery */
        }

        @keyframes blink {
            to {
                background-color: @rp_bg; /* Light gray blink */
                color: @rp_fg; /* Dark text blink */
            }
        }

        #battery.critical:not(.charging) {
            background-color: @rp_bg; /* Red critical battery */
            color: @rp_warn;
        }

        label:focus {
            background-color: #161824; /* Dark focus */
        }

        #cpu {
            /* color: #2e3257;  Blue cpu */
            color: @rp_fg;
        }

        #memory {
            color: @rp_accent; /* Green memory */
        }

        #backlight {
            color: @rp_ok; /* Light blue backlight */
        }

        #network {
            color: @rp_fg; /* Light Blue network */
        }

        #network.disconnected {
            color: @rp_warn; /* Red disconnected network */
        }

        #pulseaudio {
            color: #ff9e64; /* Orange pulseaudio */
        }

        #pulseaudio.muted {
            color: #5c5c5c; /* Darker gray muted */
        }

        #custom-power {
            color: @rp_fg; /* Light blue power */
        }

        #custom-updates {
            color: @rp_accent; /* Green updates */
        }

        #custom-media {
            background-color: @rp_bg; /* Green media */
            color: @rp_fg; /* Dark text media */
            min-width: 100px;
        }

        #custom-media.custom-spotify {
            background-color: #9ece6a; /* Green spotify */
        }

        #custom-media.custom-vlc {
            background-color: #ff9e64; /* Orange vlc */
        }

        #temperature {
            color: @rp_warn; /* Light blue temperature */
        }

        #temperature.critical {
            background-color: #e82424; /* Red critical temp */
        }

        #tray {
            border: solid 1px @rp_border; /* Light blue tray border */
            border-radius: 30px;
        }

        #idle_inhibitor {
            background-color: @rp_bg; /* Darker idle inhibitor */
            border-radius: 15px;
        }

        #custom-keyboard-layout {
            color: #dfc5a4; /* Red keyboard layout */
        }

        #custom-separator {
            color: #5c5c5c; /* Darker separator */
            margin: 0 1px;
            padding-bottom: 5px;
        }

        #custom-network_traffic {
            color: @rp_fg; /* Orange network traffic */
        }
      ''
    ];
  };
}
