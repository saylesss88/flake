# Virtualization / Containers
{pkgs, ...}: {
  environment.systemPackages = [pkgs.qemu_kvm];
  virtualisation.libvirtd.enable = true;
  # virtualisation.qemu.package = pkgs.qemu_kvm;
  # virtualisation.qemu.options = ["-enable-kvm"];
  # virtualisation.vmVariant = "kvm"; # Optimized for KVM
  virtualisation.podman = {
    enable = false;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = false;
  };
  programs.virt-manager.enable = true;
}
