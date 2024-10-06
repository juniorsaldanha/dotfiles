# To debug load times, uncomment the following line and the last line of this file
# and run `time zsh -i -c exit`
# zmodload zsh/zprof

export EDITOR=nvim
export VISUAL="$EDITOR"


# Load all plugins
if [ -f ~/.config/zsh/load_plugins.zsh ]; then
    source ~/.config/zsh/load_plugins.zsh
else
    echo "Plugins file not found"
fi

# Keymaps and bindings
if [ -f ~/.config/zsh/keymaps.zsh ]; then
    source ~/.config/zsh/keymaps.zsh
else
    echo "Keymaps file not found"
fi

# Custom functions
if [ -f ~/.config/zsh/custom-functions.zsh ]; then
	source ~/.config/zsh/custom-functions.zsh
else
	echo "Custom functions not found"
fi

# Aliases
if [ -f ~/.config/zsh/aliases.zsh ]; then
    source ~/.config/zsh/aliases.zsh
else
    echo "Aliases file not found"
fi

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
	echo "Unknown OS detected"
	echo "Please add the configuration for your OS in ~/.config/zsh/.zshrc_{os}"
	sleep 5
	return 1
fi

# bun
if [ -d "$HOME/.bun" ]; then
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Check if go is installed using which
if which go &> /dev/null; then
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# zprof
if [[ -n $ZSH_VERSION ]]; then
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi
