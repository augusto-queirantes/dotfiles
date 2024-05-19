#!/bin/bash

# Dependencies installation

sudo apt upgrade -y && sudo apt update -y

## System dependencies

sudo apt install -y curl zsh git ripgrep software-properties-common python3-dev python3-pip jq

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

## Font configuration

version=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/tags" | jq -r '.[0].name')
fonts_dir="${HOME}/.local/share/fonts"
file_name="FiraMono.zip"
download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${file_name}"

if [[ ! -d "$fonts_dir" ]]; then
  mkdir -p "$fonts_dir"
fi

wget --quiet "$download_url" -O "$file_name"

unzip "$file_name" -d "$fonts_dir"

rm "$file_name"

fc-cache -fv
