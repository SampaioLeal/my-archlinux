#!/bin/bash
USER_NAME="$(whoami)"

set -e

###
### Installing Hyprland
###
HYPRLAND_CONFIG=$HOME/.config/hypr/hyprland.conf

echo "Installing Hyprland..."
yay -S --noconfirm hyprland xdg-desktop-portal-hyprland waybar-hyprland wlogout swaylock-effects
echo "Creating the config file..."
mkdir -p $HOME/.config/hypr

###
### Installing things
###
# TODO: add image viewer
echo "Installing things..."
yay -S --noconfirm polkit-gnome ffmpeg kitty visual-studio-code-bin spotify discord microsoft-edge-stable-bin pokemon-colorscripts-git dunst rofi-lbonn-wayland-git playerctl sddm-git
sudo systemctl enable sddm.service

###
### Installing NVM and Yarn
###
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.zshrc
nvm install --lts
npm install -g yarn

###
### Install Deno
###
curl -fsSL https://deno.land/x/install/install.sh | sh

###
### Install kubernetes things (docker, kubectl, ksutomize, krew (ctx and ns), lens, helm)
###

###
### Install aws things (awscli, awsp)
###
yarn global add awsp

# TODO: configure pipewire
# TODO: configure hyprland
# TODO: add hyprpaper
# TODO: configure waybar
# TODO: configure wlogout
# TODO: configure swaylock-effects
# TODO: configure dunst
# TODO: configure rofi
# TODO: configure sddm locale and theme
# TODO: add file explorer