{
  author = "folke";
  name = "noice.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    event = ["VeryLazy"];
  };
}
