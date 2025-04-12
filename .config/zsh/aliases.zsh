alias ll='ls -lahG'
alias rmf='rm -rf'
alias follow="tail -f -n +1"
alias o="open ."
alias lg="lazygit"
alias ld="lazydocker"
alias nv="nvim"
alias nvs="nvims"
alias nvmini="NVIM_APPNAME=nvim_minimal nvim"

if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
	alias cd="z"
fi

if command -v eza &>/dev/null; then
	alias ls="eza --color=always --long --git --icons=always"
fi

if command -v bat &>/dev/null; then
    alias cat="bat"
fi

if command -v fzf &>/dev/null; then
	eval "$(fzf --zsh)"
	if command -v fd &>/dev/null; then
		export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
		export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
		export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

		_fzf_compgen_path() {
			fd --hidden --exclude .git . "$1"
		}

		_fzf_compgen_dir() {
			fd --type=d --hidden --exclude .git . "$1"
		}
	fi
fi

if command -v thefuck &>/dev/null; then
	eval $(thefuck --alias)
	eval $(thefuck --alias fk)
fi

if command -v zoxide &>/dev/null; then
	eval "$(zoxide init zsh)"
fi

if command -v yazi &>/dev/null; then
    alias F="yazi"
fi
