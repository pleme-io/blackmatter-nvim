{
  author = "simrat39";
  name = "rust-tools.nvim";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    ft = ["rust"];
  };
}
