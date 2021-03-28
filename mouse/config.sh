#!/bin/bash

# Add dependencies
sudo apt install -y cmake libevdev-dev libudev-dev libconfig++-dev

# Clone Repo
git clone https://github.com/PixlOne/logiops ~/logiops

# Build instructions
mkdir ~/logiops/build
cmake ~/logiops
make ~/logiops
sudo make install ~/logiops

# Build symbolic link to config file
sudo ln -sf ~/dotfiles/mouse/logid.cfg /etc/logid.cfg

# Enable configuration on boot
sudo systemctl enable --now logid
