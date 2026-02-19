{
  author = "rachartier";
  name = "tiny-inline-diagnostic.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  # Load immediately to enhance diagnostics display
}
