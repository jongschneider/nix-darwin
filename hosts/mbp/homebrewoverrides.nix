{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "docker/tap/sbx"
    "microsoft-teams"
    "orbstack"
    "zed"
  ];

  homebrew.brews = [
    # Additional brew just for MBP
    "grafana/grafana/gcx"
  ];

  homebrew.taps = [
    # Additional tap for MBP
    "docker/tap"
    "grafana/grafana"
  ];
}
