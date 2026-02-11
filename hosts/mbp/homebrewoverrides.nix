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
    "litra"
    "poppler"
    "openapi-generator"
    "dotnet"
  ];

  homebrew.taps = [
    # Additional tap for MBP
  ];
}
