#!/bin/bash

# Create neovim directory
mkdir ~/.config/nvim

# Build symbolic link to config file
ln -sf $(pwd)/nvim/* ~/.config/nvim/
