{
  config,
  lib,
  ...
}:
with lib; let
  name = "completion";
  plugName = name;
  cfg = config.blackmatter.components.nvim.plugin.groups.${name};
  common = import ../../common;
  configPath = "${common.includesPath}/${plugName}";
in {
  options.blackmatter.components.nvim.plugin.groups.completion = {
    enable = mkEnableOption name;
  };

  # No imports needed - plugins loaded via registry

  config = mkMerge [
    (
      mkIf cfg.enable
      {
        home.file."${configPath}/init.lua".source = ./init.lua;
        home.file."${configPath}/mappings.lua".source = ./mappings.lua;
        home.file."${configPath}/utils.lua".source = ./utils.lua;
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
