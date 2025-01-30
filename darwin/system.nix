{
  pkgs,
  system,
  ...
}: {
  # Base system configuration
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix = {
    package = pkgs.nix;

    nixPath = [
      # Support legacy workflows that use `<nixpkgs>` etc.
      "nixpkgs=${pkgs.path}"
    ];

    settings = {
      auto-optimise-store = false;
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

    # optimise store
    optimise.automatic = true;

    # Enable automatic garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    #  https://nixcademy.com/2024/02/12/macos-linux-builder/
    # linux-builder.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = system;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.nix-index.enable = true;

  system.stateVersion = 4;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Currently not working as a system service - using homebrew instead
  services.karabiner-elements.enable = false;

  # Basic system packages all machines should have
  environment.systemPackages = with pkgs; [
    (import ../scripts/git-bare-clone.nix {inherit pkgs;})
    (import ../scripts/gsquash.nix {inherit pkgs;})
    (import ../scripts/gtc.nix {inherit pkgs;})
    alejandra
    coreutils
    curl
    delve
    git
    gnumake
    go
    gofumpt
    golangci-lint
    golines
    gomodifytags
    gotests
    gotestsum
    gotools
    ice-bar
    impl
    just
    lua
    luarocks
    manix
    nil # nix LSP... testing this out.
    nixd
    nurl
    vim
    yazi
  ];
}
