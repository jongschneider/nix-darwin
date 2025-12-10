{pkgs, ...}: {
  imports = [
    ./completions/wsm.nix
  ];
  programs = {
    zsh = {
      enable = true;
      initContent = ''
            function gcpb(){
                git branch | grep \* | cut -d ' ' -f2 | pbcopy
            }
            nn () {
              if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
                echo "nnn is already running"
                return
              fi

              export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

              nnn -aeHo "$@"
              # nnn -adeHo "$@"

              if [ -f "$NNN_TMPFILE" ]; then
                . "$NNN_TMPFILE"
                rm -f "$NNN_TMPFILE" > /dev/null
              fi
            }

            function yy() {
                local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
                yazi "$@" --cwd-file="$tmp"
                if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                    cd -- "$cwd"
                fi
                rm -f -- "$tmp"
            }

            ai() {
              opencode -m github-copilot/gpt-5-mini run "$@" 2>&1 | ${pkgs.glow}/bin/glow
            }

          wtp () {
              CURRENT_WT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
              git push -u origin "$CURRENT_WT_BRANCH" --force-with-lease
          }
            PATH=$HOME/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/tools:$HOME/scripts:$PATH
        eval "$(gbm shell-integration)"

        # Enable grc aliases
        [[ -s "${pkgs.grc}/etc/grc.zsh" ]] && source "${pkgs.grc}/etc/grc.zsh"
      '';
      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
      ];
      oh-my-zsh.enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        l = "yy";
        cl = "clear";
        ccd = "claude --dangerously-skip-permissions";

        nixcheck = "darwin-rebuild check --flake ~/.config/nix-darwin/";
        nixswitch = "darwin-rebuild switch --flake ~/.config/nix-darwin/";
        nixup = "pushd ~/.config/nix-darwin; nix flake update; nixswitch; popd";

        killmysql = "sudo pkill mysql";

        # Work
        localdev = "/Users/jschneider/Developer/localdev/localdev";
        runingester = "(INGESTER_ENV=.env && goi && ingester) 2>&1 | tee tmp.log";
        runintegrator = "(INTEGRATOR_ENV=.env && goi && integrator) 2>&1 | grc cat | tee tmp.log";
        runemailpreprocessor = "ENV_FILE=preprocessor.env.localdev go run ./cmd/email_preprocessor/...";
        telcon = "tsh login --proxy=thetalake.teleport.sh --auth=google";
        colcon = "echo 'creating an ssh tunnel to dev collector via teleport...\ntsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com' && tsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com";
        goi = "go install ./...";
        c = "code .";
        v = "nvim";
        vi = "nvim";
        vim = "nvim";

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
        gignore = "v .git/info/exclude";
        glog = "git log --simplify-by-decoration --oneline --graph";
        glast = "git branch --sort=-committerdate | fzf --header 'Checkout Recent Branch' --preview 'git diff {1} --color=always' --preview-window down --bind 'ctrl-/:change-preview-window(down|hidden|),shift-up:preview-page-up,shift-down:preview-page-down' | xargs git checkout";
        wt = "git worktree";
        sc = "sesh connect \"$(
  sesh list -i | gum filter --no-strip-ansi --limit 1 --placeholder 'Choose a session' --height 50 --prompt='⚡'
)\"";
      };
    };
  };
}
