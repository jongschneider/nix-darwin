{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../home/cli
    ../../home/git
    ../../home/nvim
    ../../home/zsh
  ];

  home = {
    username = "jschneider";
    homeDirectory = "/home/jschneider";
    stateVersion = "24.05";
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

    # Development extras
    inputs.ai-toolbox.packages.${pkgs.system}.appender
    gh
    git-open
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
    l = "ls -l";
    ".." = "cd ..";
    "..." = "cd ../..";
    grep = "rg";
    cat = "bat";
    top = "btm";
    du = "dust";
    ps = "procs";
    find = "fd";
  };
}