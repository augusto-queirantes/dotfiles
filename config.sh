#!/bin/bash

RESTORE='\033[0m'

function echo_yellow {
  YELLOW='\e[0;33m'

  echo -e "${YELLOW}$1${RESTORE}";
}

function echo_green {
  GREEN='\033[00;32m'

  echo -e "${GREEN}$1${RESTORE}";
}

echo_yellow 'Starting Neovim configuration'

sh $(pwd)/nvim/config.sh

echo_green 'Neovim were successfully configured'

echo_yellow 'Starting terminal configuration'

sh $(pwd)/terminal/config.sh

echo_green 'Terminal were successfully configured'

echo_yellow 'Starting mouse configuration'

sh $(pwd)/mouse/config.sh

echo_green 'Mouse were successfully configured'
