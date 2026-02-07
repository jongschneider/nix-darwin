{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "firefox"
    "microsoft-teams"
    "notion"
    "superwhisper"
    "zed"
  ];

  homebrew.brews = [
    # Additional brew just for MBP
    "llm"
    "litra"
  ];

  homebrew.taps = [
    # Additional tap for MBP
  ];
}
