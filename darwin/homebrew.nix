{
  config,
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
    # Core homebrew packages
    brews =
      [
        "displayplacer"
        "golang-migrate"
        "modem-dev/tap/hunk"
        "lazygit"
        "lumen"
        "ollama"
        "ripgrep"
        "shaharia-lab/tap/slackcli"
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
        "bettershot"
        "dockdoor"
        "xykong/tap/flux-markdown"
        "font-monaspace"
        "font-zed-mono-nerd-font"
        "karabiner-elements"
        "mitmproxy"
        "raycast"
        "claude"
      ]
      ++ lib.optionals (system == "aarch64-darwin") [
        "ghostty"
        "vlc"
      ];

    # Default taps
    taps = [
      {
        name = "timrogers/tap";
        trusted = true;
      }
      {
        name = "sst/tap";
        trusted = true;
      }
      {
        name = "jnsahaj/lumen";
        trusted = true;
      }
      {
        name = "xykong/tap";
        trusted = true;
      }
      {
        name = "modem-dev/tap";
        trusted = true;
      }
      {
        name = "shaharia-lab/tap";
        trusted = true;
      }
    ];
  };
}
