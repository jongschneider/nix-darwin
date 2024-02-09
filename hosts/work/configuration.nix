{ pkgs, config, ... }:

{
  imports = [
    ../../darwin
  ];
  users.users.jschneider = {
    name = "jschneider";
    home = "/Users/jschneider";
  };
}
