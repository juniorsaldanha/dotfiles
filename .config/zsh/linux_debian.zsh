#!/bin/zsh

export XDG_CONFIG_HOME=$HOME/.config
export PATH=$PATH:$HOME/.cargo/bin

# alias
alias python=python3

if ! command -v nvim &> /dev/null; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  sudo mv nvim.appimage /usr/bin/nvim
fi
