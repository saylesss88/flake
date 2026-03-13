{
  flake.nixosModules.amd-drivers =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    with lib;
    let
      cfg = config.custom.amd-drivers;
    in
    {
      options.custom.amd-drivers.enable = mkEnableOption "AMD GPU/CPU optimized for AM06 Pro";

      config = mkIf cfg.enable {
        # Modern ROCm/HIP support
        systemd.tmpfiles.rules = [ "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}" ];
        services.xserver.videoDrivers = [ "amdgpu" ];

        hardware = {
          amdgpu.initrd.enable = true;

          graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
              rocmPackages.clr.icd # For OpenCL/Compute
              # Hardware Acceleration (Video Encoding/Decoding)
              libva
              libva-utils
              libva-vdpau-driver
              libvdpau-va-gl
              mesa-demos # OpenGL info

              # debugging/info tools
              # vulkan-tools # Provides 'vulkaninfo'
              # clinfo # Provides 'clinfo' to check OpenCL status
            ];
          };

          cpu.amd.updateMicrocode = true;
        };

        boot = {
          kernelModules = [
            "kvm-amd"
            "amdgpu"
          ];
          kernelParams = [
            "amd_pstate=active" # Best for Ryzen 5000+ power management
          ];
        };

        boot.kernelPackages = pkgs.linuxPackages_latest;

        environment.sessionVariables = {
          # Force VA-API detection
          LIBVA_DRIVER_NAME = "radeonsi"; # Ryzen 7000 iGPU

          # mpv terminal-friendly defaults
          MPV_VO = "tct"; # Terminal playback
        };
      };
    };
}
