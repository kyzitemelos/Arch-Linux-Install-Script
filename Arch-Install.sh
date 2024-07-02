#!/bin/bash

# Exit on error
set -e

# Variables
HOSTNAME="Hostname"
ROOT_PASSWORD="Password"
USERNAME="user"
USER_PASSWORD="Passord"
TIMEZONE="America/Chicago"
LOCALE="en_US.UTF-8"
SWAP_SIZE="32G"
DISK1="/dev/nvme0n1"
DISK2="/dev/nvme1n1"

# Update system clock
timedatectl set-ntp true

# Partition the disks
parted --script ${DISK1} \
    mklabel gpt \
    mkpart ESP fat32 1MiB 512MiB \
    set 1 boot on \
    mkpart primary 512MiB 100%

parted --script ${DISK2} \
    mklabel gpt \
    mkpart primary 0% 100%

# Format partitions
mkfs.fat -F32 ${DISK1}p1
zpool create -f -o ashift=12 -O acltype=posixacl -O canmount=off -O compression=lz4 -O dnodesize=legacy -O normalization=formD -O xattr=sa -O mountpoint=none rpool mirror ${DISK1}p2 ${DISK2}p1
zfs create -o mountpoint=none rpool/ROOT
zfs create -o mountpoint=/ -o canmount=noauto rpool/ROOT/default
mount -t zfs rpool/ROOT/default /mnt

# Create home directory within the same ZFS pool
zfs create -o mountpoint=/home rpool/HOME

# Create and enable swap
fallocate -l ${SWAP_SIZE} /mnt/swapfile
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile

# Install base system
pacstrap /mnt base linux linux-firmware zfs-dkms zfs-utils

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the system
arch-chroot /mnt /bin/bash <<EOF

# Set up timezone
ln -sf /usr
