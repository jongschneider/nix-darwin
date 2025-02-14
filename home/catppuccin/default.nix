{
  lib,
  system,
  ...
}: let
  flavor = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
in {
  catppuccin = lib.mkIf (system == "aarch64-darwin") {
    enable = true;
    flavor = flavor;
    bat.enable = true;
    fzf.enable = true;
    delta.enable = true;
    zsh-syntax-highlighting.enable = true;
  };
}
