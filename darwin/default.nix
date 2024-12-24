# darwin/default.nix
{lib, ...}: {
  imports = [
    ./system.nix
    ./preferences.nix
    ./homebrew.nix
  ];
}
