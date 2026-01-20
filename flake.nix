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
    # Add your AI Toolbox as an input
    ai-toolbox.url = "github:jongschneider/ai-toolbox";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux"];

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
          "js-m4-mini" = let
            username = "js_mini";
            system = "aarch64-darwin";
          in
            inputs.darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit username system inputs;
              };
              modules = [
                ./hosts/m4mini/configuration.nix
                inputs.home-manager.darwinModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    # extraSpecialArgs for home-manager modules (since it's a separate module system)
                    extraSpecialArgs = {
                      inherit username system inputs;
                    };
                    users.${username} = {
                      imports = [
                        ./hosts/m4mini/home.nix
                        inputs.catppuccin.homeModules.catppuccin
                      ];
                    };
                  };
                }
              ];
            };

          "Jonathans-MacBook-Pro" = let
            username = "jschneider";
            system = "aarch64-darwin";
          in
            inputs.darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit username system inputs;
              };
              modules = [
                ./hosts/mbp/configuration.nix
                inputs.home-manager.darwinModules.home-manager
                {
                  home-manager = {
                    backupFileExtension = "backup";
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    # extraSpecialArgs for home-manager modules (since it's a separate module system)
                    extraSpecialArgs = {
                      inherit username system inputs;
                    };
                    users.${username} = {
                      imports = [
                        ./hosts/mbp/home.nix
                        inputs.catppuccin.homeModules.catppuccin
                      ];
                    };
                  };
                }
              ];
            };

        };

        homeConfigurations = {
          "jschneider@buntu" = let
            username = "jschneider";
            system = "x86_64-linux";
          in
            inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs {
                inherit system;
                config = {allowUnfree = true;};
              };
              extraSpecialArgs = {
                inherit username system inputs;
              };
              modules = [
                ./hosts/buntu/home.nix
                inputs.catppuccin.homeModules.catppuccin
              ];
            };
        };
      };
    };
}
