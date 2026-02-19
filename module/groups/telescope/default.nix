{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.telescope;
  common = import ../../common;
  configPath = "${common.includesPath}/telescope";
in {
  options.blackmatter.components.nvim.plugin.groups.telescope = {
    enable = mkEnableOption "telescope";
  };
  # No imports needed - plugins loaded via registry
  config = mkMerge [
    (
      mkIf cfg.enable
      {
        home.file."${configPath}/init.lua".source = ./init.lua;
        blackmatter.components.nvim.plugins = {
          nvim-telescope."telescope.nvim".enable = true;
          nvim-telescope."telescope-file-browser.nvim".enable = false;
          nvim-telescope."telescope-project.nvim".enable = false;
          nvim-telescope."telescope-dap.nvim".enable = false;
          nvim-telescope."telescope-z.nvim".enable = false;
          # danielpieper."telescope-tmuxinator.nvim".enable = false;
        };
      }
    )
  ];
}
