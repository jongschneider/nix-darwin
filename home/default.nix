{
  config,
  pkgs,
  lib,
  username,
  system,
  ...
}: {
  imports = [
    ./catppuccin
    ./cli
    ./git
    ./grc
    ./herdr
    ./hunk
    ./karabiner
    ./nvim
    ./packages.nix
    ./starship
    ./tmux
    # ./wezterm
    ./yazi
    ./zsh
  ];

  xdg.configFile = {
    ghostty = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
      source = ./ghostty;
    };

    "raycast/latest.rayconfig" = {
      source = ./raycast/latest.rayconfig;
    };
  };

  # Ghostty's native macOS build reads Application Support, not XDG_CONFIG_HOME.
  # Force replaces old imperative/Claude-created configs that can shadow this
  # file with broken Shift+Enter remaps such as ESC+CR or raw LF.
  home.file."Library/Application Support/com.mitchellh.ghostty/config" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    source = ./ghostty/config;
    force = true;
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    sessionVariables.EDITOR = "nvim";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "26.05";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
