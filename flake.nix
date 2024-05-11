{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Soothing pastel theme for Nix
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    catppuccin,
    ...
  }: {
    darwinConfigurations."Jonathans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/work/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jschneider = {
            imports = [
              ./hosts/work/home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
          };
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Jonathans-MacBook-Pro".pkgs;
  };
}
