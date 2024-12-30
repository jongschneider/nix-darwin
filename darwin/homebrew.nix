{
  pkgs,
  lib,
  system,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Remove everything not listed
    };

    global.brewfile = true;
    caskArgs.no_quarantine = true;
    # Core homebrew packages
    brews = [
      "bitwarden-cli"
      "lazygit"
      "trash"
    ];

    # Default casks for all machines
    casks =
      [
        "font-monaspace"
        "karabiner-elements"
        "raycast"
        "shottr"
        # "orbstack"
        # "ghostty"
        # "vlc"
      ]
      ++ lib.optionals (system == "aarch64-darwin") [
        "ghostty"
        "orbstack"
        "vlc"
      ];

    # Default taps
    taps = [
      "homebrew/cask-fonts"
    ];
  };
}
