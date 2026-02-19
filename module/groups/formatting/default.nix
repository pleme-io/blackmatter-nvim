{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.blackmatter.components.nvim.plugin.groups.formatting;
in {
  options.blackmatter.components.nvim.plugin.groups.formatting = {
    enable = mkEnableOption "manage formatting";
  };
  # No imports needed - plugins loaded via registry
  config = mkMerge [
    (
      mkIf cfg.enable
      {
        home.packages = with pkgs; [
          # Formatters used by conform.nvim
          rustfmt           # Rust
          taplo             # TOML
          shfmt             # Shell (sh, zsh)
          php83Packages.php-cs-fixer  # PHP
          alejandra         # Nix
          stylua            # Lua
          nodePackages.prettier  # JS/TS/JSON/YAML/HTML/Markdown
          black             # Python
          gofumpt           # Go (better than gofmt)
          buf               # Protocol Buffers
          rubocop           # Ruby
          google-java-format  # Java
          # Optional formatters (uncomment if needed)
          # texlivePackages.latexindent  # LaTeX (large dependency)
          # terraform        # Terraform (use opentofu instead if preferred)
          zig               # Zig (includes zig fmt)
        ];
        blackmatter.components.nvim.plugins = {
          stevearc."conform.nvim".enable = true;
        };
      }
    )
  ];
}
