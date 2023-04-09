#!/bin/bash
DRIVE="/dev/nvme0n1"
HOSTNAME="arch"
TIMEZONE="America/Sao_Paulo"
KEYMAP="br-abnt2"
WIRELESS_DEVICE="wlan0"
USER_NAME="sampaiol"

# Core Packages
CUSTOM_PACKAGES="libcamera man-db man-pages intel-ucode openssh pipewire xdg-user-dirs xf86-input-synaptics dhcpcd "

# Desktop Packages
CUSTOM_PACKAGES+="ttf-fira-code ttf-nerd-fonts-symbols-common "

# Utility Packages
CUSTOM_PACKAGES+="rfkill sudo rsync unrar unzip wget zip cmake iwd nano git go bat fzf "

# Loading keymap
loadkeys $KEYMAP

set -e

### Setup phase

partition_drive() {
  # Partitioning the disk
  # 512M EFI System Partition
  # 8G Swap
  # Rest of the disk for root
  echo "Partitioning the disk..."
  echo "This will delete all data on the disk!"
  sfdisk --delete $DRIVE

  # Partition table 
  # 1 -> EFI System Partition
  # 2 -> Swap
  # 3 -> Root
  echo "Creating new GPT partition table on $DRIVE..."
  parted -s $DRIVE mklabel gpt
  echo "Creating EFI boot partition..."
  parted -s $DRIVE mkpart primary fat32 1MiB 512MiB
  parted -s $DRIVE set 1 esp on
  echo "Creating SWAP partition..."
  parted -s $DRIVE mkpart primary linux-swap 512MiB 8.5GiB
  echo "Creating root partition..."
  parted -s $DRIVE mkpart primary ext4 8.5GiB 100%
}

format_filesystems() {
  echo "Formatting the partitions..."
  mkfs.fat -F32 ${DRIVE}p1
  mkswap ${DRIVE}p2
  mkfs.ext4 ${DRIVE}p3
}

mount_filesystems() {
  echo "Mounting the partitions..."
  mount --mkdir ${DRIVE}p3 /mnt
  swapon ${DRIVE}p2
  mount --mkdir ${DRIVE}p1 /mnt/boot
}

install_base() {
  echo "Installing the base system..."
  pacstrap -K /mnt base base-devel linux linux-firmware $CUSTOM_PACKAGES
}

gen_fstab() {
  echo "Generating the fstab file..."
  genfstab -U /mnt >> /mnt/etc/fstab
}

copy_scripts() {
  cp $0 /mnt/setup.sh
  mkdir /mnt/post-setup
  cp ./install_yay.sh /mnt/post-setup/install_yay.sh
  cp ./install_shell.sh /mnt/post-setup/install_shell.sh
  cp ./install_packages.sh /mnt/post-setup/install_packages.sh
  cp -r ./zsh /mnt/post-setup/zsh
}

### Configure phase

clean_packages() {
  yes | pacman -Scc
}

set_hostname() {
  echo "Setting the hostname..."
  echo $HOSTNAME > /etc/hostname
}

set_hosts() {
  echo "Setting the hosts file..."
  cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost $HOSTNAME
::1       localhost.localdomain localhost $HOSTNAME
EOF
}

set_timezone() {
  echo "Setting the time zone..."
  ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
  hwclock --systohc
}

set_locale() {
  echo "Setting the locale to pt_BR.UTF-8..."
  echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
  locale-gen
  echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
  echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
  loadkeys br-abnt2
}

set_root_password() {
  echo "Setting root password..."
  passwd
}

install_bootloader() {
  echo "Installing the bootloader..."
  bootctl --path=/boot install
  
  echo "title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=${DRIVE}p3 rw" > /boot/loader/entries/arch.conf

  echo "default arch
timeout 0
editor 0" > /boot/loader/loader.conf
}

enable_services() {
  echo "Enabling services..."

  rfkill unblock all
  systemctl enable iwd
  
  systemctl enable dhcpcd.service
  echo "noarp" >> /etc/dhcpcd.conf
}

set_default_user() {
  echo "Setting up a default user..."
  useradd -m -G users $USER_NAME

  echo "Setting password for default user..."
  passwd $USER_NAME
  echo "Adding default user to sudoers..."
  echo "$USER_NAME ALL=(ALL) ALL" >> /etc/sudoers
  xdg-user-dirs-update
}

unmount_filesystems() {
  umount -R /mnt
  swapoff -a
}

setup() {
  partition_drive

  format_filesystems

  mount_filesystems

  install_base

  gen_fstab

  copy_scripts

  echo "Chrooting into installed system to continue setup..."
  arch-chroot /mnt ./setup.sh chroot

  if [ -f /mnt/setup.sh ]
  then
      echo "ERROR: Something failed inside the chroot, not unmounting filesystems so you can investigate."
      echo "Make sure you unmount everything before you try to run this script again."
  else
      echo "Unmounting filesystems"
      unmount_filesystems
      echo "Done! Reboot system."
  fi
}

configure() {
  set_root_password

  set_default_user

  install_bootloader

  clean_packages

  set_hostname

  set_hosts

  set_timezone

  set_locale

  enable_services

  rm -rf /setup.sh
}

if [ "$1" == "chroot" ]
then
    configure
else
    setup
fi