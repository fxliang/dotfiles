#!/usr/bin/env bash
set -e
# a function to check if a command exists, and install by package name
install_if_not_exists() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Installing $2..."
    sudo apt install -y "$2"
  fi
}

action_if_not_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    eval "$2"
  fi
}
# update package list
install_if_not_exists nvim neovim
install_if_not_exists delta delta
install_if_not_exists fdfind fd-find
install_if_not_exists batcat bat
install_if_not_exists rg ripgrep
install_if_not_exists cargo cargo
install_if_not_exists zsh zsh
action_if_not_cmd exa "cargo install exa"
# prepare lua-language-server
mkdir -p ~/apps/lua-language-server
pushd ~/apps/lua-language-server
wget https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz
tar zxvf lua-language-server-3.15.0-linux-x64.tar.gz
rm lua-language-server-3.15.0-linux-x64.tar.gz
popd
# end prepare lua-language-server

# set zsh as default shell
chsh -s "$(which zsh)" "$USER"
# switch to zsh
exec zsh
