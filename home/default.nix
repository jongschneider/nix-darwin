# home/default.nix
{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "jschneider";
    homeDirectory = "/Users/jschneider";
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

  # home.username = "jschneider";
  # home.homeDirectory = "/Users/jschneider";
  # home.stateVersion = "23.11";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = with pkgs; [
    ripgrep
    fd
    tree
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Jonathan Schneider";
    userEmail = "your.email@example.com"; # Replace with your email
  };

  # Terminal configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "docker"];
    };
  };
}
