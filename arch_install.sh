DRIVE='/dev/nvme0n1'
HOSTNAME='arch'
TIMEZONE='America/Sao_Paulo'
KEYMAP='br_abnt2'
WIRELESS_DEVICE="wlan0"
ROOT_PASSWORD=""
USER_NAME='sampaiol'
USER_PASSWORD=""

# Core Packages
CUSTOM_PACKAGES="man-db man-pages intel-ucode openssh pipewire xdg-user-dirs xf86-input-synaptics "

# Desktop Packages
CUSTOM_PACKAGES+="ttf-fira-code "

# Utility Packages
CUSTOM_PACKAGES+="rfkill sudo rsync unrar unzip wget zip cmake iwd nano git go "

# Loading keymap
loadkeys br-abnt2

setup() {
  partition_drive

  format_filesystems

  mount_filesystems

  install_base

  gen_fstab

  echo 'Chrooting into installed system to continue setup...'
  cp $0 /mnt/setup.sh 
  arch-chroot /mnt ./setup.sh chroot

  if [ -f /mnt/tmp/setup.sh ]
  then
      echo 'ERROR: Something failed inside the chroot, not unmounting filesystems so you can investigate.'
      echo 'Make sure you unmount everything before you try to run this script again.'
  else
      echo 'Unmounting filesystems'
      unmount_filesystems
      echo 'Done! Reboot system.'
  fi
}

configure() {
  install_packages

  install_bootloader

  clean_packages

  set_hostname

  set_hosts

  set_timezone

  set_locale

  set_root_password

  set_default_user

  enable_services

  copy_config_files

  updatedb

  rm /setup.sh
}

### Setup phase

partition_drive() {
  # Partitioning the disk
  # 512M EFI System Partition
  # 8G Swap
  # Rest of the disk for root
  echo 'Partitioning the disk...'
  echo 'This will delete all data on the disk!'
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
  echo 'Formatting the partitions...'
  mkfs.fat -F32 ${DRIVE}p1
  mkswap ${DRIVE}p2
  mkfs.ext4 ${DRIVE}p3
}

mount_filesystems() {
  echo 'Mounting the partitions...'
  mount --mkdir ${DRIVE}p3 /mnt
  swapon ${DRIVE}p2
  mount --mkdir ${DRIVE}p1 /mnt/boot
}

install_base() {
  echo 'Installing the base system...'
  pacstrap -K /mnt base linux linux-firmware $CUSTOM_PACKAGES
}

gen_fstab() {
  echo 'Generating the fstab file...'
  genfstab -U /mnt >> /mnt/etc/fstab
}

### Configure phase

install_packages() {
  echo 'Creating the build user...'
  mkdir /home/build
  chgrp nobody /home/build
  chmod g+ws /home/build

  setfacl -m u::rwx,g::rwx /home/build
  setfacl -d --set u::rwx,g::rwx,o::- /home/build

  ###
  ### Installing yay
  ###
  echo 'Installing yay...'
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay && sudo -u nobody makepkg -si --noconfirm
  cd && rm -rf /tmp/yay

  ###
  ### Installing Hyprland
  ###
  HYPRLAND_CONFIG=$HOME/.config/hypr/hyprland.conf

  echo 'Installing Hyprland...'
  yay -S --noconfirm hyprland-bin

  echo 'Creating the config file...'
  mkdir -p $HOME/.config/hypr

  ###
  ### Installing ZSH
  ###
  echo 'Installing ZSH...'
  yay -S --noconfirm zsh

  ###
  ### Installing Oh My ZSH
  ###
  echo 'Installing Oh My ZSH...'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  ###
  ### Installing Alacritty
  ###
  echo 'Installing Alacritty...'
  yay -S --noconfirm alacritty

  ###
  ### Installing VSCode
  ###
  echo 'Installing VSCode...'
  yay -S --noconfirm visual-studio-code-bin

  ###
  ### Installing Spotify
  ###
  echo 'Installing Spotify...'
  yay -S --noconfirm spotify

  ###
  ### Installing Discord
  ###
  echo 'Installing Discord...'
  yay -S --noconfirm discord

  ###
  ### Installing Opera
  ###
  echo 'Installing Opera...'
  yay -S --noconfirm opera
  yay -S --noconfirm opera-adblock-complete

  ###
  ### Installing LightDM
  ###
  yay -S lightdm lightdm-theme-neon-git
  cat /etc/lightdm/web-greeter.yml
}

clean_packages() {
    yes | pacman -Scc
}

set_hostname() {
  echo 'Setting the hostname...'
  echo $HOSTNAME > /etc/hostname
}

set_hosts() {
  echo 'Setting the hosts file...'
  cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost $HOSTNAME
::1       localhost.localdomain localhost $HOSTNAME
EOF
}

set_timezone() {
  echo 'Setting the time zone...'
  ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
  hwclock --systohc
}

set_locale() {
  echo 'Setting the locale to pt_BR.UTF-8...'
  echo 'pt_BR.UTF-8 UTF-8' >> /etc/locale.gen
  locale-gen
  echo 'LANG=pt_BR.UTF-8' > /etc/locale.conf
  echo 'KEYMAP=$KEYMAP' > /etc/vconsole.conf
}

set_root_password() {
  echo 'Setting root password...'
  read -sp 'Enter new password for root: ' ROOT_PASSWORD
  echo 'Setting password for root user...'
  echo 'root:$ROOT_PASSWORD' | chpasswd
}

install_bootloader() {
  echo 'Installing the bootloader...'
  bootctl --path=/boot install
  
  echo 'title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=$DRIVE3 rw' > /boot/loader/entries/arch.conf

  echo 'default arch
timeout 3
editor 0' > /boot/loader/loader.conf
}

enable_services() {
  echo 'Enabling services...'
  systemctl enable iwd
  systemctl enable lightdm.service
}

set_default_user() {
  echo 'Setting up a default user...'
  useradd -m -s /bin/zsh $USER_NAME

  echo 'Setting password for default user...'
  read -sp 'Enter new password for root: ' USER_PASSWORD
  echo '$USER_NAME:$USER_PASSWORD' | chpasswd
  echo 'Adding default user to sudoers...'
  echo '$USER_NAME ALL=(ALL) ALL' >> /etc/sudoers
  xdg-user-dirs-update
}

copy_config_files() {
  echo 'Copying the config files...'
  cp -r /tmp/zsh/.zshrc $HOME/.zshrc
}

set -ex

if [ "$1" == "chroot" ]
then
    configure
else
    setup
fi