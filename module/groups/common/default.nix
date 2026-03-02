{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.common;
  common = import ../../common;
  configPath = "${common.includesPath}/common";
in {
  options.blackmatter.components.nvim.plugin.groups.common = {
    enable = mkEnableOption "plugins that should always be included";
  };
  # No imports needed - plugins loaded via registry
  config = mkMerge [
    (
      mkIf cfg.enable
      {
        home.file."${configPath}/init.lua".source = ./init.lua;
        home.file."${configPath}/settings.lua".source = ./settings.lua;
        home.file."${configPath}/autocmds.lua".source = ./autocmds.lua;
        home.file."${configPath}/undo.lua".source = ./undo.lua;
        home.file."${configPath}/performance.lua".source = ./performance.lua;
        home.file."${configPath}/trim-whitespace.lua".source = ./trim-whitespace.lua;
        home.file."${configPath}/which-key.lua".source = ./which-key.lua;
        blackmatter.components.nvim.plugins = {
          nvim-lua."plenary.nvim".enable = true;
          nvim-tree.nvim-web-devicons.enable = true;
          folke."lazy.nvim".enable = true;
          folke."which-key.nvim".enable = true;
          folke."todo-comments.nvim".enable = true;
          numToStr."Comment.nvim".enable = true;
          ggandor."leap.nvim".enable = true;
          kylechui.nvim-surround.enable = true;
          stevearc."oil.nvim".enable = true;
          pleme-io."compass.nvim".enable = true;
        };
      }
    )
  ];
}
