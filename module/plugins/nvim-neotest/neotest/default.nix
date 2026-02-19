{
  author = "nvim-neotest";
  name = "neotest";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    cmd = ["Neotest"];
    keys = [
      { key = "<leader>nn"; cmd = "<cmd>lua require('neotest').run.run()<cr>"; desc = "Run nearest test"; }
      { key = "<leader>nf"; cmd = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>"; desc = "Run file tests"; }
      { key = "<leader>ns"; cmd = "<cmd>lua require('neotest').run.run(vim.uv.cwd())<cr>"; desc = "Run test suite"; }
      { key = "<leader>no"; cmd = "<cmd>lua require('neotest').output_panel.toggle()<cr>"; desc = "Toggle output panel"; }
      { key = "<leader>np"; cmd = "<cmd>lua require('neotest').summary.toggle()<cr>"; desc = "Toggle summary"; }
    ];
  };
}
