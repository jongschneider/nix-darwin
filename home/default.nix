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
    ghostty = {
      source = ./ghostty;
    };

    "raycast/latest.rayconfig" = {
      source = ./raycast/latest.rayconfig;
    };
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
    stateVersion = "23.11";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
