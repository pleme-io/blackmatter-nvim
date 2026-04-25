{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim;

  # Import plugin helper for lazy loading support
  pluginHelper = import ../lib/plugin-helper.nix {inherit lib pkgs;};

  # Single source of truth for plugin declarations
  # Shared with registry.nix to avoid duplication
  pluginDecls = import ./plugins/declarations.nix;

in {
  imports = [
    ./plugins/registry.nix
    ./groups
  ];
  options.blackmatter.components.nvim = {
    enable = mkEnableOption "enable neovim configuration";
    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ../pkgs/neovim { msgpack-c = pkgs.msgpack-c; };
      description = mdDoc "neovim configuration management";
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      # Python environment with latest pynvim for neovim provider
      # This fixes the "pynvim version: 0.5.2 (outdated)" warning
      # Note: We only set the env var, don't add python to packages to avoid conflicts
      home.sessionVariables = {
        NVIM_PYTHON3_HOST_PROG = "${pkgs.python3.withPackages (ps: [ ps.pynvim ])}/bin/python3";
      };

      home.packages = [
        cfg.package
        # Add all treesitter grammars from nixpkgs
        pkgs.tree-sitter
        # LuaSnip jsregexp dependency for snippet transformations
        pkgs.luajitPackages.jsregexp
        # Tools for snacks.nvim image/PDF support
        pkgs.ghostscript  # gs - for PDF rendering
        pkgs.nodePackages.mermaid-cli  # mmdc - for mermaid diagrams
      ];
      xdg.configFile."nvim/init.lua".source = ./conf/init.lua;
      blackmatter.components.nvim.plugin.groups.enable = true;

      # Bidirectional cleanup so HM linkGeneration always succeeds when the
      # site/parser and site/queries entries toggle between modes:
      #
      #   recursive = true  → real directory containing per-file symlinks
      #   recursive = false → single directory symlink to a /nix/store tree
      #
      # HM can't replace a symlink with a mkdir, nor a non-empty dir with a
      # symlink. This hook normalises by:
      #   - removing the path entirely if it's already a symlink (recursive=
      #     false → toggle), so HM's linkNewGen can recreate it
      #   - if it's a real dir (recursive=true → false migration), pruning
      #     every symlink inside and then rmdir'ing all empty subdirs. Real
      #     user files (if any) are preserved; the linkGeneration step will
      #     fail loudly if it hits one, leaving a clear remediation path.
      home.activation.cleanNvimSiteLinks = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
        for dir in "$HOME/.local/share/nvim/site/queries" "$HOME/.local/share/nvim/site/parser"; do
          if [ -L "$dir" ]; then
            rm "$dir"
          elif [ -d "$dir" ]; then
            find "$dir" -type l -delete 2>/dev/null || true
            find "$dir" -depth -type d -empty -delete 2>/dev/null || true
          fi
        done
      '';

      # TREESITTER VERSION COORDINATION
      # The nvim-treesitter plugin provides the Lua runtime (configs, query, etc.)
      # from a custom GitHub pin. Its bundled queries are stripped via postPatch.
      # Parsers (.so) and queries (.scm) below both come from the same nixpkgs
      # snapshot, guaranteeing they match. Update nixpkgs to advance them together.
      #
      # `recursive = false` produces ONE symlink per entry (parser, queries)
      # instead of fanning out to ~1500 per-file links. Both trees are
      # read-only at nvim runtime (mason and lazy.nvim write to other paths),
      # so a single dir symlink is safe and cuts HM activation work by 96%.
      home.file.".local/share/nvim/site/parser" = {
        source = "${pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        }}/parser";
        recursive = false;
      };

      # Queries from nixpkgs nvim-treesitter (matches parsers above)
      home.file.".local/share/nvim/site/queries" = {
        source = "${pkgs.vimPlugins.nvim-treesitter}/queries";
        recursive = false;
      };

      # Generate lazy-plugins.lua for lazy.nvim integration
      # Only include plugins that are actually enabled
      xdg.configFile."nvim/lua/lazy-plugins.lua".text = let
        # Filter to only enabled plugins
        enabledPluginDecls = lib.filter (decl:
          config.blackmatter.components.nvim.plugins.${decl.author}.${decl.name}.enable or false
        ) pluginDecls;
      in pluginHelper.mkLazyPluginsLua enabledPluginDecls;
    })
  ];
}
