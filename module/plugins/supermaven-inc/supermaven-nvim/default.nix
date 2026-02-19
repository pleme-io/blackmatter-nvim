{
  author = "supermaven-inc";
  name = "supermaven-nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  # Load immediately to start AI completion service
}
