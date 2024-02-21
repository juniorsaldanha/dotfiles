# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
source ~/.config/zsh/.p10k.zsh
# POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Plugins
if [ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  echo "File zsh-autosuggestions.zsh not found"
fi
if [ -f ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
  source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
else
  echo "File zsh-autocomplete.plugin.zsh not found"
fi
if [ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  echo "File zsh-syntax-highlighting.zsh not found"
fi

# Custom functions
source ~/.config/zsh/custom-functions.zsh

# static exports
export EDITOR=nvim
export VISUAL="$EDITOR"

# source environment exports
if [ -f ~/.config/zsh/.zsh_exports ]; then
  source ~/.config/zsh/.zsh_exports.zsh
fi

# Source zsh file by OS
if [[ $(uname) == "Darwin" ]]; then
  echo "nice! It's Darwin"
  source ~/.config/zsh/darwin_zsh.zsh
elif [[ $(uname) == "Linux" ]]; then
  echo "hell yaeh! It's Linux!"
  source ~/.config/zsh/linux_debian.zsh
fi

if [ -f ~/.asdf/asdf.sh ]; then
  . "$HOME/.asdf/asdf.sh"
  if ! command -v asdf &> /dev/null; then
    echo "Install asdf please! https://asdf-vm.com/guide/getting-started.html"
  fi
fi

if ! command -v zoxide &> /dev/null; then
  echo "Install 'z' zoxide please! https://github.com/ajeetdsouza/zoxide"
else
  eval "$(zoxide init zsh)"
  alias cd=z
fi
