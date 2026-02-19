{
  author = "williamboman";
  name = "mason.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  packages = pkgs: {
    # Mason manages language servers. Some binaries it downloads don't work.
    # Link to well-known derivations where mason expects binaries to be.
    home.file.".local/share/nvim/mason/packages/lua-language-server/bin/lua-language-server".source =
      "${pkgs.lua-language-server}/bin/lua-language-server";
  };
  configDir = ./config;
}
