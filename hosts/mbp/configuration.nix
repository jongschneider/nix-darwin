# hosts/mbp/default.nix
{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../darwin
    ./systemoverrides.nix # Import the overrides
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
