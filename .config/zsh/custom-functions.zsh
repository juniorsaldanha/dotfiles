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

# Compress video(s) to HEVC, GPU (VideoToolbox) when available. See `compressvid -h`.
function compressvid() {
	local fps=30 rotate=0 split= noaudio=0 max=0 res= f ext out r src size dur seg base p big
	local -a files venc vf args aargs hw
	while (( $# )); do
		case $1 in
			-f|--fps) fps=$2; shift 2 ;;
			-n|--no-audio) noaudio=1; shift ;;
			-s|--split) split=$2; shift 2 ;;
			-r|--rotate) rotate=$2; shift 2 ;;
			-R|--res) res=${2:l}; shift 2 ;;
			-h|--help) cat <<'HELP'
compressvid - compress videos to HEVC (H.265), using the GPU when available

Usage:
  compressvid [options] <file>...

  Output is written next to each source as <name>_processed.<ext>.
  mov, mp4, m4v and mkv keep their extension; other formats become .mp4.
  Files already named *_processed* are skipped. Options can go anywhere.

Options:
  -f, --fps N          Max frame rate (default: 30). Never raises it.
  -R, --res RES        Max resolution: 4k, 2k, 1080p, 720p, 480p or a number.
                       Caps the short side, so portrait works too. Never upscales.
  -r, --rotate DEG     Rotate clockwise: 0 (default), 90, 180, 270.
  -n, --no-audio       Remove the audio track (default: AAC 128k).
  -s, --split SIZE     Split into parts no bigger than SIZE (K, M, G; base 1000),
                       e.g. 25M -> <name>_processed_part00.<ext>, _part01, ...
  -h, --help           Show this help.

Examples:
  compressvid IMG_1830.MOV
  compressvid IMG_*.MOV *.mp4
  compressvid -R 1080p -f 60 clip.mov
  compressvid -s 25M -n -r 90 clip.mov

Encoder: hevc_videotoolbox (q 55) on macOS, else libx265 (crf 26).
Keeps HDR and metadata. Needs ffmpeg and ffprobe.
HELP
				return ;;
			-*) print -u2 "Unknown option: $1"; return 1 ;;
			*) files+=("$1"); shift ;;
		esac
	done
	(( ${#files} )) || { compressvid -h; return 1 }
	[[ $fps == <1-> ]] || { print -u2 "fps must be a positive integer"; return 1 }
	[[ $rotate == (0|90|180|270) ]] || { print -u2 "rotate must be 0, 90, 180 or 270"; return 1 }
	case $res in
		''|<1->) ;;
		4k) res=2160 ;;
		2k) res=1440 ;;
		<1->p) res=${res%p} ;;
		*) print -u2 "res must be 4k, 2k, 1080p, 720p, 480p or a number"; return 1 ;;
	esac
	if [[ -n $split ]]; then
		[[ $split =~ '^([0-9.]+)([KkMmGg]?)[Bb]?$' ]] || { print -u2 "Bad size: $split (use e.g. 25M)"; return 1 }
		case ${(U)match[2]} in K) max=1e3 ;; M) max=1e6 ;; G) max=1e9 ;; *) max=1 ;; esac
		max=$(printf %.0f $(( match[1] * max )))
	fi

	if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q hevc_videotoolbox; then
		venc=(-c:v hevc_videotoolbox -q:v 55) hw=(-hwaccel videotoolbox)
	else
		venc=(-c:v libx265 -crf 26 -preset medium)
	fi
	(( noaudio )) && aargs=(-an) || aargs=(-map '0:a:0?' -c:a aac -b:a 128k)

	for f in $files; do
		[[ -f $f ]] || { print -u2 "Skip (not a file): $f"; continue }
		[[ ${f:t:r} == *_processed* ]] && { print "Skip (already processed): $f"; continue }
		ext=${f:e}
		[[ ${ext:l} == (mov|mp4|m4v|mkv) ]] || ext=mp4
		out="${f:r}_processed.$ext"

		vf=()
		r=$(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of csv=p=0 "$f")
		[[ $r == <1->/<1-> ]] && src=$(( ${r%/*}.0 / ${r#*/} )) || src=999
		(( src > fps )) && vf+=(fps=$fps)
		# cap the short side at $res so portrait and landscape both work
		[[ -n $res ]] && vf+=("scale='if(gte(iw,ih),-2,min($res,iw))':'if(gte(iw,ih),min($res,ih),-2)'")
		case $rotate in 90) vf+=(transpose=1) ;; 180) vf+=(hflip,vflip) ;; 270) vf+=(transpose=2) ;; esac

		args=(-hide_banner -loglevel error -stats -y $hw -i "$f" -map 0:v:0 $aargs $venc -tag:v hvc1
			-force_key_frames 'expr:gte(t,n_forced*2)' -map_metadata 0 -movflags +faststart)
		(( ${#vf} )) && args+=(-vf ${(j:,:)vf})
		print "▶ $f → $out"
		ffmpeg $args "$out" || { print -u2 "Failed: $f"; continue }

		size=$(wc -c < "$out")
		if (( max && size > max )); then
			dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$out")
			seg=$(( dur * max / size * 0.95 ))
			base=${out:r}
			while :; do
				(( seg >= 1 )) || { print -u2 "Can't split under $split (keyframe gap too large)"; break }
				rm -f ${base}_part*.$ext(N)
				ffmpeg -hide_banner -loglevel error -i "$out" -map 0 -c copy -f segment \
					-segment_time $seg -reset_timestamps 1 "${base}_part%02d.$ext" || break
				big=0
				for p in ${base}_part*.$ext(N); do (( $(wc -c < "$p") > max )) && big=1; done
				(( big )) || { rm "$out"; break }
				seg=$(( seg * 0.85 ))
			done
		fi
		du -h "$f" ${base:+${base}_part*.$ext(N)} "$out"(N) 2>/dev/null
		base=
	done
}
