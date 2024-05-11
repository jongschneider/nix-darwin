{...}: let
  oxocarbon = (import ../oxocarbon.nix).dark;
in {
  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };
}
