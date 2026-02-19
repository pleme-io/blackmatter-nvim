{
  author = "folke";
  name = "snacks.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  priority = 1000;
  # snacks.nvim should NOT be lazy-loaded and needs high priority (per its healthcheck)
}
