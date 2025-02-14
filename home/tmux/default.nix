{
  pkgs,
  config,
  ...
}: let
  tmux-nerd-font-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-nerd-font-window-name";
    rtpFilePath = "tmux-nerd-font-window-name.tmux";
    version = "unstable-2023-12-13";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "tmux-nerd-font-window-name";
      rev = "410d5becb3a5c118d5fabf89e1633d137906caf1";
      hash = "sha256-HqSaOcnb4oC0AtS0aags2A5slsPiikccUSuZ1sVuago=";
    };
  };
in {
  home = {
    packages = with pkgs; [
      gitmux
      yq-go # required for tmux-nerd-font-window-name
    ];
    file.".gitmux.yml".source = ./gitmux.yml;
    file.".config/tmux/tmux-nerd-font-window-name.yml".source = ./tmux-nerd-font-window-name.yml;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";

    aggressiveResize = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    newSession = false;
    secureSocket = true;
    shortcut = "b";
    terminal = "xterm-256color";

    extraConfig = let
      gitmux = "$(gitmux -cfg ~/.gitmux.yml)";
    in ''
      # Make pam_tid.so work in tmux
      __helper="${pkgs.pam-reattach}/bin/reattach-to-session-namespace";
      set-option -g default-command "$__helper zsh"

      set -ga terminal-overrides ",*256col*:Tc"
      setenv -g COLORTERM truecolor

      set-option -g allow-passthrough
      set-option -ga update-environment TERM
      set-option -ga update-environment TERM_PROGRAM

      set -g base-index 1              # start indexing windows at 1 instead of 0
      setw -g pane-base-index 1        # start indexing panes at 1 instead of 0
      set -g detach-on-destroy off     # don't exit from tmux when closing a session
      set -g escape-time 0             # zero-out escape time delay (http://superuser.com/a/252717/65504) a larger value may be required in remote connections
      set -g history-limit 1000000     # increase history size (from 2,000)
      set -g mouse on                  # enable mouse support
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-interval 3         # update the status bar every 3 seconds
      set -g focus-events on           # TODO: learn how this works
      set -g detach-on-destroy off # don't exit from tmux when closing a session
      setw -g automatic-rename on      # automatically rename windows based on the application within
      set -g set-titles on             # use titles in tabs
      set -g set-titles-string "#I:#W" # Set parent terminal title to reflect current window in tmux session
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

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

      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config Reloaded!"

      # open lazygit in a new window
      bind-key g display-popup -w "90%" -h "90%" -d "#{pane_current_path}" -E "lazygit"

      unbind '"'
      # split window and fix path for tmux 1.9
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Resize panes
      bind -r H resize-pane -L 10
      bind -r J resize-pane -D 10
      bind -r K resize-pane -U 10
      bind -r L resize-pane -R 10


      bind -r M resize-pane -Z

      # toggle the status bar
      bind-key -T prefix B set-option -g status


      bind-key "T" run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
      )\""

      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
      set -g detach-on-destroy off  # don't exit from tmux when closing a session
      bind -N "last-session (via sesh) " L run-shell "sesh last"

      bind c new-window -c "#{pane_current_path}"

      set -g status-left "#[fg=blue,bold]#S #[fg=white,nobold]#(if [[ ${gitmux} ]]; then echo ${gitmux}; else echo ""; fi) "
      set -ga status-left "#[fg=red}]#S " # session name
      set -g status-left-length 200
      set -g status-right ""
      set -g status-position top

      set -g window-status-format " #[fg=green]#W "
      set -g window-status-current-format '*#[fg=magenta]#W'

      set -g @continuum-save-interval '5'
      set -g @continuum-restore 'on'
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
    plugins = with pkgs.tmuxPlugins; [
      tmux-nerd-font-window-name
      vim-tmux-navigator
      yank
      sensible
      prefix-highlight
      {
        plugin = resurrect;
        extraConfig =
          # bash
          ''
            set -g @resurrect-save 'S'
            set -g @resurrect-restore 'R'
            set -g @resurrect-capture-pane-contents 'on'

            resurrect_dir="$HOME/.config/tmux/resurrect"
            set -g @resurrect-dir $resurrect_dir
          '';
      }
    ];
  };
}
