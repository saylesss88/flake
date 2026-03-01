{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixos
    ./users.nix
    # ./impermanence.nix
  ];
  #============================#
  #      Lanzaboote
  # ===========================#
  environment.systemPackages = [];

  custom = {
    nix.enable = true;
  };

  # boot.loader.systemd-boot.enable = lib.mkForce false;

  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };
  # =================================#
  # services.displayManager.sessionPackages = [ pkgs.mangowc ];
  # services.displayManager.defaultSession = "mango";
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "jr";

  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/"; # Critical for VMs
  # Not needed with LUKS
  boot.zfs.requestEncryptionCredentials = false;
  # systemd handles mounting
  systemd.services.zfs-mount.enable = false;

  services.zfs = {
    autoScrub.enable = true;
    # periodically runs `zpool trim`
    trim.enable = true;
    # autoSnapshot = true;
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      # replace uuid# with output of UUID # from `sudo blkid /dev/vda2`
      device = "/dev/disk/by-uuid/c815272b-9f16-4a81-a307-6e6e983d8306";

      allowDiscards = true;
      preLVM = true;
    };
  };

  # ------------------------------------------------------------------
  # Roll-back root to blank snapshot on **every** boot
  # ------------------------------------------------------------------
  # Uncomment after first reboot
  # boot.initrd.postMountCommands = lib.mkAfter ''
  #   zfs rollback -r rpool/local/root@blank
  # '';

  # ------------------------------------------------------------------
  # 5. Basic system (root password, serial console for VM)
  # ------------------------------------------------------------------
  # Unique 8-hex hostId (run once in live ISO: head -c4 /dev/urandom | xxd -p)
  networking.hostId = "11fdb844";
  networking.networkmanager.enable = true;
  networking.hostName = "magic";

  users.users.root.initialPassword = "changeme"; # change after first login

  boot.kernelParams = ["console=tty1"];

  # ------------------------------------------------------------------
  # (Optional) Enable SSH for post-install configuration
  # ------------------------------------------------------------------
  # services.openssh = {
  #  enable = true;
  #  settings.PermitRootLogin = "yes";
  #};
  system.stateVersion = "26.05";
}
