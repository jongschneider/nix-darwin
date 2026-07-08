{...}: {
  # Let lazygit keep Ctrl+h/j/k/l for itself instead of moving herdr focus
  # (vim-herdr-navigation passthrough; anchored exact match on the process name).
  home.sessionVariables.HERDR_NAV_PASSTHROUGH_RE = "^lazygit$";

  xdg.configFile = {
    "herdr/config.toml" = {
      source = ./config.toml;
    };
    "herdr/session-picker.sh" = {
      source = ./session-picker.sh;
      executable = true;
    };
  };
}
