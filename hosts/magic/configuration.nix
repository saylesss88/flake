{
  pkgs,
  lib,
  inputs,
  host,
  system,
  colorscheme,
  userVars,
  ...
}: {
  imports = [
    ./hardware.nix
    ./security.nix
    ./users.nix
    # inputs.lib.nixOsModules # Likely redundant, remove if it causes issues
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.default
    # inputs.impermanence.nixosModules.impermanence # Only keep if you use it for other paths like /var/log, etc.
    ./disk-config.nix
    ./impermanence.nix # If this file defines additional impermanence-related configurations
  ];

  # Home-Manager Configuration needs to be here for home.packages to be available in the Configuration Package and VM i.e.
  # `nix build .#nixos`
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit pkgs inputs host system colorscheme userVars;};
    users.jr = {...}: {
      imports = [
        inputs.lib.homeModules
        ./home.nix
      ];
    };
  };
  ############################################################################
  # Corrected boot.initrd.postBootCommands script
  boot.initrd.postBootCommands = lib.mkAfter ''
    set -euo pipefail # Exit on error, unset variables, pipefail

    mkdir -p /btrfs_tmp
    mount -o subvol=/ /dev/nvme0n1 /btrfs_tmp # Mount the root of the Btrfs partition to operate on subvolumes

    # If /rootfs subvolume exists, move it to old_roots with a timestamp
    if [[ -e /btrfs_tmp/rootfs ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/rootfs)" "+%Y-%m-%d_%H:%M:%S")
      echo "Archiving old /rootfs to /btrfs_tmp/old_roots/$timestamp"
      mv /btrfs_tmp/rootfs "/btrfs_tmp/old_roots/$timestamp"
    fi

    # Define recursive subvolume deletion function
    delete_subvolume_recursively() {
      local subvol_path="$1"
      IFS=$'\n' # Set IFS to newline to handle spaces in subvolume names
      for i in $(btrfs subvolume list -o "$subvol_path" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      echo "Deleting subvolume: $subvol_path"
      btrfs subvolume delete "$subvol_path"
    }

    # Prune old root subvolumes older than 30 days
    # Note: `find` outputs full paths, so using `/btrfs_tmp/$i` might be incorrect
    # if `find` already gives the full path relative to the mount point.
    # It's safer to provide the full path to `delete_subvolume_recursively`.
    echo "Pruning old root subvolumes older than 30 days..."
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30 -type d -print); do
      # $i will be something like /btrfs_tmp/old_roots/2024-05-30_HH:MM:SS
      # We need to pass the *absolute path* of the subvolume on the mounted filesystem.
      # Since we moved them to /btrfs_tmp/old_roots/, and /btrfs_tmp is the root of the btrfs fs,
      # we can strip the /btrfs_tmp prefix to get the subvolume path relative to the root of the Btrfs partition.
      # Or, even simpler, directly call it with the absolute path within the temporary mount.
      delete_subvolume_recursively "$i"
    done


    # Create a new, fresh /rootfs subvolume
    echo "Creating new /rootfs subvolume..."
    btrfs subvolume create /btrfs_tmp/rootfs

    # Unmount the temporary mount point
    echo "Unmounting /btrfs_tmp..."
    umount /btrfs_tmp
  '';

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "codeium"
    ];

  nixpkgs.overlays = [
    inputs.lib.overlays
  ];

  # disko.enable = true; # Not needed if disko is imported via inputs.disko.nixosModules.default

  # Enable/Disable Custom Modules
  custom = {
    # stylixModule.enable = true;
    bootModule.enable = true;
    cachixModule.enable = true;
    packagesModule.enable = true;
    users.enable = true;
    drivers.amdgpu.enable = true;
    vm.guest-services.enable = true;
    utilsModule.enable = true;
    lspModule.enable = true;
    nixModule.enable = true;
    zram.enable = true;
  };

  users = {
    mutableUsers = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];
  # virtualisation.libvirtd.enable = true;
  # virtualisation.qemu.package = pkgs.qemu_kvm;
  # virtualisation.qemu.options = ["-enable-kvm"]; # Correct syntax
  # virtualisation.vmVariant = "kvm"; # Optimized for KVM
  # local.hardware-clock.enable = true; # If local.hardware-clock is a custom option, make sure it's defined

  # During system activation, compare the closure size difference between the current and new system and display a formatted
  # table if significant changes are detected.
  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nushell}/bin/nu -c "let diff_closure = (${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'); let table = ($diff_closure | lines | where $it =~ KiB | where $it =~ → | parse -r '^(?<Package>\S+): (?<Old>[^,]+)(?:.*) → (?<New>[^,]+)(?:.*), (?<DiffBin>.*)$' | insert Diff { get DiffBin | ansi strip | into filesize } | sort-by -r Diff | reject DiffBin); if ($table | get Diff | is-not-empty) { print \"\"; $table | append [[Package Old New Diff]; [\"\" \"\" \"\" \"\"]] | append [[Package Old New Diff]; [\"\" \"\" \"Total:\" ($table | get Diff | math sum) ]] | print; print \"\" }"
    fi
  '';

  # Enable Impermanence isEphemeral = true; # This line is commented out.
  # If you want to use the nixos-impermanence module for '/', uncomment this and remove the manual script.
  # fileSystems."/".options = ["${inputs.impermanence.fileSystemOptions.ephemeral}"]; # Example for impermanence module

  # Set your time zone.
  time.timeZone = "America/New_York";

  # nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"]; # Uncomment if needed

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  # system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable"; # Uncomment if you want unstable channel

  # console.keyMap = userVars.keys;
  console.keyMap = "us";

  # nixpkgs.config.allowUnfree = true; # Remove this if you only want to allow specified packages via allowUnfreePredicate

  networking.hostName = "magic";
  # This value determines the NixOS release from which the default settings for stateful data, like file locations and
  # database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release
  # version of the first install of this system. Before changing this value read the documentation for this option (e.g. man
  # configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
