# impermanence.nix
# This file defines what parts of your system should persist across reboots
# when you have an impermanent (fresh on boot) root filesystem.
{
  config,
  pkgs,
  lib,
  ...
}: {
  # The 'environment.persistence' option is the core of configuring impermanence.
  # It defines bind-mounts from a persistent location (like /nix/persist)
  # to locations on your root filesystem (/) that would otherwise be ephemeral.
  #

  boot.initrd.postResumeCommands = lib.mkAfter ''
    set -euo pipefail # Ensure failure handling

    mkdir -p /btrfs_tmp
    mount -o subvol=/ /dev/nvme0n1 /btrfs_tmp

    # Clean existing rootfs subvolume if present
    if [[ -e /btrfs_tmp/rootfs ]]; then
      echo "Deleting existing rootfs..."
      btrfs subvolume delete /btrfs_tmp/rootfs
    fi

    echo "Creating fresh /rootfs subvolume..."
    btrfs subvolume create /btrfs_tmp/rootfs

    echo "Unmounting temporary mount..."
    umount /btrfs_tmp
  '';
  # We use "/nix/persist" as the base for all persistent data, which is common
  # and ensures it lives on your persistent /nix subvolume.
  environment.persistence."/nix/persist" = {
    # hideMounts = true will make these bind-mounted directories appear as part
    # of the root filesystem's snapshot, rather than separate mount points,
    # which is generally cleaner for an impermanent root.
    hideMounts = true;

    # List of directories within the root filesystem (/) that you want to persist.
    # These will be backed by directories in /nix/persist.
    directories = [
      "/etc" # Persist system configuration changes made outside of Nix.
      # If you manage *all* /etc files declaratively in Nix,
      # you might omit this, but it's often safer to include.
      "/var/log" # Persist system logs.
      "/var/lib" # Crucial for many services to retain their data (databases,
      # Docker, NetworkManager state, systemd journal, etc.).
      # BE CAREFUL: This can grow large. You might want to be
      # more granular, e.g., instead of "/var/lib", specify:
      # "/var/lib/bluetooth"
      # "/var/lib/systemd"
      # "/var/lib/NetworkManager"
      # "/var/lib/polkit-1"
      # "/var/lib/udisks2"
      # "/var/lib/colord"
      # "/var/lib/gdm" # If using GDM (GNOME Display Manager)
      # "/var/lib/flatpak" # If you use Flatpaks
      # "/var/lib/postgresql" # If running a PostgreSQL server
      # "/var/lib/mysql"      # If running a MySQL/MariaDB server
      # "/var/lib/docker"     # If you use Docker
      "/var/spool" # For mail queues, cron jobs, etc.
      "/srv" # Common for web server data, git repos, etc.
      "/root" # To persist files in the root user's home directory.
      # This is generally less common in a declarative setup,
      # but good to have if root ever creates files there.
      # You can add other directories where programs might store persistent data
      # outside of /home or /nix. For example:
      # "/opt"
      # "/usr/local"
    ];

    # List of individual files within the root filesystem (/) that you want to persist.
    # These will be backed by files in /nix/persist.
    files = [
      # Example: SSH host keys, if you want them to remain consistent
      # and not regenerated on every boot (though NixOS can manage these declaratively too)
      # "/etc/ssh/ssh_host_ed25519_key"
      # "/etc/ssh/ssh_host_ed25519_key.pub"
      # "/etc/ssh/ssh_host_rsa_key"
      # "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    # You can also specify users whose home directory contents you want to persist.
    # However, since you're mounting `/home` as a separate Btrfs subvolume
    # (`@home`), user persistence within `/home` is already handled by that
    # separate mount, and you typically won't need to list users here for typical
    # home directory contents. This is more for specific cases or if /home
    # wasn't a separate subvolume.
    # users.jr = [
    # ];
  };

  # This section configures directories that should be *ephemeral* (cleared on reboot)
  # by mounting them as tmpfs (RAM filesystem) or ensuring they're cleaned.
  # Use this for truly temporary data that you *never* want to persist.

  # You can define swap devices here. If you want a swap *file* (common with Btrfs),
  # it needs to live on a persistent subvolume (like /nix/persist).
  # Uncomment and adjust size as needed:
  fileSystems."/swapfile" = {
    device = "/nix/persist/swapfile";
    fsType = "swap";
    # This will manage the creation of the swapfile and ensure its permissions.
    # The 'impermanence' module handles setting up the tmpfiles rule for this.
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = 1024 * 8; # Example: 8 GB swapfile (in MiB)
    }
  ];
}
