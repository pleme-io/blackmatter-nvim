{
  description = "Blackmatter Neovim - curated neovim distribution with 55 plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, devenv }: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"
    ];
  in {
    homeManagerModules.default = import ./module;

    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = self.packages.${system}.blnvim;
      blnvim = pkgs.callPackage ./package { };
    });

    # Build blnvim from the consumer's pkgs (final) so system overlays
    # (e.g. sandbox test fixes) propagate into blnvim's dependencies.
    overlays.default = final: prev: {
      blnvim = final.callPackage ./package { };
    };

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [
          self.packages.${system}.blnvim
          pkgs.nixd
          pkgs.lua-language-server
          pkgs.stylua
          pkgs.luajitPackages.luacheck
          pkgs.jq
          pkgs.curl
          pkgs.nix-prefetch-scripts
        ];
        shellHook = ''
          echo "blackmatter-nvim dev shell"
          echo "  blnvim              — run the standalone editor"
          echo "  nixd                — Nix LSP"
          echo "  lua-language-server — Lua LSP"
          echo "  stylua              — Lua formatter"
          echo "  luacheck            — Lua linter"
          echo "  nix-prefetch-url    — compute plugin hashes"
        '';
      };
      devenv = devenv.lib.mkShell {
        inputs = { inherit nixpkgs devenv; };
        inherit pkgs;
        modules = [{
          languages.nix.enable = true;
          packages = with pkgs; [ nixpkgs-fmt nil ];
          git-hooks.hooks.nixpkgs-fmt.enable = true;
        }];
      };
    });
  };
}
