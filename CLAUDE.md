# blackmatter-nvim — Claude Orientation

One-sentence purpose: curated neovim distribution (`blnvim`) — 55 plugins via
lazy.nvim, Nix-managed treesitter parsers, runnable standalone or as an HM module.

## Classification

- **Archetype:** `blackmatter-component-custom-package-hm`
- **Flake shape:** **custom** (does NOT go through mkBlackmatterFlake)
- **Reason:** Package + HM + overlay using `callPackage` pattern so system
  overlays propagate into plugin deps. Stable and idiomatic.
- **Option namespace:** `blackmatter.components.nvim`

## Where to look

| Intent | File |
|--------|------|
| Package derivation | `package/` |
| HM module | `module/default.nix` |
| Plugin registry | `module/plugins/` |
| LSP / formatter config | `module/conf/` |

## Constraint

**Never pin nvim-treesitter to GitHub HEAD** — parser / query version mismatch
will silently break syntax highlighting. Use nixpkgs treesitter parsers only.
