{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ../../home
  ];

  # Distinct tmux status bar (catppuccin macchiato palette, warm accent) to tell apart from MBP
  programs.tmux.extraConfig = lib.mkAfter ''
    set -g status-style "bg=#363a4f,fg=#cad3f5"
    set -g status-left "#[fg=#f5a97f,bold]#S #[fg=#cad3f5,nobold]#(gitmux -cfg ~/.gitmux.yml) "
    set -g status-right "#[fg=#363a4f,bg=#f5a97f,bold] mini #[default]"
    set -g window-status-current-format '*#[fg=#f5a97f]#W'
  '';

  # Ghostty terminfo for SSH sessions (TERM=xterm-ghostty)
  home.file.".terminfo/78/xterm-ghostty".source = config.lib.file.mkOutOfStoreSymlink "/Applications/Ghostty.app/Contents/Resources/terminfo/78/xterm-ghostty";
  home.file.".terminfo/67/ghostty".source = config.lib.file.mkOutOfStoreSymlink "/Applications/Ghostty.app/Contents/Resources/terminfo/67/ghostty";

  home.packages = with pkgs; [
    gh
    inetutils
    unrar # extract RAR archives
    wget
    xz # extract XZ archives
    zlib

    # Apps
    brave

    # Dev
    inputs.ai-toolbox.packages.${pkgs.stdenv.hostPlatform.system}.appender
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.amp
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.cursor-agent
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tuicr
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.handy
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
    git-open
    glow
    gum
    jqp
    lazydocker
    mkcert
    neofetch
    # nodejs-slim
    # nodePackages_latest.jsonlint
    redis
    repomix
    # yt-dlp # disabled: curl-impersonate checkPhase fails on macOS 15
  ];
}
