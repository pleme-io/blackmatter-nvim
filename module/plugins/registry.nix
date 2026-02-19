# Plugin Registry - Auto-discovers and registers all nvim plugins
# All plugins use the simple declaration format via plugin-helper
{
  lib,
  pkgs,
  ...
}: let
  pluginHelper = import ../../lib/plugin-helper.nix {inherit lib pkgs;};

  # Single source of truth for plugin declarations
  pluginDecls = import ./declarations.nix;

  # Convert declarations to module imports using plugin-helper
  pluginModules = map pluginHelper.mkPlugin pluginDecls;
in {
  imports = pluginModules;
}
