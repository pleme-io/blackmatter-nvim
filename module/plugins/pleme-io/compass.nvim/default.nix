{
  author = "pleme-io";
  name = "compass.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    cmd = ["Compass" "CompassRefresh"];
  };
}
