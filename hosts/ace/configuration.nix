{
  pkgs,
  inputs,
  # overlays,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config2.nix
    ./luks_key.nix
    ./users.nix
    # ./suspend_hibernate.nix
    # ./specialisation.nix
    # ./container.nix
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.default
    ./impermanence.nix
    ./sops.nix
  ];
  # gaming.enable = false;
  # docker-compose.enable = false;
  specialisation.no-sops.configuration = {
    # security.apparmor.enable = lib.mkForce false;
  };

  # All users must be declared
  users.mutableUsers = false;

  nix.settings.allowed-users = ["@wheel"];

  # Network Time Protocol (NTP)
  services.timesyncd.enable = true;

  security.pam.services.swaylock = {};
  security.pam.services.hyprlock.text = "auth include login";

  programs.nix-ld = {
    enable = true;
    libraries = [];
  };

  # Diff report
  # system.activationScripts.diff = ''
  #   BLUE=$(${pkgs.ncurses}/bin/tput setaf 4)
  #   CLEAR=$(${pkgs.ncurses}/bin/tput sgr0)

  #   if [[ -e /run/current-system ]]; then
  #     echo "$BLUE   $CLEAR System Diff Report $BLUE   $CLEAR"
  #     ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
  #     echo "$BLUE                $CLEAR"
  #   fi
  # '';

  # nixpkgs.overlays = [overlays];

  powerManagement.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  networking.hostName = "ace"; # Define your hostname.

  custom = {
    ace.enable = true; # bundle of nixos modules
    ace.timezone = "America/New_York";
    sddm.enable = false;
    ace.hostname = "ace";
    ace.locale = "en_US.UTF-8";
    boot.enable = true;
    networking.enable = true;
    greetd.enable = true;
    users.enable = true;
    nix.enable = true;
    drivers.amdgpu.enable = true;
    cachix.enable = true;
    zram.enable = true;
    lsp.enable = true;
    utils.enable = true;
    virtualbox.enable = false;
    security = {
      usbguard.enable = true;
      auditd.enable = true;
      # clamav.enable = true;
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # environment.defaultPackages = lib.mkForce [];

  time.timeZone = "America/New_York";

  console.keyMap = "us";

  # nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
