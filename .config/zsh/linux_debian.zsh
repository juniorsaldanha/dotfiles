#!/bin/zsh

# alias
alias python=python3

if ! command -v nvim &> /dev/null; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  mv nvim.appimage /usr/bin/nvim
fi
