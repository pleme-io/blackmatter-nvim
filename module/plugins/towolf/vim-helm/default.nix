{
  author = "towolf";
  name = "vim-helm";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    ft = ["helm"];
  };
}
