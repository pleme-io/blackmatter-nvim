{
  author = "folke";
  name = "trouble.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    cmd = ["Trouble"];
    keys = [
      {
        key = "<leader>xx";
        cmd = "<cmd>Trouble diagnostics toggle<cr>";
        desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>xX";
        cmd = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>cs";
        cmd = "<cmd>Trouble symbols toggle focus=false<cr>";
        desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>cl";
        cmd = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        desc = "LSP Definitions / references / ... (Trouble)";
      }
      {
        key = "<leader>xL";
        cmd = "<cmd>Trouble loclist toggle<cr>";
        desc = "Location List (Trouble)";
      }
      {
        key = "<leader>xQ";
        cmd = "<cmd>Trouble qflist toggle<cr>";
        desc = "Quickfix List (Trouble)";
      }
    ];
  };
}
