{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.utils;
in
{
  options.custom.utils = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable utils module";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      parallel # Shell tool for executing jobs in parallel
      jq # Command-line JSON processor
      imagemagick # Image manipulation tools
      resvg # SVG rendering library and tools
      envsubst # Environment variable substitution utility
      killall # Process termination utility
      gnumake # Build automation tool
      just # Build automation tool
      fzf # command line fuzzy finder
      polkit_gnome # authentication agent for privilege escalation
      # dbus # inter-process communication daemon
      upower # power management/battery status daemon
      dconf # configuration storage system
      dconf-editor # dconf editor
      home-manager # user environment manager
      xdg-utils # Collection of XDG desktop integration tools
      desktop-file-utils # for updating desktop database
      hicolor-icon-theme # Base fallback icon theme
      gobject-introspection # for python packages
      trash-cli # cli to manage trash files
      gawk # awk implementation
      coreutils # coreutils implementation
      bash-completion # Add bash-completion package
      pkg-config
      openssl
      unzip
      duf

    ];

    environment.variables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.nix-ld.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    users.groups.netdev = { };
    services = {
      upower.enable = true;
      openssh.enable = true;
      libinput.enable = true;
      dbus.implementation = "broker";
      logrotate.enable = true;
      journald = {
        storage = "volatile"; # Store logs in memory
        upload.enable = false; # Disable remote log upload (the default)
        extraConfig = ''
          SystemMaxUse=500M
          SystemMaxFileSize=50M
        '';
      };
    };

    programs.dconf.enable = true;

    # For polkit authentication
    security.polkit.enable = true;
    security.pam.services.swaylock = { };
    security.rtkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # For trash-cli to work properly
    services.gvfs.enable = true;

    # For proper XDG desktop integration
    xdg.portal = {
      enable = true;
      # wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        # pkgs.xdg-desktop-portal-wlr
      ];
    };

  };
}
