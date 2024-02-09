{ pkgs, config, ... }:

{
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    systemPackages = with pkgs; [
      nixpkgs-fmt # nix code formatter
      nil # nix LSP... testing this out.
      coreutils
      (import ../scripts/ff.nix { inherit pkgs; })
      (import ../scripts/gsquash.nix { inherit pkgs; })
    ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };

  fonts.fontDir.enable = true; # DANGER
  fonts.fonts = [
    (pkgs.nerdfonts.override {
      fonts = [
        "Meslo"
        "Monaspace"
      ];
    })
  ];

  homebrew = import ./homebrew.nix // { enable = true; };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.karabiner-elements.enable = true;

  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.bash.enable = true;
  # programs.fish.enable = true;

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

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # Homebrew stuff
  # homebrew = {
  #   enable = true;
  #   caskArgs.no_quarantine = true;
  #   global.brewfile = true;
  #   casks = [
  #     "raycast"
  #     "rectangle"
  #     "shottr"
  #     "karabiner-elements" # using the cask bc couldn't get  services.karabiner-elements to work correctly
  #   ];
  #   taps = [ ];
  #   brews = [ "trash" ];
  # };
}
