#!/usr/bin/env bash
set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

echo -e "${GREEN}=== NixOS Dual-Boot Safe Setup (ZFS+LUKS+Impermanence) ===${NC}"
echo -e "${YELLOW}IMPORTANT: You must have unallocated free space on your disk already.${NC}"

# 1. Select Disk
lsblk -d -o NAME,SIZE,MODEL,TYPE | grep -v "rom"
read -p "Enter the target disk (e.g., nvme0n1): " DISK_NAME
DISK="/dev/${DISK_NAME#/dev/}"

if [ ! -b "$DISK" ]; then
    echo -e "${RED}Error: Device $DISK not found.${NC}"
    exit 1
fi

# 2. Partitioning (SAFE VERSION)
echo -e "${GREEN}[1/6] Creating partitions in free space...${NC}"

# Create 1G Boot (NixOS specific EFI) in free space
# sgdisk -n 0:0:+1G means: next available part number, start at next free, size 1G
sgdisk -n 0:0:+1G -t 0:ef00 -c 0:"NixOS-EFI" "$DISK"
PART1_NUM=$(sgdisk -p "$DISK" | grep "NixOS-EFI" | tail -n 1 | awk '{print $1}')

# Create LUKS/ZFS in the rest of the free space
sgdisk -n 0:0:0 -t 0:8300 -c 0:"NixOS-LUKS" "$DISK"
PART2_NUM=$(sgdisk -p "$DISK" | grep "NixOS-LUKS" | tail -n 1 | awk '{print $1}')

partprobe "$DISK"
udevadm settle

# Determine partition paths
if [[ "$DISK" =~ "nvme" ]]; then
    PART1="${DISK}p${PART1_NUM}"
    PART2="${DISK}p${PART2_NUM}"
else
    PART1="${DISK}${PART1_NUM}"
    PART2="${DISK}${PART2_NUM}"
fi

echo -e "${YELLOW}Using Partitions: $PART1 (EFI) and $PART2 (LUKS)${NC}"

# 3. Format EFI
mkfs.fat -F32 -n NIXBOOT "$PART1"

# 4. Setup LUKS
echo -e "${YELLOW}Enter password for NixOS LUKS container:${NC}"
cryptsetup luksFormat --type luks2 "$PART2"
cryptsetup open "$PART2" cryptroot

# 5. Create ZPool
zpool create \
  -f \
  -o ashift=12 \
  -o autotrim=on \
  -O acltype=posixacl \
  -O canmount=off \
  -O compression=zstd \
  -O xattr=sa \
  -O mountpoint=none \
  rpool /dev/mapper/cryptroot

# 6. Create Datasets (Same as before)
zfs create -p -o canmount=noauto -o mountpoint=legacy rpool/local/root
zfs snapshot rpool/local/root@blank
zfs create -p -o mountpoint=legacy rpool/local/nix
zfs create -p -o mountpoint=legacy rpool/safe/home
zfs create -p -o mountpoint=legacy rpool/safe/persist

# 7. Mounting & Permissions
mount -t zfs rpool/local/root /mnt
mkdir -p /mnt/{nix,home,persist,boot}
mount -t vfat "$PART1" /mnt/boot
mount -t zfs rpool/local/nix /mnt/nix
mount -t zfs rpool/safe/home /mnt/home
mount -t zfs rpool/safe/persist /mnt/persist

# Change Your-User to your username
TARGET_USER="Your-User" 
chmod 755 /mnt
chmod 755 /mnt/home
mkdir -p /mnt/home/$TARGET_USER /mnt/persist/home/$TARGET_USER
chown -R 1000:100 /mnt/home/$TARGET_USER
chown -R 1000:100 /mnt/persist/home/$TARGET_USER

LUKS_UUID=$(blkid -s UUID -o value "$PART2")
echo -e "${GREEN}Success! LUKS UUID: ${LUKS_UUID}${NC}"
nixos-generate-config --root /mnt
