{
  author = "akinsho";
  name = "git-conflict.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    event = ["BufRead"];
  };
}
