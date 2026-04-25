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
    # Use Apple's /bin/zsh — nix-built zsh-5.9 hangs in compinit/compdump
    # on macOS 26.x (1% CPU, blocked on I/O). ~/.zshrc still works since
    # paths are absolute. Verified 2026-04-25.
    shell = "/bin/zsh";

    aggressiveResize = true;
    baseIndex = 1;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    historyLimit = 1000000;
    keyMode = "vi";
    mouse = true;
    newSession = false;
    secureSocket = true;
    shortcut = "b";
    focusEvents = true;

    extraConfig = let
      gitmux = "$(gitmux -cfg ~/.gitmux.yml)";
    in ''
      # Make pam_tid.so work in tmux
      set-option -g default-command "${pkgs.pam-reattach}/bin/reattach-to-session-namespace /bin/zsh"

      # Extended keys: forward modifier info (e.g. Shift+Enter, Ctrl+Enter) in CSI-u format
      # Without this, tmux strips modifiers and all Enter variants become plain \r
      set -g extended-keys on
      set -g extended-keys-format csi-u

      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ",*:sitm=\\E[3m:ritm=\\E[23m"
      set -as terminal-overrides ",xterm*:sitm=\\E[3m"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours

      set-option -g allow-passthrough
      set-option -ga update-environment TERM
      set-option -ga update-environment TERM_PROGRAM

      set -g detach-on-destroy off
      set -g renumber-windows on
      set -g set-clipboard on
      set -g status-interval 3
      setw -g automatic-rename on
      set -g set-titles on
      set -g set-titles-string "#I:#W"

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

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

      bind r source-file ~/.config/tmux/tmux.conf \; display "Config Reloaded!"

      bind-key g display-popup -w "90%" -h "90%" -d "#{pane_current_path}" -E "lazygit"

      unbind '"'
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Resize panes
      bind -r H resize-pane -L 10
      bind -r J resize-pane -D 10
      bind -r K resize-pane -U 10
      bind -r L resize-pane -R 10

      bind -r M resize-pane -Z

      bind-key -T prefix B set-option -g status

      bind-key "T" run-shell "~/.config/sesh/picker.sh"

      bind-key x kill-pane
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
      prefix-highlight
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-save 'S'
          set -g @resurrect-restore 'R'
          set -g @resurrect-dir "$HOME/.config/tmux/resurrect"
        '';
      }
    ];
  };
}
