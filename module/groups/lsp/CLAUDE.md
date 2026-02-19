# LSP Group

## Adding or Managing LSP Servers

Two files, two steps:

1. **`default.nix`** — add the Nix package to `home.packages`
2. **`nix_managed_servers.lua`** — add `server_name = {}` (or with config)

That's it. Rebuild.

## Architecture

`nix_managed_servers.lua` is the single source of truth. It's a table mapping lspconfig server names to their configs. `init.lua` iterates it, merges cmp capabilities, and calls `lspconfig[server].setup()`.

There is no exclude list or blocklist. Mason is UI-only — it doesn't auto-install anything.

## LSP UI Stack

The LSP group configures a layered UI via these modules (called from `init.lua`):

- **`diagnostics.lua`** — Nerd Font signs, virtual_text, float config, lsp_signature setup
- **`lspsaga.lua`** — Enhanced UI: hover, code actions, rename, peek definitions, breadcrumbs (winbar), outline sidebar, finder, lightbulb, call hierarchy
- **`keybindings.lua`** — All LSP keybindings routed through lspsaga
- **`illuminate.lua`** — Word/reference highlighting under cursor (RRethy/vim-illuminate)

### Key Bindings

| Key | Action |
|-----|--------|
| `K` | Hover doc |
| `gd` / `gD` | Go to / peek definition |
| `gt` / `gT` | Go to / peek type definition |
| `gr` | Find references + implementations |
| `<leader>ca` | Code action |
| `<leader>rn` / `<leader>rN` | Rename / rename project-wide |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>dl` | Line diagnostics |
| `<leader>db` | Buffer diagnostics |
| `<leader>o` | Toggle symbol outline |
| `<leader>ci` / `<leader>co` | Incoming / outgoing calls |
| `<C-k>` | Toggle signature help |

### Plugins (enabled in default.nix)

- `neovim/nvim-lspconfig` — core LSP client
- `williamboman/mason.nvim` + `mason-lspconfig.nvim` — LSP installer UI
- `glepnir/lspsaga.nvim` — enhanced LSP UI
- `ray-x/lsp_signature.nvim` — floating signature help
- `folke/trouble.nvim` — diagnostics list with keybindings
- `rachartier/tiny-inline-diagnostic.nvim` — inline error display
- `RRethy/vim-illuminate` — word/reference highlighting
- `towolf/vim-helm` — Helm template filetype (optional)

### Neotest (also enabled in this group)

- `nvim-neotest/neotest` — test runner framework
- `nvim-neotest/nvim-nio` — async IO (neotest dependency)
- `nvim-neotest/neotest-go` — Go adapter
- `nvim-neotest/neotest-jest` — Jest adapter
- `nvim-neotest/neotest-plenary` — Plenary adapter
- `nvim-neotest/neotest-python` — Python adapter (pytest)
- `rouge8/neotest-rust` — Rust adapter

Neotest keybindings: `<leader>nn` run nearest, `<leader>nf` run file, `<leader>ns` run suite, `<leader>no` output panel, `<leader>np` summary, `]n`/`[n` next/prev failed.

## Example: Adding a Server with Custom Config

```lua
-- nix_managed_servers.lua
return {
  my_server = {
    settings = {
      my_server = { someOption = true },
    },
  },
  -- ...
}
```

## Example: Adding a Server with Defaults

```lua
return {
  my_server = {},
  -- ...
}
```

## Files

| File | Purpose |
|------|---------|
| `default.nix` | Nix packages, plugin enablement, home.file references |
| `nix_managed_servers.lua` | Server names + configs (single source of truth) |
| `init.lua` | Setup loop: Mason, capabilities, lspconfig, then UI modules |
| `diagnostics.lua` | Diagnostic signs, display config, lsp_signature |
| `lspsaga.lua` | lspsaga configuration (hover, actions, breadcrumbs, etc.) |
| `keybindings.lua` | All LSP keybindings via lspsaga |
| `illuminate.lua` | vim-illuminate configuration |
| `filetypes.lua` | Custom filetype associations |
| `features.lua` | Auto-generated feature flags (do not edit) |
