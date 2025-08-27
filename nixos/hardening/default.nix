{...}: {
  imports = [
    # ./apparmor
    ./openSSH.nix
    ./dnscrypt-proxy.nix
    ./systemd.nix
    ./smartd.nix
    ./usbguard.nix
    ./auditd.nix
    ./doas.nix
    ./security.nix
    ./firewall.nix
    ./firejail.nix
    ./tailscale.nix
    ./clamav.nix
  ];
  # fileSystems."/".options = ["noexec"];
  # fileSystems."/etc/nixos".options = ["noexec"];
  # fileSystems."/srv".options = ["noexec"];
  # fileSystems."/var/log".options = ["noexec"];
  users.groups.netdev = {};
  services = {
    gnome.gnome-keyring.enable = true;
    # clamav = {
    #   daemon.enable = true;
    #   scanner.enable = true;
    #   updater.enable = true;
    #   updater.interval = "hourly";
    #   scanner.interval = "*-*-* 04:00:00";
    # };
    userborn.enable = false;
    # usbguard.enable = false;
    dbus.implementation = "broker";
    logrotate.enable = false;
    journald = {
      storage = "volatile"; # Store logs in memory
      upload.enable = false; # Disable remote log upload (the default)
      extraConfig = ''
        SystemMaxUse=500M
        SystemMaxFileSize=50M
      '';
    };
  };
}
