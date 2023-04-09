#!/bin/bash
USER_NAME="$(whoami)"
INITIAL_DIR="$(pwd)"

set -e

###
### Installing yay
###
echo "Installing yay..."
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R $USER_NAME:users ./yay
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
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions

env zsh

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
### Installing pokemon-colorscripts
###
echo "Installing pokemon-colorscripts..."
yay -S --noconfirm pokemon-colorscripts-git

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

###
### Install kubernetes things (kubectl, ksutomize, krew (ctx and ns), lens, helm)
###

###
### Install aws things (awscli, awsp)
###
yarn global add awsp

###
### Installing LightDM
###
yay -S --noconfirm lightdm lightdm-theme-neon-git
systemctl enable lightdm.service
sudo touch /etc/lightdm/web-greeter.yml
sudo cat > /etc/lightdm/web-greeter.yml <<EOF
greeter:
    theme: neon
EOF

