# AGENTS.md - Dotfiles Configuration

Personal dotfiles repository containing shell, terminal, editor, and tool configurations for macOS (Darwin).

## Directory Structure

```
.config/
├── alacritty/          # Alacritty terminal configuration
│   ├── alacritty.toml  # Main config (font, window, keybindings)
│   └── tokyo-night.toml # Color theme
├── btop/               # System monitor configuration
├── git/                # Git configuration
│   ├── config          # Main git config (aliases, delta, signing)
│   ├── ignore          # Global gitignore patterns
│   └── ionichealth     # Work-specific git identity
├── kitty/              # Kitty terminal configuration
│   └── kitty.conf      # Font, cursor, window settings
├── nvim/               # Primary Neovim configuration (lazy.nvim)
│   ├── AGENTS.md       # Detailed nvim-specific documentation
│   └── lua/            # Lua configuration modules
├── nvim_minimal/       # Minimal Neovim configuration
│   └── lua/            # Alternative plugin set
├── tmux/               # Tmux configuration
│   ├── tmux.conf       # Keybindings, plugins, settings
│   └── tokyonight_night.tmux # Theme
├── zsh/                # Zsh shell configuration
│   ├── .zshrc_macos    # macOS-specific setup & bootstrap
│   ├── aliases.zsh     # Shell aliases
│   ├── custom-functions.zsh # Utility functions
│   ├── keymaps.zsh     # Zsh keybindings
│   ├── load_plugins.zsh # Plugin sourcing
│   └── plugins/        # Zsh plugins (p10k, syntax-highlighting, etc.)
├── zed/                # Zed editor configuration
├── 1Password/          # SSH agent configuration
└── crush/              # Crush CLI configuration
```

## Installation & Setup

### macOS Bootstrap

Run the macOS-specific setup script which auto-installs dependencies:

```bash
source ~/.config/zsh/.zshrc_macos
```

This script installs (if missing):
- **Package manager**: Homebrew
- **Version manager**: asdf (with Go, Node.js, Python, Rust)
- **CLI tools**: neovim, ripgrep, tmux, fzf, fd, zoxide, eza, btop, bun, yazi
- **Utilities**: thefuck

### Font Setup

Run the `setup` function in `.zshrc_macos`:
```bash
setup
```

Installs:
- FiraCode Nerd Font
- Terminess Nerd Font

### Tmux Plugin Manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```
Then press `prefix + I` inside tmux to install plugins.

## Shell Configuration

### Zsh Aliases

| Alias | Command |
|-------|---------|
| `ll` | `ls -lahG` |
| `ls` | `eza --color=always --long --git --icons=always` (if eza installed) |
| `cat` | `bat` (if bat installed) |
| `lg` | `lazygit` |
| `ld` | `lazydocker` |
| `nv` / `nvmini` | Launch minimal Neovim config |
| `nvs` | fzf selector for Neovim configs |
| `F` | `yazi` file manager |
| `g` | `git` |
| `o` | `open .` |
| `fk` | `thefuck` correction |

### Shell Keybindings

| Key | Action |
|-----|--------|
| `Ctrl-a` | Launch nvim config selector (`nvims`) |
| `Ctrl-r` | History search |
| `Ctrl-p/n` | Previous/next history |
| `Esc` | Enter vi command mode |

### Useful Functions

| Function | Description |
|----------|-------------|
| `extract <file>` | Auto-extract any archive type |
| `.. <n>` | Navigate up n directories |
| `biggest <dir>` | Show largest items in directory |
| `clean_nvim` | Remove nvim cache/state |
| `nvims` | fzf selector for multiple nvim configs |
| `nvim_docker` | Run nvim in Alpine container |
| `upgrade_asdf <plugin>` | Upgrade asdf plugin to latest |
| `remotedocker_active <ip>` | Connect to remote Docker daemon |
| `nvim_browser_remote <host>` | Browse remote files via oil-ssh |
| `start_http_server [dir]` | Start Python HTTP server |

## Git Configuration

### Aliases

| Alias | Command |
|-------|---------|
| `g st` | `git status -sb` |
| `g l` | Pretty graph log |
| `g aa` | `add -A` |
| `g cm "msg"` | `commit --message` |
| `g pf` | `push --force-with-lease` |
| `g rbi` | `rebase --interactive` |
| `g nb <name>` | Create and switch to new branch |
| `g cb` | Clean merged branches |
| `g pu` | Push and set upstream |

### Features

