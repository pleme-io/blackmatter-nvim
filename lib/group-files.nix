# lib/group-files.nix
#
# Build a single config-tree derivation for an nvim group, so its multiple
# `.lua` files become one home-manager directory symlink instead of one
# entry per file. Same `recursive = false` pattern we use for the
# treesitter parser/queries trees in module/default.nix.
#
# Usage:
#
#   let
#     groupTree = import ../../lib/group-files.nix { inherit lib pkgs; } {
#       name = "lsp";
#       src  = ./.;                  # dir with the static .lua files
#       generated = {                # OPTIONAL — for files whose body is
#         "features.lua" = ''...'';  # derived from cfg, not on disk
#       };
#     };
#   in {
#     xdg.configFile."nvim/lua/groups/lsp".source = groupTree;
#   }
#
# `src` is filtered to regular files ending in `.lua` — `default.nix`,
# `CLAUDE.md`, and any other non-Lua siblings are excluded automatically.
{ lib, pkgs }:

{ name
, src
, generated ? {}
}:

let
  staticSrc = lib.sources.cleanSourceWith {
    inherit src;
    filter = path: type:
      type == "regular" && lib.hasSuffix ".lua" (baseNameOf path);
  };
in
  if generated == {} then
    # All-static group: HM symlinks the filtered source tree directly.
    # No runCommand needed — saves a build step on cold caches.
    staticSrc
  else
    pkgs.runCommand "nvim-group-${name}" { } ''
      mkdir -p $out
      cp -r ${staticSrc}/. $out/
      ${lib.concatMapStrings (entry: ''
        cp ${pkgs.writeText "nvim-group-${name}-${entry.name}" entry.value} $out/${entry.name}
      '') (lib.mapAttrsToList (n: v: { name = n; value = v; }) generated)}
    ''
