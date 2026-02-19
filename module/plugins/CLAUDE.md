# Neovim Plugin System

## Plugin Structure

Each plugin lives in `plugins/{author}/{plugin-name}/` with these files:

```
plugins/
  {author}/
    {plugin-name}/
      default.nix   # Plugin declaration (author, name, ref, rev, hash)
      rev.nix        # Git commit SHA — just a quoted string
      hash.nix       # SRI content hash — just a quoted string
      config/        # Optional: Lua configuration directory
        init.lua
```

### File Formats

**`default.nix`** — plugin metadata (minimal, script-friendly):
```nix
{
  author = "glepnir";
  name = "lspsaga.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
}
```

**`rev.nix`** — just the commit hash:
```nix
"d027f8b9c7c55e26cf4030c8657a2fc8222ed762"
```

**`hash.nix`** — just the SRI hash:
```nix
"sha256-T0z14oXBPSSB501IV8QtNQ8AdKy5HmzORx9EyzXZlx4="
```

### Optional Fields in default.nix

| Field | Type | Purpose |
|-------|------|---------|
| `configDir` | path | Lua config directory (e.g., `./config`) |
| `packages` | fn | `pkgs -> [list]` of system packages |
| `lazy` | attrset | Lazy loading spec (`enable`, `event`, `cmd`, `ft`, `keys`) |
| `priority` | int | Load priority (e.g., 1000 for colorschemes) |
| `postPatch` | string | Post-patch script for fixing upstream issues |
| `extraConfig` | attrset | Extra home-manager config |
| `extraFiles` | attrset | Additional home.file entries |

## Adding a New Plugin

1. Create `plugins/{author}/{plugin-name}/`
2. Create `default.nix` with author, name, ref
3. Create `rev.nix` with the commit SHA
4. Compute hash: `nix-prefetch-url --unpack --type sha256 "https://github.com/{author}/{name}/archive/{rev}.tar.gz"`
5. Convert: `nix hash convert --hash-algo sha256 --to sri {raw_hash}`
6. Create `hash.nix` with the SRI hash
7. Add to `declarations.nix`: `(import ./{author}/{plugin-name}/default.nix)`
8. Enable in a group's `default.nix`: `blackmatter.components.nvim.plugins.{author}."{plugin-name}".enable = true;`
9. For standalone package: also add to `package/default.nix` `enabledSet`

## Updating a Plugin

Only touch `rev.nix` and `hash.nix` — no need to edit `default.nix`:

```bash
# Get latest commit
NEW_REV=$(curl -s "https://api.github.com/repos/{author}/{name}/commits/{ref}" | jq -r .sha)
echo "\"$NEW_REV\"" > rev.nix

# Compute new hash
RAW=$(nix-prefetch-url --unpack --type sha256 "https://github.com/{author}/{name}/archive/$NEW_REV.tar.gz")
SRI=$(nix hash convert --hash-algo sha256 --to sri "$RAW")
echo "\"$SRI\"" > hash.nix
```

## How Fetching Works

`lib/plugin-helper.nix` handles fetching:

- **With hash** (all plugins): `pkgs.fetchFromGitHub` — fast tarball download, no git clone
- **Without hash** (fallback): `builtins.fetchGit` — slower git fetch, avoid this

## Two Build Modes

1. **Home-manager module** (`module/`) — used via `blackmatter.components.nvim.enable = true`. Plugins installed to `~/.local/share/nvim/site/pack/`. Groups enable plugins via `blackmatter.components.nvim.plugins.{author}."{name}".enable = true`.

2. **Standalone package** (`package/default.nix`) — builds `blnvim` binary. Has its own `enabledSet` mapping that must be kept in sync with group enables. All plugins bundled in the Nix store.

## Key Files

| File | Purpose |
|------|---------|
| `declarations.nix` | Lists all 181 plugin imports (add new plugins here) |
| `registry.nix` | Processes declarations via plugin-helper, generates Nix modules |
| `lib/plugin-helper.nix` | Core logic: mkPlugin, mkLazySpec, buildPluginDrv, fetching |
| `package/default.nix` | Standalone blnvim package with its own enabledSet |
