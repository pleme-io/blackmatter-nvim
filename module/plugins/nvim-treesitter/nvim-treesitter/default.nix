{
  author = "nvim-treesitter";
  name = "nvim-treesitter";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  # VERSION COORDINATION
  # Parsers (.so) and queries (.scm) come from pkgs.vimPlugins.nvim-treesitter
  # in module/default.nix. This plugin provides the Lua runtime only
  # (nvim-treesitter.configs, .query, .ts_utils, etc.).
  #
  # We strip the bundled queries so only nixpkgs queries are loaded — these
  # are guaranteed to match the nixpkgs parsers from the same snapshot.
  #
  # To upgrade: update rev.nix + hash.nix. Queries/parsers advance with nixpkgs.
  postPatch = ''
    rm -rf queries runtime/queries
  '';
}
