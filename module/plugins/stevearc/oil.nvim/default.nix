{
  author = "stevearc";
  name = "oil.nvim";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    cmd = ["Oil"];
    keys = [
      { key = "-"; cmd = "<cmd>Oil<cr>"; desc = "Open parent directory"; }
    ];
  };
}
