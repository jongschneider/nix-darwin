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
  home.file.".terminfo/78/xterm-ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "/Applications/Ghostty.app/Contents/Resources/terminfo/78/xterm-ghostty";
    force = true;
  };
  home.file.".terminfo/67/ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "/Applications/Ghostty.app/Contents/Resources/terminfo/67/ghostty";
    force = true;
  };

  home.packages = with pkgs; [
    inetutils
    xz # extract XZ archives
    zlib

    # Dev
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.handy
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.sandbox-runtime
    llama-cpp
    glow
    gum
    # nodejs-slim
    # nodePackages_latest.jsonlint
    repomix
    # yt-dlp # disabled: curl-impersonate checkPhase fails on macOS 15
  ];
}
