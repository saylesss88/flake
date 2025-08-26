{
  pkgs,
  lib,
  config,
  ...
}: let
  fallbackSession = pkgs.writeShellScriptBin "fallback-session" ''
    #!/bin/sh
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    export XDG_SESSION_TYPE=wayland
    exec ${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland || exec ${pkgs.ghostty}/bin/ghostty
  '';
  cfg = config.custom.greetd;
in {
  options.custom.greetd = {
    enable = lib.mkEnableOption "Enable GreetD";
  };
  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "jr";
          command = "${fallbackSession}/bin/fallback-session";
        };
      };
    };
  };
}
