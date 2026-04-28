{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.lsp;

  # Platform detection for LSP tooling
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # C/C++ compiler for LSP servers (clangd, ccls)
  cCompiler = if isDarwin then pkgs.clang else pkgs.gcc;

  # Wrap ruby-lsp so ONLY Nix-store gems resolve for LOOKUP, while a writable
  # XDG cache dir absorbs any install ruby-lsp performs at startup (it
  # Gem.install's a bundler version matching the project's Gemfile.lock).
  #
  # Why not point GEM_HOME at the read-only Nix store? ruby-lsp's
  # setup_bundler.rb calls Gem.install('bundler', version) when the installed
  # bundler doesn't match Gemfile.lock — crashes with EACCES on /nix/store.
  #
  # Why not leave Gem.user_dir (~/.gem) alone? A stray user-installed gem
  # (e.g. `gem install date`) linked against a previous ruby store path
  # shadows the Nix stdlib and crashes with "Library not loaded:
  # libruby-3.4.8.dylib" once the old ruby derivation is GC'd.
  #
  # Solution: the init.rb reads GEM_HOME/GEM_PATH from env (set in the
  # wrapper at runtime) and calls Gem.use_paths, which drops Gem.user_dir
  # entirely. The wrapper creates an XDG cache dir and exports it as
  # GEM_HOME so ruby-lsp can install bundler there without touching /nix/store.
  rubyLspWrapped = let
    rubyLsp = pkgs.rubyPackages_3_4.ruby-lsp;
    allGems = [rubyLsp] ++ (rubyLsp.propagatedBuildInputs or []) ++ [pkgs.ruby_3_4];
    gemPath = lib.concatMapStringsSep ":" (d: "${d}/lib/ruby/gems/3.4.0") allGems;
    # Nix's `''…''` heredoc treats `''` as the close delimiter, so the Ruby
    # empty-string literal must be escaped as `'''` for Nix to keep parsing.
    # The rendered .rb file gets the correct two-quote literal.
    rubyLspGemInit = pkgs.writeText "ruby-lsp-gem-paths.rb" ''
      require 'rubygems'
      gem_home = ENV['GEM_HOME']
      gem_path = (ENV['GEM_PATH'] || ''').split(':').reject(&:empty?)
      Gem.use_paths(gem_home, gem_path) if gem_home
    '';
  in
    pkgs.writeShellScriptBin "ruby-lsp" ''
      : "''${XDG_CACHE_HOME:=$HOME/.cache}"
      gem_home="$XDG_CACHE_HOME/ruby-lsp/gems/3.4.0"
      mkdir -p "$gem_home"
      export GEM_HOME="$gem_home"
      export GEM_PATH="$gem_home:${gemPath}"
      export RUBYOPT="-r${rubyLspGemInit} ''${RUBYOPT:-}"
      exec ${rubyLsp}/bin/ruby-lsp "$@"
    '';
in {
  options.blackmatter.components.nvim.plugin.groups.lsp = {
    enable = mkEnableOption "LSP support";

    # Feature toggles
    features = {
      inlayHints = {
        enable = mkEnableOption "inlay hints" // {default = true;};
      };

      diagnostics = {
        enable = mkEnableOption "diagnostics" // {default = true;};
      };

      codeActions = {
        enable = mkEnableOption "code actions" // {default = true;};
      };

      formatting = {
        enable = mkEnableOption "LSP formatting" // {default = false;};
        description = "Enable LSP-based formatting (may conflict with conform.nvim)";
      };
    };

    # Required plugins (auto-enabled when group is enabled)
    requiredPlugins = mkOption {
      type = types.listOf types.str;
      default = [
        "neovim.nvim-lspconfig"
        "williamboman.mason.nvim"
        "williamboman.mason-lspconfig.nvim"
        "hrsh7th.nvim-cmp"
        "hrsh7th.cmp-nvim-lsp"
      ];
      readOnly = true;
      description = "Plugins required for LSP functionality";
    };

    # Optional enhancement plugins
    optionalPlugins = {
      helm = mkEnableOption "vim-helm for Kubernetes manifests" // {default = true;};
    };
  };

  # No imports needed - plugins loaded via registry

  config = mkMerge [
    (mkIf cfg.enable {
      # Install development tooling and language servers
      home.packages = with pkgs;
      with dotnetCorePackages;
      with rubyPackages_3_4;
      with luajitPackages;
      with php84Packages;
      with nodePackages; [
        go
        cCompiler # Platform-specific: clang on macOS, gcc on Linux
        zulu
        nixd
        bash
        opam
        unzip
        cmake
        ninja
        nodejs
        nodePackages.typescript-language-server
        gopls
        clang-tools
        codeium
        rubyLspWrapped
        tree-sitter
        luarocks-nix
        # swift-format # Disabled: swift build failures
        rust-analyzer
        bash-language-server
        shellcheck
        nushell
        powershell
        # powershell-editor-services # Not available in nixpkgs 24.11
        basedpyright
        ruff
        # sourcekit-lsp # Disabled: swift build failures
        markdown-oxide
        zls
        texlivePackages.latexindent
        (python312.withPackages (ps: with ps; [pip]))
      ];

      # One directory symlink instead of 8 per-file home.file entries.
      # Combines the static .lua files with a generated features.lua whose
      # body is derived from cfg. See lib/group-files.nix.
      xdg.configFile."nvim/lua/groups/lsp".source =
        (import ../../../lib/group-files.nix { inherit lib pkgs; }) {
          name = "lsp";
          src = ./.;
          generated = {
            "features.lua" = ''
              -- Auto-generated by Nix LSP group configuration
              -- DO NOT EDIT MANUALLY
              return {
                inlay_hints = ${boolToString cfg.features.inlayHints.enable},
                diagnostics = ${boolToString cfg.features.diagnostics.enable},
                code_actions = ${boolToString cfg.features.codeActions.enable},
                formatting = ${boolToString cfg.features.formatting.enable},
              }
            '';
          };
        };

      # Enable required plugins
      blackmatter.components.nvim.plugins = {
        neovim.nvim-lspconfig.enable = true;
        williamboman."mason.nvim".enable = true;
        williamboman."mason-lspconfig.nvim".enable = true;
        hrsh7th.nvim-cmp.enable = true;
        hrsh7th.cmp-nvim-lsp.enable = true;
        glepnir."lspsaga.nvim".enable = true;
        ray-x."lsp_signature.nvim".enable = true;
        folke."trouble.nvim".enable = true;
        rachartier."tiny-inline-diagnostic.nvim".enable = true;
        RRethy.vim-illuminate.enable = true;
        # neotest — test runner framework + adapters
        nvim-neotest.neotest.enable = true;
        nvim-neotest.nvim-nio.enable = true;
        nvim-neotest.neotest-go.enable = true;
        nvim-neotest.neotest-jest.enable = true;
        nvim-neotest.neotest-plenary.enable = true;
        nvim-neotest.neotest-python.enable = true;
        rouge8.neotest-rust.enable = true;
      };
    })

    # Optional plugins
    (mkIf (cfg.enable && cfg.optionalPlugins.helm) {
      blackmatter.components.nvim.plugins.towolf.vim-helm.enable = true;
    })
  ];
}
