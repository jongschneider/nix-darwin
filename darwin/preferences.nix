# darwin/preferences.nix
{lib, ...}: {
  # Default system preferences that can be overridden per-machine
  system.defaults = {
    dock = {
      autohide = lib.mkDefault true;
      orientation = lib.mkDefault "bottom";
      showhidden = lib.mkDefault true;
    };

    finder = {
      AppleShowAllExtensions = lib.mkDefault true;
      FXEnableExtensionChangeWarning = lib.mkDefault false;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = lib.mkDefault true;
      InitialKeyRepeat = lib.mkDefault 15;
      KeyRepeat = lib.mkDefault 2;
    };
  };
}
