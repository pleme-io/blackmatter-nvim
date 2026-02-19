{
  description = "Blackmatter Neovim - curated neovim distribution with 55 plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/d6c71932130818840fc8fe9509cf50be8c64634f";
  };

  outputs = { self, nixpkgs }: let
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

    overlays.default = final: prev: {
      blnvim = self.packages.${final.system}.blnvim;
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
    });
  };
}
