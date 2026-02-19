{
  author = "lukas-reineke";
  name = "indent-blankline.nvim";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    event = ["VeryLazy"];
  };
}
