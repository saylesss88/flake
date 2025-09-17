{lib, ...}: {
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
    # ./tailscale.nix
    ./clamav.nix
  ];
  # fileSystems."/".options = ["noexec"];
  # fileSystems."/etc/nixos".options = ["noexec"];
  # fileSystems."/srv".options = ["noexec"];
  # fileSystems."/var/log".options = ["noexec"];
  #
  environment.etc."issue".text = ''
    Access prohibited, this system is audited and actively monitored no privacy should be expected
  '';

  # Require long passwords
  environment.etc."login.defs".text = lib.mkForce ''
    PASS_MIN_LEN 12
    PASS_MAX_DAYS 90
    PASS_MIN_DAYS 7
    PASS_WARN_AGE 14
  '';
  users.groups.netdev = {};
  services = {
    gnome.gnome-keyring.enable = true;
    userborn.enable = false;
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
