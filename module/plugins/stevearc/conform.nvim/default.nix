{
  author = "stevearc";
  name = "conform.nvim";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    event = ["BufWritePre"];
  };
}
