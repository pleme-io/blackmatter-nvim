{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.theming;
  groupTree = (import ../../../lib/group-files.nix { inherit lib pkgs; }) {
    name = "theming";
    src = ./.;
  };
in {
  options.blackmatter.components.nvim.plugin.groups.theming = {
    enable = mkEnableOption "theming";
  };
  # No imports needed - plugins loaded via registry
  config = mkMerge [
    (
      mkIf cfg.enable
      {
        # One directory symlink instead of 15 per-file home.file entries.
        # See lib/group-files.nix.
        xdg.configFile."nvim/lua/groups/theming".source = groupTree;
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
