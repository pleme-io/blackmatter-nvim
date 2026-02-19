{
  author = "hrsh7th";
  name = "nvim-cmp";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  # Completion is a core feature, load immediately
  # Setup handled by groups/completion with custom options
}
