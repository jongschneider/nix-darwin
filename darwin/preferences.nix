{lib, ...}: {
  # Default system preferences that can be overridden per-machine
  system = {
    defaults = {
      finder.AppleShowAllExtensions = lib.mkDefault true;
      finder.AppleShowAllFiles = lib.mkDefault true;
      finder._FXShowPosixPathInTitle = lib.mkDefault true;
      finder.ShowPathbar = lib.mkDefault true;
      finder.ShowStatusBar = lib.mkDefault true;

      # Use current directory as default search scope in Finder
      finder.FXDefaultSearchScope = lib.mkDefault "SCcf";

      # Whether to show warnings when change the file extension of files.
      finder.FXEnableExtensionChangeWarning = lib.mkDefault false;

      NSGlobalDomain.InitialKeyRepeat = lib.mkDefault 14;
      NSGlobalDomain.KeyRepeat = lib.mkDefault 1;
      NSGlobalDomain.ApplePressAndHoldEnabled = lib.mkDefault false;

      # Trackpad tracking speed (0.0 to 3.0, higher = faster)
      NSGlobalDomain."com.apple.trackpad.scaling" = lib.mkDefault 3.0;
      # expand save dialog by default
      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = lib.mkDefault true;
      # expand save dialog by default
      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = lib.mkDefault true;
      # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
      NSGlobalDomain.AppleKeyboardUIMode = lib.mkDefault 3;
      # Enable subpixel font rendering on non-Apple LCDs
      NSGlobalDomain.AppleFontSmoothing = lib.mkDefault 2;
      dock.autohide = lib.mkDefault true;
      # Whether to automatically rearrange spaces based on most recent use
      dock.mru-spaces = lib.mkDefault false;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    stateVersion = 4;
  };
}
