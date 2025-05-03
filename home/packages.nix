{pkgs, ...}: let
  monolisa = pkgs.callPackage ./monolisa/default.nix {};
in {
  home.packages = with pkgs; [
    monolisa
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
    nerd-fonts.victor-mono

    bottom
    fastfetch
    fd # fancy version of `find`
    ffmpeg
    lazydocker
    mariadb
    nushell
    ollama
    pam-reattach
    pipx
    ripgrep
    sesh
    tree
    vectorcode

    # Useful nix related tools
    cachix # adding/managing alternative binary caches hosted by Cachix
    comma # run software from without installing it
    nix-output-monitor # get additional information while building packages
    nix-tree # interactively browse dependency graphs of Nix derivations
    nix-update # swiss-knife for updating nix packages
    node2nix # generate Nix expressions to build NPM packages
    statix # lints and suggestions for the Nix programming language
  ];

  xdg.configFile = {
    sesh = {
      source = ./sesh;
    };
  };
}