- **Commit signing**: SSH key via 1Password
- **Diff tool**: delta with side-by-side view
- **Editor**: neovim
- **Conditional includes**: Work identity for `~/ionichealth/` directory

## Tmux Configuration

### Key Bindings

| Key | Action |
|-----|--------|
| `prefix + \|` | Split horizontally |
| `prefix + -` | Split vertically |
| `prefix + r` | Reload config |
| `prefix + H/J/K/L` | Resize pane |
| `prefix + m/M` | Toggle zoom |
| `Ctrl + h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl + Enter` | Enter copy mode |
| `v` (copy mode) | Begin selection |
| `y` (copy mode) | Copy selection |

### Plugins

- **vim-tmux-navigator**: Seamless nvim/tmux navigation
- **tmux-resurrect**: Persist sessions across restart
- **tmux-continuum**: Auto-save sessions every 15min
- **tmux-yank**: System clipboard support
- **tmux-1password**: 1Password integration

## Neovim Configurations

Two configurations available:

### Default (`nvim/`)

Full-featured config with:
- lazy.nvim plugin manager
- LSP (lua_ls, ts_ls, pyright, gopls, rust_analyzer, etc.)
- Telescope, Treesitter, Conform, gitsigns
- Tokyo Night theme

See `nvim/AGENTS.md` for detailed documentation.

### Minimal (`nvim_minimal/`)

Launch with: `nvmini` or `NVIM_APPNAME=nvim_minimal nvim`

Alternative plugin set including:
- Avante (AI)
- Copilot
- Harpoon
- Snacks
- Edgy

### Lua Formatting

All nvim configs use stylua (`.stylua.toml`):
- 2 space indentation
- 120 column width
- Unix line endings
- Auto-sorted requires

Format: `stylua lua/`

## Terminal Emulators

### Alacritty

- **Font**: Terminess Nerd Font, size 16
- **Window**: 80% opacity, blur, maximized, buttonless decorations
- **Theme**: Tokyo Night (imported)
- **Option key**: Works as Alt (both sides)

### Kitty

- **Font**: Terminess Nerd Font, size 16
- **Theme**: Configurable via `current-theme.conf`

## Code Conventions

### Lua (Neovim)

- 2 space indentation
- Double quotes preferred
- 120 char line width
- Requires auto-sorted

### Zsh

- Functions go in `custom-functions.zsh`
- Aliases go in `aliases.zsh`
- Platform checks use: `[[ $(uname) == "Darwin" ]]`
- Tool availability checks: `if command -v <tool> &>/dev/null`

### Git

- Default branch: `main`
- Commit signing enabled (SSH via 1Password)
- Use delta for diffs

## Theme

**Tokyo Night** is used consistently across:
- Neovim
- Tmux
- Alacritty
- iTerm2
- btop

## Common Tasks

### Switch Neovim Config

```bash
nvims  # fzf selector
# or
nvmini  # direct to minimal config
```

### Reload Configurations

| Config | Command |
|--------|---------|
| Tmux | `prefix + r` |
| Neovim | `:source %` or restart |
| Zsh | `source ~/.zshrc` |

### Clean Neovim Cache

```bash
clean_nvim
```

### Test Neovim in Docker

```bash
nvim_docker
```

## Dependencies (macOS)

Install all via `brew`:

| Tool | Purpose |
|------|---------|
| neovim | Editor |
| ripgrep | Fast search (Telescope) |
| fd | Fast find (Telescope, fzf) |
| fzf | Fuzzy finder |
| tmux | Terminal multiplexer |
| lazygit | Git TUI |
| lazydocker | Docker TUI |
| eza | Modern ls |
| bat | Modern cat |
| zoxide | Smart cd |
| yazi | File manager |
| thefuck | Command correction |
| delta | Git diff viewer |
| stylua | Lua formatter |
| asdf | Version manager |

## Gotchas

1. **1Password SSH signing** - Requires 1Password app running and configured
2. **asdf path** - Sourced from `/opt/homebrew/opt/asdf/libexec/asdf.sh`
3. **Tmux plugins** - TPM must be cloned manually before plugins work
4. **Nerd Fonts required** - Icons won't render without Nerd Font installed
5. **Delta for git diffs** - Install delta or diffs will fail
6. **Work git identity** - Conditional include activates for `~/ionichealth/` paths
7. **Zsh plugins location** - All in `~/.config/zsh/plugins/`, not managed by plugin manager
8. **Option-as-Alt** - Alacritty configured for this, may need terminal settings elsewhere
