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
if [ -f ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme ]; then
  source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
else
  echo "Powerlevel10k not found"
fi

if [ -f ~/.config/zsh/.p10k.zsh ]; then
  source ~/.config/zsh/.p10k.zsh
else
  echo "Powerlevel10k configuration not found"
fi
# POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Plugins
if [ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  echo "zsh-syntax-highlighting not found"
fi

if [ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  echo "zsh-autosuggestions not found"
fi

if [ -f ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
  source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
else
  echo "zsh-autocomplete not found"
fi

# Custom functions
if [ -f ~/.config/zsh/custom-functions.zsh ]; then
  source ~/.config/zsh/custom-functions.zsh
else
  echo "Custom functions not found"
fi

# exports
export EDITOR=nvim
export VISUAL="$EDITOR"

# if file exists, source it
if [ -f ~/.config/zsh/.zsh_exports ]; then
  source ~/.config/zsh/.zsh_exports
fi

if [[ $(uname) == "Darwin" ]]; then
  source ~/.config/zsh/.zshrc_macos
elif [[ "$(uname)" == "Linux" ]]; then
  if [ -f /etc/debian_version ]; then
    source ~/.config/zsh/.zshrc_debian
  elif [ -f /etc/arch-release ]; then
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

# bun completions
[ -s "/Users/umsaldanha/.bun/_bun" ] && source "/Users/umsaldanha/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="`go env GOPATH`/bin:$PATH"
