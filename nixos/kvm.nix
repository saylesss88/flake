{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.kvm;
in {
  options.custom.kvm = {
    enable = lib.mkEnableOption "Enable Qemu-KVM";
  };
  ## for QEMU-KVM ##
  ### remember to add user into group libvirtd
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
      virt-viewer
    ];

    # Virt-Manager GUI
    programs.virt-manager.enable = true;
    # Enable TPM emulation
    virtualisation = {
      # libvirtd daemon
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          # enables a TPM emulator
          swtpm.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };
      # allow USB device to be forwarded
      spiceUSBRedirection.enable = true;
    };
    # Spice protocol improves VM display and input responsiveness
    services.spice-vdagentd.enable = true;
    # Enable nested virtualization
    # boot.extraModprobeConfig = "options kvm_amd nested=1";
  };
}
