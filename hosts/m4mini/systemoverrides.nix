{
  pkgs,
  username,
  ...
}: {
  # example of overriding system configuration
  # system.defaults.dock.orientation = "right";
  # system.defaults.NSGlobalDomain.InitialKeyRepeat = 20;
  # packages added here will be added to the shared config, not replace them.

  environment.systemPackages = with pkgs; [
    # MBP-specific packages
    discord
    tailscale
  ];

  system.primaryUser = username;

  services.tailscale.enable = true;

  # Disable nix-darwin's Nix management in favor of the Determinate Systems installation
  nix.enable = false;
  nix.optimise.automatic = false;
  nix.gc.automatic = false;

  environment.pathsToLink = ["/Applications"];
  environment.systemPath = ["/opt/homebrew/bin" "/Users/${username}/go/bin" "/Users/${username}/.local/bin"];
}
