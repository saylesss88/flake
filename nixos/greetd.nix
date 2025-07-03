{pkgs, ...}: let
  fallbackSession = pkgs.writeShellScriptBin "fallback-session" ''
    #!/bin/sh
    exec ${pkgs.hyprland}/bin/Hyprland || exec ${pkgs.ghostty}/bin/ghostty
  '';
in {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${fallbackSession}/bin/fallback-session";
        user = "jr";
      };
      default_session = initial_session;
    };
  };
}
