{
  flake.homeModules.mpv =
    { config, lib, ... }:
    let
      cfg = config.custom.mpv;
    in
    {
      options.custom.mpv.enable = lib.mkEnableOption "Enable mpv module";

      config = lib.mkIf cfg.enable {
        programs.mpv = {
          enable = true;
          defaultProfiles = [
            ''
              # Terminal-safe (wf-recorder demos)
              profile=terminal
            ''
          ];
          profiles = {
            "terminal" = {
              # vo = "tct"; # ANSI terminal rendering
              vo = "sizel";
              hwdec = "auto-copy"; # Software decode → fast terminal
            };
            "amd-vaapi" = {
              # Your Ryzen 7000 sweet spot
              hwdec = "vaapi";
              vo = "gpu"; # gpu > gpu-next stability
              gpu-context = "wayland";
              gpu-api = "opengl"; # More reliable than Vulkan
              scale = "ewa_lanczos";
              video-sync = "display-resample";
            };
          };
        };

      };
    };
}
