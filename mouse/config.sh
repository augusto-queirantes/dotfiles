#!/bin/bash

# Add dependencies
sudo apt install -y cmake libevdev-dev libudev-dev libconfig++-dev git

# Clone Repo
git clone https://github.com/PixlOne/logiops ~/logiops

# Build instructions
mkdir ~/logiops/build
cd ~/logiops/build
cmake ..
make
sudo make install

# Build symbolic link to config file
sudo ln -sf $(pwd)/mouse/logid.cfg /etc/logid.cfg

# Enable configuration on boot
sudo systemctl enable --now logid
