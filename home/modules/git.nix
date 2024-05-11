{ work, pkgs, ... }:
let
  inherit (pkgs) stdenv;
in
{
  programs.git = {
    enable = true;
    userName = "Jonathan Schneider";
    userEmail = (
        if work
        then "jonathan.schneider@thetalake.com"
        else "CHANGE_ME"
        # else "22327045+hbjydev@users.noreply.github.com"
        );

    aliases = {
      a = "add";
      b = "branch";
      ch = "checkout";
      ci = "commit";
      cm = "commit -m";
      d = "diff";
      ds = "diff --staged";
      l = "log --pretty=oneline --abbrev-commit";
      p = "pull";
      pp = "push";
      s = "status -s";
      wt = "worktree";
    };

    ignores =
      if work then [
        ".devenv/"
        ".direnv/"
        ".envrc"
        "__pycache__/"
        ".env"
        "flake.nix"
        "flake.lock"
        "tmp.txt"
        "testout.txt"
      ] else [
        ".devenv/"
        ".direnv/"
        "__pycache__/"
      ];


    extraConfig = {
      # commit = {
      #   gpgsign = true;
      #   verbose = false;
      # };
      #
      # init.defaultBranch = "main";

      url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
      core.excludesfile = "/Users/jschneider/.gitignore";
      color.ui = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      merge.conflictstyle = "diff3";
      rebase.autoStash = true;
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      pull = {
        rebase = true;
      };

      # user.signingKey = (
      #   if work
      #   then "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdUGldjr+KGTEcc1XHlpNGRSvBeuPH2fBJz27+28Klw"
      #   else "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkhuhfzyg7R+O62XSktHufGmmhy6FNDi/NuPPJt7bI+"
      # );

    #   gpg = {
    #     format = "ssh";
    #     ssh = {
    #       program =
    #         if stdenv.isDarwin then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    #         else "${pkgs._1password-gui}/share/1password/op-ssh-sign";
    #     };
    #   };
    #
    #   credential = {
    #     "https://gitlab.zoodigital.com" = {
    #       helper = "${pkgs.glab}/bin/glab auth git-credential";
    #     };
    #   };
    };

    delta = {
      enable = true;
      options = {
        interactive = {
          keep-plus-minus-markers = false;
        };
        chameleon = {
              blame-code-style = "syntax";
              blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
              blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
              dark = true;
              file-added-label = "[+]";
              file-copied-label = "[==]";
              file-decoration-style = "#434C5E ul";
              file-modified-label = "[*]";
              file-removed-label = "[-]";
              file-renamed-label = "[->]";
              file-style = "#434C5E bold";
              hunk-header-style = "omit";
              keep-plus-minus-markers = true;
              line-numbers = true;
              line-numbers-left-format = " {nm:>1} │";
              line-numbers-left-style = "red";
              line-numbers-minus-style = "red italic black";
              line-numbers-plus-style = "green italic black";
              line-numbers-right-format = " {np:>1} │";
              line-numbers-right-style = "green";
              line-numbers-zero-style = "#434C5E italic";
              minus-emph-style = "bold red";
              minus-style = "bold red";
              plus-emph-style = "bold green";
              plus-style = "bold green";
              side-by-side = true;
              syntax-theme = "Nord";
              zero-style = "syntax";
            };
            features = "chameleon";
            side-by-side = true;
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --color-only --dark --paging=never";
          useConfig = false;
              showRandomTip = true;
              nerdFontsVersion = "2";
              showFileIcons = true;
              splitDiff = "auto";
        };
      };
    };
  };
}
