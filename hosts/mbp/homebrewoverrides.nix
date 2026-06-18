{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "docker/tap/sbx"
    "microsoft-teams"
    "orbstack"
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
    "grafana/grafana/gcx"
  ];

  homebrew.taps = [
    # Additional tap for MBP
    "docker/tap"
    "grafana/grafana"
  ];
}
