DOTFILES := $(shell pwd)
STOW_PACKAGES := zsh starship alacritty tmux nvim git mise claude

.PHONY: help setup brew backup stow unstow restow macos post bin clean

help:
	@echo "Targets:"
	@echo "  setup    Full bootstrap: brew + stow + macos + post"
	@echo "  brew     Install Homebrew and run 'brew bundle'"
	@echo "  backup   Move pre-existing real files out of \$$HOME (so stow can run)"
	@echo "  stow     Symlink all configs into \$$HOME"
	@echo "  unstow   Remove all symlinks"
	@echo "  restow   Re-link (use after adding/renaming files)"
	@echo "  macos    Apply macOS defaults"
	@echo "  post     Post-install steps (TPM, mise plugins)"
	@echo "  bin      Symlink bin/ scripts to ~/.local/bin"

setup: brew stow bin macos post
	@echo ""
	@echo "Done. Restart your terminal."

brew:
	@bash install/bootstrap.sh

backup:
	@bash install/backup.sh

stow:
	@command -v stow >/dev/null || { echo "stow missing — run 'make brew' first"; exit 1; }
	@for pkg in $(STOW_PACKAGES); do \
		echo "stow $$pkg"; \
		stow --dir=stow --target=$$HOME --restow $$pkg; \
	done

unstow:
	@for pkg in $(STOW_PACKAGES); do \
		echo "unstow $$pkg"; \
		stow --dir=stow --target=$$HOME --delete $$pkg; \
	done

restow: unstow stow

macos:
	@bash install/macos.sh

post:
	@bash install/post.sh

bin:
	@mkdir -p $$HOME/.local/bin
	@for f in bin/*; do \
		name=$$(basename $$f); \
		ln -sfn $(DOTFILES)/$$f $$HOME/.local/bin/$$name; \
		echo "linked $$name"; \
	done
