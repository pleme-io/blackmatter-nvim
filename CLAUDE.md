# blackmatter-nvim — Claude Orientation

> **★★★ CSE / Knowable Construction.** This repo operates under **Constructive Substrate Engineering** — canonical specification at [`pleme-io/theory/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md`](https://github.com/pleme-io/theory/blob/main/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md). The Compounding Directive (operational rules: solve once, load-bearing fixes only, idiom-first, models stay current, direction beats velocity) is in the org-level pleme-io/CLAUDE.md ★★★ section. Read both before non-trivial changes.


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
