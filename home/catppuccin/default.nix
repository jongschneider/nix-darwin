{
  lib,
  system,
  ...
}: let
  flavor = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
  # Only the darwin hosts get themed; buntu stays with its own colors.
  autoEnable = system == "aarch64-darwin";
in {
  # `enable` is the global kill switch, `autoEnable` is what enrolls ports.
  catppuccin =
    {
      enable = true;
      inherit autoEnable;
    }
    // lib.optionalAttrs autoEnable {
      inherit flavor;
      bat.enable = true;
      fzf.enable = true;
      delta.enable = true;
      nvim.enable = false; # managed via lazy.nvim in nvim/config/lua/plugins/color_scheme.lua
      zsh-syntax-highlighting.enable = true;
    };
}
