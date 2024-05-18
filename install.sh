# Dependencies installation

sudo apt upgrade -y && sudo apt update -y

# System dependencies

sudo apt install -y curl zsh git ripgrep software-properties-common python3-dev python3-pip

# Oh my zsh installation

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Neovim installation

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update -y
sudo apt install neovim
