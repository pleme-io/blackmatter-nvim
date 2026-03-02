# Standalone blnvim package — full blackmatter neovim without home-manager
{ pkgs
, neovim ? pkgs.callPackage ../pkgs/neovim { msgpack-c = pkgs.msgpack-c; }
, lib ? pkgs.lib
}:

let
  pluginHelper = import ../lib/plugin-helper.nix { inherit lib pkgs; };

  # Platform detection
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  system = pkgs.stdenv.hostPlatform.system;

  # ZLS pre-built binary — nixpkgs zls fails in nix sandbox
  # ("ln: failed to create symbolic link '/p': Read-only file system")
  zlsBinary = let
    version = "0.15.1";
    srcs = {
      "aarch64-darwin" = {
        url = "https://github.com/zigtools/zls/releases/download/${version}/zls-aarch64-macos.tar.xz";
        hash = "sha256-prPxsQ138387nZYgk/AwM0sIP0jrJgeks8y3LeKVgTM=";
      };
      "x86_64-darwin" = {
        url = "https://github.com/zigtools/zls/releases/download/${version}/zls-x86_64-macos.tar.xz";
        hash = "sha256-t2qnJL4/aXmfCAY/hOk7i1kl9r9gB/JRovvqT5/CRN0=";
      };
      "aarch64-linux" = {
        url = "https://github.com/zigtools/zls/releases/download/${version}/zls-aarch64-linux.tar.xz";
        hash = "sha256-otqoYKDgzRQQSR/5cDxqrKlt79gzuIr2qYEdb/BPwTs=";
      };
      "x86_64-linux" = {
        url = "https://github.com/zigtools/zls/releases/download/${version}/zls-x86_64-linux.tar.xz";
        hash = "sha256-O7OPUiyyMhPowHWsaxcCc/5JtCdLjBKwNMxJZAdAAGc=";
      };
    };
    src = pkgs.fetchurl srcs.${system};
  in pkgs.stdenv.mkDerivation {
    pname = "zls";
    inherit version;
    inherit src;
    nativeBuildInputs = [ pkgs.xz ];
    sourceRoot = ".";
    unpackPhase = ''
      tar xf $src
    '';
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      install -Dm755 zls $out/bin/zls
    '';
    meta = {
      description = "Zig Language Server (pre-built binary)";
      homepage = "https://github.com/zigtools/zls";
      license = lib.licenses.mit;
    };
  };

  # All plugin declarations (single source of truth)
  allPluginDecls = import ../module/plugins/declarations.nix;

  # Plugins enabled by default (mirrors group configuration)
  enabledSet = {
    # common
    "nvim-lua/plenary.nvim" = true;
    "nvim-tree/nvim-web-devicons" = true;
    "folke/lazy.nvim" = true;
    "folke/which-key.nvim" = true;
    "folke/todo-comments.nvim" = true;
    "numToStr/Comment.nvim" = true;
    "ggandor/leap.nvim" = true;
    "kylechui/nvim-surround" = true;
    "stevearc/oil.nvim" = true;
    "pleme-io/compass.nvim" = true;
    # completion
    "L3MON4D3/LuaSnip" = true;
    "hrsh7th/cmp-path" = true;
    "hrsh7th/nvim-cmp" = true;
    "hrsh7th/cmp-buffer" = true;
    "sar/cmp-lsp.nvim" = true;
    "hrsh7th/cmp-cmdline" = true;
    "hrsh7th/cmp-nvim-lsp" = true;
    "ray-x/cmp-treesitter" = true;
    "onsails/lspkind.nvim" = true;
    # "Exafunction/windsurf.nvim" — disabled: requires auth
    "rafamadriz/friendly-snippets" = true;
    "windwp/nvim-autopairs" = true;
    # formatting
    "stevearc/conform.nvim" = true;
    # lsp
    "neovim/nvim-lspconfig" = true;
    "williamboman/mason.nvim" = true;
    "williamboman/mason-lspconfig.nvim" = true;
    "glepnir/lspsaga.nvim" = true;
    "ray-x/lsp_signature.nvim" = true;
    "folke/trouble.nvim" = true;
    "rachartier/tiny-inline-diagnostic.nvim" = true;
    "RRethy/vim-illuminate" = true;
    "towolf/vim-helm" = true;
    # neotest
    "nvim-neotest/neotest" = true;
    "nvim-neotest/nvim-nio" = true;
    "nvim-neotest/neotest-go" = true;
    "nvim-neotest/neotest-jest" = true;
    "nvim-neotest/neotest-plenary" = true;
    "nvim-neotest/neotest-python" = true;
    "rouge8/neotest-rust" = true;
    # telescope
    "nvim-telescope/telescope.nvim" = true;
    # theming
    "NvChad/nvim-colorizer.lua" = true;
    "nvim-lualine/lualine.nvim" = true;
    "akinsho/bufferline.nvim" = true;
    "shaunsingh/nord.nvim" = true;
    "folke/noice.nvim" = true;
    "folke/snacks.nvim" = true;
    "MunifTanjim/nui.nvim" = true;
    "rcarriga/nvim-notify" = true;
    "lewis6991/gitsigns.nvim" = true;
    "lukas-reineke/indent-blankline.nvim" = true;
    # tmux
    "christoomey/vim-tmux-navigator" = true;
    # treesitter
    "nvim-treesitter/nvim-treesitter" = true;
    "nvim-treesitter/nvim-treesitter-textobjects" = true;
    "nvim-treesitter/nvim-treesitter-context" = true;
    "JoosepAlviste/nvim-ts-context-commentstring" = true;
    "MeanderingProgrammer/render-markdown.nvim" = true;
    "windwp/nvim-ts-autotag" = true;
  };

  isEnabled = decl: enabledSet."${decl.author}/${decl.name}" or false;
  enabledDecls = builtins.filter isEnabled allPluginDecls;

  # Build each enabled plugin
  builtPlugins = map (decl: {
    inherit decl;
    drv = pluginHelper.buildPluginDrv decl;
  }) enabledDecls;

  # Treesitter parsers and queries from nixpkgs (same approach as module/default.nix)
  treesitterParsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };

  # Pack directory: symlink farm of all plugins + treesitter
  packDir = pkgs.runCommand "blnvim-pack" {} ''
    mkdir -p $out

    # Symlink each plugin into pack/{author}/start/{name}
    ${lib.concatMapStringsSep "\n" ({ decl, drv }:
      let
        author = decl.author;
        name = decl.name;
      in ''
        mkdir -p $out/pack/${author}/start
        ln -s ${drv} $out/pack/${author}/start/${name}
      ''
    ) builtPlugins}

    # Treesitter parsers
    ln -s ${treesitterParsers}/parser $out/parser

    # Treesitter queries from nixpkgs nvim-treesitter
    ln -s ${pkgs.vimPlugins.nvim-treesitter}/queries $out/queries
  '';

  # Generate lazy-plugins.lua with Nix store paths
  lazyPluginsLua = pluginHelper.mkLazyPluginsLuaWithDirs builtPlugins;

  # jsregexp path for LuaSnip
  jsregexp = pkgs.luajitPackages.jsregexp;

  # Python environment with pynvim
  python3WithPynvim = pkgs.python3.withPackages (ps: [ ps.pynvim ]);

  # LSP feature flags (defaults matching module/groups/lsp/default.nix)
  featuresLua = ''
    -- Auto-generated by Nix (standalone package)
    -- DO NOT EDIT MANUALLY
    return {
      inlay_hints = true,
      diagnostics = true,
      code_actions = true,
      formatting = false,
    }
  '';

  # Assemble the config directory
  configDir = pkgs.runCommand "blnvim-config" {} ''
    mkdir -p $out/lua/groups $out/lua/plugins

    # ── Group configs ──
    # common
    mkdir -p $out/lua/groups/common
    for f in ${../module/groups/common}/*.lua; do
      [ -f "$f" ] && cp "$f" $out/lua/groups/common/
    done

    # completion
    mkdir -p $out/lua/groups/completion
    for f in ${../module/groups/completion}/*.lua; do
      [ -f "$f" ] && cp "$f" $out/lua/groups/completion/
    done

    # keybindings
    mkdir -p $out/lua/groups/keybindings
    cp ${../module/groups/keybindings/init.lua} $out/lua/groups/keybindings/init.lua

    # lsp (static files — features.lua generated separately)
    mkdir -p $out/lua/groups/lsp
    cp ${../module/groups/lsp/init.lua} $out/lua/groups/lsp/init.lua
    cp ${../module/groups/lsp/filetypes.lua} $out/lua/groups/lsp/filetypes.lua
    cp ${../module/groups/lsp/lspsaga.lua} $out/lua/groups/lsp/lspsaga.lua
    cp ${../module/groups/lsp/diagnostics.lua} $out/lua/groups/lsp/diagnostics.lua
    cp ${../module/groups/lsp/keybindings.lua} $out/lua/groups/lsp/keybindings.lua
    cp ${../module/groups/lsp/illuminate.lua} $out/lua/groups/lsp/illuminate.lua
    cp ${../module/groups/lsp/nix_managed_servers.lua} $out/lua/groups/lsp/nix_managed_servers.lua

    # lsp features (generated)
    cat > $out/lua/groups/lsp/features.lua << 'FEATURES_EOF'
    ${featuresLua}
    FEATURES_EOF

    # telescope
    mkdir -p $out/lua/groups/telescope
    cp ${../module/groups/telescope/init.lua} $out/lua/groups/telescope/init.lua

    # theming
    mkdir -p $out/lua/groups/theming
    for f in ${../module/groups/theming}/*.lua; do
      [ -f "$f" ] && cp "$f" $out/lua/groups/theming/
    done

    # treesitter
    mkdir -p $out/lua/groups/treesitter
    for f in ${../module/groups/treesitter}/*.lua; do
      [ -f "$f" ] && cp "$f" $out/lua/groups/treesitter/
    done

    # ── Plugin configs (from plugins with configDir) ──
    ${lib.concatMapStringsSep "\n" ({ decl, drv }:
      let
        configSrc = decl.configDir or null;
        nameWithDashes = lib.replaceStrings ["."] ["-"] decl.name;
        destPath = "$out/lua/plugins/${decl.author}/${nameWithDashes}";
      in
        if configSrc != null then ''
          mkdir -p ${destPath}
          cp -r ${configSrc}/* ${destPath}/
        '' else ""
    ) builtPlugins}

    # ── Generated files ──

    # luasnip jsregexp path (lua init at share/lua/5.1/jsregexp.lua, .so at lib/lua/5.1/jsregexp/core.so)
    cat > $out/lua/luasnip-jsregexp-path.lua << JSREGEXP_EOF
    -- Auto-generated: adds jsregexp to Lua path and cpath for LuaSnip transformations
    package.path = package.path .. ";${jsregexp}/share/lua/5.1/?.lua;${jsregexp}/share/lua/5.1/?/init.lua"
    package.cpath = package.cpath .. ";${jsregexp}/lib/lua/5.1/?.so;${jsregexp}/lib/lua/5.1/?/core.so"
    JSREGEXP_EOF

    # lazy-plugins.lua
    cat > $out/lua/lazy-plugins.lua << 'LAZY_EOF'
    ${lazyPluginsLua}
    LAZY_EOF

    # Wrapper init.lua (substitute placeholders)
    substitute ${./init.lua} $out/init.lua \
      --subst-var-by configDir $out \
      --subst-var-by packDir ${packDir}
  '';

  # C/C++ compiler for LSP (clangd, ccls)
  cCompiler = if isDarwin then pkgs.clang else pkgs.gcc;

  # Wrap ruby-lsp to export GEM_PATH (same as module/groups/lsp/default.nix)
  rubyLspWrapped = let
    rubyLsp = pkgs.rubyPackages_3_4.ruby-lsp;
    allGems = [rubyLsp] ++ (rubyLsp.propagatedBuildInputs or []) ++ [pkgs.ruby_3_4];
    gemPath = lib.concatMapStringsSep ":" (d: "${d}/lib/ruby/gems/3.4.0") allGems;
  in
    pkgs.writeShellScriptBin "ruby-lsp" ''
      export GEM_PATH="${gemPath}''${GEM_PATH:+:$GEM_PATH}"
      exec ${rubyLsp}/bin/ruby-lsp "$@"
    '';

  # Runtime dependencies — mirrors module/default.nix + groups/lsp + groups/formatting
  runtimeDeps = with pkgs; [
    # ── Core tools ──
    tree-sitter
    ripgrep
    fd
    git
    curl
    unzip

    # ── Formatters (groups/formatting/default.nix) ──
    rustfmt                     # Rust
    taplo                       # TOML
    shfmt                       # Shell (sh, zsh)
    php83Packages.php-cs-fixer  # PHP
    alejandra                   # Nix
    stylua                      # Lua
    nodePackages.prettier       # JS/TS/JSON/YAML/HTML/Markdown
    black                       # Python
    gofumpt                     # Go
    buf                         # Protocol Buffers
    rubocop                     # Ruby
    google-java-format          # Java
    zig                         # Zig (includes zig fmt)

    # ── LSP servers & tools (groups/lsp/default.nix) ──
    go
    cCompiler                   # clang on macOS, gcc on Linux
    zulu                        # Java JDK
    nixd                        # Nix
    bash                        # Bash
    opam                        # OCaml
    cmake
    ninja
    nodejs                      # Node.js (ts_ls)
    nodePackages.typescript-language-server  # TypeScript/JS LSP
    gopls                       # Go LSP
    clang-tools                 # clangd C/C++ LSP
    rubyLspWrapped              # Ruby
    luarocks-nix
    rust-analyzer               # Rust
    bash-language-server        # Bash
    shellcheck                  # Shell linting
    nushell                     # Nushell LSP
    powershell                  # PowerShell
    basedpyright                # Python
    ruff                        # Python linting
    markdown-oxide              # Markdown
    zlsBinary                   # Zig (pre-built binary)
    lua-language-server         # Lua
    texlivePackages.latexindent # LaTeX

    # ── LuaSnip dependency ──
    luajitPackages.jsregexp

    # ── Neovim providers & health check deps ──
    python3WithPynvim           # Python provider (pynvim)
    (python312.withPackages (ps: with ps; [ pip ]))
    nodePackages.neovim         # Node.js provider

    # ── Snacks.nvim tools (module/default.nix) ──
    ghostscript                 # PDF rendering
    nodePackages.mermaid-cli    # Mermaid diagrams
  ];

in
pkgs.stdenv.mkDerivation {
  pname = "blnvim";
  version = "0.1.0";

  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${neovim}/bin/nvim $out/bin/blnvim \
      --set NVIM_APPNAME "blnvim" \
      --add-flags "-u ${configDir}/init.lua" \
      --set NVIM_PYTHON3_HOST_PROG "${python3WithPynvim}/bin/python3" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}

    # Shell completions
    install -Dm644 ${./completions/blnvim.zsh} $out/share/zsh/site-functions/_blnvim
    install -Dm644 ${./completions/blnvim.bash} $out/share/bash-completion/completions/blnvim
    install -Dm644 ${./completions/blnvim.fish} $out/share/fish/vendor_completions.d/blnvim.fish
  '';

  meta = {
    description = "Blackmatter Neovim - standalone binary with 55 curated plugins";
    homepage = "https://github.com/pleme-io/blackmatter-nvim";
    license = lib.licenses.mit;
    mainProgram = "blnvim";
  };
}
