{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "microsoft-teams"
    "powershell"
    "zed"
    "superwhisper"
  ];

  homebrew.brews = [
    # Additional brew just for MBP
    "llm"
    "litra"
    "openapi-generator"
  ];

  homebrew.taps = [
    # Additional tap for MBP
  ];
}
