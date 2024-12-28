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
    catppuccin.url = "github:catppuccin/nix";
    ghostty.url = "github:ghostty-org/ghostty";
    ghostty-hm.url = "github:clo4/ghostty-hm-module";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "x86_64-darwin"];

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
        darwinConfigurations = {
          "Jonathans-MacBook-Pro" = inputs.darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            # specialArgs for darwin system modules
            specialArgs = {
              username = "jschneider";
            };
            modules = [
              ./hosts/mbp/configuration.nix
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                # extraSpecialArgs for home-manager modules (since it's a separate module system)
                home-manager.extraSpecialArgs = {
                  username = "jschneider";
                };
                home-manager.users.jschneider = {
                  imports = [
                    ./hosts/mbp/home.nix
                    inputs.catppuccin.homeManagerModules.catppuccin
                    inputs.ghostty-hm.homeModules.default
                  ];
                };
              }
            ];
          };

          "Jonathans-Mac-mini" = inputs.darwin.lib.darwinSystem {
            system = "x86_64-darwin";
            specialArgs = {
              username = "jgs";
            };
            modules = [
              ./hosts/mbp/configuration.nix
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                # extraSpecialArgs for home-manager modules (since it's a separate module system)
                home-manager.extraSpecialArgs = {
                  username = "jgs";
                };
                home-manager.users.jgs = {
                  imports = [
                    ./hosts/macmini/home.nix
                    inputs.catppuccin.homeManagerModules.catppuccin
                    inputs.ghostty-hm.homeModules.default
                  ];
                };
              }
            ];

            # modules = [
            #   ./hosts/mba
            #   inputs.home-manager.darwinModules.home-manager
            #   {
            #     home-manager.useGlobalPkgs = true;
            #     home-manager.useUserPackages = true;
            #     home-manager.users.jschneider = import ./home;
            #   }
            # ];
          };
        };
      };
    };
}
