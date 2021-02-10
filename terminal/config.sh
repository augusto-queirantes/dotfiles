#!/bin/bash

# Log info
function echo_yellow {
  YELLOW='\e[0;33m';

  echo -e "${YELLOW}$1${RESTORE}";
}

sudo apt install -y zsh curl

# Install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone custom theme and plugin
git clone https://github.com/zsh-users/zsh-autosuggestions $(pwd)/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $(pwd)/themes/powerlevel10k

# Build symbolic link to config file
ln -sf $(pwd)/plugins/* ~/.oh-my-zsh/custom/plugins
ln -sf $(pwd)/themes/* ~/.oh-my-zsh/custom/themes
ln -sf $(pwd)/.zshrc ~/.zshrc

# Set zsh as default shell
chsh -s $(which zsh)

# Log info
echo_yellow 'Reboot your computer to apply configuration'
