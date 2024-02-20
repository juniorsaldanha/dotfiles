#!/bin/zsh

# Check if it is darwin and if yes, check if brew is not installed and install it
if ! command -v brew &> /dev/null; then
  if [[ "$(uname)" == "Darwin" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

if ! command -v nvim &> /dev/null; then
  brew install neovim
fi
