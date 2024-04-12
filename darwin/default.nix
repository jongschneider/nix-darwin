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
      nil # nix LSP... testing this out.
      alejandra
      coreutils
      gnumake
      (import ../scripts/ff.nix {inherit pkgs;})
      (import ../scripts/gsquash.nix {inherit pkgs;})
      discord
      presenterm
      nurl
      manix
      delve
      go
      gofumpt
      gomodifytags
      impl
      golangci-lint
      gotools
      gotests
      gotestsum
      golines
      # ruby
      # ruby_3_3
      # rubyPackages.solargraph
      # rubyPackages.rubocop-performance
      # rubocop
    ];
    systemPath = ["/opt/homebrew/bin" "/Users/jschneider/go/bin"];
    pathsToLink = ["/Applications"];
  };

  # fonts.fontDir.enable = true; # DANGER
  # fonts.fonts = [
  #   (pkgs.nerdfonts.override {fonts = ["Hack" "Monaspace" "Meslo"];})
  # ];

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
      trusted-users = [
        "@wheel"
        "@admin" # This line is a prerequisite for linux-builder
      ];
      warn-dirty = false;
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    #  https://nixcademy.com/2024/02/12/macos-linux-builder/
    linux-builder.enable = true;
  };

  nix.nixPath = [
    # Support legacy workflows that use `<nixpkgs>` etc.
    "nixpkgs=${pkgs.path}"
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
      NSGlobalDomain.ApplePressAndHoldEnabled = false;
      dock.autohide = true;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    stateVersion = 4;

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
