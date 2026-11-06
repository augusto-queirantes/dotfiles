#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Re-run 'make setup' after the installer finishes."
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Running brew bundle..."
brew bundle --file="$DOTFILES/Brewfile"

# Rex has no Homebrew cask. Install the newest preview from its Sparkle feed
# (Sparkle updates it from then on), refusing anything Gatekeeper rejects.
REX_APP="/Applications/Rex Beta.app"
REX_FEED="https://blob.superlogical.com/public/rex-app/preview/appcast.xml"
if [[ ! -d "$REX_APP" ]]; then
  echo "Installing Rex..."
  rex_tmp="$(mktemp -d)"
  rex_dmg_url="$(curl -fsSL "$REX_FEED" | grep -o 'url="[^"]*\.dmg"' | head -1 | cut -d'"' -f2)"
  curl -fsSL "$rex_dmg_url" -o "$rex_tmp/rex.dmg"
  hdiutil attach -nobrowse -readonly -quiet -mountpoint "$rex_tmp/mnt" "$rex_tmp/rex.dmg"
  if spctl --assess --type execute "$rex_tmp/mnt/$(basename "$REX_APP")"; then
    cp -R "$rex_tmp/mnt/$(basename "$REX_APP")" /Applications/
  else
    echo "Rex failed Gatekeeper's check; not installed."
  fi
  hdiutil detach -quiet "$rex_tmp/mnt"
  rm -rf "$rex_tmp"
fi
