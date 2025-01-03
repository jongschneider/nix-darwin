{pkgs, ...}: {
  imports = [
    ../../home
  ];

  home.packages = with pkgs; [
    azure-cli
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
    protobuf
    redis
    rubocop
    ruby
    rubyPackages.rubocop-performance
    rubyPackages.solargraph
    sesh
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
