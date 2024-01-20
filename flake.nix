{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;

        environment = {
          shells = with pkgs; [ bash zsh ];
          loginShell = pkgs.zsh;
          systemPackages = with pkgs; [
            nixpkgs-fmt # nix code formatter
            nil # nix LSP... testing this out.
            coreutils
            (import ./scripts/ff.nix { inherit pkgs; })
            (import ./scripts/gsquash.nix { inherit pkgs; })
          ];
          systemPath = [ "/opt/homebrew/bin" ];
          pathsToLink = [ "/Applications" ];
        };
        # nix.package = pkgs.nix;

        fonts.fontDir.enable = true; # DANGER
        fonts.fonts = [
          (pkgs.nerdfonts.override {
            fonts = [
              "Meslo"
              "Monaspace"
            ];
          })
        ];

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # MacOS Configuration
        system = {

          defaults = {
            finder.AppleShowAllExtensions = true;
            finder._FXShowPosixPathInTitle = true;
            finder.ShowPathbar = true;
            NSGlobalDomain.InitialKeyRepeat = 14;
            NSGlobalDomain.KeyRepeat = 1;
            dock.autohide = true;
          };

          # Used for backwards compatibility, please read the changelog before changing.
          stateVersion = 4;

          keyboard.enableKeyMapping = true;
          keyboard.remapCapsLockToEscape = true;
        };


        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";


        # Add ability to used TouchID for sudo authentication
        security.pam.enableSudoTouchIdAuth = true;

        users.users.jschneider = {
          name = "jschneider";
          home = "/Users/jschneider";
        };

        # Homebrew stuff
        homebrew = {
          enable = true;
          caskArgs.no_quarantine = true;
          global.brewfile = true;
          casks = [
            "rectangle"
            "shottr"
            "karabiner-elements" # using the cask bc couldn't get  services.karabiner-elements to work correctly
          ];
          taps = [ ];
          brews = [ "trash" ];
        };
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Jonathans-MacBook-Pro
      darwinConfigurations."Jonathans-MacBook-Pro" =
        nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jschneider = import ./home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Jonathans-MacBook-Pro".pkgs;
    };
}
