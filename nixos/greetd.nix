{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.greetd;
in {
  options.custom.greetd = {
    enable = lib.mkEnableOption "Enable greetd Module";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
    programs.regreet = {
      enable = false;
      settings =
        (lib.importTOML ./regreet.toml)
        // {
          background = {
            path = ../imgs/cloudy-quasar.png;
          };
        };
    };
    services.greetd = {
      enable = true;
      settings = rec {
        regreet_session = {
          command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
          user = "greeter";
        };
        tuigreet_session = let
          session = "${pkgs.hyprland}/bin/Hyprland";
          tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
        in {
          command = "${tuigreet} --time --remember --cmd ${session}";
          user = "greeter";
        };
        default_session = tuigreet_session;
      };
    };
  };
}
