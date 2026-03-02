{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.custom.drivers.amdgpu;
in
{
  options.custom.drivers.amdgpu.enable = mkEnableOption "AMD GPU/CPU optimized for AM06 Pro";

  config = mkIf cfg.enable {
    # Modern ROCm/HIP support
    systemd.tmpfiles.rules = [ "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}" ];

    hardware = {
      # Use the newer NixOS 24.11+ option for early loading
      amdgpu.initrd.enable = true;

      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          rocmPackages.clr.icd # For OpenCL/Compute
          amdvlk # Optional: some games prefer this over the default RADV
          vaapiVdpau
          libvdpau-va-gl
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

    # For AceMagician's dual-ethernet or specific Wi-Fi chips,
    # using the latest kernel is highly recommended.
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
