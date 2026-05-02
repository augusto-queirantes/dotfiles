#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
moved=0

shopt -s dotglob nullglob

for pkg_dir in "$DOTFILES"/stow/*/; do
  pkg=$(basename "$pkg_dir")
  while IFS= read -r src; do
    rel="${src#"$pkg_dir"}"
    target="$HOME/$rel"
    if [[ -e "$target" || -L "$target" ]] && [[ ! -L "$target" ]]; then
      dest="$BACKUP_DIR/$rel"
      mkdir -p "$(dirname "$dest")"
      mv "$target" "$dest"
      echo "backed up $target -> $dest"
      moved=$((moved + 1))
    fi
  done < <(find "$pkg_dir" -type f)
done

if [[ $moved -eq 0 ]]; then
  echo "No conflicting files found."
else
  echo ""
  echo "Backed up $moved file(s) to $BACKUP_DIR"
  echo "Run 'make stow' next."
fi
