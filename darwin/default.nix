# darwin/default.nix
{pkgs, ...}: {
  # System-wide configuration
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      showhidden = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    curl
    git
    vim
  ];

  # Enable fonts dir
  fonts.fontDir.enable = true;

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Configure hostname
  networking.hostName = "Jonathans-MacBook-Pro";

  # Used for backwards compatibility
  system.stateVersion = 4;
}
