{pkgs, ...}: {

  # TODO: consider
  # https://github.com/moul/nixpkgs/blob/15a0ac8e960d46ed10cb6407ef8d08f022e53fc1/home/kitty.nix#L65
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./config;
    # settings.background_opacity = "0.90";
  };
}
