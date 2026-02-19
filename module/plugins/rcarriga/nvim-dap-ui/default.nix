{
  author = "rcarriga";
  name = "nvim-dap-ui";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    cmd = ["DapContinue" "DapToggleBreakpoint"];
  };
}
