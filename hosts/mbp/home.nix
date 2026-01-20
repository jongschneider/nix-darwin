{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../home
  ];

  programs.git.settings.user = {
    name = "jonathan-schneider-tl";
    email = "jonathan.schneider@thetalake.com";
  };

  home.packages = with pkgs; [
    # azure-cli # disabled due to azure-multiapi-storage build failure
    gh
    inetutils
    # mosh # wrapper for `ssh` that better and not dropping connections
    procs
    srt
    teleport
    unrar # extract RAR archives
    wget
    xz # extract XZ archives
    zlib

    # Dev
    inputs.ai-toolbox.packages.${pkgs.system}.appender
    inputs.llm-agents.packages.${pkgs.system}.cursor-agent
    cpulimit
    fh
    git-open
    glow
    gum
    jqp
    lazydocker
    mkcert
    # neofetch # disabled due to ueberzug dependency not building on macOS
    oapi-codegen
    # nodejs-slim
    # nodePackages_latest.jsonlint
    presenterm
    protobuf
    redis
    repomix
    rubocop
    ruby
    # rubyPackages.rubocop-performance
    # rubyPackages.solargraph
    # uv
    pipx
    yt-dlp

    # not sure I need... were migrated from brew
    pango
    rav1e
    snappy
    speex
    svt-av1
    utf8proc
    x264
    x265
  ];
}
