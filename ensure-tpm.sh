#!/usr/bin/env bash
# Clone tmux's plugin manager if it isn't there yet.
#
# home.nix activates home/.config/tmux on every switch, and that config ends its
# plugin section with `run-shell .../tpm/tpm`. Unlike Neovim, which bootstraps
# lazy.nvim from init.lua, tmux cannot fetch its own plugin manager - so without
# this, every tmux server start prints "No such file or directory" and no plugin
# loads. Both bootstrap.sh (fresh machine) and rebuild.sh (every upgrade) call
# it, because either path can be the first to make the config live.
#
# Idempotent: a second run is a no-op. Plugins themselves install on first use
# via `prefix + I`, the same way lazy.nvim installs on first nvim launch; this
# script deliberately does not install them, because tmux comes from
# home.packages and only reaches PATH in a newly started shell.
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
  echo "    TPM already present at $TPM_DIR, nothing to do."
  exit 0
fi

echo "    Cloning tmux-plugins/tpm into $TPM_DIR"
git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
echo "    TPM is installed. Start tmux and press prefix + I (Ctrl-b, then"
echo "    Shift-i) once to fetch the plugins, then prefix + R to reload."
echo "    The reload matters: prefix + I sources each plugin immediately, so"
echo "    rose-pine would otherwise run after tmux.conf's status-bar overrides."
