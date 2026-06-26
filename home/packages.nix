{
  pkgs,
  lib,
  ...
}: let
  monolisa = pkgs.callPackage ./monolisa/default.nix {};
in {
  home.packages = with pkgs;
    [
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
      maple-mono.truetype-autohint
      maple-mono.NF
      maple-mono.NF-CN

      bottom
      fd # fancy version of `find`
      ffmpeg
      mariadb
      pam-reattach
      sesh
      trash-cli
    ]
    # On darwin, ollama is installed via homebrew (see darwin/homebrew.nix).
    # The nixpkgs ollama now requires the Xcode Metal toolchain to build MLX backends.
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      ollama
    ];

  xdg.configFile = {
    sesh = {
      source = ./sesh;
    };
  };
}
