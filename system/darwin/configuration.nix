{ username }:

{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = false;
      builders-use-substitutes = false;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
        # "https://ghostty.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
      trusted-users = [ 
        "@wheel"
        "@admin" # This line is a prerequisite for linux-builder
        "@staff" 
        username 
      ];
      warn-dirty = false;
    };
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    #  https://nixcademy.com/2024/02/12/macos-linux-builder/
    linux-builder.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  # MacOS Configuration
  system = {
    defaults = {
      finder.AppleShowAllExtensions = true;
      finder.AppleShowAllFiles = true;
      finder._FXShowPosixPathInTitle = true;
      finder.ShowPathbar = true;
      finder.ShowStatusBar = true;
      # Use current directory as default search scope in Finder
      finder.FXDefaultSearchScope = "SCcf";
      NSGlobalDomain.InitialKeyRepeat = 14;
      NSGlobalDomain.KeyRepeat = 1;
      NSGlobalDomain.ApplePressAndHoldEnabled = false;
      # expand save dialog by default
      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
      # expand save dialog by default
      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
      # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
      NSGlobalDomain.AppleKeyboardUIMode = 3;
      # Enable subpixel font rendering on non-Apple LCDs
      NSGlobalDomain.AppleFontSmoothing = 2;
      dock.autohide = true;
      # Whether to automatically rearrange spaces based on most recent use
      dock.mru-spaces = false;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    stateVersion = 4;

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override {
        fonts = [ "GeistMono" ];
      })
    ];
  };

  homebrew = {
    enable = true;

    brews = [ "mas" ];

    casks = [
      "arc"
      "element"
      "httpie"
      "raycast"
      "discord"
      "notion"
      "orbstack"
      "spotify"
    ] ++ (
      # Handle work environment desktop packages
      if username == "haydenyoung"
      then [
        "microsoft-teams"
        "slack"
        "amazon-chime" # Comms
      ]
      else [
        "linear"
      ]
    );

    masApps = {
      # Safari Extentions
      "1Password for Safari" = 1569813296;
      "Dark Reader for Safari" = 1438243180;

      # Applications
      Keynote = 409183694;
      "Yubico Authenticator" = 1497506650;
    };
  };

  environment.pathsToLink = [ "/share/qemu" ];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  users.users.${username}.home = "/Users/${username}";

  services.yabai = {
    enable = true;
    config = {
      # default layout (can be bsp, stack or float)
      layout = "bsp";
      # new window spawns to the right if vertical split, or bottom if horizontal split
      window_placement = "second_child";

      top_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      window_gap = 12;

      window_opacity = "off";
      window_opacity_duration = 0.0;
      active_window_opacity = 1.0;
      normal_window_opacity = 0.9;

      # mouse settings
      # center mouse on window with focus
      mouse_follows_focus = "on";
      # modifier for clicking and dragging with mouse
      mouse_modifier = "alt";
      # set modifier + left-click drag to move window
      mouse_action1 = "move";
      # set modifier + right-click drag to resize window
      mouse_action2 = "resize";
      # when window is dropped in center of another window, swap them (on edges it will split it)
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      # ignore these apps
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Alfred Preferences$" manage=off
      yabai -m rule --add app="^Messages$" manage=off
      yabai -m rule --add app="^Music$" manage=off
      yabai -m rule --add app="Microsoft Teams$" manage=off
      yabai -m rule --add app="^CleanShot X$" manage=off
      yabai -m rule --add app="^CleanMyMac X$" manage=off
      yabai -m rule --add app="^1Password$" manage=off
      yabai -m rule --add app="^Raycast$" manage=off
      yabai -m rule --add app="^Ivory$" manage=off
      yabai -m rule --add app="^Finder$" manage=off
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # -- Changing Window Focus --
      # change window focus within space
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - h : yabai -m window --focus west
      alt - l : yabai -m window --focus east

      #change focus between external displays (left and right)
      alt - s: yabai -m display --focus west
      alt - g: yabai -m display --focus east

      # -- Modifying the Layout --

      # rotate layout clockwise
      shift + alt - r : yabai -m space --rotate 270

      # flip along y-axis
      shift + alt - y : yabai -m space --mirror y-axis

      # flip along x-axis
      shift + alt - x : yabai -m space --mirror x-axis

      # toggle window float
      shift + alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2


      # -- Modifying Window Size --

      # maximize a window
      shift + alt - m : yabai -m window --toggle zoom-fullscreen

      # balance out tree of windows (resize to occupy same area)
      shift + alt - e : yabai -m space --balance

      # -- Moving Windows Around --

      # swap windows
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - h : yabai -m window --swap west
      shift + alt - l : yabai -m window --swap east

      # move window and split
      ctrl + alt - j : yabai -m window --warp south
      ctrl + alt - k : yabai -m window --warp north
      ctrl + alt - h : yabai -m window --warp west
      ctrl + alt - l : yabai -m window --warp east

      # move window to display left and right
      shift + alt - s : yabai -m window --display west; yabai -m display --focus west;
      shift + alt - g : yabai -m window --display east; yabai -m display --focus east;


      # move window to prev and next space
      shift + alt - p : yabai -m window --space prev;
      shift + alt - n : yabai -m window --space next;

      # move window to space #
      shift + alt - 1 : yabai -m window --space 1;
      shift + alt - 2 : yabai -m window --space 2;
      shift + alt - 3 : yabai -m window --space 3;
      shift + alt - 4 : yabai -m window --space 4;
      shift + alt - 5 : yabai -m window --space 5;
      shift + alt - 6 : yabai -m window --space 6;
      shift + alt - 7 : yabai -m window --space 7;
    '';
  };
}
