#!/bin/bash

# Dependencies installation

sudo apt upgrade -y && sudo apt update -y

## System dependencies

sudo apt install -y curl zsh git ripgrep software-properties-common python3-dev python3-pip jq fd-find meld

## Neovim installation

sudo snap install --beta nvim --classic

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

## Asdf configuration

## Clone asdf using the latest tag version as target branch
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch (git ls-remote --tags --sort="v:refname" https://github.com/asdf-vm/asdf.git | tail -n1 | sed 's/.*\///; s/\^{}//')

asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf install erlang 27.0
asdf install elixir 1.17.1
asdf install nodejs 20.15.0

asdf global erlang 27.0
asdf global elixir 1.17.1
asdf global nodejs 20.15.0
