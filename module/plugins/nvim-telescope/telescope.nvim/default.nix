{
  author = "nvim-telescope";
  name = "telescope.nvim";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  configDir = ./config;
  lazy = {
    enable = true;
    cmd = ["Telescope"];
    keys = [
      { key = "<leader>ff"; cmd = "<cmd>Telescope find_files<cr>"; desc = "Find files"; }
      { key = "<leader>fg"; cmd = "<cmd>Telescope live_grep<cr>"; desc = "Live grep"; }
      { key = "<leader>fb"; cmd = "<cmd>Telescope buffers<cr>"; desc = "Buffers"; }
      { key = "<leader>fh"; cmd = "<cmd>Telescope help_tags<cr>"; desc = "Help tags"; }
      { key = "<leader>fo"; cmd = "<cmd>Telescope oldfiles<cr>"; desc = "Recent files"; }
      { key = "<leader>fw"; cmd = "<cmd>Telescope grep_string<cr>"; desc = "Grep word"; }
      { key = "<leader>fd"; cmd = "<cmd>Telescope diagnostics<cr>"; desc = "Diagnostics"; }
    ];
  };
}
