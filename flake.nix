{
  description = "Jonathan's System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Per-system attributes can be defined here
      };

      flake = {
        darwinConfigurations."Jonathans-MacBook-Pro" = inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin"; # Assuming M1/M2 Mac
          modules = [
            ./darwin
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # home-manager.users.jschneider = import ./home;
              home-manager.users.jschneider = {
                imports = [
                  ./home
                ];
              };
            }
          ];
        };
      };
    };
}
