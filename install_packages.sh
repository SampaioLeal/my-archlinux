#!/bin/bash
###
### Installing yay
###
echo "Installing yay..."
sudo git clone https://aur.archlinux.org/yay.git $HOME/yay
cd $HOME/yay && makepkg -Si --noconfirm
cd && rm -rf $HOME/yay

###
### Installing Hyprland
###
HYPRLAND_CONFIG=$HOME/.config/hypr/hyprland.conf

echo "Installing Hyprland..."
yay -S --noconfirm hyprland-bin xdg-desktop-portal-hyprland-git
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
usermod --shell /bin/zsh $USER_NAME
echo "Copying the config files..."
cp -r /tmp/zsh/.zshrc $HOME/.zshrc

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
### Installing Opera
###
echo "Installing Opera..."
yay -S --noconfirm opera
yay -S --noconfirm opera-adblock-complete

###
### Installing LightDM
###
yay -S lightdm lightdm-theme-neon-git
cat /etc/lightdm/web-greeter.yml
systemctl enable lightdm.service
