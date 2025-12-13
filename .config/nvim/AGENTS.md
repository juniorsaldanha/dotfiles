# AGENTS.md - Neovim Configuration

This is a personal Neovim configuration using lazy.nvim as the plugin manager.

## Directory Structure

```
.
├── init.lua                 # Entry point - loads config modules
├── lua/
│   ├── config/
│   │   ├── options.lua      # Vim options (leader, tabs, search, etc.)
│   │   ├── keymaps.lua      # General keymaps (non-plugin)
│   │   ├── autocmd.lua      # Autocommands
│   │   └── lazy.lua         # Plugin manager bootstrap
│   └── plugins/
│       ├── init.lua         # Base plugins (plenary, devicons)
│       ├── lsp.lua          # LSP configuration (mason, lspconfig)
│       ├── cmp.lua          # Autocompletion
│       ├── telescope.lua    # Fuzzy finder
│       ├── treesitter.lua   # Syntax highlighting
│       ├── conform.lua      # Formatting
│       ├── lint.lua         # Linting
│       ├── gitsigns.lua     # Git integration
│       ├── oil.lua          # File explorer
│       ├── whichkey.lua     # Keybinding hints
│       ├── theme.lua        # Colorscheme (tokyonight)
│       ├── floaterm.lua     # Floating terminal (local plugin)
│       ├── tmux.lua         # Tmux navigation
│       ├── persistence.lua  # Session management
│       └── dashboard.lua    # Start screen
├── ftplugin/                # Filetype-specific settings (empty)
├── .stylua.toml             # Lua formatter config
├── .luarc.json              # Lua LSP config
└── lazy-lock.json           # Plugin version lock file
```

## Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open lazy.nvim plugin manager UI |
| `:Mason` | Open Mason package manager UI |
| `:ConformInfo` | Show formatter info for current buffer |
| `:Format` | Manually format buffer (or range) |
| `:Restore` | Restore last session for current directory |
| `:checkhealth` | Diagnose issues with plugins/LSP |

## Formatting & Linting

### Lua Files

- **Formatter**: stylua (configured in `.stylua.toml`)
  - 2 space indentation
  - 120 column width
  - Unix line endings
  - Auto-sorted requires

Run manually: `stylua lua/`

### Format on Save

Format on save is enabled globally via conform.nvim. To disable, edit `lua/plugins/conform.lua` and set `format_on_save = false`.

## Code Conventions

### Lua Style

- **Indentation**: 2 spaces (per `.stylua.toml`)
- **Quotes**: Double quotes preferred
- **Line width**: 120 characters
- **Requires**: Auto-sorted by stylua

### Plugin Structure

Each plugin file follows this pattern:

```lua
--[[
  Plugin Name - Short description

  KEYMAPS: Modify the `keys` or `on_attach` section
  OTHER: Add/remove items in specific tables
]]

return {
    "author/plugin-name",
    event = "...",  -- Lazy loading event
    dependencies = { ... },
    keys = { ... },  -- Plugin keymaps
    opts = { ... },  -- Plugin options
    config = function(_, opts)
        -- Setup code
    end,
}
```

### Keymap Conventions

- **Leader key**: Space
- General keymaps go in `lua/config/keymaps.lua`
- Plugin-specific keymaps stay in their plugin files
- All keymaps should have a `desc` for which-key

Helper pattern used throughout:
```lua
local function opts(desc)
    return { desc = desc, noremap = true, silent = true }
end
```

## Key Mappings Reference

### Leader Prefixes

| Prefix | Group |
|--------|-------|
| `<leader>b` | Buffer |
| `<leader>c` | Code |
| `<leader>f` | Find |
| `<leader>g` | Git |
| `<leader>h` | Hunk (git) |
| `<leader>q` | Quit/Quickfix |
| `<leader>s` | Search |
| `<leader>t` | Terminal/Toggle |

### Important Keymaps

| Key | Mode | Action |
|-----|------|--------|
| `jk` | Insert | Exit insert mode |
| `<Space>` | Normal | Leader key |
| `-` | Normal | Open Oil file explorer |
| `<C-_>` or `<C-/>` | Normal | Toggle floating terminal |
| `<leader>gg` | Normal | Open lazygit |
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader><leader>` | Normal | Find buffers |
| `<leader>cf` | Normal/Visual | Format buffer |
| `<leader>?` | Normal | Show buffer keymaps |

### LSP Keymaps (buffer-local when LSP attaches)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next/prev diagnostic |

## Adding New Features

### Adding a New Plugin

1. Create `lua/plugins/pluginname.lua`
2. Return a table with the plugin spec
3. Restart Neovim or run `:Lazy sync`

### Adding a New LSP Server

1. Add server name to `ensure_installed` in `lua/plugins/lsp.lua` (line ~38)
2. Add server config to `servers` table in same file (line ~139)
3. Restart and run `:Mason` to install

### Adding a New Formatter

1. Add formatter mapping in `lua/plugins/conform.lua` → `formatters_by_ft`
2. Install via Mason or system package manager

### Adding a New Linter

1. Add linter mapping in `lua/plugins/lint.lua` → `linters_by_ft`
2. Install via Mason or system package manager

### Adding a New Treesitter Parser

1. Add language to `ensure_installed` in `lua/plugins/treesitter.lua`
2. Run `:TSInstall <language>` or restart

## Gotchas

1. **Leader must be set before lazy.nvim loads** - Done in `lua/config/options.lua`

2. **Plugin keymaps in keys = {}** - These are lazy-loaded; plugin won't load until keymap is pressed

3. **floaterm.nvim is a local plugin** - Located at `~/gh/floaterm.nvim/`, not from a package manager

4. **Auto-format on save** - Enabled by default. Writes may feel slow if formatter is missing/slow

5. **Trailing whitespace auto-removed** - Autocommand in `autocmd.lua` strips trailing whitespace on save

6. **Session restore** - Use `:Restore` command to restore session for current directory

7. **Telescope C-j/C-k navigation** - Remapped from default C-n/C-p for selection navigation

## LSP Servers Configured

| Server | Language |
|--------|----------|
| lua_ls | Lua |
| ts_ls | TypeScript/JavaScript |
| html | HTML |
| cssls | CSS |
| jsonls | JSON |
| pyright | Python |
| gopls | Go |
| rust_analyzer | Rust |
| bashls | Bash |
| yamlls | YAML |

## Testing Changes

After making changes:
1. Save the file (auto-formats if stylua available)
2. Source the file: `:source %` (for config files)
3. Or restart Neovim: `:qa` then reopen
4. Check for errors: `:checkhealth`
5. For lazy.nvim issues: `:Lazy health`

## Dependencies

External tools that should be installed:
- `git` - Required by lazy.nvim and gitsigns
- `make` - Required by telescope-fzf-native
- `ripgrep` - Used by Telescope live_grep
- `fd` - Used by Telescope find_files (optional but faster)
- `stylua` - Lua formatter
- `lazygit` - Git TUI (for floaterm integration)
