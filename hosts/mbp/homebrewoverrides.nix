{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "microsoft-teams"
    "powershell"
    "zed"
  ];

  homebrew.brews = [
    # Additional brew just for MBP
    "llm"
  ];

  homebrew.taps = [
    # Additional tap for MBP
  ];
}
