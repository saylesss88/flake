{
  flake.nixosModules.amd-drivers =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.custom.boot;
    in
    {
      options.custom.boot.enable = lib.mkEnableOption "Enable custom boot module";

      config = lib.mkIf cfg.enable {
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

      };
    };
}
