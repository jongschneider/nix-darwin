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
        "modem-dev/tap/hunk"
        "lazygit"
        # Brew rather than nix: nixpkgs' mole-cleaner lags the upstream releases.
        "mole"
        # node is wanted in its own right: global npm CLIs live under
        # /opt/homebrew/lib, and the /usr/local/bin symlinks in system.nix need
        # node + npx to exist. Listed explicitly so it stops riding along as a
        # transitive dep of agent-browser/bitwarden-cli, where `cleanup = "zap"`
        # would take it out the moment either of those goes away.
        "node"
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
        "yaak"
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
