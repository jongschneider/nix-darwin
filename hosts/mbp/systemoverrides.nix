# hosts/mbp/overrides.nix
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
  ];

  environment.pathsToLink = ["/Applications"];
  environment.systemPath = ["/opt/homebrew/bin" "/Users/${username}/go/bin"];
}