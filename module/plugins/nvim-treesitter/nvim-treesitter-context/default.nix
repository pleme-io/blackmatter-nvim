{
  author = "nvim-treesitter";
  name = "nvim-treesitter-context";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    event = ["BufRead"];
  };
}
