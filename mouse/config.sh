#!/bin/bash

# Add dependencies
sudo pacman -S cmake libevdev libconfig pkgconf

# Clone Repo
git clone https://github.com/PixlOne/logiops ~/logiops

# Build instructions
mkdir ~/logiops/build
cd ~/logiops/build
cmake ..
make
sudo make install

# Build symbolic link to config file
ln -sf $(pwd)/mouse/logid.cfg /etc/logid.cfg

# Enable configuration on boot
sudo systemctl enable --now logid
