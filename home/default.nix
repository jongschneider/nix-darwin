{
  config,
  pkgs,
  lib,
  username,
  system,
  ...
}: let
  flavor = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
in {
  imports = [
    ./packages.nix
  ];

  catppuccin = lib.mkIf (system == "aarch64-darwin") {
    enable = true;
    flavor = flavor;
    bat.enable = true;
    fzf.enable = true;
    delta.enable = true;
    zsh-syntax-highlighting.enable = true;
  };

  xdg.configFile = {
    nvim = {
      source = config.lib.file.mkOutOfStoreSymlink ./nvim;
      recursive = true;
    };

    wezterm = {
      source = ./wezterm;
    };

    "karabiner/assets/complex_modifications/nix.json".text = builtins.toJSON {
      title = "CapsLock modifier - Nix managed";
      rules = [
        {
          description = ''
            Change caps_lock to left_control if pressed with other keys,
            change caps_lock to escape if pressed alone.
          '';
          manipulators = [
            {
              type = "basic";
              from = {
                key_code = "caps_lock";
                modifiers = {optional = ["any"];};
              };
              to = [
                {key_code = "left_control";}
              ];
              to_if_alone = [
                {key_code = "escape";}
              ];
            }
          ];
        }
      ];
    };

    "raycast/latest.rayconfig" = {
      source = ./raycast/latest.rayconfig;
    };
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    sessionVariables.EDITOR = "nvim";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Git configuration
  programs = {
    ghostty = lib.mkIf (system == "aarch64-darwin") {
      enable = true;
      # flake not supported in darwin... yet
      package = null;
      shellIntegration.enable = true;
      settings = {
        font-size = 13;
        font-family = "GeistMono Nerd Font";
        background-opacity = 0.95;
        theme = "tokyonight";
        window-theme = "system";
        macos-option-as-alt = true;
      };
    };

    git = {
      enable = true;
      userName = "Jonathan Schneider";
      userEmail = "jonathan.schneider@thetalake.com";

      delta = {
        enable = true;
        options = {
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

      ignores = [
        ".direnv"
        ".envrc"
        "tmp.txt"
        "testout.txt"
        "permitted_addresses.txt"
        "postscreen_access.txt"
        ".DS_Store"
        ".vscode"
        "*.pem"
        "*/vcr_responses.localdev.*.yaml"
        "result"
      ];

      extraConfig = {
        url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
        color.ui = true;
        diff.colorMoved = "zebra";
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
      };
    };

    jq.enable = true;
    bat = {
      enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
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

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        ctrl_n_shortcuts = true;
        enter_accept = true;
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
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

        nixcheck = "darwin-rebuild check --flake ~/.config/nix-darwin/";
        nixswitch = "darwin-rebuild switch --flake ~/.config/nix-darwin/";
        nixup = "pushd ~/.config/nix-darwin; nix flake update; nixswitch; popd";

        killmysql = "sudo pkill mysql";

        # Work
        localdev = "/Users/jschneider/Developer/localdev/localdev";
        runingester = "export INGESTER_ENV=.env && goi && ingester > tmp.txt";
        runintegrator = "export INTEGRATOR_ENV=.env && goi && integrator  > tmp.txt";
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
        gignore = "c .git/info/exclude";
        glog = "git log --simplify-by-decoration --oneline --graph";
        glast = "git branch --sort=-committerdate | fzf --header 'Checkout Recent Branch' --preview 'git diff {1} --color=always' --preview-window down --bind 'ctrl-/:change-preview-window(down|hidden|),shift-up:preview-page-up,shift-down:preview-page-down' | xargs git checkout";
        wt = "git worktree";
        sc = "sesh connect \"$(
	sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --height 50 --prompt='⚡'
)\"";
      };
    };
    wezterm = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "$os$username$directory$git_branch$git_status$c$rust$golang$nodejs$php$java$kotlin$haskell$python$line_break$character ";
        os = {
          disabled = false;
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
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
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
          style_user = "fg:text";
          style_root = "fg:text";
          format = "[ $user ]($style)";
        };

        directory = {
          truncation_length = 100;
          truncate_to_repo = false;
          style = "fg:peach";
          format = "[](fg:text)[ $path ]($style)";
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
          symbol = "";
          style = "fg:green";
          format = "[](fg:text)[ $symbol $branch ]($style)";
        };

        git_status = {
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
          style = "fg:teal";
          format = "[](fg:text)[ $symbol( $version) ]($style)";
        };

        rust = {
          style = "red bold";
          format = "[](fg:text) [$symbol( $version)]($style)";
        };

        golang = {
          symbol = "󰟓";
          style = "fg:teal";
          format = "[](fg:text)[ $symbol( $version) ]($style)";
        };

        python = {
          symbol = "";
          style = "fg:teal";
          format = "[](fg:text)[ $symbol( $version) ]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:mantle";
          format = "[[ $symbol( $context) ](fg:base bg:blue)]($style)";
        };
        character = {
          success_symbol = "[](maroon)";
          error_symbol = "[](red)";
          vimcmd_symbol = "[](green)";
        };
        line_break = {
          disabled = false;
        };
        add_newline = false;
      };
    };

    neovim = {
      enable = true;
      extraLuaConfig = ''
        require('user')
      '';
      extraPackages = with pkgs; [
        # Included for nil_ls
        cargo
        # Included to build telescope-fzf-native.nvim
        cmake
        luajitPackages.tiktoken_core # copilot (optional)
      ];
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      vimdiffAlias = true;
    };

    tmux = import ./tmux.nix {inherit pkgs;};
  };
}
