# Arch-Linux-Install-Script
Arch Linux Install Script

Instructions to Run the Script:

1. Boot into Arch Linux installation media.

2. Connect to the internet (use iwctl for wireless).

3. Download the script to your installation environment:

open bash terminal

curl -O https://github.com/kyzitemelos/Arch-Linux-Install-Script.git

chmod +x arch_install.sh

./arch_install.sh

Replace https://github.com/kyzitemelos/Arch-Linux-Install-Script.git with the actual URL where you have hosted this script.
Additional Steps for Secure Boot:
After running the script, you'll need to enroll the keys generated for Secure Boot in your system's firmware settings. The exact process for this varies depending on your motherboard's firmware (UEFI) interface, but generally, it involves:

1. Entering the UEFI firmware settings (usually by pressing a key like F2, F10, F12, or DEL during boot).

2. Navigating to the Secure Boot configuration section.

3. Enrolling the keys:
*Locate the option to enroll keys and navigate to the /etc/secureboot/keys directory on the EFI partition to enroll the db.crt.
This script will set up your Arch Linux system with ZFS, GNOME (Wayland), and i3, along with Secure Boot configuration. After running the script and enrolling the keys, your system will be ready to use upon reboot.
