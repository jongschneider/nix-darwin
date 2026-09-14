{pkgs, ...}: {
  # Machine-specific Homebrew configuration
  homebrew.casks = [
    "docker/tap/sbx"
    # Azure Storage Explorer ships its auth hub controller as a
    # framework-dependent net10.0 app, so it needs a .NET 10 runtime present or
    # it dies on launch. The cask rather than the `dotnet` formula: the cask
    # installs to /usr/local/share/dotnet, which is what
    # /etc/dotnet/install_location_arm64 points at, and that registered path is
    # the only way a GUI app finds the runtime -- DOTNET_ROOT never reaches
    # anything LaunchServices starts.
    "dotnet-runtime"
    "microsoft-teams"
    "orbstack"
    "zed"
  ];

  homebrew.brews = [
    # Additional brew just for MBP
    "gcx"
  ];

  homebrew.taps = [
    # Additional tap for MBP
    {
      name = "docker/tap";
      trusted = true;
    }
  ];
}
