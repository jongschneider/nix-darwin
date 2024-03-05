{
  pkgs,
  config,
  ...
}: {
  environment = {
    shells = with pkgs; [bash zsh];
    loginShell = pkgs.zsh;
    systemPackages = with pkgs; [
      # nixpkgs-fmt # nix code formatter
      # nil # nix LSP... testing this out.
      alejandra
      coreutils
      (import ../scripts/ff.nix {inherit pkgs;})
      (import ../scripts/gsquash.nix {inherit pkgs;})
      discord
      presenterm
      nurl
      manix
    ];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
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

  homebrew = import ./homebrew.nix // {enable = true;};

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # services.karabiner-elements.enable = true;

  # Necessary for using flakes on this system.
  nix = {
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["flakes" "nix-command"];
      substituters = ["https://nix-community.cachix.org"];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["@wheel"];
      warn-dirty = false;
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    # linux-builder.enable = true;

    # # This line is a prerequisite
    # trusted-users = [ "@admin" ];
  };

  nix.nixPath = [
    "$HOME/.nix-defexpr/channels"
  ];

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.bash.enable = true;
  programs.nix-index.enable = true;

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
}
