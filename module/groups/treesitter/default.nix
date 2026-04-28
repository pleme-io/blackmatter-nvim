{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.treesitter;
  groupTree = (import ../../../lib/group-files.nix { inherit lib pkgs; }) {
    name = "treesitter";
    src = ./.;
  };
in {
  options.blackmatter.components.nvim.plugin.groups.treesitter = {
    enable = mkEnableOption "treesitter";
  };

  # No imports needed - plugins loaded via registry

  config = mkMerge [
    (
      mkIf cfg.enable
      {
        # One directory symlink instead of 5 per-file home.file entries.
        xdg.configFile."nvim/lua/groups/treesitter".source = groupTree;
        blackmatter.components.nvim.plugins = {
          nvim-treesitter.nvim-treesitter.enable = true;
          nvim-treesitter.nvim-treesitter-textobjects.enable = true;
          # nvim-treesitter.nvim-treesitter-context.enable = true;
          JoosepAlviste.nvim-ts-context-commentstring.enable = true;
          MeanderingProgrammer."render-markdown.nvim".enable = true;
          windwp.nvim-ts-autotag.enable = true;
        };
      }
    )
  ];
}
