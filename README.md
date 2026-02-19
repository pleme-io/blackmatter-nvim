# Blackmatter Neovim

A curated Neovim distribution built with Nix. 55 plugins, 11 LSP servers, 13 formatters, and a Nord-themed UI — all bundled into a single `blnvim` binary with zero runtime dependencies.

## Install

```bash
# Build and run
nix run github:pleme-io/blackmatter-nvim

# Or add to your flake
{
  inputs.blackmatter-nvim.url = "github:pleme-io/blackmatter-nvim";
}

# Use the overlay to get pkgs.blnvim
nixpkgs.overlays = [ inputs.blackmatter-nvim.overlays.default ];
```

The binary is called `blnvim`. It wraps Neovim with `NVIM_APPNAME=blnvim`, keeping your existing `~/.config/nvim` untouched.

## What's Inside

### Plugins (55 enabled)

**Editing** — Comment.nvim, leap.nvim, nvim-surround, nvim-autopairs, nvim-ts-autotag

**Completion** — nvim-cmp with buffer/path/LSP/treesitter/cmdline sources, LuaSnip + friendly-snippets, lspkind icons

**LSP** — nvim-lspconfig, mason.nvim, lspsaga (hover, rename, code actions, breadcrumbs, outline), lsp_signature, trouble.nvim, tiny-inline-diagnostic, vim-illuminate

**Testing** — neotest with adapters for Go, Jest, Python (pytest), Rust, Plenary

**Search** — Telescope with fd + ripgrep, hidden files, quickfix integration

**Treesitter** — Full grammar set from nixpkgs, textobjects (function/class select, move, swap), context, ts-context-commentstring, render-markdown, autotag

**UI** — Nord colorscheme, lualine (with macro recording indicator), bufferline, gitsigns (hunk nav/staging/blame), snacks.nvim (dashboard, terminal, gitbrowse, zen, scroll, word navigation), noice, nvim-notify, indent-blankline, nvim-colorizer, which-key (popup disabled)

**Navigation** — oil.nvim (file explorer), todo-comments, vim-tmux-navigator

**Formatting** — conform.nvim with rustfmt, prettier, stylua, alejandra, black, gofumpt, shfmt, taplo, buf, rubocop, google-java-format, php-cs-fixer, zig fmt

### LSP Servers

All servers are Nix-managed — no Mason downloads needed at runtime.

| Server | Language |
|--------|----------|
| basedpyright | Python |
| ruff | Python (linting) |
| ts_ls | TypeScript / JavaScript |
| nixd | Nix |
| rust_analyzer | Rust |
| gopls | Go |
| clangd | C / C++ |
| zls | Zig |
| bashls | Bash |
| ruby_lsp | Ruby |
| nushell | Nushell |

### Key Bindings

Leader key: `,` (comma)

**General**

| Key | Action |
|-----|--------|
| `ff` | Format file |
| `S-h` / `S-l` | Previous / next buffer |
| `<leader>bd` | Close buffer |
| `<leader><space>` | Clear search highlight |
| `A-j` / `A-k` | Move line(s) up / down |
| `C-s` | Save |
| `<leader>sv` / `<leader>sh` | Vertical / horizontal split |
| `jk` | Escape to normal mode |

**LSP** (via lspsaga)

| Key | Action |
|-----|--------|
| `K` | Hover doc |
| `gd` / `gD` | Go to / peek definition |
| `gt` / `gT` | Go to / peek type definition |
| `gr` | References + implementations |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>dl` / `<leader>db` | Line / buffer diagnostics |
| `<leader>o` | Symbol outline |
| `<C-k>` | Signature help |

**Git**

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next / previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hu` | Undo stage |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Toggle line blame |
| `<leader>hd` | Diff file |
| `<leader>gg` | Open in GitHub |

**Testing**

| Key | Action |
|-----|--------|
| `<leader>nn` | Run nearest test |
| `<leader>nf` | Run file tests |
| `<leader>ns` | Run test suite |
| `<leader>np` | Toggle summary |
| `<leader>no` | Toggle output panel |

**Other**

| Key | Action |
|-----|--------|
| `-` | Open oil.nvim (file explorer) |
| `s` / `S` | Leap forward / backward |
| `<leader>tt` | Toggle terminal |
| `<leader>z` | Zen mode |
| `]t` / `[t` | Next / previous TODO comment |
| `]]` / `[[` | Next / previous reference |
| `<C-l>` / `<C-h>` | Jump forward / backward in snippet |

## Architecture

```
blackmatter-nvim/
  flake.nix              # Exposes packages.blnvim, overlays.default, homeManagerModules.default
  lib/plugin-helper.nix  # Core: mkPlugin, mkLazySpec, buildPluginDrv, fetching
  package/               # Standalone blnvim binary (all plugins + tools bundled)
    default.nix          # Derivation with enabledSet, runtimeDeps, makeWrapper
    init.lua             # Bootstrap init.lua (templated with Nix store paths)
  module/                # Home-manager module (alternative to standalone package)
    plugins/             # 181 plugin declarations
      declarations.nix   # Central import list
      registry.nix       # Processes declarations into Nix modules
      {author}/{name}/   # Per-plugin: default.nix, rev.nix, hash.nix, config/
    groups/              # 9 feature groups
      common/            # Core utilities
      completion/        # nvim-cmp ecosystem
      formatting/        # conform.nvim
      keybindings/       # General editor bindings
      lsp/               # LSP, diagnostics, neotest
      telescope/         # Fuzzy finder
      theming/           # UI, colorscheme, statusline
      tmux/              # Tmux navigation
      treesitter/        # Syntax, textobjects, context
```

**Plugin declarations** are minimal data files — 6 lines of metadata. `lib/plugin-helper.nix` generates full Nix modules from them. Plugins with a `configDir` get auto-setup via lazy.nvim's config callback.

**Two build modes**:
- `nix build .#blnvim` — standalone binary, everything in the Nix store
- `homeManagerModules.default` — integrates with home-manager, plugins in `~/.local/share/nvim`

## Platforms

| System | Status |
|--------|--------|
| aarch64-darwin | Primary |
| x86_64-darwin | Supported |
| aarch64-linux | Supported |
| x86_64-linux | Supported |

## Development

```bash
nix develop  # Provides blnvim, nixd, lua-language-server, stylua
```

## Adding a Plugin

```bash
# 1. Create declaration
mkdir -p module/plugins/{author}/{name}

# 2. Get rev + hash
REV=$(curl -s "https://api.github.com/repos/{author}/{name}/commits/main" | jq -r .sha)
echo "\"$REV\"" > module/plugins/{author}/{name}/rev.nix
RAW=$(nix-prefetch-url --unpack --type sha256 "https://github.com/{author}/{name}/archive/$REV.tar.gz")
echo "\"$(nix hash convert --hash-algo sha256 --to sri $RAW)\"" > module/plugins/{author}/{name}/hash.nix

# 3. Create default.nix
cat > module/plugins/{author}/{name}/default.nix << 'EOF'
{
  author = "{author}";
  name = "{name}";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
}
EOF

# 4. Register in declarations.nix
# 5. Enable in a group's default.nix
# 6. Add to package/default.nix enabledSet (for standalone build)
# 7. nix build .#blnvim
```

## License

MIT
