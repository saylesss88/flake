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

      # Add the Niri overlay for this specialisation
      nixpkgs.overlays = [inputs.niri.overlays.niri];

      # Enable Niri session
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };

      # Optionally, add a test user and greetd for login
      users.users.niri = {
        isNormalUser = true;
        extraGroups = ["networkmanager" "video" "wheel"];
        initialPassword = "test"; # for testing only!
      };

      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = lib.mkForce "${pkgs.niri}/bin/niri";
            user = lib.mkForce "niri";
          };
          default_session = initial_session;
        };
      };

      environment.etc."niri/config.kdl".text = ''
        binds {
          Mod+T { spawn "alacritty"; }
          Mod+D { spawn "fuzzel"; }
          Mod+Q { close-window; }
          Mod+Shift+Q { exit; }
        }
      '';
      environment.systemPackages = with pkgs; [
        alacritty
        waybar
        fuzzel
        mako
      ];

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        # Optionally:
        jack.enable = true;
      };

      hardware.alsa.enablePersistence = true;

      networking.networkmanager.enable = true;
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];

  nixpkgs.overlays = [overlays inputs.niri.overlays.niri];

  boot.binfmt.emulatedSystems = ["x86_64-windows" "aarch64-linux"];

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-partlabel/luks";
      allowDiscards = true;
      # fallbackToPassword = true;
    };
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
