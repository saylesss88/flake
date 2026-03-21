{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ./impermanence.nix
    # inputs.self.nixosModules.amd-drivers
    # inputs.self.nixosModules.mangowc
  ];
  environment.systemPackages = [ ];

  custom = {
    mangowc.enable = true;
    utils.enable = true;
    zram.enable = true;
    zsh.enable = true;
    my-fonts.enable = true;
    quickshell.enable = false;
    magic = {
      enable = true;
      timezone = "America/New_York";
      hostname = "magic";
      locale = "en_US.UTF-8";
    };
    nix.enable = true;
    amd-drivers.enable = true;
  };

  time.timeZone = "America/New_York";
  services.chrony.enableNTS = true;
  services.fstrim.enable = true;

  # systemd handles mounting
  systemd.services.zfs-mount.enable = false;

  services.zfs = {
    autoScrub.enable = true;
    # periodically runs `zpool trim`
    trim.enable = true;
    # autoSnapshot = true;
  };

  security = {
    sudo.configFile = ''
      Defaults lecture=always
      Defaults lecture_file=${misc/groot.txt}
    '';
  };

  # Unique 8-hex hostId (run once in live ISO: head -c4 /dev/urandom | xxd -p)
  networking.hostId = "11fdb844";
  networking.networkmanager.enable = true;
  networking.hostName = "magic";

  users.users.root.initialPassword = "changeme"; # change after first login

  boot.kernelParams = [ "console=tty1" ];

  system.stateVersion = "25.11";
}
