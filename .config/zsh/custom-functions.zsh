function clean_nvim() {
	rm -rf ~/.local/share/nvim/
	rm -rf ~/.local/state/nvim/
}

function disabledevverification() {
	sudo spctl --master-disable
	echo "Developer verification Disabled - Darwin Only"
}

function enabledevverification() {
	sudo spctl --master-enable
	echo "Developer verification Enabled - Darwin Only"
}

function setup_python_symlink() {
    sudo rm -rf /usr/local/bin/python
    brew update && brew install python3
    sudo ln -s /opt/homebrew/bin/python3 /usr/local/bin/python
}

function remotedocker_active() {
	# The following line and options.conf is to setup access in Docker Host Daemon, dont forget to open port 2375 tcp on firewall
	# sudo mkdir -p /etc/systemd/system/docker.service.d
	# sudo nano /etc/systemd/system/docker.service.d/options.conf
	# [Service]
	# ExecStart=
	# ExecStart=/usr/bin/dockerd -H unix:// -H tcp://0.0.0.0:2375

	# # Reload the systemd daemon.
	# sudo systemctl daemon-reload

	# # Restart Docker.
	# sudo systemctl restart docker

	if [ "$1" ]; then
		export DOCKER_HOST=tcp://$1:2375
		echo "Connected to Docker Daemon on $1:2375"
	else
		echo "Example of usage; rdocker ipOfDockerHost"
	fi
}

function remotedocker_deactive() {
	echo "Deactivated Docker Daemon Remote from $DOCKER_HOST"
	unset DOCKER_HOST
}

function sshauto() {
	if [ "$1" ]; then
		ping=$(ping -c 1 $1 | grep bytes | wc -l)
		if [ "$ping" -gt 1 ]; then
			sshpass -p "$3" ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" "$2"@"$1"
		else
			echo "IP/FQDN: $1 not accessible"
		fi
	else
		echo "Example of usage; $(sshauto ip user pass)"
	fi
}

#function winbox() {
# export PATH="/Applications/Wine Staging.app/Contents/Resources/wine/bin:$PATH"
# export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
# export DYLD_FALLBACK_LIBRARY_PATH="/usr/lib:/opt/X11/lib:$DYLD_FALLBACK_LIBRARY_PATH"
# wine64 ~/Documents/winbox64.exe > /dev/null 2>&1 &
# }

# I need to find a new transfer service to replace transfer.sh as it is not working anymore
function transfer() {
	if [ $# -eq 0 ]; then
		echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>" >&2
		return 1
	fi
	if tty -s; then
		file="$1"
		file_name=$(basename "$file")
		if [ ! -e "$file" ]; then
			echo "$file: No such file or directory" >&2
			return 1
		fi
		if [ -d "$file" ]; then
			file_name="$file.zip"
			zip -r -q $file_name $file
			curl --progress-bar --upload-file "$file_name" "https://transfer.sh/$file_name" | tee /dev/null
			echo
			rm -rf $file_name
		else
			curl --progress-bar --upload-file "$file" "https://transfer.sh/$file" | tee /dev/null
			echo
		fi
	fi
}

function extract() {
	if [ -f $1 ]; then
		case $1 in
		*.tar.bz2) tar xvjf $1 ;;
		*.tar.xz) tar xf $1 ;;
		*.tar.gz) tar xvzf $1 ;;
		*.bz2) bunzip2 $1 ;;
		*.rar) rar x $1 ;;
		*.gz) gunzip $1 ;;
		*.tar) tar xvf $1 ;;
		*.tbz2) tar xvjf $1 ;;
		*.tgz) tar xvzf $1 ;;
		*.zip) unzip $1 ;;
		*.Z) uncompress $1 ;;
		*.7z) 7z x $1 ;;
		*) echo "don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

function ..() {
	for i in $(seq 1 $1); do
		cd ../
	done
}

function biggest() {
	if [ "$1" ]; then
		du -h -d 1 "$1" | sort -h
	fi

}

function cppcheck() {
	if [ "$1" ]; then
		cpplint --filter=-runtime/int --exclude=$1/.pio/ --quiet --output=vs7 --recursive $1
	else
		cpplint --filter=-runtime/int --exclude=.pio/ --quiet --output=vs7 --recursive .
	fi
}

function nvims() {
	items=("default" "nvim_minimal")
	config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
	if [[ -z $config ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $config == "default" ]]; then
		config=""
	fi
	NVIM_APPNAME=$config nvim $@
}

function nvim_docker() {
	docker run -w /root -it --rm alpine:latest sh -uelic '
    apk add git nodejs neovim ripgrep build-base wget stow --update
    git clone https://github.com/juniorsaldanha/dotfiles ~/dotfiles
    cd ~/dotfiles && stow .
    cd ~/ && nvim
    '
}

function start_http_server() {
    if [ "$1" ]; then
        if [ -d "$1" ]; then
            cd "$1" || return
        fi
        python3 -m http.server
    else
        echo "Example of usage; start_http_server /path/to/directorya or start_http_server for current dir"
    fi
}

function nvim_browser_remote() {
    # nvim oil-ssh://[username@]hostname[:port]/[path]
    if [ "$1" ]; then
        nvim "oil-ssh://$1"
    else
        echo "Example of usage; nvim_browser_remote username@hostname:/path/to/file"
    fi
}

function upgrade_asdf() {
    plugin=$1
    asdf plugin update $plugin
    asdf install $plugin latest
    asdf global $plugin latest
    newVersion=$(asdf current $plugin | awk '{print $2}')

    echo "Upgraded $plugin to latest version: $newVersion"
}

function upgrade_go_asdf(){
    upgrade_asdf golang
}
