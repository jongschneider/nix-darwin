{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # m4mini-specific packages
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
