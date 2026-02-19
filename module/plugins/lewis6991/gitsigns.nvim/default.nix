{
  author = "lewis6991";
  name = "gitsigns.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    event = ["BufRead"];
  };
}
