#!/bin/bash

USERNAME="$(whoami)"
INITIAL_DIR="$(pwd)"

###
### Installing yay
###
echo "Installing yay..."
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R $USERNAME:users ./yay
cd ./yay && makepkg -si --noconfirm
cd $INITIAL_DIR

###
### Installing Hyprland
###
HYPRLAND_CONFIG=$HOME/.config/hypr/hyprland.conf

echo "Installing Hyprland..."
yay -S --noconfirm hyprland xdg-desktop-portal-hyprland
echo "Creating the config file..."
mkdir -p $HOME/.config/hypr

###
### Installing Mako
###
echo "Installing Mako..."
yay -S --noconfirm mako

###
### Installing ZSH
###
echo "Installing ZSH..."
yay -S --noconfirm zsh
sudo usermod --shell /bin/zsh $USER_NAME
echo "Copying the config files..."
cp -r ./zsh/.zshrc $HOME/.zshrc

###
### Installing Oh My ZSH
###
echo "Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

###
### Installing Alacritty
###
echo "Installing Alacritty..."
yay -S --noconfirm alacritty

###
### Installing VSCode
###
echo "Installing VSCode..."
yay -S --noconfirm visual-studio-code-bin

###
### Installing Spotify
###
echo "Installing Spotify..."
yay -S --noconfirm spotify

###
### Installing Discord
###
echo "Installing Discord..."
yay -S --noconfirm discord

###
### Installing MS Edge Browser
###
echo "Installing MS Edge..."
yay -S --noconfirm microsoft-edge-stable-bin

###
### Installing LightDM
###
yay -S lightdm lightdm-theme-neon-git
cat /etc/lightdm/web-greeter.yml
systemctl enable lightdm.service
