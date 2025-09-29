#!/usr/bin/env bash
set -e

log() {
  echo "[dotfiles] $*"
}

# Use sudo if available, else fallback
if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  SUDO=""
fi

install_if_not_exists() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "Installing $2..."
    $SUDO apt-get update -y || true
    $SUDO apt-get install -y "$2"
  fi
}

action_if_not_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "Installing $1 by action"
    eval "$2"
  fi
}

# Environment check
log "Running install.sh in Codespaces: $CODESPACES"

install_if_not_exists nvim neovim
install_if_not_exists delta delta
install_if_not_exists fdfind fd-find
install_if_not_exists batcat bat
install_if_not_exists rg ripgrep
install_if_not_exists cargo cargo
install_if_not_exists zsh zsh
action_if_not_cmd exa "cargo install exa"

# prepare lua-language-server
LUA_LS_DIR="$HOME/apps/lua-language-server"
LUA_LS_VERSION="3.15.0"
LUA_LS_TGZ="lua-language-server-$LUA_LS_VERSION-linux-x64.tar.gz"
if [ ! -d "$LUA_LS_DIR" ] || [ ! -f "$LUA_LS_DIR/bin/lua-language-server" ]; then
  log "Installing lua-language-server..."
  mkdir -p "$LUA_LS_DIR"
  pushd "$LUA_LS_DIR"
  wget -nv "https://github.com/LuaLS/lua-language-server/releases/download/$LUA_LS_VERSION/$LUA_LS_TGZ"
  tar zxvf "$LUA_LS_TGZ"
  rm "$LUA_LS_TGZ"
  popd
else
  log "lua-language-server already installed"
fi

# set zsh as default shell, skip if already zsh or not interactive
if [ -n "$CODESPACES" ] && [ -x "$(command -v zsh)" ] && [ "$SHELL" != "$(which zsh)" ]; then
  log "Changing shell to zsh"
  $SUDO chsh -s "$(which zsh)" "$USER" || true
fi

log "dotfiles install.sh complete"
