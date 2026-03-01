{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.impermanence.nixosModules.impermanence];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import -f -N rpool
    zfs rollback -r rpool/local/root@blank
  '';

  environment.persistence."/persist" = {
    directories = [
      # "/var/lib/sbctl"
      "/etc/NetworkManager/system-connections" # This is where Wi-Fi/Ethernet profiles live
      "/var/lib/bluetooth" # While you're at it, keep your Bluetooth pairs
      "/var/lib/nixos" # Keeps track of UID/GIDs
      "/var/lib/systemd/coredump"
    ];
    # files = [
    #   "/etc/machine-id"
    # ];
  };
}
