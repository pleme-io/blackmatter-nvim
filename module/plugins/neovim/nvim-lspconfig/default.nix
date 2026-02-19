{
  author = "neovim";
  name = "nvim-lspconfig";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
}
