#!/bin/bash

# Install elixir lang server
git clone git@github.com:elixir-lsp/elixir-ls.git ~/.elixir-ls

cd ~/.elixir-ls

# Install dependencies and compile it
mix deps.get
mix compile && mix elixir_ls.release -o release

# Go back
cd ~/dotfiles
