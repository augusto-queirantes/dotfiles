#!/bin/bash

# Dependencies related

sudo pacman -S curl zsh git ripgrep jq meld zsh-syntax-highlighting

# Oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >> /dev/null

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## Oh my zsh configuration

ln -fs $PWD/zsh/zshrc ~/.zshrc

# Asdf configuration

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

# Sublime
sudo snap install sublime-text --classic

# Discord
sudo snap install discord

# Spotify
sudo snap install spotify
