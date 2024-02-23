# To debug load times, uncomment the following line and the last line of this file
# and run `time zsh -i -c exit`
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
source ~/.config/zsh/.p10k.zsh
# POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Plugins
if [ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
  source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Custom functions
source ~/.config/zsh/custom-functions.zsh

# exports
export EDITOR=nvim
export VISUAL="$EDITOR"

# if file exists, source it
if [ -f ~/.config/zsh/.zsh_exports ]; then
  source ~/.config/zsh/.zsh_exports
fi

if [[ $(uname) == "Darwin" ]]; then
  echo "Setting up MacOS zshrc..."
  source ~/.config/zsh/.zshrc_macos
elif [[ "$(uname)" == "Linux" ]]; then
  if [ -f /etc/debian_version ]; then
    echo "Setting up Debian zshrc..."
    source ~/.config/zsh/.zshrc_debian
  elif [ -f /etc/arch-release ]; then
    echo "Setting up Arch zshrc..."
    source ~/.config/zsh/.zshrc_arch
  else
    echo "Unknown Linux distribution"
    return 1
  fi
else
  echo "Unknown OS"
  return 1
fi

# zprof
