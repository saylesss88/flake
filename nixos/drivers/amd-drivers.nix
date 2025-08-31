{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.custom.drivers.amdgpu;
in {
  options.custom.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD GPU and CPU Drivers";
  };

  config = mkIf cfg.enable {
    # Systemd tmpfiles rules for ROCm HIP
    systemd.tmpfiles.rules = ["L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"];

    # Video drivers configuration for X server
    services.xserver.videoDrivers = ["amdgpu"];

    # Hardware configuration for AMD GPU and CPU
    hardware = {
      amdgpu.amdvlk.enable = true;
      graphics = {
        enable = true;
        # Enable 32-bit support. This should correctly pull in 32-bit Mesa.
        enable32Bit = true;
        extraPackages = with pkgs; [
          amdvlk
          mesa # This includes the 64-bit Mesa and should trigger 32-bit Mesa when enable32Bit is true
          rocmPackages.clr.icd # OpenCL
          vulkan-loader # Vulkan runtime
          vulkan-validation-layers # Vulkan debugging (optional)
          vulkan-tools # Vulkan utilities (optional)
          gpu-viewer
        ];
        extraPackages32 = with pkgs; [
          # For AMDVLK, the 32-bit version is typically provided by `amdvlk` itself
          # when enable32Bit is true. However, if it's explicitly needed here,
          # it's often accessed via a specific derivation or package within pkgs.
          # A common way to ensure it's present is to add it to extraPackages32,
          # but `amdvlk.drivers32bit` isn't it.
          #
          # If you need specific 32-bit AMDVLK components beyond what enable32Bit provides,
          # you might need to look for `pkgs.amdvlk.override` or a specific `pkgs.lib32.amdvlk`.
          # However, for most use cases, just enabling 32-bit and including `amdvlk`
          # in `extraPackages` is sufficient.
          #
          # Let's try without explicitly adding amdvlk here, relying on enable32Bit.
          # If a specific 32-bit AMDVLK component is *still* missing after this,
          # we would need to find the exact 32-bit package for it.
          #
          # To ensure 32-bit AMDVLK support, it's usually sufficient to have
          # `amdvlk` in `extraPackages` and `enable32Bit = true`.
          # If not, it would be `pkgs.amdvlk_32bit` or similar, but often it's
          # included automatically.
        ];
      };

      # CPU microcode updates
      cpu.amd.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    # Boot configuration for AMD GPU and CPU support
    boot = {
      kernelModules = [
        # "kvm-amd"
        "amdgpu"
        # "v4l2loopback"
      ];
      kernelParams = [
        "amd_pstate=active"
        "tsc=unstable"
        "radeon.si_support=0"
        "radeon.cik_support=0"
        "amdgpu.si_support=1"
        "amdgpu.cik_support=1"
      ];
      # extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      blacklistedKernelModules = ["radeon"];
    };
  };
}
