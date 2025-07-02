{
  lib,
  pkgs,
  inputs, # Add config to the arguments for accessing config.networking.hostName etc.
  overlays,
  ...
}: let
  PRIMARYUSBID = "B7B4-863B"; # From `blkid /dev/sda1`
  BACKUPUSBID = "Ventoy"; # Optional secondary USB
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config2.nix
    ./users.nix
    ./security.nix
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.default
    ./impermanence.nix
    ./sops.nix
  ];

  specialisation = {
    niri-test.configuration = {
      system.nixos.tags = ["niri"];

      # Add the Niri overlay if needed
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      # Enable Niri session
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-unstable;

      # Optionally, set Niri settings (see niri-flake docs for more options)
      # programs.niri.settings = { ... };

      # Set up a test user
      users.users.niri = {
        isNormalUser = true;
        uid = 1100;
        extraGroups = ["networkmanager" "video" "wheel"];
        initialPassword = "test"; # change as appropriate
      };

      # Use Greetd as a display manager for Wayland sessions
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "niri-session";
          user = "niri";
        };
      };

      # Optionally, add some useful packages for a minimal desktop
      environment.systemPackages = with pkgs; [
        ghostty
        waybar
        fuzzel
        mako
        # ...any other tools you want
      ];

      # Enable sound, networking, etc. as needed
      sound.enable = true;
      networking.networkmanager.enable = true;
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];

  nixpkgs.overlays = [overlays];

  boot.binfmt.emulatedSystems = ["x86_64-windows" "aarch64-linux"];

  # boot.initrd.luks.devices = {
  #   cryptroot = {
  #     device = "/dev/disk/by-partlabel/luks";
  #     allowDiscards = true;
  #     # fallbackToPassword = true;
  #   };
  # };
  boot.initrd.kernelModules = [
    "uas"
    "usbcore"
    "usb_storage"
    "vfat"
    "nls_cp437"
    "nls_iso8859_1"
  ];

  boot.initrd.postDeviceCommands = lib.mkBefore ''
    mkdir -p /key
    sleep 2
    mount -n -t vfat -o ro $(findfs UUID=${PRIMARYUSBID}) /key || \
    mount -n -t vfat -o ro $(findfs UUID=${BACKUPUSBID}) /key || echo "No USB key found"
  '';

  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-partlabel/luks";
    keyFile = "/key/usb-luks.key";
    fallbackToPassword = true;
    allowDiscards = true;
    preLVM = false; # Crucial!
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  networking.hostName = "magic"; # Define your hostname.

  # It seems like 'custom' might be a custom module that bundles other modules.
  # If so, ensure inputs.lib.nixOsModules correctly points to its definition.
  # Otherwise, these would be top-level options.
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

  # During system activation, compare the closure size difference between the current and new system and display a formatted table if significant changes are detected.
  # system.activationScripts.diff = ''
  #   if [[ -e /run/current-system ]]; then
  #     ${pkgs.nushell}/bin/nu -c "let diff_closure = (${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'); let table = (\$diff_closure | lines | where \$it =~ KiB | where \$it =~ → | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$' | insert Diff { get DiffBin | ansi strip | into filesize } | sort-by -r Diff | reject DiffBin); if (\$table | get Diff | is-not-empty) { print \"\"; \$table | append [[Package Old New Diff]; [\"\" \"\" \"\" \"\"]] | append [[Package Old New Diff]; [\"\" \"\" \"Total:\" (\$table | get Diff | math sum) ]] | print; print \"\" }"
  #   fi
  # '';

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  time.timeZone = "America/New_York";

  console.keyMap = "us";

  # nixpkgs.config.allowUnfree = true; # This is global, duplicates the predicate slightly.

  system.stateVersion = "25.05";
}
