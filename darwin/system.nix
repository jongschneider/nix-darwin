{
  pkgs,
  system,
  lib,
  ...
}: let
  gtd = pkgs.callPackage ../scripts/gtd {};
  mike = pkgs.callPackage ../scripts/mike {};
in {
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

    # optimise store - disabled, let Determinate Nix handle it
    optimise.automatic = false;

    # Enable automatic garbage collection
    gc = {
      automatic = lib.mkDefault true;
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = system;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    enableCompletion = false; # Disable system-level compinit (oh-my-zsh handles it)
  };
  programs.nix-index.enable = true;

  # Raise default macOS file descriptor limits (default soft limit is 256)
  launchd.daemons.maxfiles = {
    command = "/bin/launchctl limit maxfiles 524288 524288";
    serviceConfig = {
      Label = "limit.maxfiles";
      RunAtLoad = true;
    };
  };

  system.stateVersion = 4;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Currently not working as a system service - using homebrew instead
  services.karabiner-elements.enable = false;

  # Basic system packages all machines should have
  environment.systemPackages = with pkgs; [
    (import ../scripts/git-bare-clone.nix {inherit pkgs;})
    (import ../scripts/wta.nix {inherit pkgs;})
    (import ../scripts/gsquash.nix {inherit pkgs;})
    bun
    alejandra
    ast-grep
    coreutils
    curl
    delve
    git
    gnumake
    go_1_25
    gofumpt
    golangci-lint
    golines
    gomodifytags
    gotests
    gotestsum
    gotools
    grc
    gtd
    ice-bar
    impl
    just
    lua
    luarocks
    lynx
    manix
    mike
    nil # nix LSP
    nurl
    sqlc
    sqlite
    vhs
    vim
    zig
    yazi
  ];
}
