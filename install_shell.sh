#!/bin/bash
USER_NAME="$(whoami)"

set -e

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

env zsh ./install_packages.sh