{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.treesitter;
  common = import ../../common;
  configPath = "${common.includesPath}/treesitter";
in {
  options.blackmatter.components.nvim.plugin.groups.treesitter = {
    enable = mkEnableOption "treesitter";
  };

  # No imports needed - plugins loaded via registry

  config = mkMerge [
    (
      mkIf cfg.enable
      {
        home.file."${configPath}/init.lua".source = ./init.lua;
        home.file."${configPath}/parsers.lua".source = ./parsers.lua;
        home.file."${configPath}/setup.lua".source = ./setup.lua;
        home.file."${configPath}/filetype.lua".source = ./filetype.lua;
        home.file."${configPath}/commentstring.lua".source = ./commentstring.lua;
        blackmatter.components.nvim.plugins = {
          nvim-treesitter.nvim-treesitter.enable = true;
          nvim-treesitter.nvim-treesitter-textobjects.enable = true;
          nvim-treesitter.nvim-treesitter-context.enable = true;
          JoosepAlviste.nvim-ts-context-commentstring.enable = true;
          MeanderingProgrammer."render-markdown.nvim".enable = true;
          windwp.nvim-ts-autotag.enable = true;
        };
      }
    )
  ];
}
