{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.obs-studio;
in {
  options.custom.obs-studio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Obs-Studio";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      #enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-source-clone
        obs-move-transition
        obs-composite-blur
        obs-backgroundremoval
      ];
    };
  };
}
