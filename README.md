# Dotfiles of @junirosaldanha on github and @umsaldanha on socials

## Intro

This is the dotfiles compatible and tested with:

- MacOS, zsh, tmux, neovim > 0.9
- Linux (Debian based "PopOS"), zsh, tmux, neovim > 0.9
<!-- TODO: Add Arch based compatibility, not yet compatible -->
- Linux (Arch based "Manjaro"), zsh, tmux, neovim > 0.9

## How-to

- Clone this repository with the submodules to your home directory
  - Use the following command to cloned
    `git clone --recurse-submodules git@github.com:juniorsaldanha/dotfiles.git ~/dotfiles`
- Make sure that you have stow installed
  - To install it with brew run
    `brew install stow`
  - To install it with apt-get run (for Debian based)
    `sudo apt-get install stow -y`
  - To install it with pacman run (for Arch)
    `sudo pacman -S stow`
- Change the directory to the repository cloned `cd ~/dotfiles/` and run `stow .`
- If you receive any error or warning make sure that you don't have these files on the home dir. Remember that the `stow` tool it will just create all the symlinks from your home dir.
  - If you create, rename, or delete files/folders you have to run stow again for update/recreate/delete the symlinks

## Neovim

- Required: (recommend to use adsf)
  - python3 >= 3
  - python3-virtualenv
  - cargo
  - go

## ASDF

- Recommend to use asdf to manage all the programing languages binaries
  - it has some nice feats that you can check it out on https://asdf-vm.com/
  - Make sure to install all the required softwares for Neovim, Shell, Tmux

@umsaldanha on socials
