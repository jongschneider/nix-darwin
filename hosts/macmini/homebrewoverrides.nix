{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "zed"
  ];

  homebrew.brews = [
    # Additional brew just for MBP
    "litra"
  ];

  homebrew.taps = [
    # Additional tap for MBP
  ];
}
