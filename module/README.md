# Blackmatter Neovim — Module

Home-manager module for the blackmatter neovim configuration. 181 plugins declared, ~55 enabled by default across 9 groups.

For standalone usage without home-manager, see `../package/`.

## Structure

```
module/
  default.nix          # Main module entry (imports groups + plugin registry)
  common/              # Shared helpers (paths, base URL)
  groups/              # Feature groups (9 groups, each with default.nix + Lua)
    common/            # Plenary, devicons, which-key, leap, surround, oil, etc.
    completion/        # nvim-cmp, sources, LuaSnip, autopairs
    formatting/        # conform.nvim (formatters: rustfmt, prettier, stylua, etc.)
    keybindings/       # General editor keybindings
    lsp/               # LSP servers, lspsaga, diagnostics, neotest
    telescope/         # Fuzzy finder with fd/rg
    theming/           # Nord colorscheme, lualine, bufferline, gitsigns, snacks
    tmux/              # vim-tmux-navigator
    treesitter/        # Syntax highlighting, textobjects, context, autotag
  plugins/             # Plugin declarations (181 plugins)
    declarations.nix   # Central import list
    registry.nix       # Processes declarations via plugin-helper
    {author}/{name}/   # Per-plugin: default.nix, rev.nix, hash.nix, config/
```

## Plugin System

Plugins are simple data declarations processed by `lib/plugin-helper.nix`:

```nix
# plugins/author/plugin-name/default.nix
{
  author = "folke";
  name = "snacks.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;  # optional — Lua config auto-loaded by lazy.nvim
}
```

See `plugins/CLAUDE.md` for the full plugin system guide.

## Groups

Each group has a `default.nix` (Nix module that enables plugins + installs packages) and Lua config files.

| Group | Plugins | Purpose |
|-------|---------|---------|
| common | 8 | Core utilities (plenary, devicons, which-key, leap, surround, oil, Comment, todo-comments) |
| completion | 9 | nvim-cmp + sources, LuaSnip, friendly-snippets, autopairs |
| formatting | 1 | conform.nvim with 15+ formatters |
| keybindings | 0 | General editor keybindings (buffers, splits, movement) |
| lsp | 14 | LSP servers, lspsaga, diagnostics, trouble, illuminate, neotest |
| telescope | 1 | Telescope with fd/rg integration |
| theming | 10 | Nord, lualine, bufferline, gitsigns, snacks, noice, notify, colorizer, indent-blankline |
| tmux | 1 | vim-tmux-navigator |
| treesitter | 6 | nvim-treesitter, textobjects, context, ts-context-commentstring, render-markdown, autotag |

## Usage (Home-Manager)

```nix
blackmatter.components.nvim.enable = true;
```

This is typically enabled via a profile (e.g., `blackmatter.profiles.frost.enable = true` chains through `base.developer` which sets `nvim.enable = true`).
