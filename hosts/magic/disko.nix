# /mnt/etc/nixos/disko-devices.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # <-- !! ABSOLUTELY CONFIRM THIS IS YOUR TARGET DISK !!
        content = {
          type = "gpt";
          partitions = {
            boot = {
              priority = 1;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Overwrite existing partition
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    # This subvolume for / will be impermanent by default
                    # Further impermanence configuration done in configuration.nix
                  };
                  "@home" = {
                    mountOptions = ["compress=zstd"];
                    mountpoint = "/home";
                  };
                  "@nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  # If you want a separate persistent /var (e.g., for databases)
                  # you'd add another subvolume here:
                  # "@var" = {
                  #   mountOptions = [ "compress=zstd" ];
                  #   mountpoint = "/var";
                  # };
                };
                mountpoint = "/btrfs"; # This is the mountpoint for the entire Btrfs partition during install
              };
            };
          };
        };
      };
    };
  };
}
