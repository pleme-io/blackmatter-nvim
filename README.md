# blackmatter-nvim

A curated Neovim distribution built with Nix. 186 plugin declarations (55 enabled by default), 11 LSP servers, 13 formatters, and a Nord-themed UI -- all bundled into a single `blnvim` binary. Neovim 0.11.6 is built from source. Plugins are managed by lazy.nvim at runtime, installed by Nix at build time. Treesitter parsers and queries come from nixpkgs to guarantee version alignment. No runtime downloads -- everything is hermetically sealed in the Nix store.

## Architecture

```
                     flake.nix
                    /    |    \
          packages/   overlays   homeManagerModules
              |                        |
         package/                  module/
         default.nix               default.nix
              |                   /    |    \
         (standalone          plugins/  groups/  conf/
          blnvim binary)         |         |
                          declarations.nix  9 feature groups
                          registry.nix      (common, completion,
                          183 plugin dirs    formatting, keybindings,
                                             lsp, telescope, theming,
                                             tmux, treesitter)
```

**Data flow:**

1. `declarations.nix` is the single source of truth -- 183 plugin declarations as minimal data files (author, name, ref, rev, hash, optional lazy spec)
2. `registry.nix` feeds declarations through `lib/plugin-helper.nix` which generates full Nix modules (options, fetching, lazy.nvim specs)
3. Groups enable coherent sets of plugins together (e.g., enabling `lsp` group turns on nvim-lspconfig, mason, lspsaga, trouble, neotest, etc.)
4. `conf/init.lua` bootstraps lazy.nvim, then loads groups in order: common, treesitter, lsp, theming, formatting, keybindings, completion

**Two build modes:**
- `nix build .#blnvim` -- standalone binary, everything in the Nix store, zero home-manager dependency
- `homeManagerModules.default` -- integrates with home-manager, plugins symlinked into `~/.local/share/nvim/site/pack/`

## Features

- 183 plugin declarations, 55 enabled by default across 9 feature groups
- Neovim 0.11.6 built from source with CMake (not the nixpkgs derivation)
- lazy.nvim manages runtime loading; Nix manages installation and versioning
- All treesitter parsers from nixpkgs (grammars and queries version-locked together)
- 11 Nix-managed LSP servers -- no Mason downloads at runtime
- 13 formatters via conform.nvim (rustfmt, prettier, stylua, alejandra, black, gofumpt, shfmt, taplo, buf, rubocop, google-java-format, zig fmt, php-cs-fixer)
- Nord colorscheme with lualine, bufferline, snacks.nvim dashboard, noice UI
- neotest with Go, Jest, Python, Rust, and Plenary adapters
- Standalone `blnvim` binary wraps Neovim with `NVIM_APPNAME=blnvim` -- keeps `~/.config/nvim` untouched
- Shell completions for zsh, bash, and fish
- ZLS 0.15.1 pre-built binary (avoids nixpkgs sandbox build failure)

## Installation / Getting Started

```bash
# Run directly (no install needed)
nix run github:pleme-io/blackmatter-nvim

# Build the binary
nix build github:pleme-io/blackmatter-nvim
./result/bin/blnvim
```

### As a Flake Input

```nix
{
  inputs.blackmatter-nvim.url = "github:pleme-io/blackmatter-nvim";

  outputs = { self, nixpkgs, blackmatter-nvim, ... }: {
    # Option 1: Use the overlay
    nixpkgs.overlays = [ blackmatter-nvim.overlays.default ];
    # Then pkgs.blnvim is available

    # Option 2: Use the package directly
    environment.systemPackages = [
      blackmatter-nvim.packages.${system}.blnvim
    ];

    # Option 3: Home-manager module (per-plugin enable/disable control)
    home-manager.users.you = {
      imports = [ blackmatter-nvim.homeManagerModules.default ];
      blackmatter.components.nvim.enable = true;
    };
  };
}
```

## Usage

The binary is called `blnvim`. It uses its own `NVIM_APPNAME` so it will not interfere with an existing Neovim configuration.

```bash
blnvim              # Open editor
blnvim file.rs      # Open a file
blnvim +42 file.rs  # Open at line 42
```

### Plugins (55 enabled by default)

**Editing** -- Comment.nvim, leap.nvim, nvim-surround, nvim-autopairs, nvim-ts-autotag

**Completion** -- nvim-cmp with buffer/path/LSP/treesitter/cmdline sources, LuaSnip + friendly-snippets, lspkind icons

**LSP** -- nvim-lspconfig, mason.nvim, lspsaga (hover, rename, code actions, breadcrumbs, outline), lsp_signature, trouble.nvim, tiny-inline-diagnostic, vim-illuminate

**Testing** -- neotest with adapters for Go, Jest, Python (pytest), Rust, Plenary

**Search** -- Telescope with fd + ripgrep, hidden files, quickfix integration

**Treesitter** -- Full grammar set from nixpkgs, textobjects (function/class select, move, swap), ts-context-commentstring, render-markdown, autotag

