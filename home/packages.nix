{pkgs, ...}: {
  home.packages = with pkgs; [
    # Basics
    (nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "FiraCode"
        "GeistMono"
        "Hack"
        "JetBrainsMono"
        "Meslo"
        "Monaspace"
        "NerdFontsSymbolsOnly"
      ];
    })
    asciinema
    asciiquarium
    coreutils
    curl
    du-dust # fancy version of `du`
    fastfetch
    fd # fancy version of `find`
    inetutils
    mosh # wrapper for `ssh` that better and not dropping connections
    mysql
    procs
    srt
    teleport_14
    tree
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
    nodejs_22
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
