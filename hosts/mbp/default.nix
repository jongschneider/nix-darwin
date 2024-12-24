# hosts/mbp/default.nix
{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../darwin
    ./overrides.nix # Import the overrides
  ];

  # packages added here will be added to the shared config, not replace them.
  environment.systemPackages = with pkgs; [
    # MBP-specific packages
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
