# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# export PATH="/usr/local/opt/protobuf@21/bin:$PATH"
#source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
source ~/.config/zsh/.p10k.zsh
# POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Plugins
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Custom functions
source ~/.config/zsh/custom-functions.zsh

# exports
export EDITOR=nvim
export VISUAL="$EDITOR"

# Check if homebrew is installed and install it if not
if ! command -v brew &> /dev/null
then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check if asdf is installed and load it or install it
if [ -d /usr/local/opt/asdf ]; then
  . /usr/local/opt/asdf/libexec/asdf.sh
else
  echo "Installing asdf..."
  brew install asdf
fi

eval "$(zoxide init zsh)"
