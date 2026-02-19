{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.keybindings;
  common = import ../../common;
  configPath = "${common.includesPath}/keybindings/init.lua";
in {
  options.blackmatter.components.nvim.plugin.groups.keybindings = {
    enable = mkEnableOption "keybindings";
  };
  # No imports needed - plugins loaded via registry
  config = mkMerge [
    (
      mkIf cfg.enable
      {
        home.file."${configPath}".source = ./init.lua;
        blackmatter.components.nvim.plugins = {
          hrsh7th.nvim-cmp.enable = true;
        };
      }
    )
  ];
}
