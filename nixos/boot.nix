_:
{

  boot = {
    supportedFilesystems = [ "zfs" ];
    # using LUKS instead
    zfs.requestEncryptionCredentials = false;
    zfs.devNodes = "/dev/"; # Critical for VMs
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
        configurationLimit = 15;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.luks.devices = {
      cryptroot = {
        # replace uuid# with output of UUID # from `sudo blkid /dev/vda2`
        device = "/dev/disk/by-uuid/c815272b-9f16-4a81-a307-6e6e983d8306";

        allowDiscards = true;
        preLVM = true;
      };
    };
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/var/lib/sbctl";
    # };
  };

}
