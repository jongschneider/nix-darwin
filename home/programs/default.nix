{pkgs, ...}:
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
      plugins = {
        mappings = {
          K = "preview-tui";
        };
        src = pkgs.nnn + "/plugins";
      };
      bookmarks = {
        a = "~/Applications";
        d = "~/Desktop";
        D = "~/Downloads";
        c = "~/code";
        i = "~/code/integrator";
        n = "~/code/ingester";
        N = "/Users/jschneider/.config/nix-darwin";
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
        l = "eza";
        lll = "eza -l";
        la = "eza -a";
        lt = "eza --tree";
        lla = "eza -la";
        ll = "n";
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
    # starship = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   settings = {
    #     add_newline = false;
    #   };
    # };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "[](color_orange)\$os\$username\[](bg:color_yellow fg:color_orange)\$directory\[](fg:color_yellow bg:color_aqua)\$git_branch\$git_status\[](fg:color_aqua bg:color_blue)\$c\$rust\$golang\$nodejs\$php\$java\$kotlin\$haskell\$python\[](fg:color_blue bg:color_bg3)\$docker_context\[](fg:color_bg3 bg:color_bg1)\$time\[ ](fg:color_bg1)\$line_break$character ";

        palette = "gruvbox_dark";

        palettes.gruvbox_dark = {
          color_fg0 = "#fbf1c7";
          color_bg1 = "#3c3836";
          color_bg3 = "#665c54";
          color_blue = "#458588";
          color_aqua = "#689d6a";
          color_green = "#98971a";
          color_orange = "#d65d0e";
          color_purple = "#b16286";
          color_red = "#cc241d";
          color_yellow = "#d79921";
        };

        os = {
          disabled = false;
          style = "bg:color_orange fg:color_fg0";
        };

        os.symbols = {
          NixOS = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Fedora = "󰣛";
          Macos = "󰀵";
        };

        username = {
          show_always = true;
          style_user = "bg:color_orange fg:color_fg0";
          style_root = "bg:color_orange fg:color_fg0";
          format = "[ $user ]($style)";
        };

        directory = {
          style = "fg:color_fg0 bg:color_yellow";
          format = "[ $path ]($style)";
          truncation_length = 3;
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
          symbol = "";
          style = "bg:color_aqua";
          format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
        };

        git_status = {
          style = "bg:color_aqua";
          format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:color_bg1";
          format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        python = {
          symbol = "";
          style = "bg:color_blue";
          format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:color_bg3";
          format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        line_break = {
          disabled = false;
        };

        character = {
          disabled = false;
          success_symbol = "[](bold fg:color_green)";
          error_symbol = "[](bold fg:color_red)";
          vimcmd_symbol = "[](bold fg:color_green)";
          vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
          vimcmd_replace_symbol = "[](bold fg:color_purple)";
          vimcmd_visual_symbol = "[](bold fg:color_yellow)";
        };
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
      ];
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      vimdiffAlias = true;
    };

    tmux = {
      enable = true;
      sensibleOnTop = true;
      baseIndex = 1;
      shortcut = "l";
      aggressiveResize = true;
      plugins = with pkgs; [{
        plugin = tmuxPlugins.catppuccin;
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
        # extraConfig = ''
        #   set -g @catppuccin_window_left_separator "█"
        #   set -g @catppuccin_window_left_separator "█"
        #   set -g @catppuccin_window_right_separator "█ "
        #   set -g @catppuccin_window_number_position "right"
        #   set -g @catppuccin_window_middle_separator "  █"

        #   set -g @catppuccin_window_default_fill "number"

        #   set -g @catppuccin_window_current_fill "number"
        #   set -g @catppuccin_window_current_text "#{pane_current_path}"

        #   set -g @catppuccin_status_modules_right "application session date_time"
        #   set -g @catppuccin_status_left_separator  ""
        #   set -g @catppuccin_status_right_separator " "
        #   set -g @catppuccin_status_right_separator_inverse "yes"
        #   set -g @catppuccin_status_fill "all"
        #   set -g @catppuccin_status_connect_separator "no"
        # '';
        # extraConfig = ''
        #   set -g @catppuccin_window_status_enable "yes"
        #   set -g @catppuccin_flavour 'frappe'
        #   set -g @catppuccin_window_left_separator ""
        #   set -g @catppuccin_window_right_separator " "
        #   set -g @catppuccin_window_middle_separator " █"
        #   set -g @catppuccin_window_number_position "right"

        #   set -g @catppuccin_window_default_fill "number"
        #   set -g @catppuccin_window_default_text "#W"

        #   set -g @catppuccin_window_current_fill "number"
        #   set -g @catppuccin_window_current_text "#W"

        #   set -g @catppuccin_status_modules_right "directory user host session"
        #   set -g @catppuccin_status_left_separator  " "
        #   set -g @catppuccin_status_right_separator ""
        #   set -g @catppuccin_status_right_separator_inverse "no"
        #   set -g @catppuccin_status_fill "icon"
        #   set -g @catppuccin_status_connect_separator "no"
        #   set -g @catppuccin_directory_text "#{pane_current_path}" 
        # '';
      }];
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
      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
    };
  };
}
