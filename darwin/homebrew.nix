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
        "golang-migrate"
        "lazygit"
        "opencode"
        "uv"
        "trash"
      ]
      ++ lib.optionals (system == "aarch64-darwin") [
        "bitwarden-cli"
      ];

    # Default casks for all machines
    casks =
      [
        "android-platform-tools"
        "font-monaspace"
        "karabiner-elements"
        "mitmproxy"
        "raycast"
        "shottr"
        "claude"
        "voiceink"
      ]
      ++ lib.optionals (system == "aarch64-darwin") [
        "ghostty"
        "orbstack"
        "vlc"
      ];

    # Default taps
    taps = [
      "timrogers/tap"
      "sst/tap"
    ];
  };
}
