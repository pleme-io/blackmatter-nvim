{
  author = "mfussenegger";
  name = "nvim-dap";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    cmd = ["DapContinue" "DapToggleBreakpoint" "DapStepOver" "DapStepInto" "DapStepOut" "DapTerminate"];
  };
}
