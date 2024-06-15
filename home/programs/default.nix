{pkgs, ...}: let
  flavor = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
  lib = pkgs.lib;
in
  # https://nix-community.github.io/home-manager/options.html
  {
    # catppuccin = {
    #   enable = true;
    #   # flavor = "mocha";
    #   flavor = "frappe";
    # };
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
      # yazi = {
      #   enable = true;
      #   # catppuccin.enable = true;
      # };
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
        catppuccin.enable = true;
      };

      eza = {
        enable = true;
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
        catppuccin.enable = true;
        enableZshIntegration = true;
      };

      lazygit = {
        enable = true;
        # catppuccin.enable = true;
        catppuccin = {
          enable = true;
          flavor = "frappe";
        };
        settings = {
          git = {
            paging = {
              colorArg = "always";
              pager = "delta --color-only --dark --paging=never";
              useConfig = false;
              showRandomTip = true;
              nerdFontsVersion = "2";
              showFileIcons = true;
              # splitDiff = "auto";
              splitDiff = "always";
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
          catppuccin.enable = true;
          options = {
            # chameleon = {
            #   blame-code-style = "syntax";
            #   blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
            #   blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
            #   dark = true;
            #   file-added-label = "[+]";
            #   file-copied-label = "[==]";
            #   file-decoration-style = "#434C5E ul";
            #   file-modified-label = "[*]";
            #   file-removed-label = "[-]";
            #   file-renamed-label = "[->]";
            #   file-style = "#434C5E bold";
            #   hunk-header-style = "omit";
            #   keep-plus-minus-markers = true;
            #   line-numbers = true;
            #   line-numbers-left-format = " {nm:>1} │";
            #   line-numbers-left-style = "red";
            #   line-numbers-minus-style = "red italic black";
            #   line-numbers-plus-style = "green italic black";
            #   line-numbers-right-format = " {np:>1} │";
            #   line-numbers-right-style = "green";
            #   line-numbers-zero-style = "#434C5E italic";
            #   minus-emph-style = "bold red";
            #   minus-style = "bold red";
            #   plus-emph-style = "bold green";
            #   plus-style = "bold green";
            #   side-by-side = true;
            #   syntax-theme = "Nord";
            #   zero-style = "syntax";
            # };
            # features = "chameleon";
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
          v = "/Users/jschneider/Developer";
          i = "/Users/jschneider/Developer/integrator";
          n = "/Users/jschneider/Developer/ingester";
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
        # options = ["--cmd cd" "--hook pwd"];
        options = ["--hook pwd"];
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

          wtp () {
              CURRENT_WT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
              git push -u origin "$CURRENT_WT_BRANCH" --force-with-lease
          }
            PATH=$HOME/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/tools:$HOME/scripts:$PATH
        '';
        oh-my-zsh.enable = true;
        enableCompletion = true;
        autocd = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        syntaxHighlighting.catppuccin.enable = true;
        shellAliases = {
          # l = "eza";
          # lll = "eza -l";
          # la = "eza -a";
          # lt = "eza --tree";
          # lla = "eza -la";
          # ll = "nn";
          # ll = "yazi";

          # y = "yy";
          l = "yy";
          zi = "cdi";
          cl = "clear";

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
          gignore = "c .git/info/exclude";
          glog = "git log --simplify-by-decoration --oneline --graph";
          glast = "git branch --sort=-committerdate | fzf --header 'Checkout Recent Branch' --preview 'git diff {1} --color=always' --preview-window down --bind 'ctrl-/:change-preview-window(down|hidden|),shift-up:preview-page-up,shift-down:preview-page-down' | xargs git checkout";
          wt = "git worktree";
          # wtp = 
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
            opacity = 0.97;
            padding.x = 2;
            padding.y = 2;
            dynamic_padding = true;
            dynamic_title = true;
            decorations = "buttonless";
          };
          cursor.style = {
            shape = "Beam";
            blinking = "On";
          };
        };
      };

      wezterm = {
        enable = true;
        # extraConfig = ''''
      };

      starship = {
        enable = true;
        catppuccin = {
          enable = true;
          # flavor = "latte";
          # flavor = "frappe";
          # flavor = "macchiato";
          flavor = "mocha";
        };
        enableZshIntegration = true;
        settings = {
          # format = "$os$git_branch$git_status$c$rust$golang$nodejs$php$java$kotlin$haskell$python$docker_context$line_break$character ";
          # format = "[](surface0)$os$username[](bg:peach fg:surface0)$directory[](fg:peach bg:green)$git_branch$git_status[](fg:green bg:teal)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:teal)$line_break$character ";
          # format = "[](surface0)$os$username[](bg:surface0 fg:text)$directory[](bg:surface0 fg:text)$git_branch$git_status[](bg:surface0 fg:text)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](surface0)$line_break$character ";
          # format = "$os$username[](fg:text)$directory[](fg:text)$git_branch$git_status[](fg:text)$c$rust$golang$nodejs$php$java$kotlin$haskell$python$line_break$character ";
          format = "$os$username$directory$git_branch$git_status$c$rust$golang$nodejs$php$java$kotlin$haskell$python$line_break$character ";
          os = {
            disabled = false;
            # style = "bg:surface0 fg:text";
            style = "fg:text";
          };

          os.symbols = {
            NixOS = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Fedora = "󰣛";
            Macos = "󰀵";
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            # Raspbian = "󰐿";
            # Mint = "󰣭";
            # Macos = "";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            # Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
          };

          username = {
            show_always = true;
            # style_user = "bg:surface0 fg:text";
            # style_root = "bg:surface0 fg:text";
            style_user = "fg:text";
            style_root = "fg:text";
            format = "[ $user ]($style)";
          };

          directory = {
            # style = "fg:mantle bg:peach";
            # style = "bg:surface0 fg:peach";
            truncation_length = 100;
            truncate_to_repo = false;
            style = "fg:peach";
            format = "[](fg:text)[ $path ]($style)";
            # truncation_length = 3;
            # truncate_to_repo = true;
            # truncation_symbol = "…/";
            # truncation_length = 8;
            truncation_symbol = "…/";
          };

          directory.substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = "󰝚 ";
            "Pictures" = " ";
            "Developer" = "󰲋 ";
          };

          git_branch = {
            # symbol = "";
            # style = "bg:teal";
            symbol = "";
            # style = "bg:surface0 fg:green";
            style = "fg:green";
            # format = "[[ $symbol $branch ](fg:base bg:green)]($style)";
            format = "[](fg:text)[ $symbol $branch ]($style)";
          };

          git_status = {
            # style = "bg:teal";
            # format = "[[($all_status$ahead_behind )](fg:base bg:green)]($style)";
            # style = "bg:surface0 fg:green";
            style = "fg:green";
            format = "[($all_status$ahead_behind )]($style)";
          };

          time = {
            disabled = false;
            time_format = "%R";
            style = "bg:peach";
            format = "[[  $time ](fg:mantle bg:purple)]($style)";
          };

          nodejs = {
            symbol = "";
            # style = "bg:teal";
            # format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
            # style = "bg:surface0 fg:teal";
            style = "fg:teal";
            format = "[](fg:text)[ $symbol( $version) ]($style)";
          };

          rust = {
            # symbol = "";
            # style = "bg:teal";
            # format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
            # style = "bg:surface0 fg:teal";
            style = "red bold";
            format = "[](fg:text) [$symbol( $version)]($style)";
          };

          golang = {
            symbol = "󰟓";
            # style = "bg:teal";
            # format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
            # style = "bg:surface0 fg:teal";
            style = "fg:teal";
            format = "[](fg:text)[ $symbol( $version) ]($style)";
          };

          python = {
            symbol = "";
            # style = "bg:teal";
            # format = "[[ $symbol( $version) ](fg:base bg:teal)]($style)";
            # style = "bg:surface0 fg:teal";
            style = "fg:teal";
            format = "[](fg:text)[ $symbol( $version) ]($style)";
          };

          docker_context = {
            symbol = "";
            style = "bg:mantle";
            # format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
            format = "[[ $symbol( $context) ](fg:base bg:blue)]($style)";
          };
          character = {
            # success_symbol = "[](maroon)";
            # error_symbol = "[](red)";
            # vimcmd_symbol = "[](green)";
            # success_symbol = "[󰘍](maroon)";
            # error_symbol = "[󰘍](red)";
            # vimcmd_symbol = "[󰘍](green)";
            success_symbol = "[](maroon)";
            error_symbol = "[](red)";
            vimcmd_symbol = "[](green)";
          };
          line_break = {
            disabled = false;
          };
          add_newline = false;
        };
      };

      neovim = {
        enable = true;
        # defaultEditor = true;
        extraLuaConfig = ''
          require('user')
        '';
        extraPackages = [
          # Included for nil_ls
          pkgs.cargo
          # Included to build telescope-fzf-native.nvim
          pkgs.cmake
        ];
        withNodeJs = true;
        withPython3 = true;
        withRuby = true;
        vimdiffAlias = true;
      };

      tmux = import ./tmux.nix {inherit pkgs;};
      # tmux = {
      #   enable = true;
      #   # catppuccin = {
      #   #   enable = true;
      #   #   extraConfig = ''
      #   #     # set -g @catppuccin_window_left_separator ""
      #   #     # set -g @catppuccin_window_right_separator " "
      #   #     # set -g @catppuccin_window_middle_separator " █"
      #   #     # set -g @catppuccin_window_number_position "right"
      #   #     # set -g @catppuccin_window_default_fill "number"
      #   #     # set -g @catppuccin_window_default_text "#W"
      #   #     # set -g @catppuccin_window_current_fill "number"
      #   #     # set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
      #   #     # set -g @catppuccin_status_modules_right "directory meetings date_time"
      #   #     # set -g @catppuccin_status_modules_left "session"
      #   #     # set -g @catppuccin_status_left_separator  " "
      #   #     # set -g @catppuccin_status_right_separator " "
      #   #     # set -g @catppuccin_status_right_separator_inverse "no"
      #   #     # set -g @catppuccin_status_fill "icon"
      #   #     # set -g @catppuccin_status_connect_separator "no"
      #   #     # set -g @catppuccin_directory_text "#{b:pane_current_path}"
      #   #     # set -g @catppuccin_date_time_text "%H:%M"
      #   #   '';
      #   # };
      #   sensibleOnTop = true;
      #   baseIndex = 1;
      #   shortcut = "b";
      #   aggressiveResize = true;
      #   plugins = with pkgs.tmuxPlugins; [
      #     vim-tmux-navigator
      #     sensible
      #     yank
      #     resurrect # persist tmux sessions after computer restart
      #     continuum # automatically saves sessions for you every 15 minutes
      #     prefix-highlight
      #     tokyo-night-tmux
      #   ];
      #   extraConfig = ''
      #     # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      #     set -g default-terminal "xterm-256color"
      #     set -ga terminal-overrides ",*256col*:Tc"
      #     set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      #     set-environment -g COLORTERM "truecolor"
      #
      #     # Set status bars to top
      #     # set-option -g status-position top
      #
      #     # Mouse works as expected
      #     set-option -g mouse on
      #
      #     # Vim style pane selection
      #     bind h select-pane -L
      #     bind j select-pane -D
      #     bind k select-pane -U
      #     bind l select-pane -R
      #
      #     # Start windows and panes at 1, not 0
      #     set -g base-index 1
      #     set -g pane-base-index 1
      #     set-window-option -g pane-base-index 1
      #     set-option -g renumber-windows on
      #
      #     # Use Alt-arrow keys without prefix key to switch panes
      #     bind -n M-Left select-pane -L
      #     bind -n M-Right select-pane -R
      #     bind -n M-Up select-pane -U
      #     bind -n M-Down select-pane -D
      #
      #     # Shift arrow to switch windows
      #     bind -n S-Left  previous-window
      #     bind -n S-Right next-window
      #
      #     # Shift Alt vim keys to switch windows
      #     bind -n M-H previous-window
      #     bind -n M-L next-window
      #
      #     # Remap the split pane
      #     unbind %
      #     bind | split-window -h
      #
      #     unbind '"'
      #     bind - split-window -v
      #     # Resize panes
      #     bind -r h resize-pane -L 5
      #     bind -r j resize-pane -D 5
      #     bind -r k resize-pane -U 5
      #     bind -r l resize-pane -R 5
      #
      #     # bind -r S-left resize-pane -L 5
      #     # bind -r S-down resize-pane -D 5
      #     # bind -r S-up resize-pane -U 5
      #     # bind -r S-right resize-pane -R 5
      #
      #     # set vi-mode
      #     set-window-option -g mode-keys vi
      #
      #     bind -r m resize-pane -Z
      #
      #     # vim style yank keybindings
      #     bind-key -T copy-mode-vi v send-keys -X begin-selection
      #     bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      #     bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      #
      #     # keybinding to make sure that when we split pane we are in the same cwd as the pane we came from
      #     bind '"' split-window -v -c "#{pane_current_path}"
      #     bind % split-window -h -c "#{pane_current_path}"
      #
      #     # auto kill pane when closing
      #     # set -g @catppuccin_flavour 'mocha'
      #
      #     set -g @tokyo-night-tmux_show_datetime 0
      #     set -g @tokyo-night-tmux_show_path 1
      #     set -g @tokyo-night-tmux_path_format relative
      #     set -g @tokyo-night-tmux_window_id_style dsquare
      #     set -g @tokyo-night-tmux_window_id_style dsquare
      #     set -g @tokyo-night-tmux_show_git 0bind-key x kill-pane
      #   '';
      # };
    };
  }
