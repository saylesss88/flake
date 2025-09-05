{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  cfg = config.custom.greetd;
in {
  options.custom.greetd = {
    enable = lib.mkEnableOption "Enable greetd Module";
  };

  config = lib.mkIf cfg.enable {
    systemd.network.wait-online.enable = false;
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
}
