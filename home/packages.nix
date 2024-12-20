{pkgs, ...}: {
  home.packages = with pkgs; [
    # Basics
    # (nerdfonts.override {
    #   fonts = [
    #     "CascadiaCode"
    #     "FiraCode"
    #     "GeistMono"
    #     "Hack"
    #     "JetBrainsMono"
    #     "Meslo"
    #     "Monaspace"
    #     "NerdFontsSymbolsOnly"
    #     "Gohu"
    #     "CodeNewRoman"
    #   ];
    # })
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.geist-mono
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.symbols-only
    nerd-fonts.gohufont
    nerd-fonts.code-new-roman
    asciinema
    asciiquarium
    azure-cli
    coreutils
    curl
    du-dust # fancy version of `du`
    fastfetch
    fd # fancy version of `find`
    ffmpeg
    inetutils
    # mosh # wrapper for `ssh` that better and not dropping connections
    mariadb
    procs
    srt
    teleport
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
