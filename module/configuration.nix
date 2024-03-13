{username}: {
  nixpkgs,
  pkgs,
  lib,
  ...
}: {
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

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  environment = {
    shells = with pkgs; [bash zsh];
    loginShell = pkgs.zsh;
    systemPackages = with pkgs; [
      # nixpkgs-fmt # nix code formatter
      # nil # nix LSP... testing this out.
      alejandra
      coreutils
      (import ./scripts/ff.nix {inherit pkgs;})
      (import ./scripts/gsquash.nix {inherit pkgs;})
      discord
      presenterm
      nurl
      manix
    ];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };

  homebrew = import ./homebrew.nix // {enable = true;};

  programs.fish.enable = true;
  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
}
