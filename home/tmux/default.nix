{pkgs, ...}: let
  # Create a derivation for your theme files
  tmuxThemes = pkgs.stdenv.mkDerivation {
    name = "tmux-themes";
    src = ./themes;
    installPhase = ''
      mkdir -p $out/themes
      cp -r * $out/themes/
    '';
  };
in {
  enable = true;

  aggressiveResize = true;
  baseIndex = 1;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  newSession = false;
  secureSocket = true;
  shell = "${pkgs.zsh}/bin/zsh";
  shortcut = "b";
  terminal = "xterm-256color";
  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = resurrect;
      extraConfig = ''
        # Use default resurrect location
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-processes 'all'
        set -g @resurrect-strategy-nvim 'session'
      '';
    }
    {
      plugin = vim-tmux-navigator;
    }
    {
      plugin = yank;
    }
    {
      plugin = continuum;
      extraConfig = ''
        # Enable automatic restore
        set -g @continuum-restore 'on'

        # Save every 5 minutes
        set -g @continuum-save-interval '5'

        # Show save status in status bar
        # set -g status-right 'Continuum: #{continuum_status}'

        # Enable automatic saves
        set -g @continuum-save 'on'
      '';
    }
    sensible
    prefix-highlight
  ];

  extraConfig = ''
    # Make pam_tid.so work in tmux
    __helper="${pkgs.pam-reattach}/bin/reattach-to-session-namespace";
    set-option -g default-command "$__helper zsh"

    set -g mouse on
    # set -g status-right ""
    set -g status-left-length 300    # increase length (from 10)
    set -g status-position top       # macOS / darwin style
    set -g status-style 'bg=default' # transparent

    set -g allow-passthrough on

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

    # Theme configuration
    if-shell '[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]' \
      "source-file '${tmuxThemes}/themes/catppuccin/dark.conf'" \
      "source-file '${tmuxThemes}/themes/catppuccin/light.conf'"
    source-file "${tmuxThemes}/themes/catppuccin.conf"


    # Status bar visibility management
    if-shell "[ -z \"$TMUX_MINIMAL\" ]" {
      set -g status on
    } {
      set -g status off
      set-hook -g after-new-window      'if "[ #{session_windows} -gt 1 ]" "set status on"'
      set-hook -g after-kill-pane       'if "[ #{session_windows} -lt 2 ]" "set status off"'
      set-hook -g pane-exited           'if "[ #{session_windows} -lt 2 ]" "set status off"'
      set-hook -g window-layout-changed 'if "[ #{session_windows} -lt 2 ]" "set status off"'
    }

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

    # Manual save/restore bindings with absolute paths
    bind-key C-s run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh"
    bind-key C-r run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh"

    # Explicitly initialize plugins in order
    run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux"
    run-shell "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux"
  '';
}
