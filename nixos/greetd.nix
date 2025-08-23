{
  pkgs,
  config,
  lib,
  ...
}: let
  fallbackSession = pkgs.writeShellScriptBin "fallback-session" ''
    #!/bin/sh
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    export XDG_SESSION_TYPE=wayland
    exec ${pkgs.hyprland}/bin/Hyprland || exec ${pkgs.ghostty}/bin/ghostty
  '';
  cfg = config.custom.greetd;
in {
  options.custom.greetd = {
    enable = lib.mkEnableOption "Enable greetd Module";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = false;
      settings = rec {
        initial_session = {
          command = "${fallbackSession}/bin/fallback-session";
          user = "jr";
        };
        default_session = initial_session;
      };
    };
  };
}
