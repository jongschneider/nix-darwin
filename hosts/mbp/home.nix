{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../home
  ];

  home.packages = with pkgs; [
    azure-cli
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
    cpulimit
    fh
    git-open
    glow
    gum
    jqp
    lazydocker
    mkcert
    neofetch
    nodejs_23
    nodePackages_latest.jsonlint
    protobuf
    redis
    rubocop
    ruby
    rubyPackages.rubocop-performance
    rubyPackages.solargraph
    yt-dlp
    magic-wormhole

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
