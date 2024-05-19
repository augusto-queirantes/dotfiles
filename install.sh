# Dependencies installation

sudo apt upgrade -y && sudo apt update -y

## System dependencies

sudo apt install -y curl zsh git ripgrep software-properties-common python3-dev python3-pip jq fonts-firacode

## Neovim installation

sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo apt update -y
sudo apt install -y neovim

## Oh my zsh installation

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >> /dev/null

## Oh my zsh configuration

ln -fs $PWD/zsh/zshrc ~/.zshrc

## Nvim configuration

ln -fs $PWD/nvim ~/.config/nvim
