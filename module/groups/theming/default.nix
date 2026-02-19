{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.theming;
  common = import ../../common;
  configPath = "${common.includesPath}/theming";
in {
  options.blackmatter.components.nvim.plugin.groups.theming = {
    enable = mkEnableOption "theming";
  };
  # No imports needed - plugins loaded via registry
  config = mkMerge [
    (
      mkIf cfg.enable
      {
        home.file."${configPath}/init.lua".source = ./init.lua;
        home.file."${configPath}/bufferline.lua".source = ./bufferline.lua;
        home.file."${configPath}/lualine.lua".source = ./lualine.lua;
        home.file."${configPath}/noice.lua".source = ./noice.lua;
        home.file."${configPath}/colorscheme.lua".source = ./colorscheme.lua;
        home.file."${configPath}/nui.lua".source = ./nui.lua;
        home.file."${configPath}/border.lua".source = ./border.lua;
        home.file."${configPath}/input.lua".source = ./input.lua;
        home.file."${configPath}/menu.lua".source = ./menu.lua;
        home.file."${configPath}/popup.lua".source = ./popup.lua;
        home.file."${configPath}/notify.lua".source = ./notify.lua;
        home.file."${configPath}/devicons.lua".source = ./devicons.lua;
        home.file."${configPath}/snacks.lua".source = ./snacks.lua;
        home.file."${configPath}/gitsigns.lua".source = ./gitsigns.lua;
        home.file."${configPath}/indent-blankline.lua".source = ./indent-blankline.lua;
        blackmatter.components.nvim.plugins = {
          NvChad."nvim-colorizer.lua".enable = true;
          nvim-lualine."lualine.nvim".enable = true;
          akinsho."bufferline.nvim".enable = true;
          shaunsingh."nord.nvim".enable = true;
          folke."noice.nvim".enable = true;
          folke."snacks.nvim".enable = true;
          MunifTanjim."nui.nvim".enable = true;
          rcarriga."nvim-notify".enable = true;
          # mrjones2014."legendary.nvim" — disabled: unmaintained, causes vim.validate deprecation
          lewis6991."gitsigns.nvim".enable = true;
          lukas-reineke."indent-blankline.nvim".enable = true;
        };
      }
    )
  ];
}
