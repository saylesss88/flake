{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.custom.hyprland;
in {
  options.custom.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.custom.hyprlandModule.enable;
      description = "Enable hyprland module";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # swww
      grim
      slurp
      wl-clipboard-rs
      cliphist
      swappy
      ydotool
      wpaperd
      wofi
      hyprpicker
      pavucontrol
      blueman
      # lxqt.lxqt-policykit
      brightnessctl
      polkit_gnome
      wlr-randr
      wtype
      rose-pine-cursor
      # nwg-look
      # yad
      # gtk-engine-murrine
    ];
    systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland = {
        enable = true;
        # hidpi = true;
      };
      systemd.enable = true;
    };

    services.mako = {
      enable = true;
      settings = {
        groupBy = "summary";
        defaultTimeout = "10000";
        icons = "true";
        borderColor = "#ff0000";
        borderRadius = "5";
        borderSize = "1";
        textColor = "#ff0000";
        margin = "0,20,,20";
        backgroundColor = "#000000";
      };
    };
    # Place Files Inside Home Directory
    home.file = {
      "Pictures/Wallpapers" = {
        source = inputs.wallpapers;
        recursive = true;
      };
      ".face.icon".source = ./face.png;
      ".config/face.png".source = ./face.png;
      ".config/swappy/config".text = ''
        [Default]
        save_dir=/home/jr/Pictures/Screenshots
        save_filename_format=swappy-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=Ubuntu
        paint_mode=brush
        early_exit=true
        fill_shape=false
      '';
      ".config/wpaperd/config.toml".text = ''
        [default]
         path = "/home/jr/Pictures/Wallpapers/"
         duration = "30m"
         transition-time = 600
      '';
    };
  };
}
