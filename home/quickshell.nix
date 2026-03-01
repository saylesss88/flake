{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  programs.quickshell = {
    enable = true;
    package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;
    configs = {
      "shell.qml" = ./shell.qml;
    };
  };
}
