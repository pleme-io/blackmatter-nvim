{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  name = "completion";
  cfg = config.blackmatter.components.nvim.plugin.groups.${name};
  groupTree = (import ../../../lib/group-files.nix { inherit lib pkgs; }) {
    inherit name;
    src = ./.;
  };
in {
  options.blackmatter.components.nvim.plugin.groups.completion = {
    enable = mkEnableOption name;
  };

  # No imports needed - plugins loaded via registry

  config = mkMerge [
    (
      mkIf cfg.enable
      {
        # One directory symlink instead of 3 per-file home.file entries.
        xdg.configFile."nvim/lua/groups/${name}".source = groupTree;
        blackmatter.components.nvim.plugins = {
          L3MON4D3.LuaSnip.enable = true;
          hrsh7th.cmp-path.enable = true;
          hrsh7th.nvim-cmp.enable = true;
          hrsh7th.cmp-buffer.enable = true;
          sar."cmp-lsp.nvim".enable = true;
          hrsh7th.cmp-cmdline.enable = true;
          yetone."avante.nvim".enable = false;
          hrsh7th.cmp-nvim-lsp.enable = true;
          ray-x.cmp-treesitter.enable = true;
          onsails."lspkind.nvim".enable = true;
          zbirenbaum."copilot.lua".enable = false;
          zbirenbaum."copilot-cmp".enable = false;
          Exafunction."windsurf.nvim".enable = false;
          rafamadriz.friendly-snippets.enable = true;
          windwp.nvim-autopairs.enable = true;
        };
      }
    )
  ];
}
