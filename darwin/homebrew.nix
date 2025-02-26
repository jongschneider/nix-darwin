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
    brews =
      [
        "displayplacer"
        "lazygit"
        "litra"
        "trash"
      ]
      ++ lib.optionals (system == "aarch64-darwin") [
        "bitwarden-cli"
      ];

    # Default casks for all machines
    casks =
      [
        "font-monaspace"
        "karabiner-elements"
        "raycast"
        "shottr"
        "claude"
      ]
      ++ lib.optionals (system == "aarch64-darwin") [
        "ghostty"
        "orbstack"
        "vlc"
      ];

    # Default taps
    taps = [
      "timrogers/tap"
    ];
  };
}
