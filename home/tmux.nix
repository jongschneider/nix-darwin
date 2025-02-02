{pkgs, ...}: let
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "master";
      sha256 = "sha256-3rMYYzzSS2jaAMLjcQoKreE0oo4VWF9dZgDtABCUOtY=";
    };
  };
in {
  enable = true;

  aggressiveResize = true;
  baseIndex = 1;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  newSession = true;
  secureSocket = true;
  # shell = "${pkgs.fish}/bin/fish";
  shell = "${pkgs.zsh}/bin/zsh";
  shortcut = "b";
  terminal = "screen-256color";

  plugins = with pkgs.tmuxPlugins; [
    tokyo-night
    yank
    sensible
    resurrect # persist tmux sessions after computer restart
    continuum # automatically saves sessions for you every 15 minutes
    prefix-highlight
    vim-tmux-navigator
  ];

  extraConfig = ''
    # set-default colorset-option -ga terminal-overrides ",xterm-256color:Tc"
    set -as terminal-features ",xterm-256color:RGB"
    # set-option -sa terminal-overrides ",xterm*:Tc"
    set -g mouse on

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

    set -g @tokyo-night-tmux_show_datetime 0
    set -g @tokyo-night-tmux_show_path 1
    set -g @tokyo-night-tmux_path_format relative
    set -g @tokyo-night-tmux_window_id_style dsquare
    set -g @tokyo-night-tmux_show_git 0

    run-shell ${tokyo-night}/share/tmux-plugins/tokyo-night/tokyo-night.tmux

    unbind '"'
    bind - split-window -v

    # Resize panes
    bind -r h resize-pane -L 5
    bind -r j resize-pane -D 5
    bind -r k resize-pane -U 5
    bind -r l resize-pane -R 5

    # set vi-mode
    set-window-option -g mode-keys vi

    bind -r m resize-pane -Z

    # keybindings
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

    # show popup to switch to a session (overrides default choose-tree command)
    bind-key "K" display-popup -E "sesh connect \"$(
      sesh list -i | gum filter --no-strip-ansi --limit 1 --placeholder 'Choose a session' --height 50 --prompt='⚡'
    )\""

    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
    bind c new-window -c "#{pane_current_path}"

    # Make pam_tid.so work in tmux
    __helper="${pkgs.pam-reattach}/bin/reattach-to-session-namespace";
    set-option -g default-command "$__helper zsh"
  '';
}
