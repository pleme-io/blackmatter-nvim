{
  author = "jcdickinson";
  name = "http.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  # NOTE: This plugin originally built a Rust package from source
  # This will need special handling in the registry loading logic
}
