## Intro

This is the dotfiles compatible and tested with MacOS, zsh, tmux, neovim > 0.9

## How-to

- Clone this repository with the submodules to your home directory
  - Use the following command to clone
```bash
git clone --recurse-submodules https://github.com/juniorsaldanha/dotfiles ~/dotfiles
```
- Make sure that you have stow installed
  - To install it with brew run `brew install stow`
- Change the directory to the repository cloned and run `stow .`
- If you receive any error or warning make sure that you don't have these files on the home dir. Remember that the `stow` tool it will just create all the symlinks from your home dir.

## How-to with Docker

- Declare the following function in your `.zshrc` or `.bashrc` file
```bash
function nvim_docker() {
    docker run -w /root -it --rm alpine:latest sh -uelic '
    apk add git nodejs neovim ripgrep build-base wget stow --update
    git clone https://github.com/juniorsaldanha/dotfiles ~/dotfiles
    cd ~/dotfiles && stow .
    cd ~/ && nvim
    '
}
```
- Run the command `nvim_docker` in your terminal
- Not fully tested yet, some plugins may not work properly

## How-to (nvim only) without removing your current dotfiles/nvim config
- Clone this repository with the submodules to your home directory
  - Use the following command to clone:
```bash
git clone --recurse-submodules https://github.com/juniorsaldanha/dotfiles ~/dotfiles_juniorsaldanha
```
- Copy nvim config folder to your home directory
```bash
cp -r ~/dotfiles_juniorsaldanha/nvim ~/.config/nvim_juniorsaldanha
```
- Add `nvim_juniorsaldanha` alias to your `.zshrc` or `.bashrc` file
```bash
function nvim_juniorsaldanha() {
	NVIM_APPNAME=nvim_juniorsaldanha nvim $@
}
```
- Run `nvim_juniorsaldanha` in your terminal

## Credits
Junior Saldanha (@juniorsaldanha on github and @umsaldanha on socials)
