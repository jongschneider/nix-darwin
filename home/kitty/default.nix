{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./config;
    settings.background_opacity = "0.90";
  };
}
