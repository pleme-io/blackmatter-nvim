{
  author = "folke";
  name = "lazy.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  # Bootstrap plugin - not lazy loaded
  # This plugin manager loads after Neovim starts but before other plugins
}
