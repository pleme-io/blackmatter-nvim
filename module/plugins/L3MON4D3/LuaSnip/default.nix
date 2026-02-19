{
  author = "L3MON4D3";
  name = "LuaSnip";
  ref = "master";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  # Provide jsregexp as extra config so its nix store path gets embedded
  packages = pkgs: let
    jsregexp = pkgs.luajitPackages.jsregexp;
  in {
    home.file.".config/nvim/lua/luasnip-jsregexp-path.lua".text = ''
      -- Auto-generated: adds jsregexp to Lua cpath for LuaSnip transformations
      package.cpath = package.cpath .. ";${jsregexp}/lib/lua/5.1/?.so"
    '';
  };
}
