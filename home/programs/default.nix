{ pkgs, ... }:

# https://nix-community.github.io/home-manager/options.html
{
  programs = {
    htop.enable = true;
    ripgrep.enable = true;
    bottom.enable = true; # fancy version of `top` with ASCII graphs
    tealdeer.enable = true; # rust implementation of `tldr`
    gh.enable = true;
    lf.enable = true;
    jq.enable = true;

    thefuck = {
      enable = true;
      enableZshIntegration = true;
      enableInstantMode = true;
    };

    awscli = {
      enable = true;
      # TODO: add credentials here
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    # eza = {
    #   enable = true;
    #   enableAliases = true;
    #   git = true;
    #   icons = true;
    # };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };


    lazygit.enable = true;

    git = {
      enable = true;
      userName = "Jonathan Schneider";
      userEmail = "jonathan.schneider@thetalake.com";

      delta = {
        enable = true;
        options = {
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

      aliases = {
        a = "add";
        c = "commit";
        ca = "commit --amend";
        can = "commit --amend --no-edit";
        cl = "clone";
        cm = "commit -m";
        co = "checkout";
        cp = "cherry-pick";
        cpx = "cherry-pick -x";
        d = "diff";
        f = "fetch";
        fo = "fetch origin";
        fu = "fetch upstream";
        lg = "lazygit";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        pl = "pull";
        pr = "pull -r";
        ps = "push";
        psf = "push -f";
        rb = "rebase";
        rbi = "rebase -i";
        r = "remote";
        ra = "remote add";
        rr = "remote rm";
        rv = "remote -v";
        rs = "remote show";
        st = "status";
      };

      ignores = [ ".direnv" ".envrc" "tmp.txt" "testout.txt" ];

      extraConfig = {
        url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
        core.excludesfile = "/Users/jschneider/.gitignore";
        color.ui = true;
        # commit.gpgsign = true;
        diff.colorMoved = "zebra";
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
      };
    };

    nnn = {
      enable = true;
      package = pkgs.nnn.override { withNerdIcons = true; };
      plugins = {
        mappings = {
          K = "preview-tui";
        };
      };
    };

    z-lua.enable = true;

    zsh = {
      enable = true;
      initExtra = ''
        n () {
          if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
            echo "nnn is already running"
            return
          fi

          export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

          nnn -adeHo "$@"

          if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
          fi
        }
        PATH=$HOME/bin:$HOME/go/bin:$HOME/tools:$HOME/scripts:$PATH
        # Fig post block. Keep at the bottom of this file.
        [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
      '';

      enableCompletion = true;
      autocd = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "n";
        nixcheck = "darwin-rebuild check --flake ~/.config/nix-darwin/";
        nixswitch = "darwin-rebuild switch --flake ~/.config/nix-darwin/";
        nixup = "pushd ~/.config/nix-darwin; nix flake update; nixswitch; popd";

        # Work
        localdev = "/Users/jschneider/code/localdev/localdev";
        runingester = "export INGESTER_ENV=.env && goi && ingester > tmp.txt";
        runintegrator = "export INTEGRATOR_ENV=.env && goi && integrator  > tmp.txt";
        runemailpreprocessor = "ENV_FILE=preprocessor.env.localdev go run ./cmd/email_preprocessor/...";
        telcon = "tsh login --proxy=thetalake.teleport.sh --auth=google";
        colcon = "echo 'creating an ssh tunnel to dev collector via teleport...\ntsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com' && tsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com";
        goi = "go install ./... && go vet ./...";
        c = "code .";

        nixconf = "code /Users/jschneider/.config/nix-darwin";

        # More git aliases
        g = "git";
        ga = "git add";
        gs = "git status";
        gd = "git diff";
        gdt = "git difftool";
        gdlist = "git diff --name-status";
        gcm = "git commit -m";
        gco = "git checkout";
        gcob = "git checkout -b";
        gcom = "git checkout master && git pull";
        gignore = "c .git/info/exclude";
        glog = "git log --simplify-by-decoration --oneline --graph";
        glast = "git branch --sort=-committerdate | fzf --header 'Checkout Recent Branch' --preview 'git diff {1} --color=always' --preview-window down --bind 'ctrl-/:change-preview-window(down|hidden|),shift-up:preview-page-up,shift-down:preview-page-down' | xargs git checkout";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
      };
    };

    alacritty = {
      enable = true;

      settings = {
        env.TERM = "xterm-256color";

        font = {
          normal.family = "MesloLGS Nerd Font Mono";
          # normal.family = "Monaspace Krypton Light";
          size = 13;
        };

        cursor.style = {
          shape = "Beam";
          blinking = "On";
        };
      };

    };
  };
}
