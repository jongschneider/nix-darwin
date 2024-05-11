{
  description = "Jonathan's Nix configuration for Darwin";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Use latest unstable 23.05 Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";

    # Include `nxs` (nixpkgs-stable) and `nxt` (nixpkgs-trunk)
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    trunk.url = "github:nixos/nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index = {
      url = "github:nix-community/nix-index";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin"];

      flake = let
        systems = import ./system {inherit inputs;};

        mkPkgs = pkgs: extraOverlays: system:
          import pkgs {
            inherit system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "openssl-1.1.1w"
              ];
              pulseaudio = true;
            };
            overlays = extraOverlays;
          };
        pkgsDarwin_arm = mkPkgs inputs.nixpkgs [] "aarch64-darwin";
      in {
        overlays = {};

        darwinConfigurations = {
          # personal = systems.mkDarwin {
          #   system = "aarch64-darwin";
          #   username = "hayden";
          # };

          # hostname = "Jonathans-MacBook-Pro"
          work = systems.mkDarwin {
            system = "aarch64-darwin";
            username = "jschneider";
          };
        };
      };

      perSystem = {pkgs, ...}: let
        inherit (pkgs) just ssh-to-age;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [just ssh-to-age];
        };
      };
    };
}
