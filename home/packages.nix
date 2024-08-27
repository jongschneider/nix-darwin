{pkgs, ...}: {
  home.packages = with pkgs; [
    # Basics
    (nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "JetBrainsMono"
        "FiraCode"
        "Monaspace"
        "Hack"
        "Meslo"
        "GeistMono"
      ];
    })
    coreutils
    inetutils
    curl
    wget
    tree
    procs
    # ffmpeg
    asciiquarium
    srt
    mysql
    fastfetch
    teleport_14

    du-dust # fancy version of `du`
    fd # fancy version of `find`
    mosh # wrapper for `ssh` that better and not dropping connections
    unrar # extract RAR archives
    xz # extract XZ archives
    zlib
    asciinema

    # Dev
    fh
    jqp
    ruby
    rubyPackages.solargraph
    rubyPackages.rubocop-performance
    rubocop
    nodejs_22
    git-open
    mkcert
    glow
    gum
    yt-dlp
    # youtube-dl
    redis
    protobuf
    cpulimit
    neofetch
    lazydocker
    sesh

    # not sure I need... were migrated from brew
    x265
    x264
    svt-av1
    utf8proc
    speex
    snappy
    # shared-mime-info
    rav1e
    pango

    # Useful nix related tools
    cachix # adding/managing alternative binary caches hosted by Cachix
    comma # run software from without installing it
    nix-output-monitor # get additional information while building packages
    nix-tree # interactively browse dependency graphs of Nix derivations
    nix-update # swiss-knife for updating nix packages
    node2nix # generate Nix expressions to build NPM packages
    statix # lints and suggestions for the Nix programming language
  ];
}
