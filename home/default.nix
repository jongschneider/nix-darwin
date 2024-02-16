{ pkgs, config, lib, home-manager, ... }:

{

  imports = [
    ./kitty
    ./programs
    # ./vscode
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    username = "jschneider";
    homeDirectory = "/Users/jschneider";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      # Basics
      coreutils
      inetutils
      curl
      wget
      tree
      procs
      ffmpeg
      asciiquarium
      srt
      mysql

      du-dust # fancy version of `du`
      fd # fancy version of `find`
      mosh # wrapper for `ssh` that better and not dropping connections
      unrar # extract RAR archives
      xz # extract XZ archives
      zlib

      # Dev
      fh
      jqp
      go
      golangci-lint
      gotestsum
      nodejs_21
      git-open
      mkcert
      glow
      youtube-dl
      redis
      protobuf
      cpulimit
      neofetch
      
      # not sure I need... were migrated from brew
      x265
      x264
      svt-av1
      utf8proc
      speex
      snappy
      shared-mime-info
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
  };

}
