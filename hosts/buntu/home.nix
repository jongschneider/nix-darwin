{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../home/cli
    ../../home/git
    ../../home/nvim
    ../../home/packages.nix
    ../../home/zsh
  ];

  home = {
    username = "jschneider";
    homeDirectory = "/home/jschneider";
    stateVersion = "24.05";
  };

  xdg.configFile = {
    ghostty = {
      source = ../../home/ghostty;
    };
  };

  home.packages = with pkgs; [
    # Go development tools
    go_1_23
    gofumpt
    golangci-lint
    gotools
    delve

    # Essential CLI tools
    curl
    wget
    git
    tree
    htop
    bottom
    fd
    ripgrep

    # Container tools
    lazydocker

    # Development utilities
    tmux
    neofetch
    just

    # Neovim dependencies
    # Language servers
    lua-language-server
    nil
    bash-language-server
    marksman

    # Formatters
    stylua
    alejandra
    prettierd
    nodePackages.prettier

    # File management & navigation
    yazi
    fzf
    lazygit

    # Nix tools
    home-manager

    # Development extras
    inputs.ai-toolbox.packages.${pkgs.system}.appender
    gh
    git-open
    ghostty
    glow
    gum
    jqp
    mkcert
    protobuf
    repomix
  ];

  # Enable direnv for project environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Server-focused shell aliases
  home.shellAliases = {
    ll = "ls -la";
    la = "ls -la";
    ".." = "cd ..";
    "..." = "cd ../..";
    grep = "rg";
    cat = "bat";
    top = "btm";
    du = "dust";
    ps = "procs";
    find = "fd";
    v = "nvim";
  };
}