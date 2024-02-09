{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./config;
    shellIntegration.enableZshIntegration = true;
  };
}
