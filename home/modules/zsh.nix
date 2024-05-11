{ pkgs, ...}:
{
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };

      # programs.jq.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

programs.nnn = {
        enable = true;
        package = pkgs.nnn.override {withNerdIcons = true;};
        extraPackages = with pkgs; [
          ffmpegthumbnailer
          mediainfo
        ];

        bookmarks = {
          a = "~/Applications";
          d = "~/Desktop";
          D = "~/Downloads";
          c = "~/code";
          i = "~/code/integrator";
          n = "~/code/ingester";
          N = "/Users/jschneider/.config/nix-darwin";
        };

        plugins = {
          src =
            (pkgs.fetchFromGitHub {
              owner = "jarun";
              repo = "nnn";
              rev = "v4.8";
              sha256 = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
            })
            + "/plugins";

          mappings = {
            c = "fzcd";
            d = "dragdrop";
            f = "fzopen";
            o = "launch";
            p = "preview-tui";
            v = "imgview";
          };
        };
      };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      directory.home_symbol = "🏠";
    };
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "aws" ];
      theme = "robbyrussell";
    };

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      s = "doppler run";
      ops = "op run --no-masking";

      cat = "bat";

      dc = "docker compose";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcl = "docker compose logs";
      dclf = "docker compose logs -f";
      dcc = "docker compose cp";
      dci = "docker compose inspect";
      dce = "docker compose exec";
      dcr = "docker compose restart";

      tf = "terraform";

      nb = "nix build --json --no-link --print-build-logs";
      watch = "viddy";

      wt = "git worktree";

          killmysql = "sudo pkill mysql";

          # Work
          localdev = "/Users/jschneider/code/localdev/localdev";
          runingester = "export INGESTER_ENV=.env && goi && ingester > tmp.txt";
          runintegrator = "export INTEGRATOR_ENV=.env && goi && integrator  > tmp.txt";
          runemailpreprocessor = "ENV_FILE=preprocessor.env.localdev go run ./cmd/email_preprocessor/...";
          telcon = "tsh login --proxy=thetalake.teleport.sh --auth=google";
          colcon = "echo 'creating an ssh tunnel to dev collector via teleport...\ntsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com' && tsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com";
          # goi = "go install ./... && go vet ./...";
          goi = "go install ./...";
          c = "code .";
          vim = "nvim";
          vi = "nvim";

          # tmux aliases
          ta = "tmux attach";
          tls = "tmux ls";
          tat = "tmux attach -t";
          tns = "tmux new-session -s";

          nixconf = "code /Users/jschneider/.config/nix-darwin";

          # More git aliases
          lg = "lazygit";
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

    initExtra = ''
      ${builtins.readFile ../../config/zsh/extraInit.zsh}
    '';
  };
}
