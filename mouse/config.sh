#!/bin/bash

sudo pacman -S cmake libevdev libconfig pkgconf

git clone https://github.com/PixlOne/logiops ~/logiops

mkdir ~/logiops/build
cd ~/logiops/build
cmake ..
make
sudo make install

sudo systemctl enable --now logid

ln -sf $(pwd)/mouse/logid.cfg /etc/logid.cfg
