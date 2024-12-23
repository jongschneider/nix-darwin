# home/default.nix
{pkgs, ...}: {
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
    userEmail = "jonathan.schneider@thetalake.com";
  };

  # Terminal configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "docker"];
    };
  };
}
