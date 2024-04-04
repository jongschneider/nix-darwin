{pkgs, ...}: let
  flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
  lib = pkgs.lib;
in
  # https://nix-community.github.io/home-manager/options.html
  {
    programs = {
      htop.enable = true;
      ripgrep.enable = true;
      bottom.enable = true; # fancy version of `top` with ASCII graphs
      tealdeer.enable = true; # rust implementation of `tldr`
      gh.enable = true;
      # lf.enable = true;
      lf = {
        enable = true;
        settings = {
          preview = true;
          hidden = true;
          drawbox = true;
          icons = true;
          ignorecase = true;
          color256 = true;
          relativenumber = true;
        };
      };
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

      eza = {
        enable = true;
        # enableAliases = true;
        git = true;
        icons = true;
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

      lazygit = {
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

        ignores = [".direnv" ".envrc" "tmp.txt" "testout.txt"];

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

      # z-lua.enable = true;
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      zsh = {
        enable = true;
        initExtra = ''
          function gcpb(){
              git branch | grep \* | cut -d ' ' -f2 | pbcopy
          }
          nn () {
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
        '';

        enableCompletion = true;
        autocd = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          l = "eza";
          lll = "eza -l";
          la = "eza -a";
          lt = "eza --tree";
          lla = "eza -la";
          ll = "nn";

          nixcheck = "darwin-rebuild check --flake ~/.config/nix-darwin/";
          nixswitch = "darwin-rebuild switch --flake ~/.config/nix-darwin/";
          nixup = "pushd ~/.config/nix-darwin; nix flake update; nixswitch; popd";

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
      };

      alacritty = {
        enable = true;

        settings = {
          env.TERM = "xterm-256color";

          font = {
            # normal.family = "MesloLGS Nerd Font Mono";
            normal.family = "Hack Nerd Font Mono";
            # normal.family = "Monaspace Krypton Light";
            size = 13;
          };
          window = {
            opacity = 0.85;
            padding.x = 25;
            padding.y = 20;
            dynamic_padding = false;
            decorations = "buttonless";
          };
          cursor.style = {
            shape = "Beam";
            blinking = "On";
          };
        };
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          line_break = {
            disabled = false;
          };
          add_newline = false;
          palette = "tokyonight";
          palettes.tokyonight = {
            red = "#f7768e";
            orange = "#ff9e64";
            yellow = "#e0af68";
            light-green = "#9ece6a";
            green = "#73daca";
            turquoise = "#89ddff";
            light-cyan = "#b4f9f8";
            teal = "#2ac3de";
            cyan = "#7dcfff";
            blue = "#7aa2f7";
            magenta = "#bb9af7";
            white = "#c0caf5";
            light-gray = "#9aa5ce";
            parameters = "#cfc9c2";
            comment = "#565f89";
            black = "#414868";
            foreground = "#a9b1d6";
            background = "#1a1b26";
          };
        };
      };

      tmux = {
        enable = true;
        sensibleOnTop = true;
        baseIndex = 1;
        shortcut = "Space";
        aggressiveResize = true;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          sensible
          yank
          prefix-highlight
          {
            plugin = catppuccin;

            extraConfig = ''
              set -g @catppuccin_window_left_separator ""
              set -g @catppuccin_window_right_separator " "
              set -g @catppuccin_window_middle_separator " █"
              set -g @catppuccin_window_number_position "right"

              set -g @catppuccin_window_default_fill "number"
              set -g @catppuccin_window_default_text "#W"

              set -g @catppuccin_window_current_fill "number"
              set -g @catppuccin_window_current_text "#W"

              set -g @catppuccin_status_modules_right "directory user host session"
              set -g @catppuccin_status_left_separator  " "
              set -g @catppuccin_status_right_separator ""
              set -g @catppuccin_status_right_separator_inverse "no"
              set -g @catppuccin_status_fill "icon"
              set -g @catppuccin_status_connect_separator "no"

              set -g @catppuccin_directory_text "#{pane_current_path}"
            '';
          }
        ];
        extraConfig = ''
          # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
          set -g default-terminal "xterm-256color"
          set -ga terminal-overrides ",*256col*:Tc"
          set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
          set-environment -g COLORTERM "truecolor"

          # Set status bars to top
          set-option -g status-position top

          # Mouse works as expected
          set-option -g mouse on

          # Vim style pane selection
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # Start windows and panes at 1, not 0
          set -g base-index 1
          set -g pane-base-index 1
          set-window-option -g pane-base-index 1
          set-option -g renumber-windows on

          # Use Alt-arrow keys without prefix key to switch panes
          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D

          # Shift arrow to switch windows
          bind -n S-Left  previous-window
          bind -n S-Right next-window

          # Shift Alt vim keys to switch windows
          bind -n M-H previous-window
          bind -n M-L next-window

          # Resize panes
          bind -r S-left resize-pane -L 5
          bind -r S-down resize-pane -D 5
          bind -r S-up resize-pane -U 5
          bind -r S-right resize-pane -R 5

          # set vi-mode
          set-window-option -g mode-keys vi

          # vim style yank keybindings
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          # keybinding to make sure that when we split pane we are in the same cwd as the pane we came from
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
        '';
      };
    };
  }
