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

###
### Installing Hyprland
###
HYPRLAND_CONFIG=$HOME/.config/hypr/hyprland.conf

echo "Installing Hyprland..."
yay -S --noconfirm hyprland xdg-desktop-portal-hyprland waybar-hyprland wlogout swaylock-effects
echo "Creating the config file..."
mkdir -p $HOME/.config/hypr

###
### Installing ZSH
###
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

echo "Installing ZSH..."
yay -S --noconfirm zsh
sudo usermod --shell /bin/zsh $USER_NAME
echo "Copying the config files..."
cp -r ./zsh/.zshrc $HOME/.zshrc

###
### Installing Oh My ZSH
###
echo "Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions --depth=1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting --depth=1
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions --depth=1
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" --depth=1
ln -s "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"

env zsh

###
### Installing things
###
# TODO: add image viewer
echo "Installing things..."
yay -S --noconfirm polkit-gnome ffmpeg kitty visual-studio-code-bin spotify discord microsoft-edge-stable-bin pokemon-colorscripts-git dunst rofi playerctl sddm-git
 
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
