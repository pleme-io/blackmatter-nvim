{
  author = "jose-elias-alvarez";
  name = "null-ls.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  packages = pkgs: [ pkgs.nodePackages.prettier ];
}
