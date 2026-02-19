{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.components.nvim.plugin.groups.tmux;
in
{
  options.blackmatter.components.nvim.plugin.groups.tmux =
    {
      enable = mkEnableOption "tmux";
    };

  # No imports needed - plugins loaded via registry

  config =
    mkMerge [
      (mkIf cfg.enable
        {
          blackmatter.components.nvim.plugins = {christoomey.vim-tmux-navigator.enable = true;};
        }
      )
    ];
}
