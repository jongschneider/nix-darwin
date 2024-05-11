{ pkgs,  ... }:
let
  # oxocarbon = (import ../oxocarbon.nix).dark;
in
{
  programs.tmux = {
        enable = true;
        sensibleOnTop = true;
        baseIndex = 1;
        shortcut = "b";
        aggressiveResize = true;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          resurrect # persist tmux sessions after computer restart
          continuum # automatically saves sessions for you every 15 minutes
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

          # Remap the split pane
          unbind %
          bind | split-window -h 

          unbind '"'
          bind - split-window -v
          # Resize panes
          bind -r h resize-pane -L 5
          bind -r j resize-pane -D 5
          bind -r k resize-pane -U 5
          bind -r l resize-pane -R 5

          # bind -r S-left resize-pane -L 5
          # bind -r S-down resize-pane -D 5
          # bind -r S-up resize-pane -U 5
          # bind -r S-right resize-pane -R 5
          
          # set vi-mode
          set-window-option -g mode-keys vi
          
          bind -r m resize-pane -Z

          # vim style yank keybindings
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          # keybinding to make sure that when we split pane we are in the same cwd as the pane we came from
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"

          # auto kill pane when closing
          bind-key x kill-pane

          set -g @resurrect-capture-pane-contents 'on'
          set -g @continuum-restore 'on'
        '';
      };}

