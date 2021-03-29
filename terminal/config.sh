#!/bin/bash

# Log info
function echo_yellow {
  YELLOW='\e[0;33m';

  echo -e "${YELLOW}$1${RESTORE}";
}

sudo pacman -S zsh curl

# Install ohzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone custom theme and plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

# Build symbolic link to config file
ln -sf $(pwd)/.zshrc ~/.zshrc

# Set zsh as default shell
chsh -s $(which zsh)

# Log info
echo_yellow 'Reboot your computer to apply configuration'
