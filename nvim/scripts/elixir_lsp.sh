#!/bin/bash

# Clones the repo
git clone git@github.com:elixir-lsp/elixir-ls.git ~/.elixir-ls

# Creates the builded files dir
mkdir ~/.elixirls

cd ~/.elixir-ls

# Install dependencies
mix deps.get

# Compile it
MIX_ENV=prod mix compile

# Release it inside the specified folder
MIX_ENV=prod mix elixir_ls.release2 -o ~/.elixirls

# Go back
cd ~/dotfiles

rm -rf ~/.elixir-ls/
