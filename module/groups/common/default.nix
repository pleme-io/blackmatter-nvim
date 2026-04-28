{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.common;
  groupTree = (import ../../../lib/group-files.nix { inherit lib pkgs; }) {
    name = "common";
    src = ./.;
  };
in {
  options.blackmatter.components.nvim.plugin.groups.common = {
    enable = mkEnableOption "plugins that should always be included";
  };
  # No imports needed - plugins loaded via registry
  config = mkMerge [
    (
      mkIf cfg.enable
      {
        # One directory symlink instead of 7 per-file home.file entries.
        xdg.configFile."nvim/lua/groups/common".source = groupTree;
        blackmatter.components.nvim.plugins = {
          nvim-lua."plenary.nvim".enable = true;
          nvim-tree.nvim-web-devicons.enable = true;
          folke."lazy.nvim".enable = true;
          folke."which-key.nvim".enable = true;
          folke."todo-comments.nvim".enable = true;
          numToStr."Comment.nvim".enable = true;
          stevearc."oil.nvim".enable = true;
          pleme-io."compass.nvim".enable = true;
        };
      }
    )
  ];
}
