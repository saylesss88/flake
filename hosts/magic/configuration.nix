{
  lib,
  pkgs,
  inputs, # Add config to the arguments for accessing config.networking.hostName etc.
  overlays,
  ...
}:
#    let
#   PRIMARYUSBID = "B7B4-863B"; # From `blkid /dev/sda1`
#   BACKUPUSBID = "Ventoy"; # Optional secondary USB
# in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config2.nix
    # ./luks_key.nix
    ./users.nix
    ./suspend_hibernate.nix
    # ./security.nix
    ./specialisation.nix
    ./container.nix
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.default
    ./impermanence.nix
    ./sops.nix
  ];

  programs.nix-ld = {
    enable = true;
    libraries = [];
  };

  nixpkgs.overlays = [overlays inputs.niri.overlays.niri];

  powerManagement.enable = true;

  boot = {
    initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-partlabel/luks";
        allowDiscards = true;
        # fallbackToPassword = true;
      };
    };
    resumeDevice = "/dev/disk/by-uuid/0dbae39f-939d-42eb-916e-5372ba2c203f";
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  networking.hostName = "magic"; # Define your hostname.

  custom = {
    magic.enable = true; # bundle of nixos modules
    magic.timezone = "America/New_York";
    magic.hostname = "magic";
    magic.locale = "en_US.UTF-8";
    boot.enable = true;
    users.enable = true;
    nix.enable = true;
    drivers.amdgpu.enable = true;
    cachix.enable = true;
    zram.enable = true;
    lsp.enable = true;
    utils.enable = true;
  };

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nushell}/bin/nu -c "let diff_closure = (${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'); let table = (\$diff_closure | lines | where \$it =~ KiB | where \$it =~ → | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$' | insert Diff { get DiffBin | ansi strip | into filesize } | sort-by -r Diff | reject DiffBin); if (\$table | get Diff | is-not-empty) { print \"\"; \$table | append [[Package Old New Diff]; [\"\" \"\" \"\" \"\"]] | append [[Package Old New Diff]; [\"\" \"\" \"Total:\" (\$table | get Diff | math sum) ]] | print; print \"\" }"
    fi
  '';

  systemd.tmpfiles.rules = [
    "d /var/www 0755 root root - -"
    "d /var/www/mdbook 0755 root root - -"
    "d /home/jr/nix-book/book 0755 jr users - -"
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  networking.firewall.allowedTCPPorts = [80];

  time.timeZone = "America/New_York";

  console.keyMap = "us";

  # nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
