{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "microsoft-teams"
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
