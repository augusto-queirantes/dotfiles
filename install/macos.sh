#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults..."

# Keyboard: fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock mru-spaces -bool false

# Screenshots in ~/Screenshots as PNG
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
# NB: reported broken on recent macOS (window shadows still captured) — kept
# because it is harmless; verify against macos-defaults.com when it matters.
defaults write com.apple.screencapture disable-shadow -bool true

# Rex appearance. Key bindings live in ~/.config/rex/init.lua; these are the
# app's Settings window. Quit Rex before running this, or it overwrites them.
defaults write com.superlogical.rex Workspace.appearance -string "dark"
defaults write com.superlogical.rex Workspace.darkThemeID -string "merino-dark"
defaults write com.superlogical.rex Workspace.lightThemeID -string "merino-light"
defaults write com.superlogical.rex Workspace.terminalFontPointSize -float 18
defaults write com.superlogical.rex Workspace.terminalFontSmoothing -bool true
defaults write com.superlogical.rex Workspace.tabStyle -string "vertical"
defaults write com.superlogical.rex Workspace.sidebarPosition -string "left"
defaults write com.superlogical.rex Workspace.inactivePaneFadeMode -string "both"
defaults write com.superlogical.rex Workspace.tabIconTintMode -string "off"
defaults write com.superlogical.rex Workspace.usesStandardInactiveWindowPaneStyles -bool true
defaults write com.superlogical.rex rex.agents.names-sessions -bool true

# Restart affected apps
killall Finder Dock SystemUIServer 2>/dev/null || true

echo "macOS defaults applied. Some changes require a logout/restart."
