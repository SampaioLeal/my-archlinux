#!/bin/bash
USER_NAME="$(whoami)"
INITIAL_DIR="$(pwd)"

set -e

###
### Installing yay
###
echo "Installing yay..."
cd /opt
sudo git clone https://aur.archlinux.org/yay.git --depth=1
sudo chown -R $USER_NAME:users ./yay
cd ./yay && makepkg -si --noconfirm
cd $INITIAL_DIR

./install_shell.sh