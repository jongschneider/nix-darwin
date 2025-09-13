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

  # Set zsh as default shell
  programs.zsh.enable = true;

  xdg.configFile = {
    "albert/albert.conf" = {
      text = ''
        [General]
        hotkey=Alt+Space
        showTray=false
        telemetry=false

        [org.albert.extension.applications]
        enabled=true

        [org.albert.extension.calculator]
        enabled=true

        [org.albert.extension.files]
        enabled=true

        [org.albert.extension.terminal]
        enabled=true

        [org.albert.extension.websearch]
        enabled=true
      '';
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

    # Desktop applications
    albert

    # Nix tools
    home-manager

    # Development extras
    inputs.ai-toolbox.packages.${pkgs.system}.appender
    gh
    git-open
    kitty
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