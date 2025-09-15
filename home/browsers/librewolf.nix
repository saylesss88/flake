{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.librewolf;
in {
  options.custom.librewolf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the LibreWolf Module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      policies = {
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        DisableAppUpdate = true;
      };
      profiles.my-default = {
        isDefault = true;
        name = "Default Profile";
        extraConfig = ''
          ${builtins.readFile ./user.js}
          "general.autoScroll" = true;
          "sidebar.verticalTabs" = true;
        '';

        settings = {
        };
      };
    };
    xdg.desktopEntries.librewolf = {
      name = "LibreWolf";
      exec = "${pkgs.librewolf}/bin/librewolf";
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };
  };
}
