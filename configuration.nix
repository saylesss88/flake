# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
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
    ./users.nix
    ./nixos
  ];

  custom = {
    greetd.enable = true;
  };

  environment.systemPackages = [
    pkgs.zoxide
    pkgs.mcfly
    pkgs.rustup
    pkgs.gcc
    pkgs.rustc
    pkgs.ripgrep
    pkgs.hyprpaper
    inputs.randpaper.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Use the systemd-boot EFI boot loader.
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
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  networking.hostName = "magic"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  # networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # ------------------------------------------------------------------
  # 2. ZFS support see: https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html
  # ------------------------------------------------------------------
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/"; # Critical for VMs
  # Not needed with LUKS
  boot.zfs.requestEncryptionCredentials = false;
  # systemd handles mounting
  systemd.services.zfs-mount.enable = false;

  services.zfs = {
    # autoScrub.enable = true;
    # periodically runs `zpool trim`
    # trim.enable = true;
    # autoSnapshot = true;
  };

  # ------------------------------------------------------------------
  # 3. LUKS
  # ------------------------------------------------------------------
  boot.initrd.luks.devices = {
    cryptroot = {
      # replace uuid# with output of UUID # from `sudo blkid /dev/vda2`
      device = "/dev/disk/by-uuid/c1f3e910-b5c7-4de8-865c-312c6a36afdf";
      allowDiscards = true;
      preLVM = true;
    };
  };

  # ------------------------------------------------------------------
  # 4. Roll-back root to blank snapshot on **every** boot
  # ------------------------------------------------------------------
  # Uncomment after first reboot
  # boot.initrd.postMountCommands = lib.mkAfter ''
  #   zfs rollback -r rpool/local/root@blank
  # '';

  # ------------------------------------------------------------------
  # 5. Basic system (root password, serial console for VM)
  # ------------------------------------------------------------------
  # Unique 8-hex hostId (run once in live ISO: head -c4 /dev/urandom | xxd -p)
  networking.hostId = "7967fe7d";

  users.users.root.initialPassword = "changeme"; # change after first login

  boot.kernelParams = ["console=tty1"];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
