{
  work,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenv;
in {
  programs.git = {
    enable = true;

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
      if work
      then [
        ".devenv/"
        ".direnv/"
        ".envrc"
        "__pycache__/"
        ".env"
        ".ropeproject/"
        "flake.nix"
        "flake.lock"
      ]
      else [
        ".devenv/"
        ".direnv/"
        "__pycache__/"
        ".ropeproject/"
      ];

    userName = "Jonathan Schneider";
    userEmail = "jonathan.schneider@thetalake.com";

    extraConfig = {
      # commit = {
      #   gpgsign = true;
      #   verbose = false;
      # };

      init.defaultBranch = "main";

      rebase = {
        autoStash = true;
      };

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

      # gpg = {
      #   format = "ssh";
      #   ssh = {
      #     program =
      #       if stdenv.isDarwin
      #       then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
      #       else "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      #   };
      # };
      #
      # credential = {
      #   "https://gitlab.zoodigital.com" = {
      #     helper = "${pkgs.glab}/bin/glab auth git-credential";
      #   };
      # };
    };

    delta = {
      enable = true;
      options = {
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#067a00";
          hunk-header-style = "file line-number syntax";
        };
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
        };
      };
    };
  };
}
