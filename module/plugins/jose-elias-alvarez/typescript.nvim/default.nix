{
  author = "jose-elias-alvarez";
  name = "typescript.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    ft = ["typescript" "typescriptreact" "javascript" "javascriptreact"];
  };
}
