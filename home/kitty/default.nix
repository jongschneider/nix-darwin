{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./config;
    shellIntegration.enableZshIntegration = true;
    settings.background_opacity = "0.60";
    settings.tab_bar_edge = "top"; # tab bar on top
    settings.term = "xterm-256color";
  };
}
