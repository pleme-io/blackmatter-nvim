{
  author = "iamcco";
  name = "markdown-preview.nvim";
  ref = "main";
  rev = import ./rev.nix;
  hash = import ./hash.nix;
  lazy = {
    enable = true;
    ft = ["markdown"];
    cmd = ["MarkdownPreview" "MarkdownPreviewStop" "MarkdownPreviewToggle"];
  };
  # NOTE: This plugin originally had a home.activation hook for npm install
  # This will need to be handled separately in the registry loading logic
}
