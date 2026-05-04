{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "brave-browser"
    "docker"
    "docker/tap/sbx"
    "firefox"
#    "linear-linear"
    "microsoft-teams"
    "notion"
    "surge-downloader/tap/surge"
    "zed"
  ];

  homebrew.brews = [
    # Additional brew just for MBP
    "llm"
    "litra"
  ];

  homebrew.taps = [
    # Additional tap for MBP
    "surge-downloader/tap"
    "docker/tap"
  ];
}
