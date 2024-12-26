{
  pkgs,
  lib,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # cleanup = "zap"; # Remove everything not listed
      cleanup = "uninstall"; # uncomment when everything is migrated over
    };

    global.brewfile = true;

    # Core homebrew packages
    brews = [
      "bitwarden-cli"
      "lazygit"
      "trash"
    ];

    # Default casks for all machines
    casks = [
      "font-monaspace"
      "orbstack"
      "raycast"
      "shottr"
      "vlc"
    ];

    # Default taps
    taps = [
      "homebrew/cask-fonts"
    ];
  };
}
