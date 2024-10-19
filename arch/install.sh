#!/bin/bash

# Dependencies related

sudo pacman -S curl zsh git ripgrep jq meld zsh-syntax-highlighting unzip make base-devel libssh unixodbc libxslt fop docker-buildx docker-compose docker

# Oh my zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >> /dev/null

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## Oh my zsh configuration

ln -fs $PWD/zsh/zshrc ~/.zshrc

# Asdf configuration

## Clone asdf using the latest tag version as target branch
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf install erlang 24.3.4.16
asdf install elixir 1.16.1-otp-24
asdf install nodejs 18.20.3

asdf global erlang 24.3.4.16
asdf global elixir 1.16.1-otp-24
asdf global nodejs 18.20.3
