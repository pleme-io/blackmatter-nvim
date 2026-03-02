{
  author = "pleme-io";
  name = "compass.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  pluginOverride = pkgs: pkgs.vimPlugins.compass-nvim;
  lazy = {
    enable = true;
    cmd = ["Compass" "CompassRefresh"];
  };
}
