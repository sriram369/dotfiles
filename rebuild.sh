#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# home.nix activates home/.config/tmux on every switch, so an upgrade can be the
# first run to make that config live. Provision TPM here too, not only in
# bootstrap.sh, or an existing machine gets the config with no plugin manager.
# Runs before the exec, which would otherwise replace this process.
"$DIR/ensure-tpm.sh"

exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac
