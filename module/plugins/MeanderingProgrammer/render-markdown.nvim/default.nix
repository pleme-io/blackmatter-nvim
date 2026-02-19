{
  author = "MeanderingProgrammer";
  name = "render-markdown.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    ft = ["markdown"];
  };
}