**UI** -- Nord colorscheme, lualine (macro recording indicator), bufferline, gitsigns (hunk nav/staging/blame), snacks.nvim (dashboard, terminal, gitbrowse, zen, scroll, word navigation), noice, nvim-notify, indent-blankline, nvim-colorizer, which-key

**Navigation** -- oil.nvim (file explorer), todo-comments, vim-tmux-navigator

**Formatting** -- conform.nvim with rustfmt, prettier, stylua, alejandra, black, gofumpt, shfmt, taplo, buf, rubocop, google-java-format, php-cs-fixer, zig fmt

### LSP Servers

All servers are Nix-managed -- no Mason downloads needed at runtime.

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

## Configuration

### Home-Manager Module Options

```nix
blackmatter.components.nvim = {
  enable = true;                    # Enable the Neovim configuration
  package = pkgs.callPackage ...;   # Override the Neovim derivation
};

# Individual plugins can be toggled:
blackmatter.components.nvim.plugins.folke.snacks-nvim.enable = true;
blackmatter.components.nvim.plugins.lewis6991.gitsigns-nvim.enable = true;

# Feature groups can be toggled:
blackmatter.components.nvim.plugin.groups.lsp.enable = true;
blackmatter.components.nvim.plugin.groups.completion.enable = true;
blackmatter.components.nvim.plugin.groups.theming.enable = true;
```

### LSP Feature Flags

The LSP group exposes feature toggles:

```nix
blackmatter.components.nvim.plugin.groups.lsp = {
  enable = true;
  features.inlay_hints = true;
  features.diagnostics = true;
  features.code_actions = true;
  features.formatting = false;  # Use conform.nvim instead
};
```

## Development

```bash
# Enter dev shell with blnvim, nixd, lua-language-server, stylua, luacheck
nix develop

# Build standalone binary
nix build .#blnvim

# Run directly
nix run
```

### Adding a Plugin

```bash
# 1. Create declaration directory
mkdir -p module/plugins/{author}/{name}

# 2. Get rev + hash
REV=$(curl -s "https://api.github.com/repos/{author}/{name}/commits/main" | jq -r .sha)
echo "\"$REV\"" > module/plugins/{author}/{name}/rev.nix
RAW=$(nix-prefetch-url --unpack --type sha256 \
  "https://github.com/{author}/{name}/archive/$REV.tar.gz")
echo "\"$(nix hash convert --hash-algo sha256 --to sri $RAW)\"" \
  > module/plugins/{author}/{name}/hash.nix

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

## Project Structure

```
blackmatter-nvim/
  flake.nix                      # packages.blnvim, overlays.default, homeManagerModules.default
  lib/
    plugin-helper.nix            # Core: mkPlugin, mkLazySpec, buildPluginDrv, toLuaValue
  package/                       # Standalone blnvim binary
    default.nix                  # Derivation: enabledSet, runtimeDeps, makeWrapper
    init.lua                     # Bootstrap init.lua (templated with @configDir@, @packDir@)
    completions/                 # Shell completions (zsh, bash, fish)
  pkgs/
    neovim/                      # Neovim 0.11.6 built from source
      default.nix                # CMake build with vendored deps
      deps/                      # libvterm, lpeg, bundled dependencies
  module/                        # Home-manager module
    default.nix                  # Entry point: options, treesitter, lazy-plugins.lua generation
    common/                      # Shared constants (paths, URLs)
    conf/init.lua                # Runtime init.lua (lazy.nvim bootstrap + group loading)
    plugins/                     # 183 plugin declarations
      declarations.nix           # Central import list (single source of truth)
      registry.nix               # Processes declarations into Nix modules
      {author}/{name}/           # Per-plugin: default.nix, rev.nix, hash.nix, config/
    groups/                      # 9 feature groups
      common/                    # Core utilities (oil.nvim, which-key, plenary, etc.)
      completion/                # nvim-cmp ecosystem
      formatting/                # conform.nvim + 13 formatters
      keybindings/               # General editor bindings
      lsp/                       # LSP servers, diagnostics, neotest, lspsaga
      telescope/                 # Fuzzy finder
      theming/                   # UI: colorscheme, statusline, bufferline, snacks
      tmux/                      # Tmux navigation integration
      treesitter/                # Syntax, textobjects, context
```

## Platforms

| System | Status |
|--------|--------|
| aarch64-darwin | Primary |
| x86_64-darwin | Supported |
| aarch64-linux | Supported |
| x86_64-linux | Supported |

## Related Projects

| Repo | Description |
|------|-------------|
| [blackmatter](https://github.com/pleme-io/blackmatter) | Home-manager/nix-darwin module aggregator that consumes this repo |
| [blackmatter-shell](https://github.com/pleme-io/blackmatter-shell) | Zsh distribution (companion shell environment) |
| [blackmatter-desktop](https://github.com/pleme-io/blackmatter-desktop) | Desktop environment modules (Linux compositors, terminals, browsers) |
| [substrate](https://github.com/pleme-io/substrate) | Reusable Nix build patterns |

## License

MIT
