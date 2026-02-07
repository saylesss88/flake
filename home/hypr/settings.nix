_: {
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        kb_layout = "us";
        # kb_options = [
        #   "grp:alt_caps_toggle"
        #   "caps:super"
        # ];
        numlock_by_default = true;
        repeat_rate = 50;
        repeat_delay = 300;
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
      };

      general = {
        layout = "dwindle";
        gaps_in = 4;
        gaps_out = 5;
        border_size = 1;
        resize_on_border = true;
        allow_tearing = true;

        "col.active_border" = "rgba(8DA101dd)"; # Active border color with alpha
        "col.inactive_border" = "rgba(c5c9aaff)"; # Inactive border color fully transparent

        # Alternatively, rgb without alpha:
        # col.active_border = rgb(0DB7D4);
        # col.inactive_border = rgb("313136");

        # For gradients, you can do:
        # col.active_border = rgb("0DB7D4") rgb("00CFFF") 45deg;
        # (Two colors and an optional angle for the gradient)
      };

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        vfr = true;
        vrr = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      decoration = {
        rounding = 20;
        # blur = {
        #   enabled = true;
        #   size = 14;
        #   passes = 4;
        #   brightness = 1;
        #   contrast = 1;
        #   # popups = true;
        #   # popups_ignorealpha = 0.6;
        #   ignore_opacity = false;
        #   new_optimizations = true;
        # };
        blur = {
          enabled = true;
          size = 8;
          new_optimizations = true;
          passes = 3;
          ignore_opacity = true;
        };
        shadow = {
          enabled = true;
          ignore_window = true;
          range = 6;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.5, 0, 0.99, 0.99"
          "smoothIn, 0.5, -0.5, 0.68, 1.5"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 3, smoothOut"
          "windowsIn, 1, 3, smoothOut"
          "windowsMove, 1, 4, smoothIn, slide"
          "border, 1, 5, default"
          "fade, 1, 5, smoothIn"
          "fadeDim, 1, 5, smoothIn"
          "workspaces, 1, 6, default"
        ];
      };
      windowrule = [
        # "tag +file-manager, class:^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$"
        # "tag +terminal, class:^(Alacritty|kitty|kitty-dropterm|ghostty)$"
        # "tag +browser, class:^(Brave-browser(-beta|-dev|-unstable)?)$"
        # "tag +browser, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
        # "tag +browser, class:^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
        # "tag +browser, class:^([Tt]horium-browser|[Cc]achy-browser)$"
        # "tag +projects, class:^(codium|codium-url-handler|VSCodium)$"
        # "tag +projects, class:^(VSCode|code-url-handler)$"
        # "tag +im, class:^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$"
        # "tag +im, class:^([Ff]erdium)$"
        # "tag +im, class:^([Ww]hatsapp-for-linux)$"
        # "tag +im, class:^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$"
        # "tag +im, class:^(teams-for-linux)$"
        # "tag +games, class:^(gamescope)$"
        # "tag +games, class:^(steam_app_d+)$"
        # "tag +gamestore, class:^([Ss]team)$"
        # "tag +gamestore, title:^([Ll]utris)$"
        # "tag +settings, class:^(gnome-disks|wihotspot(-gui)?)$"
        # "tag +settings, class:^([Rr]ofi)$"
        # "tag +settings, class:^(file-roller|org.gnome.FileRoller)$"
        "tag +settings, class:^(nm-applet|nm-connection-editor|blueman-manager)$"
        "tag +settings, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        # "tag +settings, class:^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"
        "tag +settings, class:(xdg-desktop-portal-gtk)"
        "move 72% 7%,title:^(Picture-in-Picture)$"
        # "center, class:^([Ff]erdium)$"
        "center, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        "center, class:([Tt]hunar), title:negative:(.*[Tt]hunar.*)"
        "center, title:^(Authentication Required)$"
        # "idleinhibit fullscreen, class:^(*)$"
        # "idleinhibit fullscreen, title:^(*)$"
        "idleinhibit fullscreen, fullscreen:1"
        "float, tag:settings*"
        "float,class:^(org.pwmt.zathura)$"
        # "float, class:^([Ff]erdium)$"
        "float, title:^(Picture-in-Picture)$"
        "float, class:^(mpv|com.github.rafostar.Clapper)$"
        "float, title:^(Authentication Required)$"
        # "float, class:(codium|codium-url-handler|VSCodium), title:negative:(.*codium.*|.*VSCodium.*)"
        # "float, class:^(com.heroicgameslauncher.hgl)$, title:negative:(Heroic Games Launcher)"
        # "float, class:^([Ss]team)$, title:negative:^([Ss]team)$"
        "float, class:([Tt]hunar), title:negative:(.*[Tt]hunar.*)"
        "float, initialTitle:(Add Folder to Workspace)"
        "float, initialTitle:(Open Files)"
        "float, initialTitle:(wants to save)"
        "size 70% 60%, initialTitle:(Open Files)"
        "size 70% 60%, initialTitle:(Add Folder to Workspace)"
        "size 70% 70%, tag:settings*"
        "size 60% 70%, class:^([Ff]erdium)$"
        "opacity 1.0 1.0, tag:browser*"
        "opacity 0.9 0.8, tag:projects*"
        "opacity 0.94 0.86, tag:im*"
        "opacity 0.9 0.8, tag:file-manager*"
        "opacity 0.8 0.7, tag:terminal*"
        "opacity 0.8 0.7, tag:settings*"
        # "opacity 0.8 0.7, class:^(gedit|org.gnome.TextEditor|mousepad)$"
        # "opacity 0.9 0.8, class:^(seahorse)$ # gnome-keyring gui"
        "opacity 0.95 0.75, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "keepaspectratio, title:^(Picture-in-Picture)$"
        "fullscreen, tag:games*"
      ];

      env = [
        "NIXOS_OZONE_WL, 1"
        "NIXPKGS_ALLOW_UNFREE, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland, x11"
        "GDK_SCALE_FACTOR,1"
        "CLUTTER_BACKEND, wayland"
        "QT_QPA_PLATFORM=wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "SDL_VIDEODRIVER, x11"
        "MOZ_ENABLE_WAYLAND, 1"
        "EDITOR,hx"
      ];
    };

    extraConfig = ''
      monitor=DP-1, 3840x2160, 0x0, 1.5
    '';
  };
}
