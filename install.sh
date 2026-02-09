#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/HieuDao-Code/nixos-config.git"
DOTFILES="$HOME/.dotfiles"
HOSTNAME="$(hostname)"

echo "==> Installing NixOS config"
echo "    Host: $HOSTNAME"
echo "    Repo: $REPO"
echo "    Path: $DOTFILES"

# Clone or update repo
if [ ! -d "$DOTFILES/.git" ]; then
  echo "==> Cloning dotfiles repo"
  git clone "$REPO" "$DOTFILES"
else
  echo "==> Updating dotfiles repo"
  git -C "$DOTFILES" pull
fi

# Ensure hardware config exists
HWCFG="$DOTFILES/hosts/$HOSTNAME/hardware-configuration.nix"
if [ ! -f "$HWCFG" ]; then
  echo "==> Generating hardware-configuration.nix"
  sudo mkdir -p "$(dirname "$HWCFG")"
  sudo nixos-generate-config \
    --root / \
    --show-hardware-config |
    sudo tee "$HWCFG" >/dev/null
fi

# # Optional: keep /etc/nixos pointing to dotfiles
# if [ ! -e /etc/nixos ]; then
#   echo "==> Linking /etc/nixos → $DOTFILES"
#   sudo ln -s "$DOTFILES" /etc/nixos
# fi

echo "==> Rebuilding system"
sudo nixos-rebuild switch --flake "$DOTFILES#$HOSTNAME"

echo "✅ NixOS installation complete"
