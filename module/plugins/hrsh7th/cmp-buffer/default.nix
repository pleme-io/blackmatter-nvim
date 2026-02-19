{
  author = "hrsh7th";
  name = "cmp-buffer";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  # Completion source, load immediately with nvim-cmp
}
