# Log info
function echo_yellow {
  YELLOW='\e[0;33m'

  echo -e "${YELLOW}$1${RESTORE}";
}

# Clone dependencies
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
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
