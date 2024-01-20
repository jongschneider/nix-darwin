{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

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
      htop
      coreutils
      curl
      wget
      tree
      procs
      ripgrep
      ffmpeg
      asciiquarium

      # Dev
      gh
      fh
      lf
      jq
      jqp
      go
      golangci-lint
      gotestsum
      nodejs_21
      git-open
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    eza = {
      enable = true;
      enableAliases = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "Jonathan Schneider";
      userEmail = "jonathan.schneider@thetalake.com";

      difftastic.enable = true;
      difftastic.display = "side-by-side-show-both";
      difftastic.color = "always";

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

      extraConfig = {
        core.excludesfile = "/Users/jschneider/.gitignore";
        url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
        pull.rebase = true;
        push = { autoSetupRemote = true; };
      };
    };

    z-lua.enable = true;

    zsh = {
      enable = true;
      initExtra = ''
        PATH=$HOME/bin:$HOME/go/bin:$HOME/tools:$HOME/scripts:$PATH
      '';
      initExtraBeforeCompInit = ''
        PATH=$HOME/bin:$HOME/go/bin:$HOME/tools:$HOME/scripts:$PATH
      '';
      enableCompletion = true;
      autocd = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        # ls = "ls --color=auto -F";
        nixswitch = "darwin-rebuild switch --flake ~/.config/nix-darwin/";
        nixup = "pushd ~/.config/nix-darwin; nix flake update; nixswitch; popd";

        # Work
        localdev = "/Users/jschneider/code/localdev/localdev";
        runingester = "export INGESTER_ENV=.env && goi && ingester > tmp.txt";
        runintegrator = "goi && integrator  > tmp.txt";
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
    };

    alacritty = {
      enable = true;

      settings = {
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
