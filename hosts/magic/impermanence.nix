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
      "/var/lib/nixos"
    ];
  };
}
