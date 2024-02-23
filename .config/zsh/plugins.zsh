#!/bin/zsh

FLAVOR=""
VER=""

if [[ $(uname) == "Darwin" ]]; then
  source ~/.config/zsh/darwin_zsh.zsh
elif [[ $(uname) == "Linux" ]]; then
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    FLAVOR=$ID_LIKE
    VER=$VERSION_ID
  else
    echo "Not able to determine the OS"
    exit 1
  fi


  source ~/.config/zsh/linux_debian.zsh
fi






