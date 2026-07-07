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
        "agent-browser"
        "displayplacer"
        "herdr"
        "modem-dev/tap/hunk"
        "lazygit"
        "ollama"
        "ripgrep"
        "shaharia-lab/tap/slackcli"
        "uv"
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
      ];

    # Default taps
    taps = [
      {
        name = "anomalyco/tap";
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
