{
  author = "tpope";
  name = "vim-fugitive";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    cmd = ["Git" "G" "Gdiffsplit" "Gvdiffsplit" "Gread" "Gwrite" "Ggrep" "GMove" "GDelete" "GBrowse"];
  };
}
