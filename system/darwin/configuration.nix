{username}: {pkgs, ...}: {
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = false;
      builders-use-substitutes = false;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["@staff" username];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleFontSmoothing = 1;
        AppleShowAllExtensions = true;
        AppleKeyboardUIMode = 3;
      };
      dock = {
        autohide = true;
        tilesize = 46;
      };
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override {
        fonts = ["GeistMono"];
      })
    ];
  };

  homebrew = {
    enable = true;

    # brews = ["mas"];

    casks =
      [
        "arc"
        "discord"
        "element"
        "httpie"
        "notion"
        "orbstack"
        "raycast"
        "spotify"
      ]
      ++ (
        # Handle work environment desktop packages
        if username == "jschneider"
        then [
          # "microsoft-teams"
          # "slack"
          # "amazon-chime" # Comms
        ]
        else [
          # "linear"
        ]
      );

    # masApps = {
    #   # Safari Extentions
    #   "1Password for Safari" = 1569813296;
    #   "Dark Reader for Safari" = 1438243180;
    #
    #   # Applications
    #   Keynote = 409183694;
    #   "Yubico Authenticator" = 1497506650;
    # };
  };

  # environment.pathsToLink = ["/share/qemu"];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;

  users.users.${username}.home = "/Users/${username}";
}
