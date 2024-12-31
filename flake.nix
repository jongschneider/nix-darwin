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
          "Jonathans-MacBook-Pro" = let
            username = "jschneider";
            system = "aarch64-darwin";
          in
            inputs.darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit username system;
              };
              modules = [
                ./hosts/mbp/configuration.nix
                inputs.home-manager.darwinModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    # extraSpecialArgs for home-manager modules (since it's a separate module system)
                    extraSpecialArgs = {
                      inherit username system;
                    };
                    users.${username} = {
                      imports = [
                        ./hosts/mbp/home.nix
                        inputs.catppuccin.homeManagerModules.catppuccin
                        inputs.ghostty-hm.homeModules.default
                      ];
                    };
                  };
                }
              ];
            };

          "Jonathans-Mac-mini" = let
            username = "jgs";
            system = "x86_64-darwin";
          in
            inputs.darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit username system;
              };
              modules = [
                ./hosts/macmini/configuration.nix
                inputs.home-manager.darwinModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    # extraSpecialArgs for home-manager modules (since it's a separate module system)
                    extraSpecialArgs = {
                      inherit username system;
                    };
                    users.${username} = {
                      imports = [
                        ./hosts/macmini/home.nix
                        inputs.catppuccin.homeManagerModules.catppuccin
                        inputs.ghostty-hm.homeModules.default
                      ];
                    };
                  };
                }
              ];
            };
        };
      };
    };
}
