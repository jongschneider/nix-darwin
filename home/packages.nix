{
  pkgs,
  inputs,
  work,
  ...
}:
[
  # (pkgs.callPackage ../pkgs/bins {})

  pkgs.awscli2
  pkgs.cachix
  pkgs.doppler
  pkgs.fd
  pkgs.glow
  pkgs.gum
  pkgs.httpie
  pkgs.jq
  pkgs.mods
  pkgs.moreutils
  pkgs.podman-compose
  pkgs.ripgrep
  pkgs.sops
  pkgs.viddy
]
++ pkgs.lib.lists.optionals work [
  pkgs.bitwarden-cli
]
