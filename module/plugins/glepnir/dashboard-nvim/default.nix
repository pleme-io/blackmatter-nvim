{
  author = "glepnir";
  name = "dashboard-nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    event = ["VimEnter"];
  };
}
